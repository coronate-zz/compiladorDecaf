/* File: ast_type.cc
 * -----------------
 * Implementation of type node classes.
 *
 * Author: Deyuan Guo
 */

#include <string.h>
#include "ast_decl.h"
#include "ast_type.h"
#include "errors.h"

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
    expr_type = NULL;
}

void Type::PrintChildren(int indentLevel) {
    printf("%s", typeName);
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
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

NamedType::NamedType(Identifier *i) : Type(*i->GetLocation()) {
    Assert(i != NULL);
    (id=i)->SetParent(this);
}

void NamedType::PrintChildren(int indentLevel) {
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
    id->Print(indentLevel+1);
}

void NamedType::CheckDecl(reasonT r) {
    Decl *d = symtab->Lookup(this->id);
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

void NamedType::Check(checkT c, reasonT r) {
    if (c == E_CheckDecl) {
        this->CheckDecl(r);
    } else {
        id->Check(c);
    }
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
        // subclass can compatible with its parent class and interface.
        return cdecl2->IsChildOf(decl1);
    }
}

ArrayType::ArrayType(yyltype loc, Type *et) : Type(loc) {
    Assert(et != NULL);
    (elemType=et)->SetParent(this);
}
void ArrayType::PrintChildren(int indentLevel) {
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
    elemType->Print(indentLevel+1);
}

void ArrayType::CheckDecl() {
    elemType->Check(E_CheckDecl);
    if (elemType->GetType()) {
        expr_type = this;
    }
}

void ArrayType::Check(checkT c) {
    if (c == E_CheckDecl) {
        this->CheckDecl();
    } else {
        elemType->Check(c);
    }
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






SymbolTable *symtab;

/* Scope class, maintain the necessary information of scope structure.
 */
class Scope
{
  protected:
    Hashtable<Decl*> *ht;
    const char *parent;                 // record the class inheritance
    std::list<const char *> *interface; // record the interface of class
    const char *owner;                  // record the scope owner for class

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

/* Implementation of Symbol Table
 */
SymbolTable::SymbolTable() {
    PrintDebug("sttrace", "SymbolTable constructor.\n");
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

/*
 * Resert symbol table counter and active scopes for another pass.
 */
void SymbolTable::ReEnter() {
    PrintDebug("sttrace", "======== Reenter SymbolTable ========\n");
    activeScopes->clear();
    activeScopes->push_back(0);

    cur_scope = 0;
    scope_cnt = 0;
    id_cnt = 0;
}

/*
 * Enter a new scope.
 */
void SymbolTable::BuildScope() {
    PrintDebug("sttrace", "Build new scope %d.\n", scope_cnt + 1);
    scope_cnt++;
    scopes->push_back(new Scope());
    activeScopes->push_back(scope_cnt);
    cur_scope = scope_cnt;
}

/*
 * Enter a new scope, and set owner for class and interface.
 */
void SymbolTable::BuildScope(const char *key) {
    PrintDebug("sttrace", "Build new scope %d.\n", scope_cnt + 1);
    scope_cnt++;
    scopes->push_back(new Scope());
    scopes->at(scope_cnt)->SetOwner(key);
    activeScopes->push_back(scope_cnt);
    cur_scope = scope_cnt;
}

/*
 * Enter a new scope.
 */
void SymbolTable::EnterScope() {
    PrintDebug("sttrace", "Enter scope %d.\n", scope_cnt + 1);
    scope_cnt++;
    activeScopes->push_back(scope_cnt);
    cur_scope = scope_cnt;
}

/*
 * Find scope from owner name.
 */
int SymbolTable::FindScopeFromOwnerName(const char *key) {
    int scope = -1;

    for (int i = 0; i < scopes->size(); i++) {
        if (scopes->at(i)->HasOwner()) {
            if (!strcmp(key, scopes->at(i)->GetOwner())) {
                scope = i;;
                break;
            }
        }
    }

    PrintDebug("sttrace", "From %s find scope %d.\n", key, scope);
    return scope;
}

/*
 * Look up symbol in all active scopes.
 */
Decl * SymbolTable::Lookup(Identifier *id) {
    Decl *d = NULL;
    const char *parent = NULL;
    const char *key = id->GetIdName();
    PrintDebug("sttrace", "Lookup %s from active scopes %d.\n", key, cur_scope);

    //printf("Look up %s from scope %d\n", key, cur_scope);

    // Look up all the active scopes.
    for (int i = activeScopes->size(); i > 0; --i) {

        int scope = activeScopes->at(i-1);
        Scope *s = scopes->at(scope);

        if (s->HasHT()) {
            d = s->GetHT()->Lookup(key);
        }
        if (d != NULL) break;

        while (s->HasParent()) {
            parent = s->GetParent();
            scope = FindScopeFromOwnerName(parent);
            if (scope != -1) {
                if (scope == cur_scope) {
                    // If the parent relation has a loop, then report an error.
                    break;
                } else {
                    s = scopes->at(scope);
                    if (s->HasHT()) {
                        d = s->GetHT()->Lookup(key);
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
Decl * SymbolTable::LookupParent(Identifier *id) {
    Decl *d = NULL;
    const char *parent = NULL;
    const char *key = id->GetIdName();
    Scope *s = scopes->at(cur_scope);
    PrintDebug("sttrace", "Lookup %s in parent of %d.\n", key, cur_scope);

    // Look up parent scopes.
    while (s->HasParent()) {
        parent = s->GetParent();
        int scope = FindScopeFromOwnerName(parent);
        //printf("Look up %s from %s\n", key, parent);

        if (scope != -1) {
            if (scope == cur_scope) {
                // If the parent relation has a loop, then report an error.
                break;
            } else {
                s = scopes->at(scope);
                if (s->HasHT()) {
                    d = s->GetHT()->Lookup(key);
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
Decl * SymbolTable::LookupInterface(Identifier *id) {
    Decl *d = NULL;
    const char *key = id->GetIdName();
    int scope;
    Scope *s = scopes->at(cur_scope);
    PrintDebug("sttrace", "Lookup %s in interface of %d.\n", key, cur_scope);

    // Look up interface scopes.
    if (s->HasInterface()) {

        std::list<const char *> * itfc = s->GetInterface();

        for (std::list<const char *>::iterator it = itfc->begin();
                it != itfc->end(); it++) {
            scope = FindScopeFromOwnerName(*it);
            //printf("Look up %s from %s\n", key, *it);

            if (scope != -1) {
                Scope *sc = scopes->at(scope);
                if (sc->HasHT()) {
                    d = sc->GetHT()->Lookup(key);
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
Decl * SymbolTable::LookupField(Identifier *base, Identifier *field) {
    Decl *d = NULL;
    const char *b = base->GetIdName();
    const char *f = field->GetIdName();
    PrintDebug("sttrace", "Lookup %s from field %s\n", f, b);

    // find scope from field name.
    int scope = FindScopeFromOwnerName(b);
    if (scope == -1) return NULL;

    // lookup the given field.
    Scope *s = scopes->at(scope);
    if (s->HasHT()) {
        d = s->GetHT()->Lookup(f);
    }
    if (d != NULL) return d;

    // lookup the parent.
    while (s->HasParent()) {
        b = s->GetParent();
        scope = FindScopeFromOwnerName(b);
        if (scope != -1) {
            if (scope == cur_scope) {
                // If the parent relation has a loop, then report an error.
                break;
            } else {
                s = scopes->at(scope);
                if (s->HasHT()) {
                    d = s->GetHT()->Lookup(f);
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
Decl * SymbolTable::LookupThis() {
    PrintDebug("sttrace", "Lookup This\n");
    Decl *d = NULL;
    // Look up all the active scopes.
    for (int i = activeScopes->size(); i > 0; --i) {

        int scope = activeScopes->at(i-1);
        Scope *s = scopes->at(scope);

        if (s->HasOwner()) {
            PrintDebug("sttrace", "Lookup This as %s\n", s->GetOwner());
            // Look up scope 0 to find the class decl.
            Scope *s0 = scopes->at(0);
            if (s0->HasHT()) {
                d = s0->GetHT()->Lookup(s->GetOwner());
            }
        }
        if (d) break;
    }
    return d;
}

/*
 * Insert new symbol into current scope.
 */
int SymbolTable::InsertSymbol(Decl *decl) {
    const char *key = decl->GetId()->GetIdName();
    Scope *s = scopes->at(cur_scope);
    PrintDebug("sttrace", "Insert %s to scope %d\n", key, cur_scope);

    if (!s->HasHT()) {
        s->BuildHT();
    }

    s->GetHT()->Enter(key, decl);
    return id_cnt++;
}

/*
 * Look up symbol in current scope.
 */
bool SymbolTable::LocalLookup(Identifier *id) {
    Decl *d = NULL;
    const char *key = id->GetIdName();
    Scope *s = scopes->at(cur_scope);
    PrintDebug("sttrace", "LocalLookup %s from scope %d\n", key, cur_scope);

    if (s->HasHT()) {
        d = s->GetHT()->Lookup(key);
    }

    return (d == NULL) ? false : true;
}

/*
 * Exit current scope and return to its uplevel scope.
 */
void SymbolTable::ExitScope() {
    PrintDebug("sttrace", "Exit scope %d\n", cur_scope);
    activeScopes->pop_back();
    cur_scope = activeScopes->back();
}

/*
 * Deal with class inheritance, set parent for a subclass.
 */
void SymbolTable::SetScopeParent(const char *key) {
    scopes->at(cur_scope)->SetParent(key);
}

/*
 * Deal with class interface, set interfaces for a subclass.
 */
void SymbolTable::SetInterface(const char *key) {
    scopes->at(cur_scope)->AddInterface(key);
}

/*
 * Print the whole symbol table.
 */
void SymbolTable::Print() {
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

