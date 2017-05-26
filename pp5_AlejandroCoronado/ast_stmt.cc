
#include "ast_decl.h"
#include "ast_expr.h"
#include "ast_stmt.h"
#include "ast_type.h"

Program::Program(List<Decl*> *d) {
    Assert(d != NULL);
    (decls=d)->SetParentAll(this);
}

void Program::impresionAux(int indentLevel) {
    decls->PrintAll(indentLevel+1);
    printf("\n");
}




StmtBlock::StmtBlock(List<VarDecl*> *d, List<Stmt*> *s) {
    Assert(d != NULL && s != NULL);
    (decls=d)->SetParentAll(this);
    (stmts=s)->SetParentAll(this);
}

void StmtBlock::impresionAux(int indentLevel) {
    decls->PrintAll(indentLevel+1);
    stmts->PrintAll(indentLevel+1);
}

void StmtBlock::BuildST() {
    symtab->BuildScope();
    decls->CheckAll(E_BuildST);
    stmts->CheckAll(E_BuildST);
    symtab->ExitScope();
}




ConditionalStmt::ConditionalStmt(Expr *t, Stmt *b) {
    Assert(t != NULL && b != NULL);
    (test=t)->SetParent(this);
    (body=b)->SetParent(this);
}

ForStmt::ForStmt(Expr *i, Expr *t, Expr *s, Stmt *b): LoopStmt(t, b) {
    Assert(i != NULL && t != NULL && s != NULL && b != NULL);
    (init=i)->SetParent(this);
    (step=s)->SetParent(this);
}

void ForStmt::impresionAux(int indentLevel) {
    init->Print(indentLevel+1, "(init) ");
    test->Print(indentLevel+1, "(test) ");
    step->Print(indentLevel+1, "(step) ");
    body->Print(indentLevel+1, "(body) ");
}

void ForStmt::BuildST() {
    symtab->BuildScope();
    body->Check(E_BuildST);
    symtab->ExitScope();
}




void WhileStmt::impresionAux(int indentLevel) {
    test->Print(indentLevel+1, "(test) ");
    body->Print(indentLevel+1, "(body) ");
}

void WhileStmt::BuildST() {
    symtab->BuildScope();
    body->Check(E_BuildST);
    symtab->ExitScope();
}




IfStmt::IfStmt(Expr *t, Stmt *tb, Stmt *eb): ConditionalStmt(t, tb) {
    Assert(t != NULL && tb != NULL); 
    elseBody = eb;
    if (elseBody) elseBody->SetParent(this);
}

void IfStmt::impresionAux(int indentLevel) {
    test->Print(indentLevel+1, "(test) ");
    body->Print(indentLevel+1, "(then) ");
    if (elseBody) elseBody->Print(indentLevel+1, "(else) ");
}

void IfStmt::BuildST() {
    symtab->BuildScope();
    body->Check(E_BuildST);
    symtab->ExitScope();
    if (elseBody) {
        symtab->BuildScope();
        elseBody->Check(E_BuildST);
        symtab->ExitScope();
    }
}




CaseStmt::CaseStmt(IntConstant *v, List<Stmt*> *s) {
    Assert(s != NULL);
    value = v;
    if (value) value->SetParent(this);
    (stmts=s)->SetParentAll(this);
    case_label = NULL;
}

void CaseStmt::impresionAux(int indentLevel) {
    if (value) value->Print(indentLevel+1);
    stmts->PrintAll(indentLevel+1);
}

void CaseStmt::BuildST() {
    symtab->BuildScope();
    stmts->CheckAll(E_BuildST);
    symtab->ExitScope();
}


void CaseStmt::GenCaseLabel() {
    case_label = CG->NewLabel();
}



SwitchStmt::SwitchStmt(Expr *e, List<CaseStmt*> *c) {
    Assert(e != NULL && c != NULL);
    (expr=e)->SetParent(this);
    (cases=c)->SetParentAll(this);
    end_switch_label = NULL;
}

void SwitchStmt::impresionAux(int indentLevel) {
    expr->Print(indentLevel+1);
    cases->PrintAll(indentLevel+1);
}

void SwitchStmt::BuildST() {
    symtab->BuildScope();
    cases->CheckAll(E_BuildST);
    symtab->ExitScope();
}




ReturnStmt::ReturnStmt(yyltype loc, Expr *e) : Stmt(loc) {
    Assert(e != NULL);
    (expr=e)->SetParent(this);
}

void ReturnStmt::impresionAux(int indentLevel) {
    expr->Print(indentLevel+1);
}




PrintStmt::PrintStmt(List<Expr*> *a) {
    Assert(a != NULL);
    (args=a)->SetParentAll(this);
}

void PrintStmt::impresionAux(int indentLevel) {
    args->PrintAll(indentLevel+1, "(args) ");
}







//------------------------------------------CHECK Functions---------------------------------

void WhileStmt::Check(checkT c) {
    switch (c) {
        case E_BuildST:
            this->BuildST(); break;
        case E_CheckType:
            this->CheckType(); break;
        default:
            test->Check(c);
            symtab->EnterScope();
            body->Check(c);
            symtab->ExitScope();
    }
}

void PrintStmt::Check(checkT c) {
    args->CheckAll(c);
    if (c == E_CheckType) {
        for (int i = 0; i < args->NumElements(); i++) {
            Type *t = args->Nth(i)->GetType();
            if (t != NULL && t != Type::stringType && t != Type::intType
                     && t != Type::boolType) {
                ReportError::PrintArgMismatch(args->Nth(i), i + 1, t);
            }
        }
    }
}


void ReturnStmt::Check(checkT c) {
    expr->Check(c);
    if (c == E_CheckType) {
        Node *n = this;
        
        while (n->GetParent()) {
            if (dynamic_cast<FnDecl*>(n) != NULL) break;
            n = n->GetParent();
        }
        Type *t_given = expr->GetType();
        Type *t_expected = dynamic_cast<FnDecl*>(n)->GetType();
        if (t_given && t_expected) {
            if (!t_expected->IsCompatibleWith(t_given)) {
                ReportError::ReturnMismatch(this, t_given, t_expected);
            }
        }
    }
}



void SwitchStmt::Check(checkT c) {
    if (c == E_BuildST) {
        this->BuildST();
    } else {
        expr->Check(c);
        symtab->EnterScope();
        cases->CheckAll(c);
        symtab->ExitScope();
    }
}




void CaseStmt::Check(checkT c) {
    if (c == E_BuildST) {
        this->BuildST();
    } else {
        if (value) value->Check(c);
        symtab->EnterScope();
        stmts->CheckAll(c);
        symtab->ExitScope();
    }
}


void BreakStmt::Check(checkT c) {
    if (c == E_CheckType) {
        Node *n = this;
        while (n->GetParent()) {
            if (n->IsLoopStmt() || n->IsCaseStmt()) return;
            n = n->GetParent();
        }
        ReportError::BreakOutsideLoop(this);
    }
}

void IfStmt::Check(checkT c) {
    switch (c) {
        case E_BuildST:
            this->BuildST(); break;
        case E_CheckType:
            this->CheckType(); break;
        default:
            test->Check(c);
            symtab->EnterScope();
            body->Check(c);
            symtab->ExitScope();
            if (elseBody) {
                symtab->EnterScope();
                elseBody->Check(c);
                symtab->ExitScope();
            }
    }
}


void ForStmt::Check(checkT c) {
    switch (c) {
        case E_BuildST:
            this->BuildST(); break;
        case E_CheckType:
            this->CheckType(); break;
        default:
            init->Check(c);
            test->Check(c);
            step->Check(c);
            symtab->EnterScope();
            body->Check(c);
            symtab->ExitScope();
    }
}


void Program::Check() {

    if (IsDebugOn("ast")) { this->Print(0); }

    symtab = new hashImplentation(); decls->CheckAll(E_BuildST);
    if (IsDebugOn("st")) { symtab->Print(); }
    if (IsDebugOn("ast+")) { this->Print(0); }

    symtab->ReEnter(); decls->CheckAll(E_CheckDecl);
    if (IsDebugOn("ast+")) { this->Print(0); }

    symtab->ReEnter(); decls->CheckAll(E_CheckInherit);
    if (IsDebugOn("ast+")) { this->Print(0); }


    symtab->ReEnter(); decls->CheckAll(E_CheckType);
    if (IsDebugOn("ast+")) { this->Print(0); }
}



void StmtBlock::Check(checkT c) {
    if (c == E_BuildST) {
        this->BuildST();
    } else {
        symtab->EnterScope();
        decls->CheckAll(c);
        stmts->CheckAll(c);
        symtab->ExitScope();
    }
}

//------------------------------------------CHECK EMIT---------------------------------


void StmtBlock::Emit() {
    decls->EmitAll();
    stmts->EmitAll();
}


void Program::Emit() {


    
    bool has_main = false;
    for (int i = 0; i < decls->NumElements(); i++) {
        Decl *d = decls->Nth(i);
        if (d->IsFnDecl()) {
            if (!strcmp(d->GetId()->GetIdName(), "main")) {
                has_main = true;
                break;
            }
        }
    }
    if (!has_main) {
        ReportError::NoMainFound();
        return;
    }

    
    for (int i = 0; i < decls->NumElements(); i++) {
        decls->Nth(i)->AssignOffset();
    }
    
    for (int i = 0; i < decls->NumElements(); i++) {
        decls->Nth(i)->agregandoMetodosPX();
    }
    if (IsDebugOn("tac+")) { this->Print(0); }

    decls->EmitAll();
    if (IsDebugOn("tac+")) { this->Print(0); }

    
    CG->DoFinalCodeGen();
}


void WhileStmt::Emit() {
    const char *l0 = CG->NewLabel();
    CG->GenLabel(l0);

    test->Emit();
    Location *t0 = test->GetEmitLocDeref();
    const char *l1 = CG->NewLabel();
    end_loop_label = l1;
    CG->GenIfZ(t0, l1);

    body->Emit();
    CG->GenGoto(l0);

    CG->GenLabel(l1);
}


void ForStmt::Emit() {
    init->Emit();

    const char *l0 = CG->NewLabel();
    CG->GenLabel(l0);
    test->Emit();
    Location *t0 = test->GetEmitLocDeref();
    const char *l1 = CG->NewLabel();
    end_loop_label = l1;
    CG->GenIfZ(t0, l1);

    body->Emit();
    step->Emit();
    CG->GenGoto(l0);

    CG->GenLabel(l1);
}


void ReturnStmt::Emit() {
    if (expr->IsEmptyExpr()) {
        CG->GenReturn();
    } else {
        expr->Emit();
        CG->GenReturn(expr->GetEmitLocDeref());
    }
}

void PrintStmt::Emit() {
    for (int i = 0; i < args->NumElements(); i++) {
        args->Nth(i)->Emit();
        
        Type *t = args->Nth(i)->GetType();
        BuiltIn f;
        if (t == Type::intType) {
            f = PrintInt;
        } else if (t == Type::stringType) {
            f = PrintString;
        } else {
            f = PrintBool;
        }
        Location *l = args->Nth(i)->GetEmitLocDeref();
        Assert(l);
        CG->GenBuiltInCall(f, l);
    }
}


void IfStmt::Emit() {
    test->Emit();
    Location *t0 = test->GetEmitLocDeref();
    const char *l0 = CG->NewLabel();
    CG->GenIfZ(t0, l0);

    body->Emit();
    const char *l1 = CG->NewLabel();
    CG->GenGoto(l1);

    CG->GenLabel(l0);
    if (elseBody) elseBody->Emit();
    CG->GenLabel(l1);
}


void BreakStmt::Emit() {
    
    Node *n = this;
    while (n->GetParent()) {
        if (n->IsLoopStmt()) {
            const char *l = dynamic_cast<LoopStmt*>(n)->GetEndLoopLabel();
            CG->GenGoto(l);
            return;
        } else if (n->IsSwitchStmt()) {
            const char *l = dynamic_cast<SwitchStmt*>(n)->GetEndSwitchLabel();
            return;
        }
        n = n->GetParent();
    }
}

void CaseStmt::Emit() {
    CG->GenLabel(case_label);
    stmts->EmitAll();
}


void SwitchStmt::Emit() {
    expr->Emit();

    
    end_switch_label = CG->NewLabel();

    Location *switch_value = expr->GetEmitLocDeref();

    
    
    
    for (int i = 0; i < cases->NumElements(); i++) {
        CaseStmt *c = cases->Nth(i);

        
        c->GenCaseLabel();
        const char *cl = c->GetCaseLabel();

        
        IntConstant *cv = c->GetCaseValue();

        
        if (cv) {
            
            cv->Emit();
            Location *cvl = cv->GetEmitLocDeref();
            Location *t = CG->GenBinaryOp("!=", switch_value, cvl);
            CG->GenIfZ(t, cl);
        } else {
            
            CG->GenGoto(cl);
        }
    }

    
    cases->EmitAll();

    
    CG->GenLabel(end_switch_label);
}




//----------------------------CHECK Type--------------------------------------------

void IfStmt::CheckType() {
    test->Check(E_CheckType);
    if (test->GetType() && test->GetType() != Type::boolType) {
        ReportError::TestNotBoolean(test);
    }
    symtab->EnterScope();
    body->Check(E_CheckType);
    symtab->ExitScope();
    if (elseBody) {
        symtab->EnterScope();
        elseBody->Check(E_CheckType);
        symtab->ExitScope();
    }
}


void WhileStmt::CheckType() {
    test->Check(E_CheckType);
    if (test->GetType() && test->GetType() != Type::boolType) {
        ReportError::TestNotBoolean(test);
    }
    symtab->EnterScope();
    body->Check(E_CheckType);
    symtab->ExitScope();
}

void ForStmt::CheckType() {
    init->Check(E_CheckType);
    test->Check(E_CheckType);
    if (test->GetType() && test->GetType() != Type::boolType) {
        ReportError::TestNotBoolean(test);
    }
    step->Check(E_CheckType);
    symtab->EnterScope();
    body->Check(E_CheckType);
    symtab->ExitScope();
}

