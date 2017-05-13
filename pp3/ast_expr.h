


#ifndef _H_ast_expr
#define _H_ast_expr

#include <string>

#include "ast.h"
#include "ast_stmt.h"
#include "ast_type.h"
#include "list.h"

class FnDecl;

class Expr : public Stmt
{
  protected:
    Type *type;

  public:
    Expr(yyltype loc) : Stmt(loc) {}
    Expr() : Stmt() {}
    virtual Type *GetType() { return type; }
    virtual const char *GetTypeName() { if (type) return type->GetTypeName(); else return NULL;}
};

class EmptyExpr : public Expr
{
};

class IntConstant : public Expr
{
  protected:
    int value;

  public:
    IntConstant(yyltype loc, int val);
};

class DoubleConstant : public Expr
{
  protected:
    double value;
    
  public:
    DoubleConstant(yyltype loc, double val);
};

class BoolConstant : public Expr
{
  protected:
    bool value;
    
  public:
    BoolConstant(yyltype loc, bool val);
};

class StringConstant : public Expr
{
  protected:
    char *value;
    
  public:
    StringConstant(yyltype loc, const char *val);
};

class NullConstant: public Expr
{
  public:
    NullConstant(yyltype loc);
};

class Operator : public Node
{
  protected:
    char tokenString[4];
    
  public:
    Operator(yyltype loc, const char *tok);
    friend std::ostream &operator<<(std::ostream &out, Operator *op) { if (op) return out << op->tokenString; else return out; }
 };
 
class CompoundExpr : public Expr
{
  protected:
    Operator *op;
    Expr *left, *right;  
    
  public:
    CompoundExpr(Expr *lhs, Operator *op, Expr *rhs);  
    CompoundExpr(Operator *op, Expr *rhs);  
};

class ArithmeticExpr : public CompoundExpr
{
  public:
    ArithmeticExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    ArithmeticExpr(Operator *op, Expr *rhs) : CompoundExpr(op,rhs) {}
    void ReviewStatements();
    Type *GetType() { return right->GetType(); }
    const char *GetTypeName() { return right->GetTypeName();}
};

class RelationalExpr : public CompoundExpr
{
  public:
    RelationalExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    void ReviewStatements();
    Type *GetType() { return Type::boolType; }
    const char *GetTypeName() { return "bool"; }
};

class EqualityExpr : public CompoundExpr
{
  public:
    EqualityExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    void ReviewStatements();
    Type *GetType() { return Type::boolType; }
    const char *GetTypeName() { return "bool"; }
};

class LogicalExpr : public CompoundExpr
{
  public:
    LogicalExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    LogicalExpr(Operator *op, Expr *rhs) : CompoundExpr(op,rhs) {}
    void ReviewStatements();
    Type *GetType() { return Type::boolType; }
    const char *GetTypeName() { return "bool"; }
};

class AssignExpr : public CompoundExpr
{
  public:
    AssignExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    void ReviewStatements();
    Type *GetType() { return left->GetType(); }
    const char *GetTypeName() { return left->GetTypeName(); }

};

class LValue : public Expr
{
  public:
    LValue(yyltype loc) : Expr(loc) {}
};

class This : public Expr
{
  public:
    This(yyltype loc) : Expr(loc) {}
    void ReviewStatements();
};

class ArrayAccess : public LValue
{
  protected:
    Expr *base, *subscript;
    
  public:
    ArrayAccess(yyltype loc, Expr *base, Expr *subscript);
    void ReviewStatements();
    Type *GetType();
    const char *GetTypeName();
};


class FieldAccess : public LValue
{
  protected:
    Expr *base;  
    Identifier *field;
    Type *type;  
    
  public:
    FieldAccess(Expr *base, Identifier *field);  
    void ReviewStatements();  
    Identifier *GetField() { return field; }
    Type *GetType() { return type; }
    const char *GetTypeName() { if (type) return type->GetTypeName(); else return NULL; }
};


class Call : public Expr
{
  protected:
    Expr *base;  
    Identifier *field;
    List<Expr*> *actuals;
    
  public:
    Call(yyltype loc, Expr *base, Identifier *field, List<Expr*> *args);
    void ReviewArguments(FnDecl *fndecl);  
    void ReviewStatements();  
    Type *GetType() { return type; }
    const char *GetTypeName() { if (type) return type->GetTypeName(); else return NULL; }
};

class NewExpr : public Expr
{
  protected:
    NamedType *cType;
    
  public:
    NewExpr(yyltype loc, NamedType *clsType);
    void ReviewStatements();
    Type *GetType() { return cType; }
    const char *GetTypeName() { if (cType) return cType->GetTypeName(); else return NULL;  }
};

class NewArrayExpr : public Expr
{
  protected:
    Expr *size;
    Type *elemType;
    
  public:
    NewArrayExpr(yyltype loc, Expr *sizeExpr, Type *elemType);
    void ReviewStatements();
    const char *GetTypeName();
};

class ReadIntegerExpr : public Expr
{
  public:
    ReadIntegerExpr(yyltype loc);
};

class ReadLineExpr : public Expr
{
  public:
    ReadLineExpr(yyltype loc);
};


class PostfixExpr : public Expr
{
  protected:
    LValue *lvalue;
    Operator *optr;

  public:
    PostfixExpr(yyltype loc, LValue *lv, Operator *op);
    void ReviewStatements();
    Type *GetType() { if (lvalue) return lvalue->GetType(); else return NULL; }
    const char *GetTypeName() { if (lvalue) return lvalue->GetTypeName(); else return NULL; }
};
    
#endif
