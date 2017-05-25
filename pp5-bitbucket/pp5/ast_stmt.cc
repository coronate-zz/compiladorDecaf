/* File: ast_stmt.cc
 * -----------------
 * Implementation of statement node classes.
 */
#include "ast_stmt.h"
#include "ast_type.h"
#include "ast_decl.h"
#include "ast_expr.h"
#include "hashtable.h"

Program::Program(List<Decl*> *d) {
    Assert(d != NULL);
    (decls=d)->SetParentAll(this);
}

void Program::Check(Hashtable<Node*> *global, int pass) {
    /* pp3: here is where the semantic analyzer is kicked off.
     *      The general idea is perform a tree traversal of the
     *      entire program, examining all constructs for compliance
     *      with the semantic rules.  Each node can have its own way of
     *      checking itself, which makes for a great use of inheritance
     *      and polymorphism in the node classes.
     */
    for (int i = 0; i < decls->NumElements(); i++) {
        decls->Nth(i)->Check(global, pass);
    } 
}

void Program::Emit(CodeGenerator* codeGen) {
    // emit all var decls
    for (int i = 0; i < decls->NumElements(); i++) {
        if (dynamic_cast<VarDecl*>(decls->Nth(i)) != NULL) {
            decls->Nth(i)->Emit(codeGen);
        }
    }
    // emit all class and functions decls
    for (int i = 0; i < decls->NumElements(); i++) {
        if (dynamic_cast<VarDecl*>(decls->Nth(i)) == NULL) {
            decls->Nth(i)->Emit(codeGen);
        }
    }
}


void Stmt::Check(Hashtable<Node*> *table, int pass) {
}

StmtBlock::StmtBlock(List<VarDecl*> *d, List<Stmt*> *s) {
    Assert(d != NULL && s != NULL);
    (decls=d)->SetParentAll(this);
    (stmts=s)->SetParentAll(this);
}

void StmtBlock::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        Hashtable<Node*> *stmtTable = new Hashtable<Node*>(table);
        astTable = stmtTable;
        if (dynamic_cast<ForStmt*>(parent) != NULL || dynamic_cast<WhileStmt*>(parent) != NULL) {
            astTable->insert("break", parent);
        }
        if (decls != NULL) {
            
            for (int i = 0; i < decls->NumElements(); i++) {
                decls->Nth(i)->Check(stmtTable, pass);
            } 
        } 

        if (stmts != NULL) {
            for (int i = 0; i < stmts->NumElements(); i++) {
                stmts->Nth(i)->Check(stmtTable, pass);
            } 
        }
    } else if (pass == 1) {
        if (decls != NULL) {
            
            for (int i = 0; i < decls->NumElements(); i++) {
                decls->Nth(i)->Check(table, pass);
            } 
        } 

        if (stmts != NULL) {
            for (int i = 0; i < stmts->NumElements(); i++) {
                stmts->Nth(i)->Check(table, pass);
            } 
        }
    } else if (pass == 2) {
        if (decls != NULL) {
            
            for (int i = 0; i < decls->NumElements(); i++) {
                decls->Nth(i)->Check(table, pass);
            } 
        } 

        if (stmts != NULL) {
            for (int i = 0; i < stmts->NumElements(); i++) {
                stmts->Nth(i)->Check(table, pass);
            } 
        }
    }
}

void StmtBlock::Emit(CodeGenerator* codeGen) {
    for (int i = 0; i < decls->NumElements(); i++) {
        decls->Nth(i)->Emit(codeGen);
    }
    for (int i = 0; i < stmts->NumElements(); i++) {
        stmts->Nth(i)->Emit(codeGen);
    }
}

ConditionalStmt::ConditionalStmt(Expr *t, Stmt *b) { 
    Assert(t != NULL && b != NULL);
    (test=t)->SetParent(this); 
    (body=b)->SetParent(this);
}

void ConditionalStmt::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        test->Check(table, pass);
        body->Check(table, pass);
    } else if (pass == 2) {
        test->Check(table, pass);
        body->Check(table, pass);
    }
}

ForStmt::ForStmt(Expr *i, Expr *t, Expr *s, Stmt *b): LoopStmt(t, b) { 
    Assert(i != NULL && t != NULL && s != NULL && b != NULL);
    (init=i)->SetParent(this);
    (step=s)->SetParent(this);
}

void ForStmt::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        init->Check(table, pass);
        test->Check(table, pass);
        step->Check(table, pass);
        body->Check(table, pass);
    } else if (pass == 2) {
        init->Check(table, pass);
        test->Check(table, pass);
        if (test->evalType != Type::boolType && test->evalType != Type::errorType) {
            ReportError::TestNotBoolean(test);
        }
        step->Check(table, pass);
        body->Check(table, pass);
    }
}

void ForStmt::Emit(CodeGenerator* codeGen) {
    const char* startFor = codeGen->NewLabel();
    const char* endFor = codeGen->NewLabel();
    breakLabel = strdup(endFor);
    init->Emit(codeGen);
    codeGen->GenLabel(startFor);
    test->Emit(codeGen);
    codeGen->GenIfZ(test->memoryLocation, endFor);
    body->Emit(codeGen);
    step->Emit(codeGen);
    codeGen->GenGoto(startFor);
    codeGen->GenLabel(endFor);
}


void WhileStmt::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        test->Check(table, pass);
        body->Check(table, pass);
    } else if (pass == 2) {
        test->Check(table, pass);
        if (test->evalType != Type::boolType && test->evalType != Type::errorType) {
            ReportError::TestNotBoolean(test);
        }
        body->Check(table, pass);
    }
}

void WhileStmt::Emit(CodeGenerator* codeGen) {
    const char* startWhile = codeGen->NewLabel();
    const char* endWhile = codeGen->NewLabel();
    breakLabel = strdup(endWhile);
    codeGen->GenLabel(startWhile);
    test->Emit(codeGen);
    codeGen->GenIfZ(test->memoryLocation, endWhile);
    body->Emit(codeGen);
    codeGen->GenGoto(startWhile);
    codeGen->GenLabel(endWhile);
}

IfStmt::IfStmt(Expr *t, Stmt *tb, Stmt *eb): ConditionalStmt(t, tb) { 
    Assert(t != NULL && tb != NULL); // else can be NULL
    elseBody = eb;
    if (elseBody) elseBody->SetParent(this);
}

void IfStmt::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        test->Check(table, pass);
        body->Check(table, pass);
        if (elseBody) elseBody->Check(table, pass);
    } else if (pass == 2) {
        test->Check(table, pass);
        if (test->evalType != Type::boolType && test->evalType != Type::errorType) {
            ReportError::TestNotBoolean(test);
        }
        body->Check(table, pass);
        if (elseBody) elseBody->Check(table, pass);
    }
}

void IfStmt::Emit(CodeGenerator* codeGen) {
    test->Emit(codeGen);

    const char* endIf = codeGen->NewLabel();
    codeGen->GenIfZ(test->memoryLocation, endIf);
    body->Emit(codeGen);
    if (elseBody) {
        const char* endElse = codeGen->NewLabel();
        codeGen->GenGoto(endElse);
        codeGen->GenLabel(endIf);
        elseBody->Emit(codeGen);
        codeGen->GenLabel(endElse);
    } else {
        codeGen->GenLabel(endIf);
    }   
}

void BreakStmt::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
    } else if (pass == 2) {
        if (!astTable->defined("break") && dynamic_cast<ForStmt*>(parent) == NULL && dynamic_cast<WhileStmt*>(parent) == NULL) {

            ReportError::BreakOutsideLoop(this); 
        }
    }
}

void BreakStmt::Emit(CodeGenerator* codeGen) {
    LoopStmt* loop = dynamic_cast<LoopStmt*>(astTable->get("break"));
    codeGen->GenGoto(loop->breakLabel);
}

ReturnStmt::ReturnStmt(yyltype loc, Expr *e) : Stmt(loc) { 
    Assert(e != NULL);
    (expr=e)->SetParent(this);
}
  
void ReturnStmt::Check(Hashtable<Node*> *table, int pass) {
    expr->Check(table, pass);

    if (pass == 0) {
        astTable = table;
    } else if (pass == 1) {
    } else if (pass == 2) {
        Type* retType = dynamic_cast<Type*>(astTable->get("return"));
        if (retType) {
            if (!expr->evalType->IsCompatibleWith(table, retType)) {
                ReportError::ReturnMismatch(this, expr->evalType, retType);
            }
        }
    }
}

void ReturnStmt::Emit(CodeGenerator* codeGen) {
    expr->Emit(codeGen);
    codeGen->GenReturn(expr->memoryLocation);
}

PrintStmt::PrintStmt(List<Expr*> *a) {    
    Assert(a != NULL);
    (args=a)->SetParentAll(this);
}


void PrintStmt::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        for (int i = 0; i < args->NumElements(); i++) {
            args->Nth(i)->Check(table, pass);
        } 
    } else if (pass == 2) {
        for (int i = 0; i < args->NumElements(); i++) {
            args->Nth(i)->Check(table, pass);
            if (args->Nth(i)->evalType != Type::intType && args->Nth(i)->evalType != Type::boolType &&
                    args->Nth(i)->evalType != Type::stringType ) {

                ReportError::PrintArgMismatch(args->Nth(i), i+1, args->Nth(i)->evalType);

            }
        } 

    }
}

void PrintStmt::Emit(CodeGenerator* codeGen) {
    for (int i = 0; i < args->NumElements(); i++) {
        args->Nth(i)->Emit(codeGen);
        if (args->Nth(i)->evalType == Type::intType) {
            codeGen->GenBuiltInCall(PrintInt, args->Nth(i)->memoryLocation);
        } else if (args->Nth(i)->evalType == Type::stringType) {
            codeGen->GenBuiltInCall(PrintString, args->Nth(i)->memoryLocation);
        } else {
            codeGen->GenBuiltInCall(PrintBool, args->Nth(i)->memoryLocation);
        }
    }
}
