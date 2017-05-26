

#ifndef _H_ast_type
#define _H_ast_type

#include <iostream>


#include <list>
#include <vector>
#include "hashtable.h"
#include "ast.h"
#include "list.h"

class Type : public Node
{
  protected:
    char *typeName;

  public :
    
    static Type *intType, *doubleType, *boolType, *voidType,
                *nullType, *stringType, *errorType;
    
    Type(yyltype loc) : Node(loc) { expr_type = NULL; }
    Type(const char *str);
    
    const char *nombreNodo() { return "Type"; }
    void impresionAux(int indentLevel);
    virtual void PrintToStream(std::ostream& out) { out << typeName; }
    friend std::ostream& operator<<(std::ostream& out, Type *t)
        { t->PrintToStream(out); return out; }
    
    void Check(checkT c);
    virtual void Check(checkT c, reasonT r) { Check(c); }
    virtual bool IsBasicType() { return !IsNamedType() && !IsArrayType(); }
    virtual bool IsNamedType() { return false; }
    virtual bool IsArrayType() { return false; }
    virtual bool IsEquivalentTo(Type *other) { return this == other; }
    virtual bool IsCompatibleWith(Type *other) { return this == other; }
    char * GetTypeName() { return typeName; }
    virtual void SetSelfType() { expr_type = this; }
    
    virtual int GetTypeSize() { return 4; }
};

class NamedType : public Type
{
  protected:
    Identifier *id;

  public:
    
    NamedType(Identifier *i);
    
    const char *nombreNodo() { return "NamedType"; }
    void impresionAux(int indentLevel);
    void PrintToStream(std::ostream& out) { out << id; }
    
    void Check(checkT c, reasonT r);
    void Check(checkT c) { Check(c, LookingForType); }
    bool IsNamedType() { return true; }
    bool IsEquivalentTo(Type *other);
    bool IsCompatibleWith(Type *other);
    Identifier *GetId() { return id; }

  protected:
    void CheckDecl(reasonT r);
};

class ArrayType : public Type
{
  protected:
    Type *elemType;

  public:
    
    ArrayType(yyltype loc, Type *elemType);
    
    const char *nombreNodo() { return "ArrayType"; }
    void impresionAux(int indentLevel);
    void PrintToStream(std::ostream& out) { out << elemType << "[]"; }
    
    void Check(checkT c);
    bool IsArrayType() { return true; }
    bool IsEquivalentTo(Type *other);
    bool IsCompatibleWith(Type *other);
    Type * GetElemType() { return elemType->GetType(); }

  protected:
    void CheckDecl();
};




/* Symbol Table Implementation. */

class Decl;
class Identifier;
class Scope;

class hashImplentation
{
  protected:
    std::vector<Scope *> *scopes;
    std::vector<int> *activeScopes;
    int cur_scope;  /* current scope */
    int scope_cnt;  /* scope counter */
    int id_cnt;

  public:
    hashImplentation();

    /* Enter a new scope. */
    void BuildScope();
    /* Enter a new scope, and set owner for class and interface. */
    void BuildScope(const char *key);
    /* Enter a new scope without build new hashtable. */
    void EnterScope();
    /* Look up symbol in all active scopes. */
    Decl *recorrerHash(Identifier *id);
    /* Look up symbol in parent scopes. */
    Decl *recorrerHashParent(Identifier *id);
    /* Look up symbol in interface scopes. */
    Decl *recorrerHashInterface(Identifier *id);
    /* Look up symbol in a given class/interface name. */
    Decl *recorrerHashField(Identifier *base, Identifier *field);
    /* Look up the class decl for This. */
    Decl *recorrerHashThis();
    /* Insert new symbol into current scope. */
    int InsertSymbol(Decl *decl);
    /* Look up symbol in current scope. */
    bool LocalrecorrerHash(Identifier *id);
    /* Exit current scope and return to its parent scope. */
    void ExitScope();

    /* Deal with class inheritance, set parent for a subclass. */
    void SetScopeParent(const char *key);
    /* Deal with class interface, set interfaces for a subclass. */
    void SetInterface(const char *key);

    /* Resert symbol table counter and active scopes for another pass. */
    void ReEnter();

    /* Print the whole symbol table. */
    void Print();

  protected:
    int FindScopeFromOwnerName(const char *owner);

};

extern hashImplentation *symtab;

#endif


