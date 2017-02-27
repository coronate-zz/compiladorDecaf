El código funciona completo y se probo con todos los documentos de prueba. En todos los casos el output es el mismo.
Se probaron algunos casos adicionales para el preprocesador.
El iunico Problema fue durante la asignacion de yylval.stringConstant, La regla identifica correctamente este caso
pero el programa no me deja guardar mi valor en yylval.stringConstant, ni sando "= yytext" o las funciones
strdup o strcpy.

OPINIÓN:
Creo que el proyecto presenta muchas dificultades y en el material de la clase realmente no aporta ningún valor para la 
elaboración del compilador. La mejor fuente de infroamción es observar el funcionamineto y estrcutura de otros compiladores. pero Pienso que se podrían hacer algunos ejemplos en clase para tener una idea de que es lo que debemos hacer.


