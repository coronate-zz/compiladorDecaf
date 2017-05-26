/* File: ast_expr.h
 * ----------------
 * The Expr class and its subclasses are used to represent
 * expressions in the parse tree.  For each expression in the
 * language (add, call, New, etc.) there is a corresponding
 * node class for that construct.
 *
 * pp3: You will need to extend the Expr classes to implement
 * semantic analysis for rules pertaining to expressions.
 *
 * pp5: You will need to extend the Expr classes to implement
 * code generation for expressions.
 *
 * Author: Deyuan Guo
 */

#ifndef _H_ast_expr
#define _H_ast_expr

#include "ast.h"
#include "ast_stmt.h"
#include "list.h"
#include "ast_type.h"

class NamedType; // for new
class Type; // for NewArray

class Expr : public Stmt
{
  public:
    // constructor.
    Expr(yyltype loc) : Stmt(loc) { expr_type = NULL; }
    Expr() : Stmt() { expr_type = NULL; }
    // code generation stuff.
    virtual Location * GetEmitLocDeref() { return GetEmitLoc(); }
    virtual bool IsArrayAccessRef() { return false; }
    virtual bool IsEmptyExpr() { return false; }
};

/* This node type is used for those places where an expression is optional.
 * We could use a NULL pointer, but then it adds a lot of checking for
 * NULL. By using a valid, but no-op, node, we save that trouble */
class EmptyExpr : public Expr
{
  public:
    // print stuff.
    const char *GetPrintNameForNode() { return "Empty"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    bool IsEmptyExpr() { return true; }
};

class IntConstant : public Expr
{
  protected:
    int value;

  public:
    // constructor.
    IntConstant(yyltype loc, int val);
    // print stuff.
    const char *GetPrintNameForNode() { return "IntConstant"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class DoubleConstant : public Expr
{
  protected:
    double value;

  public:
    // constructor.
    DoubleConstant(yyltype loc, double val);
    // print stuff.
    const char *GetPrintNameForNode() { return "DoubleConstant"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class BoolConstant : public Expr
{
  protected:
    bool value;

  public:
    // constructor.
    BoolConstant(yyltype loc, bool val);
    // print stuff.
    const char *GetPrintNameForNode() { return "BoolConstant"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class StringConstant : public Expr
{
  protected:
    char *value;

  public:
    // constructor.
    StringConstant(yyltype loc, const char *val);
    // print stuff.
    const char *GetPrintNameForNode() { return "StringConstant"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class NullConstant: public Expr
{
  public:
    // constructor.
    NullConstant(yyltype loc) : Expr(loc) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "NullConstant"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class Operator : public Node
{
  protected:
    char tokenString[4];

  public:
    // constructor.
    Operator(yyltype loc, const char *tok);
    // print stuff.
    const char *GetPrintNameForNode() { return "Operator"; }
    void PrintChildren(int indentLevel);
    friend std::ostream& operator<<(std::ostream& out, Operator *o)
        { return out << o->tokenString; }
    // semantic check stuff.
    const char * GetOpStr() { return tokenString; }
};

class CompoundExpr : public Expr
{
  protected:
    Operator *op;
    Expr *left, *right; // left will be NULL if unary

  public:
    // constructor.
    CompoundExpr(Expr *lhs, Operator *op, Expr *rhs); // for binary
    CompoundExpr(Operator *op, Expr *rhs);            // for unary
    // print stuff.
    void PrintChildren(int indentLevel);
};

class ArithmeticExpr : public CompoundExpr
{
  public:
    // constructor.
    ArithmeticExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    ArithmeticExpr(Operator *op, Expr *rhs) : CompoundExpr(op,rhs) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "ArithmeticExpr"; }
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void CheckType();
};

class RelationalExpr : public CompoundExpr
{
  public:
    // constructor.
    RelationalExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "RelationalExpr"; }
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void CheckType();
};

class EqualityExpr : public CompoundExpr
{
  public:
    // constructor.
    EqualityExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "EqualityExpr"; }
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void CheckType();
};

class LogicalExpr : public CompoundExpr
{
  public:
    // constructor.
    LogicalExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    LogicalExpr(Operator *op, Expr *rhs) : CompoundExpr(op,rhs) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "LogicalExpr"; }
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void CheckType();
};

class AssignExpr : public CompoundExpr
{
  public:
    // constructor.
    AssignExpr(Expr *lhs, Operator *op, Expr *rhs)
        : CompoundExpr(lhs,op,rhs) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "AssignExpr"; }
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void CheckType();
};

class LValue : public Expr
{
  public:
    // constructor.
    LValue(yyltype loc) : Expr(loc) {}
};

class This : public Expr
{
  public:
    // constructor.
    This(yyltype loc) : Expr(loc) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "This"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void CheckType();
};

class ArrayAccess : public LValue
{
  protected:
    Expr *base, *subscript;

  public:
    // constructor.
    ArrayAccess(yyltype loc, Expr *base, Expr *subscript);
    // print stuff.
    const char *GetPrintNameForNode() { return "ArrayAccess"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
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
    Expr *base; // will be NULL if no explicit base
    Identifier *field;

  public:
    // constructor.
    FieldAccess(Expr *base, Identifier *field); //ok to pass NULL base
    // print stuff.
    const char *GetPrintNameForNode() { return "FieldAccess"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
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
    Expr *base; // will be NULL if no explicit base
    Identifier *field;
    List<Expr*> *actuals;

  public:
    // constructor.
    Call(yyltype loc, Expr *base, Identifier *field, List<Expr*> *args);
    // print stuff.
    const char *GetPrintNameForNode() { return "Call"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
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
    // constructor.
    NewExpr(yyltype loc, NamedType *clsType);
    // print stuff.
    const char *GetPrintNameForNode() { return "NewExpr"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
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
    // constructor.
    NewArrayExpr(yyltype loc, Expr *sizeExpr, Type *elemType);
    // print stuff.
    const char *GetPrintNameForNode() { return "NewArrayExpr"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void CheckType();
};

class ReadIntegerExpr : public Expr
{
  public:
    // constructor.
    ReadIntegerExpr(yyltype loc) : Expr(loc) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "ReadIntegerExpr"; }
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class ReadLineExpr : public Expr
{
  public:
    // constructor.
    ReadLineExpr(yyltype loc) : Expr (loc) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "ReadLineExpr"; }
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class PostfixExpr : public Expr
{
  protected:
    LValue *lvalue;
    Operator *op;
  public:
    // constructor.
    PostfixExpr(LValue *lv, Operator *op);
    // print stuff.
    const char *GetPrintNameForNode() { return "PostfixExpr"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void CheckType();
};

#endif

