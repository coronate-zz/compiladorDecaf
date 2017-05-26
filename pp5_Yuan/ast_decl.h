/* File: ast_decl.h
 * ----------------
 * In our parse tree, Decl nodes are used to represent and
 * manage declarations. There are 4 subclasses of the base class,
 * specialized for declarations of variables, functions, classes,
 * and interfaces.
 *
 * pp3: You will need to extend the Decl classes to implement
 * semantic processing including detection of declaration conflicts
 * and managing scoping issues.
 *
 * pp5: You will need to extend the Decl classes to implement
 * code generation for declarations.
 *
 * Author: Deyuan Guo
 */

#ifndef _H_ast_decl
#define _H_ast_decl

#include "ast.h"
#include "list.h"
#include "ast_type.h"

class Type;
class NamedType;
class Identifier;
class Stmt;

class Decl : public Node
{
  protected:
    Identifier *id;
    int idx;

  public:
    // constructor.
    Decl(Identifier *name);
    // print stuff.
    friend std::ostream& operator<<(std::ostream& out, Decl *d)
        { return out << d->id; }
    // semantic check stuff.
    Identifier * GetId() { return id; }
    int GetIndex() { return idx; }
    virtual bool IsVarDecl() { return false; }
    virtual bool IsClassDecl() { return false; }
    virtual bool IsInterfaceDecl() { return false; }
    virtual bool IsFnDecl() { return false; }
    // code generation stuff.
    virtual void AssignOffset() {}
    virtual void AssignMemberOffset(bool inClass, int offset) {}
    virtual void AddPrefixToMethods() {}
};

class VarDecl : public Decl
{
  protected:
    Type *type;
    bool is_global;
    int class_member_ofst;

  public:
    // constructor.
    VarDecl(Identifier *name, Type *type);
    // print stuff.
    const char *GetPrintNameForNode() { return "VarDecl"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    bool IsVarDecl() { return true; }
    // code generation stuff.
    void AssignOffset();
    void AssignMemberOffset(bool inClass, int offset);
    void Emit();
    void SetEmitLoc(Location *l) { emit_loc = l; }

  protected:
    void BuildST();
    void CheckDecl();
    bool IsGlobal() { return this->GetParent()->GetParent() == NULL; }
    bool IsClassMember() {
        Decl *d = dynamic_cast<Decl*>(this->GetParent());
        return d ? d->IsClassDecl() : false;
    }
};

class FnDecl;

class ClassDecl : public Decl
{
  protected:
    List<Decl*> *members;
    NamedType *extends;
    List<NamedType*> *implements;
    int instance_size;
    int vtable_size;
    List<VarDecl*> *var_members;
    List<FnDecl*> *methods;

  public:
    // constructor.
    ClassDecl(Identifier *name, NamedType *extends,
              List<NamedType*> *implements, List<Decl*> *members);
    // print stuff.
    const char *GetPrintNameForNode() { return "ClassDecl"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    bool IsClassDecl() { return true; }
    bool IsChildOf(Decl *other);
    NamedType * GetExtends() { return extends; }
    // code generation stuff.
    void AssignOffset();
    void Emit();
    int GetInstanceSize() { return instance_size; }
    int GetVTableSize() { return vtable_size; }
    void AddMembersToList(List<VarDecl*> *vars, List<FnDecl*> *fns);
    void AddPrefixToMethods();

  protected:
    void BuildST();
    void CheckDecl();
    void CheckInherit();
};

class InterfaceDecl : public Decl
{
  protected:
    List<Decl*> *members;

  public:
    // constructor.
    InterfaceDecl(Identifier *name, List<Decl*> *members);
    // print stuff.
    const char *GetPrintNameForNode() { return "InterfaceDecl"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    bool IsInterfaceDecl() { return true; }
    List<Decl*> * GetMembers() { return members; }
    // code generation stuff.
    void Emit();

  protected:
    void BuildST();
    void CheckDecl();
};

class FnDecl : public Decl
{
  protected:
    List<VarDecl*> *formals;
    Type *returnType;
    Stmt *body;
    int vtable_ofst;

  public:
    // constructor.
    FnDecl(Identifier *name, Type *returnType, List<VarDecl*> *formals);
    void SetFunctionBody(Stmt *b);
    // print stuff.
    const char *GetPrintNameForNode() { return "FnDecl"; }
    void PrintChildren(int indentLevel);
    // semantic check stuff.
    void Check(checkT c);
    bool IsFnDecl() { return true; }
    bool IsEquivalentTo(Decl *fn);
    List<VarDecl*> * GetFormals() { return formals; }
    // code generation stuff.
    void AddPrefixToMethods();
    void AssignMemberOffset(bool inClass, int offset);
    void Emit();
    int GetVTableOffset() { return vtable_ofst; }
    bool HasReturnValue() { return returnType != Type::voidType; }
    bool IsClassMember() {
        Decl *d = dynamic_cast<Decl*>(this->GetParent());
        return d ? d->IsClassDecl() : false;
    }

  protected:
    void BuildST();
    void CheckDecl();
};

#endif

