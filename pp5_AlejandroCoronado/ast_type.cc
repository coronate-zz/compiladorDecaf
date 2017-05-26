

#include <string.h>
#include "ast_decl.h"
#include "ast_type.h"
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
    typeName = strdup(n);
    expr_type = NULL;
}

void Type::impresionAux(int indentLevel) {
    printf("%s", typeName);
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
}


NamedType::NamedType(Identifier *i) : Type(*i->GetLocation()) {
    Assert(i != NULL);
    (id=i)->SetParent(this);
}

void NamedType::impresionAux(int indentLevel) {
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
    id->Print(indentLevel+1);
}




bool NamedType::IsEquivalentTo(Type *other) {
    Assert(this->GetType() && other->GetType());

    if (!other->IsNamedType()) {
        return false;
    } else {
        NamedType * nt = dynamic_cast<NamedType*>(other);
        return (id->IsEquivalentTo(nt->GetId()));
    }
}

/* NamedType A IsCompatibleWith NamedType B,
 * means that A = B,
 * or class B is the subclass of class A,
 * or class B or its parents implement interface A.
 */
bool NamedType::IsCompatibleWith(Type *other) {
    Assert(this->GetType() && other->GetType());

    if (other == nullType) {
        return true;
    } else if (!other->IsNamedType()) {
        return false;
    } else if (this->IsEquivalentTo(other)) {
        return true;
    } else {
        NamedType * nt = dynamic_cast<NamedType*>(other);
        Decl *decl1 = id->GetDecl();
        Decl *decl2 = nt->GetId()->GetDecl();
        Assert(decl1 && decl2);
        if (!decl2->IsClassDecl()) {
            return false;
        }
        ClassDecl *cdecl2 = dynamic_cast<ClassDecl*>(decl2);
        
        return cdecl2->IsChildOf(decl1);
    }
}

ArrayType::ArrayType(yyltype loc, Type *et) : Type(loc) {
    Assert(et != NULL);
    (elemType=et)->SetParent(this);
}
void ArrayType::impresionAux(int indentLevel) {
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
    elemType->Print(indentLevel+1);
}




bool ArrayType::IsEquivalentTo(Type *other) {
    Assert(this->GetType() && other->GetType());

    if (!other->IsArrayType()) {
        return false;
    } else {
        ArrayType * nt = dynamic_cast<ArrayType*>(other);
        return (elemType->IsEquivalentTo(nt->GetElemType()));
    }
}

bool ArrayType::IsCompatibleWith(Type *other) {
    Assert(this->GetType() && other->GetType());

    if (other == nullType) {
        return elemType->IsCompatibleWith(other);
    } else {
        return this->IsEquivalentTo(other);
    }
}





//-----------------------------CHECK-----------------------------------

void ArrayType::Check(checkT c) {
    if (c == E_CheckDecl) {
        this->CheckDecl();
    } else {
        elemType->Check(c);
    }
}
void NamedType::Check(checkT c, reasonT r) {
    if (c == E_CheckDecl) {
        this->CheckDecl(r);
    } else {
        id->Check(c);
    }
}
void Type::Check(checkT c) {
    if (c == E_CheckDecl) {
        Type::intType->SetSelfType();
        Type::doubleType->SetSelfType();
        Type::voidType->SetSelfType();
        Type::boolType->SetSelfType();
        Type::nullType->SetSelfType();
        Type::stringType->SetSelfType();
        Type::errorType->SetSelfType();
        expr_type = this;
    }
}



void NamedType::CheckDecl(reasonT r) {
    Decl *d = symtab->recorrerHash(this->id);
    if (d == NULL || (!d->IsClassDecl() && !d->IsInterfaceDecl())) {
        ReportError::IdentifierNotDeclared(this->id, r);
    } else if (r == LookingForClass && !d->IsClassDecl()) {
        ReportError::IdentifierNotDeclared(this->id, r);
    } else if (r == LookingForInterface && !d->IsInterfaceDecl()) {
        ReportError::IdentifierNotDeclared(this->id, r);
    } else {
        this->id->SetDecl(d);
        expr_type = this;
    }
}




void ArrayType::CheckDecl() {
    elemType->Check(E_CheckDecl);
    if (elemType->GetType()) {
        expr_type = this;
    }
}



//--------------------------HASH IMPLEMTATION-----------------------------


hashImplentation *symtab;

/* Scope class, maintain the necessary information of scope structure.
 */
class Scope
{
  protected:
    Hashtable<Decl*> *ht;
    const char *parent;                 
    std::list<const char *> *interface; 
    const char *owner;                  

  public:
    Scope() {
        ht = NULL;
        parent = NULL;
        interface = new std::list<const char *>;
        interface->clear();
        owner = NULL;
    }

    bool HasHT() { return ht == NULL ? false : true; }
    void BuildHT() { ht = new Hashtable<Decl*>; }
    Hashtable<Decl*> * GetHT() { return ht; }

    bool HasParent() { return parent == NULL ? false : true; }
    void SetParent(const char *p) { parent = p; }
    const char * GetParent() { return parent; }

    bool HasInterface() { return !interface->empty(); }
    void AddInterface(const char *p) { interface->push_back(p); }
    std::list<const char *> * GetInterface() { return interface; }

    bool HasOwner() { return owner == NULL ? false : true; }
    void SetOwner(const char *o) { owner = o; }
    const char * GetOwner() { return owner; }
};


hashImplentation::hashImplentation() {
    /* Init the global scope. */
    scopes = new std::vector<Scope *>;
    scopes->clear();
    scopes->push_back(new Scope());

    /* Init the active scopes, and active global scope 0. */
    activeScopes = new std::vector<int>;
    activeScopes->clear();
    activeScopes->push_back(0);

    /* Init scope counter and identifier counter. */
    cur_scope = 0;
    scope_cnt = 0;
    id_cnt = 0;
}


void hashImplentation::ReEnter() {
    activeScopes->clear();
    activeScopes->push_back(0);

    cur_scope = 0;
    scope_cnt = 0;
    id_cnt = 0;
}

/*
 * Enter a new scope.
 */
void hashImplentation::BuildScope() {
    scope_cnt++;
    scopes->push_back(new Scope());
    activeScopes->push_back(scope_cnt);
    cur_scope = scope_cnt;
}

/*
 * Enter a new scope, and set owner for class and interface.
 */
void hashImplentation::BuildScope(const char *key) {
    scope_cnt++;
    scopes->push_back(new Scope());
    scopes->at(scope_cnt)->SetOwner(key);
    activeScopes->push_back(scope_cnt);
    cur_scope = scope_cnt;
}

/*
 * Enter a new scope.
 */
void hashImplentation::EnterScope() {
    scope_cnt++;
    activeScopes->push_back(scope_cnt);
    cur_scope = scope_cnt;
}

/*
 * Find scope from owner name.
 */
int hashImplentation::FindScopeFromOwnerName(const char *key) {
    int scope = -1;

    for (int i = 0; i < scopes->size(); i++) {
        if (scopes->at(i)->HasOwner()) {
            if (!strcmp(key, scopes->at(i)->GetOwner())) {
                scope = i;;
                break;
            }
        }
    }

    return scope;
}

/*
 * Look up symbol in all active scopes.
 */
Decl * hashImplentation::recorrerHash(Identifier *id) {
    Decl *d = NULL;
    const char *parent = NULL;
    const char *key = id->GetIdName();

    

    
    for (int i = activeScopes->size(); i > 0; --i) {

        int scope = activeScopes->at(i-1);
        Scope *s = scopes->at(scope);

        if (s->HasHT()) {
            d = s->GetHT()->recorrerHash(key);
        }
        if (d != NULL) break;

        while (s->HasParent()) {
            parent = s->GetParent();
            scope = FindScopeFromOwnerName(parent);
            if (scope != -1) {
                if (scope == cur_scope) {
                    
                    break;
                } else {
                    s = scopes->at(scope);
                    if (s->HasHT()) {
                        d = s->GetHT()->recorrerHash(key);
                    }
                    if (d != NULL) break;
                }
            } else {
                break;
            }
        }
        if (d != NULL) break;
    }

    return d;
}

/*
 * Look up symbol in parent scopes.
 */
Decl * hashImplentation::recorrerHashParent(Identifier *id) {
    Decl *d = NULL;
    const char *parent = NULL;
    const char *key = id->GetIdName();
    Scope *s = scopes->at(cur_scope);

    
    while (s->HasParent()) {
        parent = s->GetParent();
        int scope = FindScopeFromOwnerName(parent);
        

        if (scope != -1) {
            if (scope == cur_scope) {
                
                break;
            } else {
                s = scopes->at(scope);
                if (s->HasHT()) {
                    d = s->GetHT()->recorrerHash(key);
                }
                if (d != NULL) break;
            }
        }
    }

    return d;
}

/*
 * Look up symbol in interface scopes.
 */
Decl * hashImplentation::recorrerHashInterface(Identifier *id) {
    Decl *d = NULL;
    const char *key = id->GetIdName();
    int scope;
    Scope *s = scopes->at(cur_scope);

    
    if (s->HasInterface()) {

        std::list<const char *> * itfc = s->GetInterface();

        for (std::list<const char *>::iterator it = itfc->begin();
                it != itfc->end(); it++) {
            scope = FindScopeFromOwnerName(*it);
            

            if (scope != -1) {
                Scope *sc = scopes->at(scope);
                if (sc->HasHT()) {
                    d = sc->GetHT()->recorrerHash(key);
                }
                if (d != NULL) break;
            }
        }
    }
    return d;
}

/*
 * Look up symbol in a given class/interface name.
 */
Decl * hashImplentation::recorrerHashField(Identifier *base, Identifier *field) {
    Decl *d = NULL;
    const char *b = base->GetIdName();
    const char *f = field->GetIdName();

    
    int scope = FindScopeFromOwnerName(b);
    if (scope == -1) return NULL;

    
    Scope *s = scopes->at(scope);
    if (s->HasHT()) {
        d = s->GetHT()->recorrerHash(f);
    }
    if (d != NULL) return d;

    
    while (s->HasParent()) {
        b = s->GetParent();
        scope = FindScopeFromOwnerName(b);
        if (scope != -1) {
            if (scope == cur_scope) {
                
                break;
            } else {
                s = scopes->at(scope);
                if (s->HasHT()) {
                    d = s->GetHT()->recorrerHash(f);
                }
                if (d != NULL) break;
            }
        } else {
            break;
        }
    }
    return d;
}

/*
 * Look up the class decl for This.
 */
Decl * hashImplentation::recorrerHashThis() {
    Decl *d = NULL;
    
    for (int i = activeScopes->size(); i > 0; --i) {

        int scope = activeScopes->at(i-1);
        Scope *s = scopes->at(scope);

        if (s->HasOwner()) {
            
            Scope *s0 = scopes->at(0);
            if (s0->HasHT()) {
                d = s0->GetHT()->recorrerHash(s->GetOwner());
            }
        }
        if (d) break;
    }
    return d;
}

/*
 * Insert new symbol into current scope.
 */
int hashImplentation::InsertSymbol(Decl *decl) {
    const char *key = decl->GetId()->GetIdName();
    Scope *s = scopes->at(cur_scope);

    if (!s->HasHT()) {
        s->BuildHT();
    }

    s->GetHT()->Enter(key, decl);
    return id_cnt++;
}

/*
 * Look up symbol in current scope.
 */
bool hashImplentation::LocalrecorrerHash(Identifier *id) {
    Decl *d = NULL;
    const char *key = id->GetIdName();
    Scope *s = scopes->at(cur_scope);

    if (s->HasHT()) {
        d = s->GetHT()->recorrerHash(key);
    }

    return (d == NULL) ? false : true;
}

/*
 * Exit current scope and return to its uplevel scope.
 */
void hashImplentation::ExitScope() {
    activeScopes->pop_back();
    cur_scope = activeScopes->back();
}

/*
 * Deal with class inheritance, set parent for a subclass.
 */
void hashImplentation::SetScopeParent(const char *key) {
    scopes->at(cur_scope)->SetParent(key);
}

/*
 * Deal with class interface, set interfaces for a subclass.
 */
void hashImplentation::SetInterface(const char *key) {
    scopes->at(cur_scope)->AddInterface(key);
}

/*
 * Print the whole symbol table.
 */
void hashImplentation::Print() {
    std::cout << std::endl << "======== Symbol Table ========" << std::endl;

    for (int i = 0; i < scopes->size(); i++) {
        Scope *s = scopes->at(i);

        if (!s->HasHT() && !s->HasOwner() && !s->HasParent()
                && !s->HasInterface()) continue;

        std::cout << "|- Scope " << i << ":";
        if (s->HasOwner())
            std::cout << " (owner: " << s->GetOwner() << ")";
        if (s->HasParent())
            std::cout << " (parent: " << s->GetParent() << ")";
        if (s->HasInterface()) {
            std::cout << " (interface: ";
            std::list<const char *> *interface = s->GetInterface();
            for (std::list<const char *>::iterator it = interface->begin();
                    it != interface->end(); it++) {
                std::cout << *it << " ";
            }
            std::cout << ")";
        }
        std::cout << std::endl;

        if (s->HasHT()) {
            Iterator<Decl*> iter = s->GetHT()->GetIterator();
            Decl *decl;
            while ((decl = iter.GetNextValue()) != NULL) {
                std::cout << "|  + " << decl << std::endl;
            }
        }
    }

    std::cout << "======== Symbol Table ========" << std::endl;
}

