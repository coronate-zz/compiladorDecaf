Esta es la estrcutura de las calses en los archivos ast_, como podemos ver la clase 
principal es Node y todas las subclases heredan de esta clase.


 	
                               															                     Node
                     /                                                                                                                                         /                                                                                                                                                                                                                                            \                            \               \                           
                   Decl                                                                                                                                       Stmt                                                                                                                                                                                                                                        Type                      Program         Operator
   /               /  \                \               /                 /                    /                                                              /                                                                                                                                                                                                         \             \                   /    \                                                                                                       
VarDecl   ClassDecl   InterfaceDecl   FnDecl   ||    StmtBlock       BreakStmt         ConditionalStmt                                                    Expr                                                                                                                                                                                                    ReturnStmt    PrintStmt    ||  NamedType    ArrayType                                   
								                       /             \                 /                  /             /      \                \              \                                       \                                                       \               \    \       \         \                \
								                 loopStmt           ifStmt       EmprtyExpression  IntConstant DoubleConstant  BoolConstant StringConstant NullConstant                            CompoundExpr                                              LValue           This  Call NewExpr  NewArrayExpr  ReadIntegerExpr
								                  /     \                                                                                                                     /                    /          \          \            \                     /     \
							                     forStmt   WhileStmt                                                                                                         ArithmeticExpr RelationalExpr  EqualityExpr LogicalExpr  AssignExpr ||     ArrayAccess   FieldAccess
								

Lo importante es concentrarnos en los nodos terminales (hojas) de cada rama para ver la manera 
en la que se contruye cada clase y lo atributos que recibe cada tipo de nodo.
Ejemplo:
VarDecl es nodo terminal de Decl y se especifica asi:

	class VarDecl : public Decl 
	{
	  protected:
	    Type *type;
	    
	  public:
	    VarDecl(Identifier *name, Type *type);
	    const char *GetPrintNameForNode() { return "VarDecl"; }
	    void PrintChildren(int indentLevel);
	};
=> VarDecl recibe un atributo tipo Identifier y un atributo tipo identifier y atributo tipo Type
=> Cuando se genere el nonterminal VarDecl debemos crear un objeto tipo VarDecl:
	VariableDecl  :  Variable ';'     { $$ = $1; }
		      ;

	Variable  :    Type T_Identifier  { Identifier *varName = new Identifier(@2, $2);
		                            $$ = new VarDecl( varName, $1 );}
=>En este caso primero creamos el objeto Identifier(varName) usando T_Identifier como atributo( $2 )
=>Creamso varDecl usando varName y Type($1) como atributos.


Podemos seguir conociendo/construendo la relación entre cada objeto siguiendo los atributos de cada hoja.

         VarDecl 
        /       \
Identifier      Type

Como Identifier es un token que generamos en el PP1 solo debemos crear usando la direccion y el token identifier:
Identifier *varName = new Identifier(@2, $2);
   donde:  $2= T_Identifier y @2=yyloc de T_identifier

Constant:
IntConstant	*T_intConstant
DoublesConstant	*T_doubleConstant
BoolConstant	*T_BoolConstant
T_StringConstant*T_StringConstant
--------------------------------------------------------------------
Actuals:

--------------------------------------------------------------------
VarDecl:
	*Identifier
		**T_identifier
	*Type
		**Type::doubleType
		**Type::voidType  
		**Type::boolType 
		**Type::nullType   
		**Type::stringType
		**Type::errorType   
---------------------------------------------------------------------
ClassDecl:
	*Identifier
		**
	*NamedType
	*List<NamedType>
	*List<Decl>















