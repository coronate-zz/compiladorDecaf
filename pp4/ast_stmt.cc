
#include <typeinfo>

#include "ast_stmt.h"
#include "ast_type.h"
#include "ast_decl.h"
#include "ast_expr.h"
#include "errors.h"

Hashtable<Decl*> *Program::sym_table  = new Hashtable<Decl*>;

Program::Program(List<Decl*> *d) {
  Assert(d != NULL);
  (this->decls=d)->SetParentAll(this);
}

void Program::stmtReview() {
  for (int i = 0; i < this->decls->NumElements(); i++)
    this->decls->Nth(i)->stmtReview();
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
	      if ((prev = Program::sym_table->Lookup(name)) != NULL)
		ReportError::DeclConflict(cur, prev);
	      else
		sym_table->Enter(name, cur);
	    }
	}
      for (int i = 0; i < this->decls->NumElements(); i++)
	this->decls->Nth(i)->errorDeclReview();
       
    }

}

StmtBlock::StmtBlock(List<VarDecl*> *d, List<Stmt*> *s) {
  Assert(d != NULL && s != NULL);
  (this->decls=d)->SetParentAll(this);
  (this->stmts=s)->SetParentAll(this);
  this->sym_table  = new Hashtable<Decl*>;
}

void StmtBlock::stmtReview() {
  if (this->stmts)
    {
      for (int i = 0; i < this->stmts->NumElements(); i++)
        {
          Stmt *stmt = this->stmts->Nth(i);
          stmt->stmtReview();
        }
    }
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
	      if ((prev = this->sym_table->Lookup(name)) != NULL)
		{
		  ReportError::DeclConflict(cur, prev);
		}
	      else
		{
		  sym_table->Enter(name, cur);
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

ConditionalStmt::ConditionalStmt(Expr *t, Stmt *b) { 
  Assert(t != NULL && b != NULL);
  (this->test=t)->SetParent(this); 
  (this->body=b)->SetParent(this);
}

void ConditionalStmt::stmtReview() {
  this->test->stmtReview();
  if (strcmp(this->test->GetTypeName(), "bool"))
    ReportError::TestNotBoolean(this->test);

  this->body->stmtReview();
}

void ConditionalStmt::errorDeclReview() {
  this->body->errorDeclReview();
}

ForStmt::ForStmt(Expr *i, Expr *t, Expr *s, Stmt *b): LoopStmt(t, b) { 
  Assert(i != NULL && t != NULL && s != NULL && b != NULL);
  (this->init=i)->SetParent(this);
  (this->step=s)->SetParent(this);
}

void ForStmt::stmtReview() {
  if (this->init)
    this->init->stmtReview();
  if (this->step)
    this->step->stmtReview();
  ConditionalStmt::stmtReview();
}

void WhileStmt::stmtReview() {
  ConditionalStmt::stmtReview();
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

SwitchStmt::SwitchStmt(Expr *e, List<CaseStmt*> *cs, DefaultStmt *ds) {
  Assert(e != NULL && cs != NULL);
  (this->expr=e)->SetParent(this);
  (this->cases=cs)->SetParentAll(this);
  if (ds)
   (this->defaults=ds)->SetParent(this);
}

void SwitchStmt::stmtReview() {
  if (this->expr)
    this->expr->stmtReview();

  if (this->cases)
    {
      for (int i = 0; i < this->cases->NumElements(); i++)
        {
          CaseStmt *stmt = this->cases->Nth(i);
          stmt->stmtReview();
        }
    }

  if (this->defaults)
    this->defaults->stmtReview();
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
void PrintStmt::stmtReview() {
  if (this->args)
    {
      for (int i = 0; i < this->args->NumElements(); i++)
        {
          Expr *expr = this->args->Nth(i);
          expr->stmtReview();
          const char *typeName = expr->GetTypeName();
          if (typeName && strcmp(typeName, "string") && strcmp(typeName, "int") && strcmp(typeName, "bool"))
            ReportError::PrintArgMismatch(expr, (i+1), new Type(typeName));
        }
    }
}

void ReturnStmt::stmtReview() {

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
      this->expr->stmtReview();
      const char *given = expr->GetTypeName();

      if (given && expected)
        {
          Decl *gdecl = Program::sym_table->Lookup(given);
          Decl *edecl = Program::sym_table->Lookup(expected);

          if (gdecl && edecl)  
            {
              if (!strcmp(given, expected))
                return;
              else if (typeid(*gdecl) == typeid(ClassDecl))
                {
                  ClassDecl *gcldecl = dynamic_cast<ClassDecl*>(gdecl);
                  if (gcldecl->mostrarCompatibilidad(edecl))
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


IfStmt::IfStmt(Expr *t, Stmt *tb, Stmt *eb): ConditionalStmt(t, tb) { 
  Assert(t != NULL && tb != NULL);  
  this->elseBody = eb;
  if (this->elseBody) elseBody->SetParent(this);
}

void IfStmt::errorDeclReview() {
  ConditionalStmt::errorDeclReview();
  if (this->elseBody)
    this->elseBody->errorDeclReview();
}

void IfStmt::stmtReview() {
  ConditionalStmt::stmtReview();
  if (this->elseBody)
    this->elseBody->stmtReview();
}

void BreakStmt::stmtReview() {
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

CaseStmt::CaseStmt(IntConstant *ic, List<Stmt*> *sts)
  : DefaultStmt(sts) {
  (this->intconst=ic)->SetParent(this);
}

DefaultStmt::DefaultStmt(List<Stmt*> *sts) {
  if (sts) (this->stmts=sts)->SetParentAll(this);
}

void DefaultStmt::stmtReview() {
  if (this->stmts)
    {
      for (int i = 0; i < this->stmts->NumElements(); i++)
        {
          Stmt *stmt = this->stmts->Nth(i);
          stmt->stmtReview();
        }
    }
}





