/* File: ast_type.cc
 * -----------------
 * Implementation of type node classes.
 */
#include "ast_type.h"
#include "ast_decl.h"
#include <string.h>

 
/* Class constants
 * ---------------
 * These are public constants for the built-in base types (int, double, etc.)
 * They can be accessed with the syntax Type::intType. This allows you to
 * directly access them and share the built-in types where needed rather that
 * creates lots of copies.
 */

Type *Type::intType    = new Type("int");
Type *Type::doubleType = new Type("double");
Type *Type::voidType   = new Type("void");
Type *Type::boolType   = new Type("bool");
Type *Type::nullType   = new Type("null");
Type *Type::stringType = new Type("string");
Type *Type::errorType  = new Type("error"); 

Type::Type(const char *n) {
    Assert(n);
    typeName = strdup(n);
    named = false;
}
	
bool Type::IsCompatibleWith(Hashtable<Node*> *table, Type *other) {
    if (this == Type::nullType && other->named) return true;
    return this == other;
}

NamedType::NamedType(Identifier *i) : Type(*i->GetLocation()) {
    Assert(i != NULL);
    (id=i)->SetParent(this);
    named = true;
    typeName = i->name;
} 

void NamedType::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
    } else if (pass == 2) {
        if (dynamic_cast<ClassDecl*>(table->get(id->name)) == NULL && dynamic_cast<InterfaceDecl*>(table->get(id->name)) == NULL) {
            ReportError::IdentifierNotDeclared(id, LookingForType); 
        } 
    }
}

bool NamedType::IsCompatibleWith(Hashtable<Node*> *table, Type *other) {
    if (other == Type::nullType) return true;

    NamedType* nt = dynamic_cast<NamedType*>(other);
    if (!nt) return false; 
    
    ClassDecl* cd = dynamic_cast<ClassDecl*>(table->get(this->id->name));
    if (!cd) {
        return false;
    }
    if (strcmp(cd->id->name, nt->id->name) == 0) return true;
    return cd->SonOf(nt->id->name);
}

ArrayType::ArrayType(yyltype loc, Type *et) : Type(loc) {
    Assert(et != NULL);
    (elemType=et)->SetParent(this);
}

void ArrayType::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        elemType->Check(table, pass);
    } else if (pass == 2) {
        elemType->Check(table, pass);
    }
}

bool ArrayType::IsCompatibleWith(Hashtable<Node*> *table, Type *other) {
    ArrayType* at = dynamic_cast<ArrayType*>(other);
    if (!at) { 
       return false; 
    }
    return elemType->IsCompatibleWith(table, at->elemType); 
}

