

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

 
Decl *Identifier:: declIdReview() {
  Decl *decl = NULL;
  Node *parent = this->GetParent();
  while (parent)
    {
      Hashtable<Decl*> *sym_table = parent->GetSymTable();
      if (sym_table != NULL)
	{
	  if ((decl = sym_table->Lookup(this->name)) != NULL)
	    return decl;
	}
      parent = parent->GetParent();
    }

  decl = Program::sym_table->Lookup(this->name);

  return decl;
}

 
Decl *Identifier:: declIdReview(Hashtable<Decl*> *sym_table, const char *name)
{
  Decl *decl = NULL;
  if (sym_table)
    decl = sym_table->Lookup(name);
  return decl;
}
