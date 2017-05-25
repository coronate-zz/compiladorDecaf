/* File: ast_expr.cc
 * -----------------
 * Implementation of expression node classes.
 */
#include "ast_expr.h"
#include "ast_type.h"
#include "ast_decl.h"
#include <string.h>

Expr::Expr() : Stmt() {
    evalType = Type::errorType; 
}

Expr::Expr(yyltype loc) : Stmt(loc) {
    evalType = Type::errorType;
}

Hashtable<Node*>* Expr::getScope(Hashtable<Node*>* table) {
    NamedType* nt = dynamic_cast<NamedType*>(evalType);
    if (!nt) return NULL;
    ClassDecl* cd = dynamic_cast<ClassDecl*>(table->get(nt->id->name));
    if (!cd) {
        InterfaceDecl* ifdecl = dynamic_cast<InterfaceDecl*>(table->get(nt->id->name));
        if (ifdecl) {
            return ifdecl->astTable;
        } else {
            return NULL;
        }
    }
    return cd->astTable;
}

EmptyExpr::EmptyExpr() {
    evalType = Type::voidType; 
}

NullConstant::NullConstant(yyltype loc) : Expr(loc) {
    evalType = Type::nullType;
}

void NullConstant::Emit(CodeGenerator* codeGen) {
    memoryLocation = codeGen->GenLoadConstant(0);
    Assert(memoryLocation != NULL);
}

IntConstant::IntConstant(yyltype loc, int val) : Expr(loc) {
    value = val;
    evalType = Type::intType;
}

void IntConstant::Emit(CodeGenerator* codeGen) {
    memoryLocation = codeGen->GenLoadConstant(value);
    Assert(memoryLocation != NULL);
}

DoubleConstant::DoubleConstant(yyltype loc, double val) : Expr(loc) {
    value = val;
    evalType = Type::doubleType;
}

BoolConstant::BoolConstant(yyltype loc, bool val) : Expr(loc) {
    value = val;
    evalType = Type::boolType;
}

void BoolConstant::Emit(CodeGenerator* codeGen) {
    memoryLocation = codeGen->GenLoadConstant(value);
    Assert(memoryLocation != NULL);
}

StringConstant::StringConstant(yyltype loc, const char *val) : Expr(loc) {
    Assert(val != NULL);
    value = strdup(val);
    evalType = Type::stringType;
}

void StringConstant::Emit(CodeGenerator* codeGen) {
    memoryLocation = codeGen->GenLoadConstant(value);
    Assert(memoryLocation != NULL);
}

Operator::Operator(yyltype loc, const char *tok) : Node(loc) {
    Assert(tok != NULL);
    strncpy(tokenString, tok, sizeof(tokenString));
    if (tokenString[1] == '\0') {
        if (tokenString[0] == '!') {
            opType = ENot;
        } else if (tokenString[0] == '-') {
            opType = ENeg;
        } else if (tokenString[0] == '*') {
            opType = EMul;
        } else if (tokenString[0] == '/') {
            opType = EDiv;
        } else if (tokenString[0] == '%') {
            opType = EMod;
        } else if (tokenString[0] == '+') {
            opType = EPlus;
        } else if (tokenString[0] == '<') {
            opType = ELess;
        } else if (tokenString[0] == '>') {
            opType = EGreat;
        } else if (tokenString[0] == '=') {
            opType = EAssign;
        }
    } else {
        if (tokenString[0] == '<') {
            opType = ELessE;
        } else if (tokenString[0] == '>') {
            opType = EGreatE;
        } else if (tokenString[0] == '=') {
            opType = EEqual;
        } else if (tokenString[0] == '!') {
            opType = ENEqual;
        } else if (tokenString[0] == '&') {
            opType = EAnd;
        } else if (tokenString[0] == '|') {
            opType = EOr;
        }
    }
}

CompoundExpr::CompoundExpr(Expr *l, Operator *o, Expr *r) 
  : Expr(Join(l->GetLocation(), r->GetLocation())) {
    Assert(l != NULL && o != NULL && r != NULL);
    (op=o)->SetParent(this);
    (left=l)->SetParent(this); 
    (right=r)->SetParent(this);
}

CompoundExpr::CompoundExpr(Operator *o, Expr *r) 
  : Expr(Join(o->GetLocation(), r->GetLocation())) {
    Assert(o != NULL && r != NULL);
    left = NULL; 
    (op=o)->SetParent(this);
    (right=r)->SetParent(this);
}
   
void CompoundExpr::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        if (left != NULL) {
            left->Check(table, pass);
        }
        right->Check(table, pass);

    } else if (pass == 2) {
        if (left != NULL) {
            left->Check(table, pass);
        }
        right->Check(table, pass);
    }
}

void CompoundExpr::Emit(CodeGenerator* codeGen) {
    if (!left) {
        right->Emit(codeGen);
        if (op->opType == ENeg) {
            Location* temp = codeGen->GenLoadConstant(0);
            memoryLocation = codeGen->GenBinaryOp("-", temp, right->memoryLocation);
        } else if (op->opType == ENot) {
            Location* temp = codeGen->GenLoadConstant(0);
            memoryLocation = codeGen->GenBinaryOp("==", right->memoryLocation, temp);
        }
    } else {
        left->Emit(codeGen);
        right->Emit(codeGen);
        memoryLocation = codeGen->GenBinaryOp(strdup(op->tokenString), left->memoryLocation, right->memoryLocation);
    }
    Assert(memoryLocation != NULL);
}

void ArithmeticExpr::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        if (left != NULL) {
            left->Check(table, pass);
        }
        right->Check(table, pass);

    } else if (pass == 2) {
        if (left != NULL) {
            left->Check(table, pass);
        }
        right->Check(table, pass);

        if (left != NULL) {
            if (left->evalType == Type::errorType || right->evalType == Type::errorType) {
                evalType = Type::errorType;
            } else if ((left->evalType != Type::intType && left->evalType != Type::doubleType) ||
                right->evalType != left->evalType) {

                ReportError::IncompatibleOperands(op, left->evalType, right->evalType);
                evalType = Type::errorType;
            } else {
                evalType = right->evalType;
            }
        } else {
            if (right->evalType == Type::errorType) {
                evalType = Type::errorType;
            } else if (right->evalType != Type::intType && right->evalType != Type::doubleType) {
                ReportError::IncompatibleOperand(op, right->evalType);
                evalType = Type::errorType;
            } else {
                evalType = right->evalType;
            }
        }
    }
}

void RelationalExpr::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        left->Check(table, pass);
        right->Check(table, pass);

    } else if (pass == 2) {
        left->Check(table, pass);
        right->Check(table, pass);

        if ((left->evalType != Type::intType && left->evalType != Type::doubleType) || right->evalType != left->evalType) {
            ReportError::IncompatibleOperands(op, left->evalType, right->evalType);
        }
        evalType = Type::boolType;
    }

}

void RelationalExpr::Emit(CodeGenerator* codeGen) {
    left->Emit(codeGen);
    right->Emit(codeGen);
    if (op->opType == ELessE) {
        Location* temp1 = codeGen->GenBinaryOp("<", left->memoryLocation, right->memoryLocation);
        Location* temp2 = codeGen->GenBinaryOp("==", left->memoryLocation, right->memoryLocation);
        memoryLocation = codeGen->GenBinaryOp("||", temp1, temp2);
    } else if (op->opType == EGreat) {
        memoryLocation = codeGen->GenBinaryOp("<", right->memoryLocation, left->memoryLocation);
    } else if (op->opType == EGreatE) {
        Location* temp1 = codeGen->GenBinaryOp("<", right->memoryLocation, left->memoryLocation);
        Location* temp2 = codeGen->GenBinaryOp("==", right->memoryLocation, left->memoryLocation);
        memoryLocation = codeGen->GenBinaryOp("||", temp1, temp2);
    } else {
        memoryLocation = codeGen->GenBinaryOp(strdup(op->tokenString), left->memoryLocation, right->memoryLocation);
    }
    Assert(memoryLocation != NULL);
}

void EqualityExpr::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        left->Check(table, pass);
        right->Check(table, pass);

    } else if (pass == 2) {
        left->Check(table, pass);
        right->Check(table, pass);

        if (!left->evalType->IsCompatibleWith(table, right->evalType) &&
                   !right->evalType->IsCompatibleWith(table, left->evalType)) {

            ReportError::IncompatibleOperands(op, left->evalType, right->evalType);
            evalType = Type::errorType;
        }

        evalType = Type::boolType;
    }

}

void EqualityExpr::Emit(CodeGenerator* codeGen) {
    if (left->evalType == Type::stringType && right->evalType == Type::stringType) {
        // compare actual characters and not just the references
        left->Emit(codeGen);
        right->Emit(codeGen);

        if (op->opType == EEqual) {
            memoryLocation = codeGen->GenBuiltInCall(StringEqual, left->memoryLocation, right->memoryLocation);
        } else { // not equal
            Location* temp1 = codeGen->GenBuiltInCall(StringEqual, left->memoryLocation, right->memoryLocation);
            Location* temp2 = codeGen->GenLoadConstant(0);
            memoryLocation = codeGen->GenBinaryOp("==", temp1, temp2);
        }
    } else {
        if (op->opType == EEqual) {
            CompoundExpr::Emit(codeGen);
        } else { //Not equal
            left->Emit(codeGen);
            right->Emit(codeGen);
            Location* exprEqual = codeGen->GenBinaryOp("==", left->memoryLocation, right->memoryLocation);
            Location* zero = codeGen->GenLoadConstant(0);
            memoryLocation = codeGen->GenBinaryOp("==", exprEqual, zero);
        }
    }
    Assert(memoryLocation != NULL);
}

void LogicalExpr::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
        if (left != NULL) {
            left->Check(table, pass);
        }
        right->Check(table, pass);

    } else if (pass == 2) {
        if (left != NULL) {
            left->Check(table, pass);
        }
        right->Check(table, pass);

        if (left != NULL) {
            if (left->evalType == Type::errorType || right->evalType == Type::errorType) {
                evalType = Type::errorType;
            } else if (right->evalType != Type::boolType || left->evalType != Type::boolType) {
                ReportError::IncompatibleOperands(op, left->evalType, right->evalType);
                evalType = Type::errorType;
            } else {
                evalType = Type::boolType;
            }
        } else {
            if (right->evalType == Type::errorType) {
                evalType = Type::errorType;
            } else if (right->evalType != Type::boolType) {
                ReportError::IncompatibleOperand(op, right->evalType);
                evalType = Type::errorType;
            } else {
                evalType = Type::boolType;
            }
        }
    }
}

void AssignExpr::Check(Hashtable<Node*> *table, int pass) {
    left->Check(table, pass);
    right->Check(table, pass);
    if (pass == 0) {
        astTable = table;
    } else if (pass == 2) {
        if (right->evalType == Type::nullType) {
            if (dynamic_cast<NamedType*>(left->evalType) == NULL) {
                ReportError::IncompatibleOperands(op, left->evalType, right->evalType);
            }
        } else if (left->evalType == Type::errorType || right->evalType == Type::errorType) {
            evalType = left->evalType;
        } else if (!right->evalType->IsCompatibleWith(table, left->evalType)) {
            ReportError::IncompatibleOperands(op, left->evalType, right->evalType);
        }
        evalType = left->evalType;
    }
}

void AssignExpr::Emit(CodeGenerator* codeGen) {
    left->Emit(codeGen);
    right->Emit(codeGen);
    if (dynamic_cast<ArrayAccess*>(left) != NULL) {
        codeGen->GenStore(left->memoryLocation, right->memoryLocation, 0);
    } else if (storeWithOffset) {
        codeGen->GenStore(left->memoryLocation, right->memoryLocation, offset);
    } else {
        codeGen->GenAssign(left->memoryLocation, right->memoryLocation);
    }
    memoryLocation = left->memoryLocation; //TODO store?
    Assert(memoryLocation != NULL);
}

FieldAccess::FieldAccess(Expr *b, Identifier *f)
  : LValue(b? Join(b->GetLocation(), f->GetLocation()) : *f->GetLocation()) {
    Assert(f != NULL); // b can be be NULL (just means no explicit base)
    base = b; 
    if (base) base->SetParent(this); 
    (field=f)->SetParent(this);
}

void FieldAccess::Check(Hashtable<Node*> *table, int pass) {
    if (base) {
        base->Check(table, pass);
    }
    if (pass == 0) {
        astTable = table;
    } else if (pass == 1) {

    } else if (pass == 2) {
        Hashtable<Node*>* scope = astTable;
        if (base) {
            scope = base->getScope(table);
            if (!scope) {
                ReportError::FieldNotFoundInBase(field, base->evalType);
                return;
            }
        }
        if (!scope->defined(field->name)) {
            if (base) {
                ReportError::FieldNotFoundInBase(field, base->evalType);
            } else {
                ReportError::IdentifierNotDeclared(field, LookingForVariable);
            }
            astTable->insertFake(field->name);
        } else {
            VarDecl* vd = dynamic_cast<VarDecl*>(scope->get(field->name));
            if (vd) {
                ClassDecl* cd = dynamic_cast<ClassDecl*>(astTable->get("this"));
                if (!cd && base) {
                    ReportError::InaccessibleField(field, base->evalType);
                }
                evalType = vd->type; 
            } else {
                ReportError::IdentifierNotDeclared(field, LookingForVariable);
                evalType = Type::errorType;
            }
        }
    }
}

void FieldAccess::Emit(CodeGenerator* codeGen) {
    if (!base) {
        VarDecl* vd = dynamic_cast<VarDecl*>(astTable->get(field->name));
        if (dynamic_cast<ClassDecl*>(vd->GetParent()) != NULL) {
            AssignExpr* assignParent = dynamic_cast<AssignExpr*>(parent);
            if (assignParent && assignParent->left == this) {
                memoryLocation = CodeGenerator::ThisPtr;
                assignParent->storeWithOffset = true;
                assignParent->offset = vd->locationInObject;
            } else {
                memoryLocation = codeGen->GenLoad(CodeGenerator::ThisPtr, vd->locationInObject);
            }
        } else {
            memoryLocation = vd->frameLocation;
        }
    } else {
        base->Emit(codeGen);
        ClassDecl* baseClass = dynamic_cast<ClassDecl*>(codeGen->globalSymbolTable->get(base->evalType->typeName));
        VarDecl* fieldVar = dynamic_cast<VarDecl*>(baseClass->astTable->get(field->name));
        AssignExpr* assignParent = dynamic_cast<AssignExpr*>(parent);
        if (assignParent && assignParent->left == this) {
            memoryLocation = base->memoryLocation;
            assignParent->storeWithOffset = true;
            assignParent->offset = fieldVar->locationInObject;
        } else {
            memoryLocation = codeGen->GenLoad(base->memoryLocation, fieldVar->locationInObject);
        }
    }
    Assert(memoryLocation != NULL);
}

Call::Call(yyltype loc, Expr *b, Identifier *f, List<Expr*> *a) : Expr(loc)  {
    Assert(f != NULL && a != NULL); // b can be be NULL (just means no explicit base)
    base = b;
    if (base) base->SetParent(this);
    (field=f)->SetParent(this);
    (actuals=a)->SetParentAll(this);
}
 
void Call::Check(Hashtable<Node*> *table, int pass) {
    for (int i = 0; i < actuals->NumElements(); i++) {
        actuals->Nth(i)->Check(table, pass);
    } 
    if (base) base->Check(table, pass);

    if (pass == 0) {
        astTable = table;
    } else if (pass == 1) {
    } else if (pass == 2) {
        Hashtable<Node*>* scope = astTable;
        // set-up the scope
        if (base) { 
            scope = base->getScope(table);
            if (!scope) {
                // check for array length functions
                if (dynamic_cast<ArrayType*>(base->evalType) != NULL && strcmp(field->name, "length") == 0 &&
                    actuals->NumElements() == 0) {

                    evalType = Type::intType;
                    return;
                }
                if (strcmp(field->name, "length") == 0) {
                    ReportError::FieldNotFoundInBase(field, base->evalType);
                    evalType = Type::intType;
                }

                return;
            }
        }
        if (!scope->defined(field->name)) {
            if (base) {
                ReportError::FieldNotFoundInBase(field, base->evalType);
            } else {
                ReportError::IdentifierNotDeclared(field, LookingForFunction);
            }
            astTable->insertFake(field->name);
        } else {
            FnDecl* fn = dynamic_cast<FnDecl*>(scope->get(field->name));
            if (fn) {
                evalType = fn->returnType;

                //see if actuals match formals
                if (actuals->NumElements() > fn->formals->NumElements()) {
                    ReportError::NumArgsMismatch(field, fn->formals->NumElements(), actuals->NumElements());
                } else if (actuals->NumElements() < fn->formals->NumElements()) {
                    ReportError::NumArgsMismatch(field, fn->formals->NumElements(), actuals->NumElements());
                    return;
                } 

                for (int i = 0; i < fn->formals->NumElements(); i++) {
                    if (!actuals->Nth(i)->evalType->IsCompatibleWith(table, fn->formals->Nth(i)->type)) { 
                        ReportError::ArgMismatch(actuals->Nth(i), i+1, actuals->Nth(i)->evalType,
                            fn->formals->Nth(i)->type);
                    }
                }
            } else {
                evalType = Type::errorType;
            }
        }
    }
}

void Call::Emit(CodeGenerator* codeGen) {
    bool hasReturnValue = false;

    for (int i = 0; i < actuals->NumElements(); i++) {
        actuals->Nth(i)->Emit(codeGen);
    }
    if (!base) {
        FnDecl* fd = dynamic_cast<FnDecl*>(astTable->get(field->name));
        if (!fd) return;
        bool hasReturnValue = fd->returnType != Type::voidType;

        ClassDecl* parentClass = dynamic_cast<ClassDecl*>(fd->GetParent());
        if (parentClass) {
            Location* vtable = codeGen->GenLoad(CodeGenerator::ThisPtr);
            Location* methodPointer = codeGen->GenLoad(vtable, fd->vtableOffset * CodeGenerator::VarSize);
            for (int i = actuals->NumElements() - 1; i >= 0; i--) {
                codeGen->GenPushParam(actuals->Nth(i)->memoryLocation);
            }
            codeGen->GenPushParam(CodeGenerator::ThisPtr); // push this pointer
            memoryLocation = codeGen->GenACall(methodPointer, hasReturnValue);
            codeGen->GenPopParams((actuals->NumElements() + 1) * CodeGenerator::VarSize); // add one for this pointer

        } else {
            for (int i = actuals->NumElements() - 1; i >= 0; i--) {
                codeGen->GenPushParam(actuals->Nth(i)->memoryLocation);
            }
            memoryLocation = codeGen->GenLCall(fd->getFunctionLabel(), hasReturnValue);
            if (actuals->NumElements() > 0) {
                codeGen->GenPopParams(actuals->NumElements() * CodeGenerator::VarSize);
            }
        }
    } else {
        base->Emit(codeGen);

        //see if we have a array length call
        if (dynamic_cast<ArrayType*>(base->evalType) != NULL && strcmp(field->name, "length") == 0 &&
            actuals->NumElements() == 0) {
            memoryLocation = codeGen->GenLoad(base->memoryLocation, -1 * CodeGenerator::VarSize);

        } else {
            // method calls
            ClassDecl* baseDecl = dynamic_cast<ClassDecl*>(codeGen->globalSymbolTable->get(base->evalType->typeName));
            FnDecl* methodDecl = dynamic_cast<FnDecl*>(baseDecl->astTable->get(field->name));
            hasReturnValue = methodDecl->returnType != Type::voidType;
            Location* vtable = codeGen->GenLoad(base->memoryLocation);
            int offset = methodDecl->vtableOffset;
            Location* methodPointer = codeGen->GenLoad(vtable, offset * CodeGenerator::VarSize);
            for (int i = actuals->NumElements() - 1; i >= 0; i--) {
                codeGen->GenPushParam(actuals->Nth(i)->memoryLocation);
            }
            codeGen->GenPushParam(base->memoryLocation); // push this pointer
            memoryLocation = codeGen->GenACall(methodPointer, hasReturnValue);
            codeGen->GenPopParams((actuals->NumElements() + 1) * CodeGenerator::VarSize); // add one for this pointer
        }
    }
    Assert(memoryLocation != NULL || !hasReturnValue);
}

NewExpr::NewExpr(yyltype loc, NamedType *c) : Expr(loc) { 
  Assert(c != NULL);
  (cType=c)->SetParent(this);
}

void NewExpr::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 0) {
        astTable = table;
    } else if (pass == 2) {
        if (dynamic_cast<ClassDecl*>(table->get(cType->id->name)) == NULL) {
            ReportError::IdentifierNotDeclared(cType->id, LookingForClass); 
            evalType = Type::errorType;
        } else {
            evalType = cType;
        }
    }
}

void NewExpr::Emit(CodeGenerator* codeGen) {
    ClassDecl* classType = dynamic_cast<ClassDecl*>(codeGen->globalSymbolTable->get(cType->id->name));
    Location* size = codeGen->GenLoadConstant(classType->objectSize);

    memoryLocation = codeGen->GenBuiltInCall(Alloc, size);
    Location* vtablePointer = codeGen->GenLoadLabel(classType->id->name);
    codeGen->GenStore(memoryLocation, vtablePointer);
    Assert(memoryLocation != NULL);
}

NewArrayExpr::NewArrayExpr(yyltype loc, Expr *sz, Type *et) : Expr(loc) {
    Assert(sz != NULL && et != NULL);
    (size=sz)->SetParent(this); 
    (elemType=et)->SetParent(this);
}
       
void NewArrayExpr::Check(Hashtable<Node*> *table, int pass) {
    size->Check(table, pass);
    if (pass == 0) {
        astTable = table;
    } else if (pass == 2) {
        if (size->evalType != Type::intType) {
            ReportError::NewArraySizeNotInteger(size);
        }
        NamedType* nt = dynamic_cast<NamedType*>(elemType);
        if (nt && dynamic_cast<ClassDecl*>(table->get(nt->id->name)) == NULL
            && dynamic_cast<InterfaceDecl*>(table->get(nt->id->name)) == NULL)  {

            ReportError::IdentifierNotDeclared(nt->id, LookingForType); 
            evalType = Type::errorType;
        } else {
            evalType = new ArrayType(*location, elemType);
        }
    }
}

void NewArrayExpr::Emit(CodeGenerator* codeGen) {
    size->Emit(codeGen);
    Location* arraySize = size->memoryLocation;
    Location* zero = codeGen->GenLoadConstant(0);
    Location* validSize = codeGen->GenBinaryOp("<", arraySize, zero);
    const char* endIf = codeGen->NewLabel();
    codeGen->GenIfZ(validSize, endIf);
    Location* errorMessage = codeGen->GenLoadConstant("Decaf runtime error: Array size is <= 0\\n");
    codeGen->GenBuiltInCall(PrintString, errorMessage);
    codeGen->GenBuiltInCall(Halt);
    codeGen->GenLabel(endIf);
    Location* One = codeGen->GenLoadConstant(1);
    Location* arraySizePlusOne = codeGen->GenBinaryOp("+", One, arraySize);
    Location* varSize = codeGen->GenLoadConstant(CodeGenerator::VarSize);
    Location* finalArraySize = codeGen->GenBinaryOp("*", arraySizePlusOne, varSize);
    Location* memory = codeGen->GenBuiltInCall(Alloc, finalArraySize);

    // dereference memory and store array size at postion 0
    codeGen->GenStore(memory, arraySize, 0);

    Location* firstElement = codeGen->GenBinaryOp("+", memory, varSize);
    memoryLocation = firstElement;
    Assert(memoryLocation != NULL);
}

void This::Check(Hashtable<Node*> *table, int pass) {

    if (pass == 0) {
        astTable = table;
    } else if (pass == 1) {
    } else if (pass == 2) {
        if (!astTable->defined("this")) {
            ReportError::ThisOutsideClassScope(this);
            evalType = Type::errorType;
        } else {
            ClassDecl* cd = dynamic_cast<ClassDecl*>(astTable->get("this"));
            if (cd) {
                evalType = cd->type;
            } else {
                evalType = Type::errorType;
            }
        }
    }
}

void This::Emit(CodeGenerator* codeGen) {
    memoryLocation = CodeGenerator::ThisPtr;
    Assert(memoryLocation != NULL);
}

ArrayAccess::ArrayAccess(yyltype loc, Expr *b, Expr *s) : LValue(loc) {
    (base=b)->SetParent(this); 
    (subscript=s)->SetParent(this);
}

void ArrayAccess::Check(Hashtable<Node*> *table, int pass) {
    base->Check(table, pass);
    subscript->Check(table, pass);
    if (pass == 0) {
        astTable = table;
    } else if (pass == 2) {
        ArrayType* at = dynamic_cast<ArrayType*>(base->evalType);
        if (!at) {
            ReportError::BracketsOnNonArray(base);
            evalType = Type::errorType;
        } else {
            evalType = at->elemType;
        }
        if (subscript->evalType != Type::intType) {
            ReportError::SubscriptNotInteger(subscript);
        }
    }
}

void ArrayAccess::Emit(CodeGenerator* codeGen) {
    base->Emit(codeGen);
    subscript->Emit(codeGen);

    // check the bounds of the subscript
    Location* zero = codeGen->GenLoadConstant(0);
    Location* test = codeGen->GenBinaryOp("<", subscript->memoryLocation, zero);
    Location* arraySize = codeGen->GenLoad(base->memoryLocation, -1 * CodeGenerator::VarSize);
    Location* test2 = codeGen->GenBinaryOp("<", subscript->memoryLocation, arraySize);
    Location* test3 = codeGen->GenBinaryOp("==", test2, zero);
    Location* test4 = codeGen->GenBinaryOp("||", test, test3);
    const char* endIf = codeGen->NewLabel();
    codeGen->GenIfZ(test4, endIf);
    Location* errorMessage = codeGen->GenLoadConstant("Decaf runtime error: Array subscript out of bounds\\n");
    codeGen->GenBuiltInCall(PrintString, errorMessage);
    codeGen->GenBuiltInCall(Halt);
    codeGen->GenLabel(endIf);
    // end of the bounds check
    
    Location* varSize = codeGen->GenLoadConstant(CodeGenerator::VarSize);
    Location* offset = codeGen->GenBinaryOp("*", varSize, subscript->memoryLocation);
    Location* atOffset = codeGen->GenBinaryOp("+", base->memoryLocation, offset);
    AssignExpr* assignParent = dynamic_cast<AssignExpr*>(parent);
    if (assignParent && assignParent->left == this) {
        memoryLocation = atOffset;
    } else {
        memoryLocation = codeGen->GenLoad(atOffset, 0);
    }
    Assert(memoryLocation != NULL);
}

void ReadIntegerExpr::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 2) evalType = Type::intType;
}

void ReadIntegerExpr::Emit(CodeGenerator* codeGen) {
    memoryLocation = codeGen->GenBuiltInCall(ReadInteger);
    Assert(memoryLocation != NULL);
}

void ReadLineExpr::Check(Hashtable<Node*> *table, int pass) {
    if (pass == 2) evalType = Type::stringType;
}

void ReadLineExpr::Emit(CodeGenerator* codeGen) {
    memoryLocation = codeGen->GenBuiltInCall(ReadLine);
    Assert(memoryLocation != NULL);
}

