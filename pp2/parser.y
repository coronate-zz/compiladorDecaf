
%{


#include "scanner.h" // for yylex
#include "parser.h"
#include "errors.h"

void yyerror(char *msg); // standard error-handling routine

%}

/* The section before the first %% is the Definitions section of the yacc
 * input file. Here is where you declare tokens and types, add precedence
 * and associativity options, and so on.
 */
 
/* yylval 
 * ------
 * Here we define the type of the yylval global variable that is used by
 * the scanner to store attibute information about the token just scanned
 * and thus communicate that information to the parser. 
 *
 * pp2: You will need to add new fields to this union as you add different 
 *      attributes to your non-terminal symbols.
 */
%union {
    int            integerConstant;
    bool           boolConstant;
    char*          stringConstant;
    double         doubleConstant;
    char           identifier[MaxIdentLen+1];
    Decl*          decl_union;
    FnDecl*        funcionDecl_union;
    List< Decl* >*      declList_union;
    Type*               varType_union;
    VarDecl*            varDecl_union;
    InterfaceDecl*      interfaceDecl_union;
    List< Decl* >*      prototypeList_union;
    List< VarDecl* >*   varDeclList_union;
    StmtBlock*          stmtBlock_union;
    Stmt*               stmt_union;
    List< Stmt* >*      stmtList_union;
    Expr*               expr_union;
    List< Expr* >*      exprList_union;
    Call*               call_union;
    WhileStmt*          whileStmt_union;
    ForStmt*            forStmt_union;
    ReturnStmt*         returnStmt_union;
    IfStmt*             ifStmt_union;
    PrintStmt*          printStmt_union;
    ClassDecl*          classDecl_union;
    List< NamedType* >* interfaceList_union;
}


%token   <identifier> T_Identifier
%token   <stringConstant> T_StringConstant 
%token   <integerConstant> T_IntConstant
%token   <doubleConstant> T_DoubleConstant
%token   <boolConstant> T_BoolConstant
%token   T_Void T_Bool T_Int T_Double T_String T_Class 
%token   T_LessEqual T_GreaterEqual T_Equal T_NotEqual T_Dims
%token   T_And T_Or T_Null T_Extends T_This T_Interface T_Implements
%token   T_While T_For T_If T_Else T_Return T_Break
%token   T_New T_NewArray T_Print T_ReadInteger T_ReadLine



%type <call_union>                            Call
%type <exprList_union>                  AExpr
%type <exprList_union>                  Actuals
%type <ifStmt_union>                    IfStmt
%type <whileStmt_union>                 WhileStmt
%type <forStmt_union>                   ForStmt
%type <returnStmt_union>                ReturnStmt
%type <printStmt_union>     PrintStmt
%type <exprList_union>      PrintList
%type <classDecl_union>     ClassDecl
%type <declList_union>      FieldList
%type <interfaceList_union> InterfaceList
%type <decl_union>          Field
%type <interfaceList_union> AInterface
%type <declList_union>      DeclList 
%type <decl_union>          Decl
%type <varType_union>       Type
%type <varDecl_union>       VariableDecl
%type <varDecl_union>       Variable
%type <interfaceDecl_union> InterfaceDecl
%type <decl_union>          Prototype
%type <prototypeList_union> PrototypeList
%type <varDecl_union>       Param
%type <varDeclList_union>   ParamsList
%type <varDeclList_union>   AParam
%type <funcionDecl_union>        FunctionDecl
%type <stmtBlock_union>     StmtBlock
%type <varDeclList_union>   VariableDeclList
%type <stmtList_union>      StmtList
%type <stmt_union>          Stmt
%type <expr_union>          Expr
%type <expr_union>          Constant
%type <expr_union>          LValue

%nonassoc '='
%left T_Or
%left T_And
%left T_Equal T_NotEqual

%nonassoc '<' T_LessEqual '>' T_GreaterEqual
%left '+' '-'
%left '*' '/' '%'
%right '!' UMINUS
%left '[' '.' /* eso creo, no estoy seguro */


%%

Program   :    DeclList            { 
                                      @1; 
                                      /* pp2: The @1 is needed to convince 
                                       * yacc to set up yylloc. You can remove 
                                       * it once you have other uses of @n*/
                                      Program *program = new Program($1);
                                      // if no errors, advance to next phase
                                      if(ReportError::NumErrors() == 0) 
                                        program->Print(0);
                                    }
          ;


DeclList  :    DeclList Decl        { ($$=$1)->Append($2); }
          |    Decl                 { ($$ = new List<Decl*>)->Append($1); }
          ;

Decl      :    VariableDecl          { $$ = $1; }
          |    InterfaceDecl         { $$ = $1; }
          |    ClassDecl             { $$ = $1; }
          |    FunctionDecl          { $$ = $1; }
          ;

VariableDecl  :  Variable ';' { $$ = $1; }
              ;



Variable  :    Type T_Identifier  { 
                                    Identifier *varName = new Identifier(@2, $2);
                                    $$ = new VarDecl( varName, $1 );
                                  }
          ;

Type      :    T_Int          { $$ = Type::intType; }
          |    T_Double       { $$ = Type::doubleType; }
          |    T_Bool         { $$ = Type::boolType; }
          |    T_String       { $$ = Type::stringType; }
          |    T_Void         { $$ = Type::voidType; }
          |    T_Identifier   {
                                Identifier *udfType = new Identifier(@1, $1);
                                $$ = new NamedType(udfType);
                              }
          |    Type T_Dims    { $$ = new ArrayType(@1, $1); }
          ;

InterfaceDecl : T_Interface T_Identifier '{' PrototypeList '}'            {
                                                                            Identifier* interfaceName = new Identifier(@2, $2);
                                                                            $$ = new InterfaceDecl( interfaceName, $4 );
                                                                          }
              ;


PrototypeList : Prototype PrototypeList     { ($$ = $2)->InsertAt($1, 0); }
              |                             { $$ = new List< Decl* >(); }
              ;

Prototype : Type T_Identifier '(' ParamsList ')' ';'                      {
                                                                            Identifier *funcName = new Identifier(@2, $2);
                                                                            $$ = new FnDecl(funcName, $1, $4);
                                                                          }
          ;

ParamsList : Param AParam     { ($$ = $2)->InsertAt($1, 0); }
           |                  { $$ = new List< VarDecl* >(); }
           ;


AParam : ',' Param AParam     { ($$ = $3)->InsertAt($2, 0); }
       |                      { $$ = new List< VarDecl* >(); } 
       ;




Param : Variable              { $$ = $1; }
      ;

FunctionDecl  : Type T_Identifier '(' ParamsList ')' StmtBlock {
                                              Identifier* functionName = new Identifier(@2, $2);
                                              $$ = new FnDecl(functionName, $1, $4);
                                              $$->SetFunctionBody($6);
                                            }
              ;

ClassDecl   : T_Class T_Identifier '{' FieldList '}'
              {
                $$ = new ClassDecl(new Identifier(@2, $2), 
                                    NULL, 
                                    new List< NamedType* >(), 
                                    $4);
              }
            | T_Class T_Identifier T_Extends T_Identifier '{' FieldList '}'
              {
                $$ = new ClassDecl(new Identifier(@2, $2), 
                                    new NamedType(new Identifier(@4, $4)), 
                                    new List< NamedType* >(), 
                                    $6);
              }
            | T_Class T_Identifier T_Implements InterfaceList '{' FieldList '}'
              {
                $$ = new ClassDecl(new Identifier(@2, $2), 
                                    NULL, 
                                    $4, 
                                    $6);
              }
            | T_Class T_Identifier T_Extends T_Identifier T_Implements InterfaceList '{' FieldList '}'
              {
                $$ = new ClassDecl(new Identifier(@2, $2), 
                                    new NamedType(new Identifier(@4, $4)), 
                                    $6, 
                                    $8);
              }
            ;

InterfaceList   : T_Identifier AInterface     { ($$ = $2)->InsertAt(new NamedType(new Identifier(@1, $1)), 0); }
                ;

AInterface  : ',' T_Identifier AInterface     { ($$ = $3)->InsertAt(new NamedType(new Identifier(@2, $2)), 0); }
            |                                 { $$ = new List< NamedType* >(); }
            ;

FieldList   : Field FieldList                                   { ($$ = $2)->InsertAt($1, 0); }
            |                                                   { $$ = new List< Decl* >(); }
            ;

Field : VariableDecl                                            { $$ = $1; }
      | FunctionDecl                                            { $$ = $1; }
      ;



StmtBlock : '{' VariableDeclList StmtList '}'                   {
                                                                  $$ = new StmtBlock($2, $3);
                                                                }
          ;



VariableDeclList : VariableDeclList VariableDecl {
                                              ($$ = $1)->Append($2); 
                                            }
                 |                          { $$ = new List< VarDecl* >(); }
                 ;

StmtList  : Stmt StmtList       { ($$ = $2)->InsertAt($1, 0); }
          |                     { $$ = new List< Stmt* >(); }
         ;

Stmt  : ';'                     { /* ? */ }
      | Expr ';'                { $$ = $1; }
      | IfStmt                  { $$ = $1; }
      | WhileStmt               { $$ = $1; }
      | ForStmt                 { $$ = $1; }
      | T_Break ';'             { $$ = new BreakStmt(@1); }
      | ReturnStmt              { $$ = $1; }
      | PrintStmt               { $$ = $1; }
      | StmtBlock               { $$ = $1; }
      ;

IfStmt  : T_If '(' Expr ')' Stmt              { $$ = new IfStmt($3, $5, NULL); }
        | T_If '(' Expr ')' Stmt T_Else Stmt  { $$ = new IfStmt($3, $5, $7); }

WhileStmt : T_While '(' Expr ')' Stmt { $$ = new WhileStmt($3, $5); }

ForStmt   : T_For '(' Expr ';' Expr ';' Expr ')' Stmt { $$ = new ForStmt($3, $5, $7, $9); }
          | T_For '(' Expr ';' Expr ';' ')' Stmt      { $$ = new ForStmt($3, $5, new EmptyExpr(), $8); }
          | T_For '(' ';' Expr ';' Expr ')' Stmt      { $$ = new ForStmt(new EmptyExpr(), $4, $6, $8); }
          | T_For '(' ';' Expr ';' ')' Stmt           { $$ = new ForStmt(new EmptyExpr(), $4, new EmptyExpr(), $7); }


ReturnStmt  : T_Return Expr ';' { $$ = new ReturnStmt(@1, $2); }
            | T_Return ';'      { $$ = new ReturnStmt(@1, new EmptyExpr()); } 
            ;

PrintStmt   : T_Print '(' PrintList ')' ';' { $$ = new PrintStmt($3); }
            ;

PrintList  : Expr AExpr           { ($$ = $2)->InsertAt($1, 0); }
          ;



Expr  : LValue '=' Expr           { $$ = new AssignExpr($1, new Operator(@2, "="), $3); }
      | Expr '+' Expr             { $$ = new ArithmeticExpr($1, new Operator(@2, "+"), $3); }
      | Expr '-' Expr             { $$ = new ArithmeticExpr($1, new Operator(@2, "-"), $3); }
      | Expr '*' Expr             { $$ = new ArithmeticExpr($1, new Operator(@2, "*"), $3); }
      | Expr '/' Expr             { $$ = new ArithmeticExpr($1, new Operator(@2, "/"), $3); }
      | Expr '%' Expr             { $$ = new ArithmeticExpr($1, new Operator(@2, "%"), $3); }
      | '-' Expr  %prec UMINUS    { $$ = new ArithmeticExpr(new Operator(@1, "-"), $2); }
      | Expr '<' Expr             { $$ = new RelationalExpr($1, new Operator(@2, "<"), $3); }
      | Expr T_LessEqual Expr     { $$ = new RelationalExpr($1, new Operator(@2, "<="), $3); }
      | Expr '>' Expr             { $$ = new RelationalExpr($1, new Operator(@2, ">"), $3); }
      | Expr T_GreaterEqual Expr  { $$ = new RelationalExpr($1, new Operator(@2, ">="), $3); }
      | Expr T_Equal Expr         { $$ = new EqualityExpr($1, new Operator(@2, "=="), $3); }
      | Expr T_NotEqual Expr      { $$ = new EqualityExpr($1, new Operator(@2, "!="), $3); }
      | Expr T_And Expr           { $$ = new LogicalExpr($1, new Operator(@2, "&&"), $3); }
      | Expr T_Or Expr            { $$ = new LogicalExpr($1, new Operator(@2, "||"), $3); }
      | '!' Expr                  { $$ = new LogicalExpr(new Operator(@1, "!"), $2); }
      | T_ReadInteger '(' ')'     { $$ = new ReadIntegerExpr(@1); }
      | T_ReadLine '(' ')'        { $$ = new ReadLineExpr(@1); }
      | T_New '(' T_Identifier ')'                      { 
                                                        NamedType* newt = new NamedType(new Identifier(@3, $3));
                                                        $$ = new NewExpr(@1, newt);
                                                        }
      | T_NewArray '(' Expr ',' Type ')'                { $$ = new NewArrayExpr(@1, $3, $5);  }
      | Constant                                       { $$ = $1; }
      | LValue                                         { $$ = $1; }        
      | T_This                                         { $$ = new This(@1); }
      | Call                                           { $$ = $1; }
      | '(' Expr ')'                                   { $$ = $2; }
      ;


LValue  : T_Identifier           { $$ = new FieldAccess(NULL, new Identifier(@1, $1)); }
        | Expr '.' T_Identifier  { $$ = new FieldAccess($1, new Identifier(@3, $3)); }
        | Expr '[' Expr ']'      { $$ = new ArrayAccess(@1, $1, $3); }
        ;


Call  : T_Identifier '(' Actuals ')' {
                                    $$ = new Call(@1, NULL, new Identifier(@1, $1), $3);
                                  }
      | Expr '.' T_Identifier '(' Actuals ')' {
                                    $$ = new Call(@1, $1, new Identifier(@3, $3), $5);
                                  }
      ;

Actuals : Expr AExpr              { ($$ = $2)->InsertAt($1, 0); }
        |                         { $$ = new List< Expr* >(); }
        ;

AExpr   : ',' Expr AExpr          { ($$ = $3)->InsertAt($2, 0); }
        |                         { $$ = new List< Expr* >(); }
        ;


Constant  : T_IntConstant         { $$ = new IntConstant(@1, $1); }
          | T_DoubleConstant      { $$ = new DoubleConstant(@1, $1); }
          | T_BoolConstant        { $$ = new BoolConstant(@1, $1); }
          | T_StringConstant      { $$ = new StringConstant(@1, $1); }
          | T_Null                { $$ = new NullConstant(@1); }
          ;

%%


void InitParser()
{
   PrintDebug("parser", "Initializing parser");
   yydebug = false  ;
}
