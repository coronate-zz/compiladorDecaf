

#include "ast_decl.h"
#include "ast_stmt.h"
#include "ast_type.h"
#include "list.h"
#include "errors.h"

Decl::Decl(Identifier *n) : Node(*n->GetLocation()) {
    Assert(n != NULL);
    (id=n)->SetParent(this);
    idx = -1;
    expr_type = NULL;
}

VarDecl::VarDecl(Identifier *n, Type *t) : Decl(n) {
    Assert(n != NULL && t != NULL);
    (type=t)->SetParent(this);
    class_member_ofst = -1;
}

void VarDecl::impresionAux(int indentLevel) {
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
    if (class_member_ofst != -1)
        std::cout << " ~~[Ofst: " << class_member_ofst << "]";
    type->Print(indentLevel+1);
    id->Print(indentLevel+1);
    if (id->GetDecl()) printf(" ........ {def}");
}

void VarDecl::BuildST() {
    if (symtab->LocalrecorrerHash(this->GetId())) {
        Decl *d = symtab->recorrerHash(this->GetId());
        ReportError::DeclConflict(this, d);
    } else {
        idx = symtab->InsertSymbol(this);
        id->SetDecl(this);
    }
}

void VarDecl::CheckDecl() {
    type->Check(E_CheckDecl);
    id->Check(E_CheckDecl);

    expr_type = type->GetType();
}


void VarDecl::AssignOffset() {
    if (this->IsGlobal()) {
        emit_loc = new Location(gpRelative, CG->GetNextGlobalLoc(),
                id->GetIdName());
    }
}

void VarDecl::AssignMemberOffset(bool inClass, int offset) {
    class_member_ofst = offset;
    
    emit_loc = new Location(fpRelative, offset, id->GetIdName(), CG->ThisPtr);
}


ClassDecl::ClassDecl(Identifier *n, NamedType *ex, List<NamedType*> *imp,
        List<Decl*> *m) : Decl(n) {
    
    Assert(n != NULL && imp != NULL && m != NULL);
    extends = ex;
    if (extends) extends->SetParent(this);
    (implements=imp)->SetParentAll(this);
    (members=m)->SetParentAll(this);
    instance_size = 4;
    vtable_size = 0;
}

void ClassDecl::impresionAux(int indentLevel) {
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
    id->Print(indentLevel+1);
    if (id->GetDecl()) printf(" ........ {def}");
    if (extends) extends->Print(indentLevel+1, "(extends) ");
    implements->PrintAll(indentLevel+1, "(implements) ");
    members->PrintAll(indentLevel+1);
}

void ClassDecl::BuildST() {
    if (symtab->LocalrecorrerHash(this->GetId())) {
        
        Decl *d = symtab->recorrerHash(this->GetId());
        ReportError::DeclConflict(this, d);
    } else {
        idx = symtab->InsertSymbol(this);
        id->SetDecl(this);
    }
    
    symtab->BuildScope(this->GetId()->GetIdName());
    if (extends) {
        
        symtab->SetScopeParent(extends->GetId()->GetIdName());
    }
    
    for (int i = 0; i < implements->NumElements(); i++) {
        symtab->SetInterface(implements->Nth(i)->GetId()->GetIdName());
    }
    members->CheckAll(E_BuildST);
    symtab->ExitScope();
}

void ClassDecl::CheckDecl() {
    id->Check(E_CheckDecl);
    
    if (extends) {
        extends->Check(E_CheckDecl, LookingForClass);
    }
    
    for (int i = 0; i < implements->NumElements(); i++) {
        implements->Nth(i)->Check(E_CheckDecl, LookingForInterface);
    }
    symtab->EnterScope();
    members->CheckAll(E_CheckDecl);
    symtab->ExitScope();

    expr_type = new NamedType(id);
    expr_type->SetSelfType();
}

void ClassDecl::CheckInherit() {
    symtab->EnterScope();

    for (int i = 0; i < members->NumElements(); i++) {
        Decl *d = members->Nth(i);
        Assert(d != NULL); 

        if (d->IsVarDecl()) {
            
            Decl *t = symtab->recorrerHashParent(d->GetId());
            if (t != NULL) {
                
                ReportError::DeclConflict(d, t);
            }
            
            t = symtab->recorrerHashInterface(d->GetId());
            if (t != NULL) {
                
                ReportError::DeclConflict(d, t);
            }

        } else if (d->IsFnDecl()) {
            
            Decl *t = symtab->recorrerHashParent(d->GetId());
            if (t != NULL) {
                if (!t->IsFnDecl()) {
                    ReportError::DeclConflict(d, t);
                } else {
                    
                    FnDecl *fn1 = dynamic_cast<FnDecl*>(d);
                    FnDecl *fn2 = dynamic_cast<FnDecl*>(t);
                    if (fn1->GetType() && fn2->GetType() 
                            && !fn1->IsEquivalentTo(fn2)) {
                        
                        ReportError::OverrideMismatch(d);
                    }
                }
            }
            
            t = symtab->recorrerHashInterface(d->GetId());
            if (t != NULL) {
                
                FnDecl *fn1 = dynamic_cast<FnDecl*>(d);
                FnDecl *fn2 = dynamic_cast<FnDecl*>(t);
                if (fn1->GetType() && fn2->GetType() 
                        && !fn1->IsEquivalentTo(fn2)) {
                    
                    ReportError::OverrideMismatch(d);
                }
            }
            
            d->Check(E_CheckInherit);
        }
    }

    

    symtab->ExitScope();
}





bool ClassDecl::IsChildOf(Decl *other) {
    if (other->IsClassDecl()) {
        if (id->IsEquivalentTo(other->GetId())) {
            
            return true;
        } else if (!extends) {
            return false;
        } else {
            
            Decl *d = extends->GetId()->GetDecl();
            return false;
        }
    } else if (other->IsInterfaceDecl()) {
        for (int i = 0; i < implements->NumElements(); i++) {
            Identifier *iid = implements->Nth(i)->GetId();
            if (iid->IsEquivalentTo(other->GetId())) {
                return true;
            }
        }
        if (!extends) {
            return false;
        } else {
            
            Decl *d = extends->GetId()->GetDecl();
            return false;        }
    } else {
        return false;
    }
}

void ClassDecl::AddMembersToList(List<VarDecl*> *vars, List<FnDecl*> *fns) {
    for (int i = members->NumElements() - 1; i >= 0; i--) {
        Decl *d = members->Nth(i);
        if (d->IsVarDecl()) {
            vars->InsertAt(dynamic_cast<VarDecl*>(d), 0);
        } else if (d->IsFnDecl()) {
            fns->InsertAt(dynamic_cast<FnDecl*>(d), 0);
        }
    }
}

void ClassDecl::AssignOffset() {
    
    
    var_members = new List<VarDecl*>;
    methods = new List<FnDecl*>;
    ClassDecl *c = this;
    while (c) {
        c->AddMembersToList(var_members, methods);
        NamedType *t = c->GetExtends();
        if (!t) break;
        c = dynamic_cast<ClassDecl*>(t->GetId()->GetDecl());
    }

    
    for (int i = 0; i < methods->NumElements(); i++) {
        FnDecl *f1 = methods->Nth(i);
        for (int j = i + 1; j < methods->NumElements(); j++) {
            FnDecl *f2 = methods->Nth(j);
            if (!strcmp(f1->GetId()->GetIdName(), f2->GetId()->GetIdName())) {
                
                
                methods->RemoveAt(i);
                methods->InsertAt(f2, i);
                methods->RemoveAt(j);
                j--;
            }
        }
    }

    for (int i = 0; i < methods->NumElements(); i++) {
    }
    for (int i = 0; i < var_members->NumElements(); i++) {
    }

    
    instance_size = var_members->NumElements() * 4 + 4;
    vtable_size = methods->NumElements() * 4;

    int var_offset = instance_size;
    for (int i = members->NumElements() - 1; i >= 0; i--) {
        Decl *d = members->Nth(i);
        if (d->IsVarDecl()) {
            var_offset -= 4;
            d->AssignMemberOffset(true, var_offset);
        } else if (d->IsFnDecl()) {
            
            for (int i = 0; i < methods->NumElements(); i++) {
                FnDecl *f1 = methods->Nth(i);
                if (!strcmp(f1->GetId()->GetIdName(), d->GetId()->GetIdName()))
                    d->AssignMemberOffset(true, i * 4);
            }
        }
    }
}

void ClassDecl::agregandoMetodosPX() {
    
    for (int i = 0; i < members->NumElements(); i++) {
        members->Nth(i)->agregandoMetodosPX();
    }
}


InterfaceDecl::InterfaceDecl(Identifier *n, List<Decl*> *m) : Decl(n) {
    Assert(n != NULL && m != NULL);
    (members=m)->SetParentAll(this);
}

void InterfaceDecl::impresionAux(int indentLevel) {
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
    id->Print(indentLevel+1);
    if (id->GetDecl()) printf(" ........ {def}");
    members->PrintAll(indentLevel+1);
}

void InterfaceDecl::BuildST() {
    if (symtab->LocalrecorrerHash(this->GetId())) {
        Decl *d = symtab->recorrerHash(this->GetId());
        ReportError::DeclConflict(this, d);
    } else {
        idx = symtab->InsertSymbol(this);
        id->SetDecl(this);
    }
    symtab->BuildScope(this->GetId()->GetIdName());
    members->CheckAll(E_BuildST);
    symtab->ExitScope();
}



FnDecl::FnDecl(Identifier *n, Type *r, List<VarDecl*> *d) : Decl(n) {
    Assert(n != NULL && r!= NULL && d != NULL);
    (returnType=r)->SetParent(this);
    (formals=d)->SetParentAll(this);
    body = NULL;
    vtable_ofst = -1;
}

void FnDecl::SetFunctionBody(Stmt *b) {
    (body=b)->SetParent(this);
}

void FnDecl::impresionAux(int indentLevel) {
    if (expr_type) std::cout << " <" << expr_type << ">";
    if (emit_loc) emit_loc->Print();
    if (vtable_ofst != -1)
        std::cout << " ~~[VTable: " << vtable_ofst << "]";
    returnType->Print(indentLevel+1, "(return type) ");
    id->Print(indentLevel+1);
    if (id->GetDecl()) printf(" ........ {def}");
    formals->PrintAll(indentLevel+1, "(formals) ");
    if (body) body->Print(indentLevel+1, "(body) ");
}

void FnDecl::BuildST() {
    if (symtab->LocalrecorrerHash(this->GetId())) {
        Decl *d = symtab->recorrerHash(this->GetId());
        ReportError::DeclConflict(this, d);
    } else {
        idx = symtab->InsertSymbol(this);
        id->SetDecl(this);
    }
    symtab->BuildScope();
    formals->CheckAll(E_BuildST);
    if (body) body->Check(E_BuildST); 
    symtab->ExitScope();
}

void FnDecl::CheckDecl() {
    returnType->Check(E_CheckDecl);
    id->Check(E_CheckDecl);
    symtab->EnterScope();
    formals->CheckAll(E_CheckDecl);
    if (body) body->Check(E_CheckDecl);
    symtab->ExitScope();

    
    if (!strcmp(id->GetIdName(), "main")) {
        if (returnType != Type::voidType) {
            ReportError::Formatted(this->GetLocation(),
                    "Return value of 'main' function is expected to be void.");
        }
        if (formals->NumElements() != 0) {
            ReportError::NumArgsMismatch(id, 0, formals->NumElements());
        }
    }

    expr_type = returnType->GetType();
}



bool FnDecl::IsEquivalentTo(Decl *other) {
    Assert(this->GetType() && other->GetType());

    if (!other->IsFnDecl()) {
        return false;
    }
    FnDecl *fn = dynamic_cast<FnDecl*>(other);
    if (!returnType->IsEquivalentTo(fn->GetType())) {
        return false;
    }
    if (formals->NumElements() != fn->GetFormals()->NumElements()) {
        return false;
    }
    for (int i = 0; i < formals->NumElements(); i++) {
        
        Type *var_type1 =
            (dynamic_cast<VarDecl*>(formals->Nth(i)))->GetType();
        Type *var_type2 =
            (dynamic_cast<VarDecl*>(fn->GetFormals()->Nth(i)))->GetType();
        if (!var_type1->IsEquivalentTo(var_type2)) {
            return false;
        }
    }
    return true;
}

void FnDecl::agregandoMetodosPX() {
    
    
    Decl *d = dynamic_cast<Decl*>(this->GetParent());
    if (d && d->IsClassDecl()) {
        id->AddPrefix(".");
        id->AddPrefix(d->GetId()->GetIdName());
        id->AddPrefix("_");
    } else if (strcmp(id->GetIdName(), "main")) {
        id->AddPrefix("_");
    }
}

void FnDecl::AssignMemberOffset(bool inClass, int offset) {
    vtable_ofst = offset;
}

void FnDecl::Emit() {
    if (returnType == Type::doubleType) {
        ReportError::Formatted(this->GetLocation(),
                "Double type is not supported by compiler back end yet.");
        Assert(0);
    }

    Decl *d = dynamic_cast<Decl*>(this->GetParent());
    CG->GenLabel(id->GetIdName());

    
    BeginFunc *f = CG->GenBeginFunc();

    
    if (d && d->IsClassDecl()) {
        CG->GetNextParamLoc();
    }

    
    for (int i = 0; i < formals->NumElements(); i++) {
        VarDecl *v = formals->Nth(i);
        if (v->GetType() == Type::doubleType) {
            ReportError::Formatted(this->GetLocation(),
                    "Double type is not supported by compiler back end yet.");
            Assert(0);
        }
        Location *l = new Location(fpRelative, CG->GetNextParamLoc(),
                v->GetId()->GetIdName());
        v->SetEmitLoc(l);
    }

    if (body) body->Emit();

    
    f->SetFrameSize(CG->GetFrameSize());

    CG->GenEndFunc();
}



//---------------------------------------------CHECK---------------------------------------------

void VarDecl::Check(checkT c) {
    switch (c) {
        case E_CheckDecl:
            this->CheckDecl(); break;
        case E_BuildST:
            this->BuildST(); break;
        default:
            type->Check(c);
            id->Check(c);
    }
}


void FnDecl::Check(checkT c) {
    switch (c) {
        case E_BuildST:
            this->BuildST(); break;
        case E_CheckDecl:
            this->CheckDecl(); break;
        default:
            returnType->Check(c);
            id->Check(c);
            symtab->EnterScope();
            formals->CheckAll(c);
            if (body) body->Check(c);
            symtab->ExitScope();
    }
}


void ClassDecl::Check(checkT c) {
    switch (c) {
        case E_BuildST:
            this->BuildST(); break;
        case E_CheckDecl:
            this->CheckDecl(); break;
        case E_CheckInherit:
            this->CheckInherit(); break;
        default:
            id->Check(c);
            if (extends) extends->Check(c);
            implements->CheckAll(c);
            symtab->EnterScope();
            members->CheckAll(c);
            symtab->ExitScope();
    }
}


void InterfaceDecl::Check(checkT c) {
    switch (c) {
        case E_BuildST:
            this->BuildST(); break;
        case E_CheckDecl:
            expr_type = new NamedType(id);
            expr_type->SetSelfType();
            
        default:
            id->Check(c);
            symtab->EnterScope();
            members->CheckAll(c);
            symtab->ExitScope();
    }
}


//---------------------------------------EMIT----------------------------------------------











void InterfaceDecl::Emit() {
    ReportError::Formatted(this->GetLocation(),
            "Interface is not supported by compiler back end yet.");
    Assert(0);
}




void ClassDecl::Emit() {

    members->EmitAll();

    
    List<const char*> *method_labels = new List<const char*>;
    for (int i = 0; i < methods->NumElements(); i++) {
        FnDecl* fn = methods->Nth(i);
        method_labels->Append(fn->GetId()->GetIdName());
    }
    CG->GenVTable(id->GetIdName(), method_labels);
}



void VarDecl::Emit() {
    if (type == Type::doubleType) {
        ReportError::Formatted(this->GetLocation(),
                "Double type is not supported by compiler back end yet.");
        Assert(0);
    }

    if (!emit_loc) {
        
        emit_loc = new Location(fpRelative, CG->GetNextLocalLoc(),
                id->GetIdName());
    }
}
















