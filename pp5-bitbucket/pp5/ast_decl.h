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
 */

#ifndef _H_ast_decl
#define _H_ast_decl

#include <set>
#include "ast.h"
#include "list.h"
#include "hashtable.h"
#include "codegen.h"

class Type;
class NamedType;
class Identifier;
class Stmt;

class Decl : public Node 
{
  public:
    Identifier *id;
  
    Decl(Identifier *name);
    friend std::ostream& operator<<(std::ostream& out, Decl *d) { return out << d->id; }
    virtual void Check(Hashtable<Node*> *, int);
};

class VarDecl : public Decl 
{
  public:
    Type *type;
    Location* frameLocation;
    int locationInObject;
    
    VarDecl(Identifier *name, Type *type);
    virtual void Check(Hashtable<Node*> *, int);
    virtual void Emit(CodeGenerator*);
    NamedType* getClassName();
};

class ClassDecl : public Decl 
{
  protected:
    List<Decl*> *members;
    NamedType *extends;
    List<NamedType*> *implements;

  public:
    NamedType* type;
    int objectSize; // in number of vars
    ClassDecl(Identifier *name, NamedType *extends, 
    List<NamedType*> *implements, List<Decl*> *members);
    virtual void Check(Hashtable<Node*> *, int);
    virtual void Emit(CodeGenerator*);
    void Implementer(InterfaceDecl* interface);
    virtual bool SonOf(const char *other);
    void GetMethodNamesOfParent(List<const char*>*);
    int getObjectSize();
};

class InterfaceDecl : public Decl 
{
  public:
    List<Decl*> *members;
    InterfaceDecl(Identifier *name, List<Decl*> *members);
    virtual void Check(Hashtable<Node*> *, int);
};

class FnDecl : public Decl 
{
  public:
    List<VarDecl*> *formals;
    Type *returnType;
    Stmt *body;
    int vtableOffset;
    
    FnDecl(Identifier *name, Type *returnType, List<VarDecl*> *formals);
    void SetFunctionBody(Stmt *b);
    virtual void Check(Hashtable<Node*> *, int);
    virtual void Emit(CodeGenerator*);
    bool Equals(FnDecl* other);
    const char* getFunctionLabel();
    const char* getFunctionLabel(const char* basename);
};

#endif
