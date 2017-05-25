/* File: ast_decl.cc
 * -----------------
 * Implementation of Decl node classes.
 */
#include "ast_decl.h"
#include "ast_type.h"
#include "ast_stmt.h"
#include "errors.h"
#include <typeinfo>
        
         
Decl::Decl(Identifier *n) : Node(*n->GetLocation()) {
    Assert(n != NULL);
    (id=n)->SetParent(this); 
}

void Decl::Check(Hashtable<Node*> *table, int pass) {
}

VarDecl::VarDecl(Identifier *n, Type *t) : Decl(n) {
    Assert(n != NULL && t != NULL);
    (type=t)->SetParent(this);
}

void VarDecl::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        type->Check(table, pass);
        astTable = table;
        bool inserted = table->insert(id->name, this); 
        if (!inserted) {
            ReportError::DeclConflict(this, dynamic_cast<Decl*>(table->stMap[id->name])); 
        }
    } else if (pass == 2) {
        type->Check(table, pass);
    }
}

void VarDecl::Emit(CodeGenerator* codeGen) { 
    if (astTable->parent == NULL) {
        // global var
        frameLocation = new Location(gpRelative, CodeGenerator::OffsetToFirstGlobal + codeGen->getGlobalSize(), id->name);
        codeGen->addVarToGlobalSize();
    } else {
        // local var
        frameLocation = new Location(fpRelative, CodeGenerator::OffsetToFirstLocal - codeGen->getFrameSize(), id->name);
        codeGen->addVarToFrameSize();
    }
}

NamedType* VarDecl::getClassName() {
   return dynamic_cast<NamedType*>(type);
}

ClassDecl::ClassDecl(Identifier *n, NamedType *ex, List<NamedType*> *imp, List<Decl*> *m) : Decl(n) {
    // extends can be NULL, impl & mem may be empty lists but cannot be NULL
    Assert(n != NULL && imp != NULL && m != NULL);     
    extends = ex;
    type = new NamedType(n);
    if (extends) extends->SetParent(this);
    (implements=imp)->SetParentAll(this);
    (members=m)->SetParentAll(this);
}

void ClassDecl::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        bool inserted = table->stMap.insert(std::make_pair(id->name, this)).second; 
        if (!inserted) {
            ReportError::DeclConflict(this, dynamic_cast<Decl*>(table->stMap[id->name])); 
        }
        Hashtable<Node*> *classTable = new Hashtable<Node*>(table);
        astTable = classTable;
        classTable->insert("this", this);
        
        for (int i = 0; i < members->NumElements(); i++) {
            members->Nth(i)->Check(classTable, pass);
        } 
    } else if (pass == 1) {
        // check if overriding signature matches
        if (extends) {
            Node* parentClass = table->stMap[extends->id->name];
            if (parentClass) {
                astTable->parent = parentClass->astTable;
            } else {
                ReportError::IdentifierNotDeclared(extends->id, LookingForClass); 
            }
        }
        for (int i = 0; i < members->NumElements(); i++) {
            members->Nth(i)->Check(table, pass);
        } 
    } else if (pass == 2) {
        // set-up for vtable
        List<const char*>* methodNames = new List<const char*>();
        // get function names for VTable
        GetMethodNamesOfParent(methodNames);
        objectSize = (getObjectSize() + 1) * CodeGenerator::VarSize; // add one for vtable pointer

        for (int i = 0; i < implements->NumElements(); i++) {
            if (dynamic_cast<InterfaceDecl*>(table->get(implements->Nth(i)->id->name)) == NULL) {
                ReportError::IdentifierNotDeclared(implements->Nth(i)->id, LookingForInterface); 
                continue;
            }
            // check to see if this class implements all functions of the interface
            InterfaceDecl* interface = dynamic_cast<InterfaceDecl*>(table->stMap[implements->Nth(i)->id->name]);
            if (interface) {
                this->Implementer(interface);
            }
        }
        //check vardecls in superclasses
        for (int i = 0; i < members->NumElements(); i++) {
            VarDecl* vd = dynamic_cast<VarDecl*>(members->Nth(i));
            if (!vd) continue;
            Node* otherVar = NULL;
            Hashtable<Node*>* current = astTable->parent;
            while (current->parent != 0) {
                if (current->localDefined(vd->id->name)) {
                    otherVar = current->stMap[vd->id->name];
                    ReportError::DeclConflict(vd, dynamic_cast<Decl*>(otherVar)); 
                }
                current = current->parent; //put here so you don't check global functions
            }
        }
        if (extends && dynamic_cast<ClassDecl*>(table->get(extends->id->name)) != NULL) {
            for (int i = 0; i < members->NumElements(); i++) {
                FnDecl* fn = dynamic_cast<FnDecl*>(members->Nth(i));
                if (!fn) continue;
                Node* otherFunction = NULL;
                Hashtable<Node*>* current = astTable->parent; //get superclass's hashtable
                if (current->localDefined(fn->id->name)) {
                    otherFunction = current->stMap[fn->id->name];
                }
                while (current->parent != 0 && otherFunction == NULL) {
                    if (current->localDefined(fn->id->name)) {
                        otherFunction = current->stMap[fn->id->name];
                    }
                    current = current->parent; //put here so you don't check global functions
                }
                if (otherFunction) {
                    FnDecl* otherFn = dynamic_cast<FnDecl*>(otherFunction);
                    if (!otherFn) continue;
                    if (!fn->Equals(otherFn)) {
                        ReportError::OverrideMismatch(fn);
                    }
                }
            }
        }
        for (int i = 0; i < members->NumElements(); i++) {
            members->Nth(i)->Check(table, pass);
        }
    }
}

// Returns the size in number of vars that this object would be.
// Includes the vars of all parent classes.
// Also sets the offset for each VarDecl for later field access.
int ClassDecl::getObjectSize() {
    int size = 0;
    if (extends) {
        ClassDecl* parentClass = dynamic_cast<ClassDecl*>(astTable->parent->get("this"));
        if (parentClass) {
            size = parentClass->getObjectSize();
        }
    }
    for (int i = 0; i < members->NumElements(); i++) {
        VarDecl* varDecl = dynamic_cast<VarDecl*>(members->Nth(i));
        if (varDecl) {
            // add one for vtable that is at the start of all objects
            varDecl->locationInObject = (size + 1) * CodeGenerator::VarSize; 
            size++;
        }
    }
    return size;
}

void ClassDecl::Emit(CodeGenerator* codeGen) {
    List<const char*>* methodNames = new List<const char*>();
    // get function names for VTable
    GetMethodNamesOfParent(methodNames);

    for (int i = 0; i < members->NumElements(); i++) {
        members->Nth(i)->Emit(codeGen);
    }

    codeGen->GenVTable(id->name, methodNames);
}

// adds all the method names of current class and all parent classes to the names list.  Only one copy of overridden
// methods are kept.  Also sets-up the offset for each fnDecl in the vtable.  first fnDecl would be offset 0 then 1 and
// so on
void ClassDecl::GetMethodNamesOfParent(List<const char*>* names) {
    if (extends) {
        ClassDecl* parentClass = dynamic_cast<ClassDecl*>(astTable->parent->get("this"));
        if (parentClass) {
            parentClass->GetMethodNamesOfParent(names);
        }
    }
    for (int i = 0; i < members->NumElements(); i++) {
        FnDecl* method = dynamic_cast<FnDecl*>(members->Nth(i));
        if (method) {
            // overwrite overriding methods
            bool overwritten = false;
            for (int j = 0; j < names->NumElements(); j++) { //for all names found so far
                // get index of period
                const char* ptr = strchr(names->Nth(j), '.');
                // compare just the method names
                if (strcmp(ptr + 1, method->id->name) == 0) { 
                    //remove the overridden method 
                    names->RemoveAt(j);
                    names->InsertAt(method->getFunctionLabel(id->name), j);
                    method->vtableOffset = j; // set-up for vtable offsets
                    overwritten = true;
                    break;
                }
            }
            if (!overwritten) {
                method->vtableOffset = names->NumElements(); // set-up for vtable offsets
                names->Append(method->getFunctionLabel(id->name));
            }
        }
    }
}

void ClassDecl::Implementer(InterfaceDecl* interface) {
    bool reportedNotImplemented = false;
    for (int i = 0; i < interface->members->NumElements(); i++) {
        FnDecl* fn = dynamic_cast<FnDecl*>(interface->members->Nth(i));
        if (!fn) continue;
        if (!astTable->definedNotGlobal(fn->id->name)) {
            if (!reportedNotImplemented) 
                for (int j = 0; j < implements->NumElements(); j++) {
                    if (strcmp(implements->Nth(j)->id->name, interface->id->name) == 0) {
                        ReportError::InterfaceNotImplemented(this, implements->Nth(j));
                    }
                }
            reportedNotImplemented = true;
        } else {
            FnDecl* myFn = dynamic_cast<FnDecl*>(astTable->get(fn->id->name)); 
            if(!fn->Equals(myFn)) {
                ReportError::OverrideMismatch(myFn);
            }
        }
        
    }
}

bool ClassDecl::SonOf(const char *other) {
    Hashtable<Node*>* current = astTable;
    while (current->parent != 0) {
        ClassDecl* currentClass = dynamic_cast<ClassDecl*>(current->get("this"));
        if (currentClass) {
            if (currentClass->extends && strcmp(currentClass->extends->id->name, other) == 0) { // if current class name matches other
                return true;
            }
            for (int i = 0; i < currentClass->implements->NumElements(); i++) {
                if (strcmp(currentClass->implements->Nth(i)->id->name, other) == 0) { //if an interface name matches other
                    return true;
                }
            }
        }
        current = current->parent;
    }
    return false;
}

InterfaceDecl::InterfaceDecl(Identifier *n, List<Decl*> *m) : Decl(n) {
    Assert(n != NULL && m != NULL);
    (members=m)->SetParentAll(this);
}

void InterfaceDecl::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        bool inserted = table->stMap.insert(std::make_pair(id->name, this)).second; 
        if (!inserted) {
            ReportError::DeclConflict(this, dynamic_cast<Decl*>(table->stMap[id->name]));
        }
        Hashtable<Node*> *classTable = new Hashtable<Node*>(table);
        astTable = classTable;

        for (int i = 0; i < members->NumElements(); i++) {
            members->Nth(i)->Check(classTable, pass);
        }
    } else if (pass == 1) {
        for (int i = 0; i < members->NumElements(); i++) {
            members->Nth(i)->Check(table, pass);
        }
    } else if (pass == 2) {
        for (int i = 0; i < members->NumElements(); i++) {
            members->Nth(i)->Check(table, pass);
        }
    }
}

FnDecl::FnDecl(Identifier *n, Type *r, List<VarDecl*> *d) : Decl(n) {
    Assert(n != NULL && r!= NULL && d != NULL);
    (returnType=r)->SetParent(this);
    (formals=d)->SetParentAll(this);
    body = NULL;
}

void FnDecl::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        Hashtable<Node*> *fnTable = new Hashtable<Node*>(table);
        astTable = fnTable;
        bool inserted = table->stMap.insert(std::make_pair(id->name, this)).second; 
        if (!inserted) {
            ReportError::DeclConflict(this, dynamic_cast<Decl*>(table->stMap[id->name])); 
        }
        
        //add return keyword for future return type checks
        fnTable->stMap.insert(std::make_pair("return", returnType));

        //add formals to current table 
        for (int i = 0; i < formals->NumElements(); i++) {
            formals->Nth(i)->Check(fnTable, pass);
        } 
        if (body) {
            body->Check(fnTable, pass);
        }
    } else if (pass == 2) {
        if (returnType->named) {
            NamedType* nt = dynamic_cast<NamedType*>(returnType);
            if (!astTable->defined(nt->id->name)) {
                ReportError::IdentifierNotDeclared(nt->id, LookingForType); 
            } 
        }
        for (int i = 0; i < formals->NumElements(); i++) {
            formals->Nth(i)->Check(table, pass);
        } 
        if (body) {
            body->Check(table, pass);
        }
    }
}

const char* FnDecl::getFunctionLabel() {
    // set name of label.  Don't use an underscore for main
    char* name;
    if (strcmp(id->name, "main") == 0) {
        name = id->name;
    } else {
        name = new char[sizeof(id->name) + 2];  //add one for underscore
        name[0] = '_';
        strcpy(name+1, id->name);
    }
    return name;
}

const char* FnDecl::getFunctionLabel(const char* basename) {
    char* name = new char[strlen(basename) + strlen(id->name) + 2 + 1];  //add one for underscore
    name[0] = '_';
    strcpy(name+1, basename);
    name[strlen(basename) + 1] = '.';
    name[strlen(basename) + 2] = '\0';
    strcat(name, id->name);
    return name;
}

void FnDecl::Emit(CodeGenerator* codeGen) {
    if (!astTable->defined("this")) {
        // set location for formals
        for (int i = 0; i < formals->NumElements(); i++) {
            formals->Nth(i)->frameLocation = new Location(fpRelative, CodeGenerator::OffsetToFirstParam +
                (i * CodeGenerator::VarSize), formals->Nth(i)->id->name);
        }

        codeGen->GenLabel(getFunctionLabel());
    } else {
        // set location for formals
        for (int i = 0; i < formals->NumElements(); i++) {
            // use i + 1 since the this pointer will always be the first parameter
            formals->Nth(i)->frameLocation = new Location(fpRelative, CodeGenerator::OffsetToFirstParam +
                ((i + 1) * CodeGenerator::VarSize), formals->Nth(i)->id->name);
            
        }
        ClassDecl* parentClass = dynamic_cast<ClassDecl*>(parent);
        codeGen->GenLabel(getFunctionLabel(parentClass->id->name));
    }
    BeginFunc* begin = codeGen->GenBeginFunc();
    codeGen->resetFrameSize();
    body->Emit(codeGen);
    begin->SetFrameSize(codeGen->getFrameSize());
    codeGen->GenEndFunc();
}

bool FnDecl::Equals(FnDecl* other) {
    if (!this->returnType->IsEquivalentTo(other->returnType)) {
        return false;
    }
    if (this->formals->NumElements() != other->formals->NumElements()) {
        return false;
    }
    for (int j = 0; j < this->formals->NumElements(); j++) {
        if (!this->formals->Nth(j)->type->IsEquivalentTo(other->formals->Nth(j)->type)) {
            return false;
        }
    }
    return true;
}

void FnDecl::SetFunctionBody(Stmt *b) { 
    (body=b)->SetParent(this);
}
