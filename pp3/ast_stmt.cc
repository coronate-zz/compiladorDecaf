

#include <typeinfo>

#include "ast_stmt.h"
#include "ast_type.h"
#include "ast_decl.h"
#include "ast_expr.h"
#include "errors.h"

Hashtable<Decl*> *Program::tablaHash  = new Hashtable<Decl*>;

Program::Program(List<Decl*> *d) {
  Assert(d != NULL);
  (this->decls=d)->SetParentAll(this);
}

void Program::ReviewStatements() {
  for (int i = 0; i < this->decls->NumElements(); i++)
    this->decls->Nth(i)->ReviewStatements();
}

StmtBlock::StmtBlock(List<VarDecl*> *d, List<Stmt*> *s) {
  Assert(d != NULL && s != NULL);
  (this->decls=d)->SetParentAll(this);
  (this->stmts=s)->SetParentAll(this);
  this->tablaHash  = new Hashtable<Decl*>;
}

void StmtBlock::ReviewStatements() {
  if (this->stmts)
    {
      for (int i = 0; i < this->stmts->NumElements(); i++)
        {
          Stmt *stmt = this->stmts->Nth(i);
          stmt->ReviewStatements();
        }
    }
}


ConditionalStmt::ConditionalStmt(Expr *t, Stmt *b) { 
  Assert(t != NULL && b != NULL);
  (this->test=t)->SetParent(this); 
  (this->body=b)->SetParent(this);
}

void ConditionalStmt::ReviewStatements() {
  this->test->ReviewStatements();
  if (strcmp(this->test->GetTypeName(), "bool"))
    ReportError::TestNotBoolean(this->test);

  this->body->ReviewStatements();
}

void ConditionalStmt::errorDeclReview() {
  this->body->errorDeclReview();
}

ForStmt::ForStmt(Expr *i, Expr *t, Expr *s, Stmt *b): LoopStmt(t, b) { 
  Assert(i != NULL && t != NULL && s != NULL && b != NULL);
  (this->init=i)->SetParent(this);
  (this->step=s)->SetParent(this);
}

void ForStmt::ReviewStatements() {
  if (this->init)
    this->init->ReviewStatements();
  if (this->step)
    this->step->ReviewStatements();
  ConditionalStmt::ReviewStatements();
}

void WhileStmt::ReviewStatements() {
  ConditionalStmt::ReviewStatements();
}

IfStmt::IfStmt(Expr *t, Stmt *tb, Stmt *eb): ConditionalStmt(t, tb) { 
  Assert(t != NULL && tb != NULL);  
  this->elseBody = eb;
  if (this->elseBody) elseBody->SetParent(this);
}



void IfStmt::ReviewStatements() {
  ConditionalStmt::ReviewStatements();
  if (this->elseBody)
    this->elseBody->ReviewStatements();
}

void BreakStmt::ReviewStatements() {
  Node *parent = this->GetParent();
  while (parent)
    {
      if ((typeid(*parent) == typeid(WhileStmt)) ||
          (typeid(*parent) == typeid(ForStmt)) ||
          (typeid(*parent) == typeid(SwitchStmt)))
        return;
      parent = parent->GetParent();
    }
  ReportError::BreakOutsideLoop(this);
}

ReturnStmt::ReturnStmt(yyltype loc, Expr *e) : Stmt(loc) { 
  Assert(e != NULL);
  (expr=e)->SetParent(this);
}

void ReturnStmt::ReviewStatements() {

  const char *expected;
  Node *parent = this->GetParent();
  while (parent)
    {
      if (typeid(*parent) == typeid(FnDecl))
        expected = dynamic_cast<FnDecl*>(parent)->GetTypeName();
      parent = parent->GetParent();
    }
  if (this->expr)
    {
      this->expr->ReviewStatements();
      const char *given = expr->GetTypeName();

      if (given && expected)
        {
          Decl *gdecl = Program::tablaHash->Lookup(given);
          Decl *edecl = Program::tablaHash->Lookup(expected);

          if (gdecl && edecl)  
            {
              if (!strcmp(given, expected))
                return;
              else if (typeid(*gdecl) == typeid(ClassDecl))
                {
                  ClassDecl *gcldecl = dynamic_cast<ClassDecl*>(gdecl);
                  if (gcldecl->IsCompatibleWith(edecl))
                    return;
                }
            }
          else if (edecl && !strcmp(given, "null"))
            return;
          else if (!strcmp(given, expected))
            return;

          ReportError::ReturnMismatch(this, new Type(given), new Type(expected));
        }
    }
  else if (strcmp("void", expected))
    ReportError::ReturnMismatch(this, new Type("void"), new Type(expected));
}
  
PrintStmt::PrintStmt(List<Expr*> *a) {    
  Assert(a != NULL);
  (args=a)->SetParentAll(this);
}

void PrintStmt::ReviewStatements() {
  if (this->args)
    {
      for (int i = 0; i < this->args->NumElements(); i++)
        {
          Expr *expr = this->args->Nth(i);
          expr->ReviewStatements();
          const char *typeName = expr->GetTypeName();
          if (typeName && strcmp(typeName, "string") && strcmp(typeName, "int") && strcmp(typeName, "bool"))
            ReportError::PrintArgMismatch(expr, (i+1), new Type(typeName));
        }
    }
}

CaseStmt::CaseStmt(IntConstant *ic, List<Stmt*> *sts)
  : DefaultStmt(sts) {
  (this->intconst=ic)->SetParent(this);
}

DefaultStmt::DefaultStmt(List<Stmt*> *sts) {
  if (sts) (this->stmts=sts)->SetParentAll(this);
}

void DefaultStmt::ReviewStatements() {
  if (this->stmts)
    {
      for (int i = 0; i < this->stmts->NumElements(); i++)
        {
          Stmt *stmt = this->stmts->Nth(i);
          stmt->ReviewStatements();
        }
    }
}


SwitchStmt::SwitchStmt(Expr *e, List<CaseStmt*> *cs, DefaultStmt *ds) {
  Assert(e != NULL && cs != NULL);
  (this->expr=e)->SetParent(this);
  (this->cases=cs)->SetParentAll(this);
  if (ds)
   (this->defaults=ds)->SetParent(this);
}

void SwitchStmt::ReviewStatements() {
  if (this->expr)
    this->expr->ReviewStatements();

  if (this->cases)
    {
      for (int i = 0; i < this->cases->NumElements(); i++)
        {
          CaseStmt *stmt = this->cases->Nth(i);
          stmt->ReviewStatements();
        }
    }

  if (this->defaults)
    this->defaults->ReviewStatements();
}

void SwitchStmt::errorDeclReview() {
  if (this->cases)
    {
      for (int i = 0; i < this->cases->NumElements(); i++)
        {
          CaseStmt *stmt = this->cases->Nth(i);
          stmt->errorDeclReview();
        }
    }

  if (this->defaults)
    this->defaults->errorDeclReview();
}

void StmtBlock::errorDeclReview() {
  if (this->decls)
    {
      for (int i = 0; i < this->decls->NumElements(); i++)
        {
    VarDecl *cur = this->decls->Nth(i);
    Decl *prev;
    const char *name = cur->GetID()->GetName();
    if (name)
      {
        if ((prev = this->tablaHash->Lookup(name)) != NULL)
    {
      ReportError::DeclConflict(cur, prev);
    }
        else
    {
      tablaHash->Enter(name, cur);
      cur->errorDeclReview();
    }
      }
        }
    }
  if (this->stmts)
    {
      for (int i = 0; i < this->stmts->NumElements(); i++)
        {
          Stmt *stmt = stmts->Nth(i);
          stmt->errorDeclReview();
        }
    }
}

void DefaultStmt::errorDeclReview() {
  if (this->stmts)
    {
      for (int i = 0; i < this->stmts->NumElements(); i++)
        {
          Stmt *stmt = this->stmts->Nth(i);
          stmt->errorDeclReview();
        }
    }
}


void IfStmt::errorDeclReview() {
  ConditionalStmt::errorDeclReview();
  if (this->elseBody)
    this->elseBody->errorDeclReview();
}

void Program::errorDeclReview() {
  if (this->decls)
    {
       
      for (int i = 0; i < this->decls->NumElements(); i++)
  {
          Decl *cur = decls->Nth(i);
          Decl *prev;
          const char *name = cur->GetID()->GetName();
    if (name)
      {
        if ((prev = Program::tablaHash->Lookup(name)) != NULL)
    ReportError::DeclConflict(cur, prev);
        else
    tablaHash->Enter(name, cur);
      }
  }
      for (int i = 0; i < this->decls->NumElements(); i++)
  this->decls->Nth(i)->errorDeclReview();
       
    }

}
