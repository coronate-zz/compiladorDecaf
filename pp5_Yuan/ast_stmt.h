/* File: ast_stmt.h
 * ----------------
 * The Stmt class and its subclasses are used to represent
 * statements in the parse tree.  For each statment in the
 * language (for, if, return, etc.) there is a corresponding
 * node class for that construct.
 *
 * pp2: You will need to add new expression and statement node c
 * classes for the additional grammar elements (Switch/Postfix)
 *
 * pp3: You will need to extend the Stmt classes to implement
 * semantic analysis for rules pertaining to statements.
 *
 * pp5: You will need to extend the Stmt classes to implement
 * code generation for statements.
 *
 * Author: Deyuan Guo
 */

#ifndef _H_ast_stmt
#define _H_ast_stmt

#include "ast.h"
#include "list.h"

class Decl;
class VarDecl;
class Expr;

class Program : public Node
{
  protected:
    List<Decl*> *decls;

  public:
    // constructor.
    Program(List<Decl*> *declList);
    // print stuff.
    const char *GetPrintNameForNode() { return "Program"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check();
    void Check(checkT c) { Check(); }
    // code generation stuff.
    void Emit();
};

class Stmt : public Node
{
  public:
    // constructor.
    Stmt() : Node() {}
    Stmt(yyltype loc) : Node(loc) {}
};

class StmtBlock : public Stmt
{
  protected:
    List<VarDecl*> *decls;
    List<Stmt*> *stmts;

  public:
    // constructor.
    StmtBlock(List<VarDecl*> *variableDeclarations, List<Stmt*> *statements);
    // print stuff.
    const char *GetPrintNameForNode() { return "StmtBlock"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void BuildST();
};


class ConditionalStmt : public Stmt
{
  protected:
    Expr *test;
    Stmt *body;

  public:
    // constructor.
    ConditionalStmt(Expr *testExpr, Stmt *body);
};

class LoopStmt : public ConditionalStmt
{
  protected:
    const char *end_loop_label;

  public:
    // constructor.
    LoopStmt(Expr *testExpr, Stmt *body)
            : ConditionalStmt(testExpr, body) { end_loop_label = NULL; }
    // semantic check stuff.
    bool IsLoopStmt() { return true; }
    // code generation stuff.
    virtual const char * GetEndLoopLabel() { return end_loop_label; }
};

class ForStmt : public LoopStmt
{
  protected:
    Expr *init, *step;

  public:
    // constructor.
    ForStmt(Expr *init, Expr *test, Expr *step, Stmt *body);
    // print stuff.
    const char *GetPrintNameForNode() { return "ForStmt"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void BuildST();
    void CheckType();
};

class WhileStmt : public LoopStmt
{
  public:
    // constructor.
    WhileStmt(Expr *test, Stmt *body) : LoopStmt(test, body) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "WhileStmt"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void BuildST();
    void CheckType();
};

class IfStmt : public ConditionalStmt
{
  protected:
    Stmt *elseBody;

  public:
    // constructor.
    IfStmt(Expr *test, Stmt *thenBody, Stmt *elseBody);
    // print stuff.
    const char *GetPrintNameForNode() { return "IfStmt"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();

  protected:
    void BuildST();
    void CheckType();
};

class BreakStmt : public Stmt
{
  public:
    // constructor.
    BreakStmt(yyltype loc) : Stmt(loc) {}
    // print stuff.
    const char *GetPrintNameForNode() { return "BreakStmt"; }
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class IntConstant;

class CaseStmt : public Stmt
{
  protected:
    IntConstant *value;
    List<Stmt*> *stmts;
    const char *case_label;

  public:
    // constructor.
    CaseStmt(IntConstant *v, List<Stmt*> *stmts);
    // print stuff.
    const char *GetPrintNameForNode() { return value ? "Case" : "Default"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    bool IsCaseStmt() { return value ? true : false; }
    // code generation stuff.
    void Emit();
    void GenCaseLabel();
    const char * GetCaseLabel() { return case_label; }
    IntConstant * GetCaseValue() { return value; }

  protected:
    void BuildST();
};

class SwitchStmt : public Stmt
{
  protected:
    Expr *expr;
    List<CaseStmt*> *cases;
    const char *end_switch_label;

  public:
    // constructor.
    SwitchStmt(Expr *expr, List<CaseStmt*> *cases);
    // print stuff.
    const char *GetPrintNameForNode() { return "SwitchStmt"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
    bool IsSwitchStmt() { return true; }
    const char * GetEndSwitchLabel() { return end_switch_label; }

  protected:
    void BuildST();
};

class ReturnStmt : public Stmt
{
  protected:
    Expr *expr;

  public:
    // constructor.
    ReturnStmt(yyltype loc, Expr *expr);
    // print stuff.
    const char *GetPrintNameForNode() { return "ReturnStmt"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

class PrintStmt : public Stmt
{
  protected:
    List<Expr*> *args;

  public:
    // constructor.
    PrintStmt(List<Expr*> *arguments);
    // print stuff.
    const char *GetPrintNameForNode() { return "PrintStmt"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    // code generation stuff.
    void Emit();
};

#endif

