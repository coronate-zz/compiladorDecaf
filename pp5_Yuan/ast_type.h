/* File: ast_type.h
 * ----------------
 * In our parse tree, Type nodes are used to represent and
 * store type information. The base Type class is used
 * for built-in types, the NamedType for classes and interfaces,
 * and the ArrayType for arrays of other types.
 *
 * pp3: You will need to extend the Type classes to implement
 * the type system and rules for type equivalency and compatibility.
 *
 * pp5: You will need to extend the Type classes to implement
 * code generation for types.
 *
 * Author: Deyuan Guo
 */

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
    // basic types.
    static Type *intType, *doubleType, *boolType, *voidType,
                *nullType, *stringType, *errorType;
    // constructor.
    Type(yyltype loc) : Node(loc) { expr_type = NULL; }
    Type(const char *str);
    // print stuff.
    const char *GetPrintNameForNode() { return "Type"; }
    void PrintChildren(int indentLevel);
    virtual void PrintToStream(std::ostream& out) { out << typeName; }
    friend std::ostream& operator<<(std::ostream& out, Type *t)
        { t->PrintToStream(out); return out; }
    // semantic check stuff.
    void Check(checkT c);
    virtual void Check(checkT c, reasonT r) { Check(c); }
    virtual bool IsBasicType() { return !IsNamedType() && !IsArrayType(); }
    virtual bool IsNamedType() { return false; }
    virtual bool IsArrayType() { return false; }
    virtual bool IsEquivalentTo(Type *other) { return this == other; }
    virtual bool IsCompatibleWith(Type *other) { return this == other; }
    char * GetTypeName() { return typeName; }
    virtual void SetSelfType() { expr_type = this; }
    // code generation stuff.
    virtual int GetTypeSize() { return 4; }
};

class NamedType : public Type
{
  protected:
    Identifier *id;

  public:
    // constructor.
    NamedType(Identifier *i);
    // print stuff.
    const char *GetPrintNameForNode() { return "NamedType"; }
    void PrintChildren(int indentLevel);
    void PrintToStream(std::ostream& out) { out << id; }
    // semantic check stuff.
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
    // constructor.
    ArrayType(yyltype loc, Type *elemType);
    // print stuff.
    const char *GetPrintNameForNode() { return "ArrayType"; }
    void PrintChildren(int indentLevel);
    void PrintToStream(std::ostream& out) { out << elemType << "[]"; }
    // semantic check stuff.
    void Check(checkT c);
    bool IsArrayType() { return true; }
    bool IsEquivalentTo(Type *other);
    Type * GetElemType() { return elemType->GetType(); }

  protected:
    void CheckDecl();
};




/* Symbol Table Implementation. */

class Decl;
class Identifier;
class Scope;

class SymbolTable
{
  protected:
    std::vector<Scope *> *scopes;
    std::vector<int> *activeScopes;
    int cur_scope;  /* current scope */
    int scope_cnt;  /* scope counter */
    int id_cnt;

  public:
    SymbolTable();

    /* Enter a new scope. */
    void BuildScope();
    /* Enter a new scope, and set owner for class and interface. */
    void BuildScope(const char *key);
    /* Enter a new scope without build new hashtable. */
    void EnterScope();
    /* Look up symbol in all active scopes. */
    Decl *Lookup(Identifier *id);
    /* Look up symbol in parent scopes. */
    Decl *LookupParent(Identifier *id);
    /* Look up symbol in interface scopes. */
    Decl *LookupInterface(Identifier *id);
    /* Look up symbol in a given class/interface name. */
    Decl *LookupField(Identifier *base, Identifier *field);
    /* Look up the class decl for This. */
    Decl *LookupThis();
    /* Insert new symbol into current scope. */
    int InsertSymbol(Decl *decl);
    /* Look up symbol in current scope. */
    bool LocalLookup(Identifier *id);
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

extern SymbolTable *symtab;

#endif


