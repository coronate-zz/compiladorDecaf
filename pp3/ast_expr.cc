
#include <string.h>

#include <typeinfo>

#include "ast_expr.h"
#include "ast_type.h"
#include "ast_decl.h"
#include "errors.h"

IntConstant::IntConstant(yyltype loc, int val)
  : Expr(loc) {
  this->value = val;
  Expr::type = Type::intType;
}

DoubleConstant::DoubleConstant(yyltype loc, double val)
  : Expr(loc) {
  this->value = val;
  Expr::type = Type::doubleType;
}

BoolConstant::BoolConstant(yyltype loc, bool val)
  : Expr(loc) {
  this->value = val;
  Expr::type = Type::boolType;
}

StringConstant::StringConstant(yyltype loc, const char *val)
  : Expr(loc) {
  Assert(val != NULL);
  this->value = strdup(val);
  Expr::type = Type::stringType;
}

NullConstant::NullConstant(yyltype loc)
  : Expr(loc) {
  Expr::type = Type::nullType;
}

Operator::Operator(yyltype loc, const char *tok) : Node(loc) {
  Assert(tok != NULL);
  strncpy(this->tokenString, tok, sizeof(this->tokenString));
}

CompoundExpr::CompoundExpr(Expr *l, Operator *o, Expr *r) 
  : Expr(Join(l->GetLocation(), r->GetLocation())) {
  Assert(l != NULL && o != NULL && r != NULL);
  (this->op=o)->SetParent(this);
  (this->left=l)->SetParent(this); 
  (this->right=r)->SetParent(this);
}

CompoundExpr::CompoundExpr(Operator *o, Expr *r) 
  : Expr(Join(o->GetLocation(), r->GetLocation())) {
  Assert(o != NULL && r != NULL);
  this->left = NULL; 
  (this->op=o)->SetParent(this);
  (this->right=r)->SetParent(this);
}


Call::Call(yyltype loc, Expr *b, Identifier *f, List<Expr*> *a) : Expr(loc)  {
  Assert(f != NULL && a != NULL);  
  this->base = b;
  if (this->base) base->SetParent(this);
  (this->field=f)->SetParent(this);
  (this->actuals=a)->SetParentAll(this);
}

void Call::ReviewArguments(FnDecl *fndecl) {
  List<VarDecl*> *formals = fndecl->GetFormals();
  int formals_num = formals->NumElements();
  int args_num = this->actuals->NumElements();
  if (formals_num != args_num)
    {
      ReportError::NumArgsMismatch(this->field, formals_num, args_num);
      return;
    }
  else
    {
      for (int i = 0; i < formals_num; i++)
	{
	  VarDecl *vardecl = formals->Nth(i);
	  const char *expected = vardecl->GetTypeName();
	  Expr *expr = this->actuals->Nth(i);
	  const char *given = expr->GetTypeName();

          if (given && expected)
            {
              Decl *gdecl = Program::tablaHash->Lookup(given);
              Decl *edecl = Program::tablaHash->Lookup(expected);

              if (gdecl && edecl)  
                {
                  if (strcmp(given, expected))
		    if (typeid(*gdecl) == typeid(ClassDecl))
		      {
			ClassDecl *gcldecl = dynamic_cast<ClassDecl*>(gdecl);
			if (!gcldecl->IsCompatibleWith(edecl))
			  ReportError::ArgMismatch(expr, (i+1), new Type(given), new Type(expected));
		      }
                }
              else if (edecl && strcmp(given, "null"))  
		ReportError::ArgMismatch(expr, (i+1), new Type(given), new Type(expected));
              else if (gdecl == NULL && edecl == NULL && strcmp(given, expected))  
                ReportError::ArgMismatch(expr, (i+1), new Type(given), new Type(expected));
	    }
	}
    }
}

void Call::ReviewStatements() {
  if (this->actuals)
    {
      for (int i = 0; i < actuals->NumElements(); i++)
	this->actuals->Nth(i)->ReviewStatements();
    }

  Decl *decl = NULL;

  if (this->base)
    {
      this->base->ReviewStatements();
      const char *name = this->base->GetTypeName();
       
       
      if (name)
        {
          if ((decl = Program::tablaHash->Lookup(name)) != NULL)
	    {
	      decl = this->field->ReviewIdDecl(decl->GetSymTable(), this->field->GetName());
	      if ((decl == NULL) || (typeid(*decl) != typeid(FnDecl)))
		ReportError::FieldNotFoundInBase(this->field, new Type(name));
	      else
		ReviewArguments(dynamic_cast<FnDecl*>(decl));
	    }
	  else if ((typeid(*this->base->GetType()) == typeid(ArrayType))
		   && !strcmp(this->field->GetName(), "length"))  
	    {
	      this->type = Type::intType;
	    }
	  else
	    {
	      ReportError::FieldNotFoundInBase(this->field, new Type(name));
	    }
        }
    }
  else
    {
       
      decl = this->field->ReviewIdDecl();
      if ((decl == NULL) || (typeid(*decl) != typeid(FnDecl)))
        {
	  ReportError::IdentifierNotDeclared(this->field, LookingForFunction);
	  decl = NULL;  
                        
        }
      else
	ReviewArguments(dynamic_cast<FnDecl*>(decl));
    }
  if (decl != NULL)
    this->type = decl->GetType();  
}



void ArithmeticExpr::ReviewStatements() {
  const char *lt = NULL, *rt = NULL;
  if (this->left)  
    {
      this->left->ReviewStatements();
      lt = this->left->GetTypeName();
    }

  this->right->ReviewStatements();
  rt = this->right->GetTypeName();
  if (lt && rt)  
    {
      if ((strcmp(lt, "int") && strcmp(lt, "double")) ||
          (strcmp(rt, "int") && strcmp(rt, "double")) ||
          (strcmp(lt, rt)))
        ReportError::IncompatibleOperands(this->op, new Type(lt), new Type(rt));
    }
  else if (rt)  
    {
      if (strcmp(rt, "int") && strcmp(rt, "double"))
        ReportError::IncompatibleOperand(this->op, new Type(rt));
    }
}

void RelationalExpr::ReviewStatements() {
  this->left->ReviewStatements();
  const char *lt = this->left->GetTypeName();

  this->right->ReviewStatements();
  const char *rt = this->right->GetTypeName();
  if (lt && rt)  
    {
      if ((strcmp(lt, "int") && strcmp(lt, "double")) ||
    (strcmp(rt, "int") && strcmp(rt, "double")) ||
    (strcmp(lt, rt)))
  ReportError::IncompatibleOperands(this->op, new Type(lt), new Type(rt));
    }
}

void EqualityExpr::ReviewStatements() {
  this->left->ReviewStatements();
  this->right->ReviewStatements();
  const char *lt = this->left->GetTypeName();
  const char *rt = this->right->GetTypeName();
  if (lt && rt)
    {
      Decl *ldecl = Program::tablaHash->Lookup(lt);
      Decl *rdecl = Program::tablaHash->Lookup(rt);

      if (ldecl && rdecl)  
  {
    if (!strcmp(lt, rt))
      return;
    else if (typeid(*ldecl) == typeid(ClassDecl))
      {
        ClassDecl *lcldecl = dynamic_cast<ClassDecl*>(ldecl);
        if (lcldecl->IsCompatibleWith(rdecl))
    return;
      }
    else if (typeid(*rdecl) == typeid(ClassDecl))
      {
        ClassDecl *rcldecl = dynamic_cast<ClassDecl*>(rdecl);
        if (rcldecl->IsCompatibleWith(ldecl))
    return;
      }
  }
      else if (ldecl && !strcmp(rt, "null"))  
  return;
      else if (!strcmp(lt, rt))  
  return;
    }
  ReportError::IncompatibleOperands(this->op, new Type(lt), new Type(rt));
}



ArrayAccess::ArrayAccess(yyltype loc, Expr *b, Expr *s) : LValue(loc) {
  (this->base=b)->SetParent(this); 
  (this->subscript=s)->SetParent(this);
}

Type *ArrayAccess::GetType() {
  Type *type = base->GetType();
  if (type)
    return type->GetElemType();
  else
    return NULL;
}

const char *ArrayAccess::GetTypeName() {
  Type *type = this->base->GetType();
  if (type)
    return type->GetElemType()->GetTypeName();
  else
    return NULL;
}

void ArrayAccess::ReviewStatements() {
  this->base->ReviewStatements();
  if (typeid(*this->base->GetType()) != typeid(ArrayType))
    ReportError::BracketsOnNonArray(this->base);
  this->subscript->ReviewStatements();
  if (strcmp(this->subscript->GetTypeName(), "int"))
    ReportError::SubscriptNotInteger(this->subscript);
}
void LogicalExpr::ReviewStatements() {
  const char *lt = NULL, *rt = NULL;
  if (this->left)
    {
      this->left->ReviewStatements();
      lt = this->left->GetTypeName();
    }
  this->right->ReviewStatements();
  rt = this->right->GetTypeName();
  if (lt && rt)
    {
      if (strcmp(lt, "bool") || strcmp(rt, "bool"))
        ReportError::IncompatibleOperands(this->op, new Type(lt), new Type(rt));
    }
  else if (rt)
    {
      if (strcmp(rt, "bool"))
        ReportError::IncompatibleOperand(this->op, new Type(rt));
    }

}

void AssignExpr::ReviewStatements() {
  this->left->ReviewStatements();
  this->right->ReviewStatements();
  const char *lt = this->left->GetTypeName();
  const char *rt = this->right->GetTypeName();

  if (lt && rt)
    {
      Decl *ldecl = Program::tablaHash->Lookup(lt);
      Decl *rdecl = Program::tablaHash->Lookup(rt);

      if (ldecl && rdecl)  
        {
          if (!strcmp(lt, rt))
            return;
          else if (typeid(*rdecl) == typeid(ClassDecl))
      {
        ClassDecl *rcldecl = dynamic_cast<ClassDecl*>(rdecl);
        if (rcldecl->IsCompatibleWith(ldecl))
    return;
      }
        }
      else if (ldecl && !strcmp(rt, "null"))  
  return;
      else if (!strcmp(lt, rt))  
  return;
      ReportError::IncompatibleOperands(this->op, new Type(lt), new Type(rt));
    }
}

void This::ReviewStatements() {
  Node *parent = this->GetParent();
  while (parent)
    {
      if (typeid(*parent) == typeid(ClassDecl))
        {
          this->type = new NamedType(dynamic_cast<ClassDecl*>(parent)->GetID());
          return;
        }
      parent = parent->GetParent();
    }
  ReportError::ThisOutsideClassScope(this);
}

FieldAccess::FieldAccess(Expr *b, Identifier *f) 
  : LValue(b? Join(b->GetLocation(), f->GetLocation()) : *f->GetLocation()) {
  Assert(f != NULL);  
  this->base = b; 
  if (this->base) base->SetParent(this); 
  (this->field=f)->SetParent(this);
}

void FieldAccess::ReviewStatements() {
  Decl *decl = NULL;  
  if (this->base)
    {
      this->base->ReviewStatements();   
      const char *name = this->base->GetTypeName();

      if (name)
  {
    Node *parent = this->GetParent();
    Decl *cldecl = NULL;  
     
     
    while (parent)
      {
        Hashtable<Decl*> *tablaHash = parent->GetSymTable();
        if (tablaHash)
    if ((cldecl = tablaHash->Lookup(name)) != NULL)
      {
        decl = this->field->ReviewIdDecl(cldecl->GetSymTable(), this->field->GetName());
                    if ((decl == NULL) || (typeid(*decl) != typeid(VarDecl)))
                      ReportError::FieldNotFoundInBase(this->field, new Type(name));
      }
        parent = parent->GetParent();
      }
    if (cldecl == NULL)
      {
        if ((cldecl = Program::tablaHash->Lookup(name)) != NULL)  
          {
            decl = this->field->ReviewIdDecl(cldecl->GetSymTable(), this->field->GetName());
            if ((decl != NULL) && (typeid(*decl) == typeid(VarDecl)))
              ReportError::InaccessibleField(this->field, new Type(name));  
            else
              ReportError::FieldNotFoundInBase(this->field, new Type(name));  
          }
        else  
    ReportError::FieldNotFoundInBase(this->field, new Type(name));
      }
  }
    }
  else
    {
       
      decl = this->field->ReviewIdDecl();
      if (decl == NULL || typeid(*decl) != typeid(VarDecl))
        {
          ReportError::IdentifierNotDeclared(this->field, LookingForVariable);
          decl = NULL;  
                        
        }
    }
  if (decl != NULL)
    this->type = decl->GetType(); 
}



void NewExpr::ReviewStatements() {
  if (this->cType)
    {
      const char *name = this->cType->GetTypeName();
      if (name)
        {
          Decl *decl = Program::tablaHash->Lookup(name);
          if ((decl == NULL) || (typeid(*decl) != typeid(ClassDecl)))
            ReportError::IdentifierNotDeclared(new Identifier(*this->cType->GetLocation(), name), LookingForClass);
        }
    }
}

void NewArrayExpr::ReviewStatements() {
  this->size->ReviewStatements();
  if (strcmp(this->size->GetTypeName(), "int"))
    ReportError::NewArraySizeNotInteger(this->size);
  this->elemType->errorTypeReview();
}

void PostfixExpr::ReviewStatements() {
  if (this->lvalue)
    {
      this->lvalue->ReviewStatements();
      const char *name = this->lvalue->GetTypeName();
      if (strcmp(name, "int") && strcmp(name, "double"))
  ReportError::IncompatibleOperand(this->optr, this->lvalue->GetType());
    }
}


NewExpr::NewExpr(yyltype loc, NamedType *c) : Expr(loc) { 
  Assert(c != NULL);
  (this->cType=c)->SetParent(this);
}



NewArrayExpr::NewArrayExpr(yyltype loc, Expr *sz, Type *et) : Expr(loc) {
  Assert(sz != NULL && et != NULL);
  (this->size=sz)->SetParent(this); 
  (this->elemType=et)->SetParent(this);
}

const char *NewArrayExpr::GetTypeName() {
  if (this->elemType)
    {
      string delim = "[]";
      string str = this->elemType->GetTypeName() + delim;
      return str.c_str();
    }
  else
    return NULL;
}


ReadLineExpr::ReadLineExpr(yyltype loc)
  : Expr(loc) {
  Expr::type = Type::stringType;
}

ReadIntegerExpr::ReadIntegerExpr(yyltype loc)
  : Expr(loc) {
  Expr::type = Type::intType;
}

PostfixExpr::PostfixExpr(yyltype loc, LValue *lv, Operator *op)
  : Expr(loc) {
  Assert(lv != NULL && op != NULL);
  (this->lvalue=lv)->SetParent(this);
  (this->optr=op)->SetParent(this);
}

