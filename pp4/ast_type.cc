

#include <string.h>

#include <typeinfo>

#include "ast_type.h"
#include "ast_decl.h"
#include "ast_stmt.h"
#include "errors.h"



Type *Type::intType    = new Type("int");
Type *Type::doubleType = new Type("double");
Type *Type::voidType   = new Type("void");
Type *Type::boolType   = new Type("bool");
Type *Type::nullType   = new Type("null");
Type *Type::stringType = new Type("string");
Type *Type::errorType  = new Type("error"); 

Type::Type(const char *n) {
  Assert(n);
  this->typeName = strdup(n);
}

bool Type::HasSameType(Type *t) {
   
   
   
   
   
  return this == t;
}

NamedType::NamedType(Identifier *i) : Type(*i->GetLocation()) {
  Assert(i != NULL);
  (this->id=i)->SetParent(this);
} 

bool NamedType::HasSameType(Type *nt) {
  if (typeid(*nt) == typeid(NamedType))
    return !strcmp(this->GetTypeName(), nt->GetTypeName());
  else
    return false;
}

void NamedType::errorTypeReview() {
  const char *name = this->id->GetName();
  Decl *decl = Program::sym_table->Lookup(name);
  if ((decl == NULL) || (((typeid(*decl) != typeid(ClassDecl))) && ((typeid(*decl) != typeid(InterfaceDecl)))))
    {
      ReportError::IdentifierNotDeclared(id, LookingForType);
      this->id = NULL;
    }
}

ArrayType::ArrayType(yyltype loc, Type *et) : Type(loc) {
  Assert(et != NULL);
  (this->elemType=et)->SetParent(this);
}

const char *ArrayType::GetTypeName() { 
  if (this->elemType) 
    {
      string delim = "[]";
      string str = this->elemType->GetTypeName() + delim;
      return str.c_str();
    }
  else 
    return NULL;
}


bool ArrayType::HasSameType(Type *at) {
  return this->elemType->HasSameType(at->GetElemType());
}

void ArrayType::errorTypeReview() {
  this->elemType->errorTypeReview();
}
