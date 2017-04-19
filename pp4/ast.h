

#ifndef _H_ast
#define _H_ast

#include <stdlib.h>    

#include <iostream>

#include "errors.h"
#include "hashtable.h"
#include "list.h"
#include "location.h"

class Decl;

class Node  {
 protected:
  yyltype *location;
  Node *parent;

 public:
  Node(yyltype loc);
  Node();
  virtual ~Node() {}
    
  yyltype *GetLocation()   { return location; }
  void SetParent(Node *p)  { parent = p; }
  Node *GetParent()        { return parent; }

  virtual void errorDeclReview() {}
  virtual void stmtReview() {}
  virtual Hashtable<Decl*> *GetSymTable() { return NULL; }
};
   

class Identifier : public Node 
{
 protected:
  char *name;
    
 public:
  Identifier(yyltype loc, const char *name);
  const char *GetName() { return name; }
  Decl * declIdReview();
  Decl * declIdReview(Hashtable<Decl*> *sym_table, const char *name);
  friend ostream& operator<<(ostream& out, Identifier *id) { if (id) return out << id->name; else return out;}
};


 
 
 
 
class Error : public Node
{
 public:
 Error() : Node() {}
};

#endif
