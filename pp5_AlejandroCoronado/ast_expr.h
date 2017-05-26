

#ifndef _H_ast_expr
#define _H_ast_expr

#include "ast.h"
#include "ast_stmt.h"
#include "list.h"
#include "ast_type.h"

class NamedType; 
class Type; 

class Expr : public Stmt
{
  public:
    
    Expr(yyltype loc) : Stmt(loc) { expr_type = NULL; }
    Expr() : Stmt() { expr_type = NULL; }
    
    virtual Location * GetEmitLocDeref() { return GetEmitLoc(); }
    virtual bool IsArrayAccessRef() { return false; }
    virtual bool IsEmptyExpr() { return false; }
};




class EmptyExpr : public Expr
{
  public:
    
    const char *nombreNodo() { return "Empty"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    bool IsEmptyExpr() { return true; }
};

class IntConstant : public Expr
{
  protected:
    int value;

  public:
    
    IntConstant(yyltype loc, int val);
    
    const char *nombreNodo() { return "IntConstant"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();
};

class DoubleConstant : public Expr
{
  protected:
    double value;

  public:
    
    DoubleConstant(yyltype loc, double val);
    
    const char *nombreNodo() { return "DoubleConstant"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();
};

class BoolConstant : public Expr
{
  protected:
    bool value;

  public:
    
    BoolConstant(yyltype loc, bool val);
    
    const char *nombreNodo() { return "BoolConstant"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();
};

class StringConstant : public Expr
{
  protected:
    char *value;

  public:
    
    StringConstant(yyltype loc, const char *val);
    
    const char *nombreNodo() { return "StringConstant"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();
};

class NullConstant: public Expr
{
  public:
    
    NullConstant(yyltype loc) : Expr(loc) {}
    
    const char *nombreNodo() { return "NullConstant"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();
};

class Operator : public Node
{
  protected:
    char tokenString[4];

  public:
    
    Operator(yyltype loc, const char *tok);
    
    const char *nombreNodo() { return "Operator"; }
    void impresionAux(int indentLevel);
    friend std::ostream& operator<<(std::ostream& out, Operator *o)
        { return out << o->tokenString; }
    
    const char * GetOpStr() { return tokenString; }
};

class CompoundExpr : public Expr
{
  protected:
    Operator *op;
    Expr *left, *right; 

  public:
    
    CompoundExpr(Expr *lhs, Operator *op, Expr *rhs); 
    CompoundExpr(Operator *op, Expr *rhs);            
    
    void impresionAux(int indentLevel);
};

class ArithmeticExpr : public CompoundExpr
{
  public:
    
    ArithmeticExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    ArithmeticExpr(Operator *op, Expr *rhs) : CompoundExpr(op,rhs) {}
    
    const char *nombreNodo() { return "ArithmeticExpr"; }
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckType();
};

class RelationalExpr : public CompoundExpr
{
  public:
    
    RelationalExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    
    const char *nombreNodo() { return "RelationalExpr"; }
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckType();
};

class EqualityExpr : public CompoundExpr
{
  public:
    
    EqualityExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    
    const char *nombreNodo() { return "EqualityExpr"; }
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckType();
};

class LogicalExpr : public CompoundExpr
{
  public:
    
    LogicalExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    LogicalExpr(Operator *op, Expr *rhs) : CompoundExpr(op,rhs) {}
    
    const char *nombreNodo() { return "LogicalExpr"; }
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckType();
};

class AssignExpr : public CompoundExpr
{
  public:
    
    AssignExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    
    const char *nombreNodo() { return "AssignExpr"; }
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckType();
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
    
    const char *nombreNodo() { return "This"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckType();
};

class ArrayAccess : public LValue
{
  protected:
    Expr *base, *subscript;

  public:
    
    ArrayAccess(yyltype loc, Expr *base, Expr *subscript);
    
    const char *nombreNodo() { return "ArrayAccess"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();
    bool IsArrayAccessRef() { return true; }
    Location * GetEmitLocDeref();

  protected:
    void CheckType();
};

/* Note that field access is used both for qualified names
 * base.field and just field without qualification. We don't
 * know for sure whether there is an implicit "this." in
 * front until later on, so we use one node type for either
 * and sort it out later. */
class FieldAccess : public LValue
{
  protected:
    Expr *base; 
    Identifier *field;

  public:
    
    FieldAccess(Expr *base, Identifier *field); 
    
    const char *nombreNodo() { return "FieldAccess"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();
    Location * GetEmitLocDeref();

  protected:
    void CheckDecl();
    void CheckType();
};

/* Like field access, call is used both for qualified base.field()
 * and unqualified field().  We won't figure out until later
 * whether we need implicit "this." so we use one node type for either
 * and sort it out later. */
class Call : public Expr
{
  protected:
    Expr *base; 
    Identifier *field;
    List<Expr*> *actuals;

  public:
    
    Call(yyltype loc, Expr *base, Identifier *field, List<Expr*> *args);
    
    const char *nombreNodo() { return "Call"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckDecl();
    void CheckType();
    void CheckFuncArgs();
};

class NewExpr : public Expr
{
  protected:
    NamedType *cType;

  public:
    
    NewExpr(yyltype loc, NamedType *clsType);
    
    const char *nombreNodo() { return "NewExpr"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckDecl();
    void CheckType();
};

class NewArrayExpr : public Expr
{
  protected:
    Expr *size;
    Type *elemType;

  public:
    
    NewArrayExpr(yyltype loc, Expr *sizeExpr, Type *elemType);
    
    const char *nombreNodo() { return "NewArrayExpr"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckType();
};

class ReadIntegerExpr : public Expr
{
  public:
    
    ReadIntegerExpr(yyltype loc) : Expr(loc) {}
    
    const char *nombreNodo() { return "ReadIntegerExpr"; }
    
    void Check(checkT c);
    
    void Emit();
};

class ReadLineExpr : public Expr
{
  public:
    
    ReadLineExpr(yyltype loc) : Expr (loc) {}
    
    const char *nombreNodo() { return "ReadLineExpr"; }
    
    void Check(checkT c);
    
    void Emit();
};

class PostfixExpr : public Expr
{
  protected:
    LValue *lvalue;
    Operator *op;
  public:
    
    PostfixExpr(LValue *lv, Operator *op);
    
    const char *nombreNodo() { return "PostfixExpr"; }
    void impresionAux(int indentLevel);
    
    void Check(checkT c);
    
    void Emit();

  protected:
    void CheckType();
};

#endif

