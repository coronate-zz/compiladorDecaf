
#include <stdio.h>   
#include <string.h>  
#include "ast.h"
#include "ast_decl.h"
#include "ast_stmt.h"
#include "ast_type.h"
#include "errors.h"

Node::Node(yyltype loc) {
  this->location = new yyltype(loc);
  this->parent = NULL;
}

Node::Node() {
  this->location = NULL;
  this->parent = NULL;
}
	 
Identifier::Identifier(yyltype loc, const char *n) : Node(loc) {
  this->name = strdup(n);
}

Decl *Identifier::ReviewIdDecl() {
  Decl *decl = NULL;
  Node *parent = this->GetParent();
  while (parent)
    {
      Hashtable<Decl*> *tablaHash = parent->GetSymTable();
      if (tablaHash != NULL)
	{
	  if ((decl = tablaHash->Lookup(this->name)) != NULL)
	    return decl;
	}
      parent = parent->GetParent();
    }

  decl = Program::tablaHash->Lookup(this->name);

  return decl;
}

 
Decl *Identifier::ReviewIdDecl(Hashtable<Decl*> *tablaHash, const char *name)
{
  Decl *decl = NULL;
  if (tablaHash)
    decl = tablaHash->Lookup(name);
  return decl;
}
