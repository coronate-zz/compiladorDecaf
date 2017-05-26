/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 26 "parser.y" /* yacc.c:339  */


/* Just like lex, the text within this first region delimited by %{ and %}
 * is assumed to be C/C++ code and will be copied verbatim to the y.tab.c
 * file ahead of the definitions of the yyparse() function. Add other header
 * file inclusions or C++ variable declarations/prototypes that are needed
 * by your code here.
 */
#include "scanner.h" // for yylex
#include "parser.h"
#include "errors.h"

void yyerror(const char *msg); // standard error-handling routine


#line 82 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_Void = 258,
    T_Bool = 259,
    T_Int = 260,
    T_Double = 261,
    T_String = 262,
    T_Class = 263,
    T_LessEqual = 264,
    T_GreaterEqual = 265,
    T_Equal = 266,
    T_NotEqual = 267,
    T_Dims = 268,
    T_And = 269,
    T_Or = 270,
    T_Null = 271,
    T_Extends = 272,
    T_This = 273,
    T_Interface = 274,
    T_Implements = 275,
    T_While = 276,
    T_For = 277,
    T_If = 278,
    T_Else = 279,
    T_Return = 280,
    T_Break = 281,
    T_New = 282,
    T_NewArray = 283,
    T_Print = 284,
    T_ReadInteger = 285,
    T_ReadLine = 286,
    T_Incr = 287,
    T_Decr = 288,
    T_Switch = 289,
    T_Case = 290,
    T_Default = 291,
    T_Identifier = 292,
    T_StringConstant = 293,
    T_IntConstant = 294,
    T_DoubleConstant = 295,
    T_BoolConstant = 296,
    NOT = 297,
    NEG = 298,
    T_NONELSE = 299
  };
#endif
/* Tokens.  */
#define T_Void 258
#define T_Bool 259
#define T_Int 260
#define T_Double 261
#define T_String 262
#define T_Class 263
#define T_LessEqual 264
#define T_GreaterEqual 265
#define T_Equal 266
#define T_NotEqual 267
#define T_Dims 268
#define T_And 269
#define T_Or 270
#define T_Null 271
#define T_Extends 272
#define T_This 273
#define T_Interface 274
#define T_Implements 275
#define T_While 276
#define T_For 277
#define T_If 278
#define T_Else 279
#define T_Return 280
#define T_Break 281
#define T_New 282
#define T_NewArray 283
#define T_Print 284
#define T_ReadInteger 285
#define T_ReadLine 286
#define T_Incr 287
#define T_Decr 288
#define T_Switch 289
#define T_Case 290
#define T_Default 291
#define T_Identifier 292
#define T_StringConstant 293
#define T_IntConstant 294
#define T_DoubleConstant 295
#define T_BoolConstant 296
#define NOT 297
#define NEG 298
#define T_NONELSE 299

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 56 "parser.y" /* yacc.c:355  */

    int integerConstant;
    bool boolConstant;
    char *stringConstant;
    double doubleConstant;
    char identifier[MaxIdentLen+1]; // +1 for terminating null

    Program *program;

    Decl *decl;
    List<Decl*> *declList;
    VarDecl *var;
    List<VarDecl*> *varList;
    FnDecl *fDecl;
    ClassDecl *cDecl;
    InterfaceDecl *iDecl;

    Type *type;
    NamedType *namedType;
    List<NamedType*> *namedTypeList;

    Stmt *stmt;
    List<Stmt*> *stmtList;
    StmtBlock *stmtBlock;
    ForStmt *forStmt;
    WhileStmt *whileStmt;
    IfStmt *ifStmt;
    SwitchStmt *switchStmt;
    CaseStmt *caseStmt;
    List<CaseStmt*> *caseStmtList;
    BreakStmt *breakStmt;
    ReturnStmt *returnStmt;
    PrintStmt *printStmt;

    Expr *expr;
    List<Expr*> *exprList;
    Call *call;
    LValue *lValue;

#line 250 "y.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 281 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
             && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  22
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   685

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  64
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  41
/* YYNRULES -- Number of rules.  */
#define YYNRULES  115
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  222

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   299

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    62,     2,     2,     2,    49,     2,     2,
      56,    57,    47,    45,    58,    46,    53,    48,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    61,    55,
      43,    42,    44,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    52,     2,    63,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    59,     2,    60,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    50,    51,    54
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   180,   180,   198,   199,   202,   203,   204,   205,   208,
     209,   212,   215,   220,   221,   222,   223,   224,   227,   230,
     233,   237,   243,   244,   247,   249,   252,   259,   263,   266,
     268,   271,   275,   281,   282,   285,   286,   290,   297,   299,
     302,   306,   312,   314,   318,   319,   322,   323,   324,   325,
     326,   327,   328,   329,   330,   333,   335,   339,   343,   347,
     353,   354,   357,   361,   369,   371,   374,   377,   378,   382,
     385,   389,   390,   393,   394,   397,   400,   401,   402,   405,
     408,   409,   410,   411,   414,   417,   420,   423,   426,   429,
     432,   436,   439,   443,   446,   449,   452,   455,   458,   460,
     461,   465,   471,   474,   478,   481,   487,   491,   495,   501,
     502,   505,   506,   507,   508,   509
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "T_Void", "T_Bool", "T_Int", "T_Double",
  "T_String", "T_Class", "T_LessEqual", "T_GreaterEqual", "T_Equal",
  "T_NotEqual", "T_Dims", "T_And", "T_Or", "T_Null", "T_Extends", "T_This",
  "T_Interface", "T_Implements", "T_While", "T_For", "T_If", "T_Else",
  "T_Return", "T_Break", "T_New", "T_NewArray", "T_Print", "T_ReadInteger",
  "T_ReadLine", "T_Incr", "T_Decr", "T_Switch", "T_Case", "T_Default",
  "T_Identifier", "T_StringConstant", "T_IntConstant", "T_DoubleConstant",
  "T_BoolConstant", "'='", "'<'", "'>'", "'+'", "'-'", "'*'", "'/'", "'%'",
  "NOT", "NEG", "'['", "'.'", "T_NONELSE", "';'", "'('", "')'", "','",
  "'{'", "'}'", "':'", "'!'", "']'", "$accept", "Program", "DeclList",
  "Decl", "VarDecls", "VarDecl", "Variable", "Type", "FnDecl", "FnHeader",
  "Formals", "FormalList", "ClassDecl", "ClassExt", "ClassImpl",
  "ImplList", "FieldList", "Field", "InterfaceDecl", "PrototypeList",
  "Prototype", "StmtBlock", "StmtList", "Stmt", "IfStmt", "WhileStmt",
  "ForStmt", "SwitchStmt", "CaseStmts", "CaseStmt", "DefaultStmt",
  "ReturnStmt", "BreakStmt", "PrintStmt", "ExprOpt", "ExprPlus", "Expr",
  "LValue", "Call", "Actuals", "Constant", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,    61,    60,    62,    43,    45,    42,    47,    37,
     297,   298,    91,    46,   299,    59,    40,    41,    44,   123,
     125,    58,    33,    93
};
# endif

#define YYPACT_NINF -180

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-180)))

#define YYTABLE_NINF -73

#define yytable_value_is_error(Yytable_value) \
  (!!((Yytable_value) == (-73)))

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      48,   -19,  -180,  -180,  -180,  -180,   -17,   -15,  -180,    28,
      48,  -180,  -180,   -11,    -2,  -180,   -12,  -180,  -180,    -7,
      84,    43,  -180,  -180,  -180,  -180,    49,  -180,  -180,    66,
      69,    87,  -180,    66,   156,  -180,     4,    55,    56,  -180,
      76,    63,     9,    70,  -180,  -180,    73,    74,    75,   471,
      71,    77,    80,    81,    82,    83,    85,    -6,  -180,  -180,
    -180,  -180,   558,    91,   558,  -180,   558,  -180,  -180,   357,
    -180,  -180,  -180,  -180,  -180,  -180,  -180,  -180,    88,   591,
      -3,  -180,  -180,  -180,  -180,    66,  -180,    92,  -180,    95,
    -180,     6,  -180,  -180,   558,   558,   558,    86,  -180,   504,
    -180,   103,   558,   558,    94,    98,   558,   558,   -20,   100,
     234,   -20,  -180,  -180,  -180,   558,   558,   558,   558,   558,
     558,   558,   558,   558,   558,   558,   558,   558,   558,   120,
    -180,  -180,   558,  -180,   121,    20,   108,   109,   255,   111,
     304,  -180,   110,   210,     5,   591,  -180,  -180,   319,   112,
     114,   558,  -180,   632,   632,   606,   606,   617,    72,   632,
     632,    12,    12,   -20,   -20,   -20,   189,   113,   591,  -180,
    -180,  -180,  -180,  -180,    66,    66,   444,   558,   444,  -180,
      66,   118,   558,   116,  -180,   119,  -180,   558,   131,   132,
    -180,   520,   144,    -9,  -180,   591,  -180,  -180,   134,   137,
     150,   558,   444,  -180,    41,  -180,  -180,  -180,   149,  -180,
     168,   147,  -180,   151,   444,   152,   402,  -180,  -180,   402,
     402,   402
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,    14,    13,    16,    15,     0,     0,    17,     0,
       2,     4,     5,     0,     0,     6,     0,     7,     8,     0,
      28,     0,     1,     3,    11,    18,    12,    10,    19,    23,
       0,    30,    39,    23,    72,    25,     0,     0,    22,    27,
       0,     0,     0,     0,   115,    80,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   102,   114,   111,
     112,   113,     0,     0,     0,    43,     0,     9,    54,    72,
      45,    47,    48,    49,    51,    52,    50,    53,     0,    71,
      77,    81,    76,    12,    21,     0,    32,    29,    34,     0,
      37,     0,    38,    20,     0,    72,     0,   102,    68,     0,
      69,     0,     0,     0,     0,     0,     0,   110,    88,   104,
       0,    97,    42,    44,    46,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      78,    79,     0,    24,     0,     0,     0,     0,     0,     0,
       0,    67,     0,     0,     0,    74,    98,    99,     0,   109,
       0,   110,    82,    90,    92,    93,    94,    95,    96,    89,
      91,    83,    84,    85,    86,    87,     0,   103,    75,    31,
      26,    35,    36,    33,    23,    23,    72,     0,    72,   100,
       0,     0,     0,     0,   106,     0,   105,   110,     0,     0,
      57,     0,    55,     0,    70,    73,    61,   108,     0,     0,
       0,    72,    72,   101,    66,   107,    41,    40,     0,    56,
       0,     0,    60,     0,    72,     0,    65,    59,    58,    63,
      64,    62
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -180,  -180,  -180,   200,  -180,   -26,   -27,     0,    79,  -180,
     -30,  -180,  -180,  -180,  -180,  -180,  -180,  -180,  -180,  -180,
    -180,   201,  -179,   -68,  -180,  -180,  -180,  -180,  -180,  -180,
    -180,  -180,  -180,  -180,   -90,   123,   -28,  -180,  -180,  -142,
    -180
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     9,    10,    11,    34,    12,    13,    36,    15,    16,
      37,    38,    17,    31,    41,    87,   135,   173,    18,    42,
      92,    68,    69,    70,    71,    72,    73,    74,   204,   212,
     213,    75,    76,    77,    78,   149,    79,    80,    81,   150,
      82
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      14,   113,    35,    43,    25,   139,    35,   -17,    67,   185,
      14,    25,    89,     2,     3,     4,     5,    25,    19,    25,
      20,    99,    21,     1,     2,     3,     4,     5,    22,   130,
     131,   -17,   128,   129,   108,    26,   110,   220,   111,   132,
     221,    83,    91,   137,    24,   198,     8,    27,   203,    29,
     107,     1,     2,     3,     4,     5,     6,     8,   133,   125,
     126,   127,   181,   182,   128,   129,   138,     7,   140,    90,
       2,     3,     4,     5,   143,   145,   210,   211,   148,   145,
     170,   115,   116,   117,   118,     8,   119,   153,   154,   155,
     156,   157,   158,   159,   160,   161,   162,   163,   164,   165,
     166,    30,    32,     8,   168,    33,    39,    40,   190,   171,
     192,   208,    84,    86,    85,   121,   122,   123,   124,   125,
     126,   127,    88,   145,   128,   129,   100,    93,   109,    94,
      95,    96,   136,   101,   209,    14,   102,   103,   104,   105,
     142,   106,   107,   114,   188,   189,   218,    35,    35,   191,
     134,   146,   113,   113,   195,   147,   151,   167,   169,   145,
       2,     3,     4,     5,   174,   175,   177,   179,   202,   187,
     182,   184,    44,   194,    45,   196,   197,    46,    47,    48,
     193,    49,    50,    51,    52,    53,    54,    55,   199,   200,
      56,   205,   206,    57,    58,    59,    60,    61,   115,   116,
     117,   118,    62,   119,   120,   207,   214,   215,   216,    63,
      23,   217,    64,   219,   172,    27,    65,    28,    66,   115,
     116,   117,   118,     0,   119,   120,   144,     0,     0,     0,
       0,     0,   121,   122,   123,   124,   125,   126,   127,     0,
       0,   128,   129,   115,   116,   117,   118,     0,   119,   120,
       0,     0,   186,   121,   122,   123,   124,   125,   126,   127,
       0,     0,   128,   129,   115,   116,   117,   118,   180,   119,
     120,     0,     0,     0,     0,     0,     0,   121,   122,   123,
     124,   125,   126,   127,     0,     0,   128,   129,     0,     0,
       0,   152,     0,     0,     0,     0,     0,     0,   121,   122,
     123,   124,   125,   126,   127,     0,     0,   128,   129,     0,
       0,     0,   176,   115,   116,   117,   118,     0,   119,   120,
       0,     0,     0,     0,     0,     0,     0,     0,   115,   116,
     117,   118,     0,   119,   120,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   121,   122,   123,
     124,   125,   126,   127,     0,     0,   128,   129,     0,     0,
       0,   178,   121,   122,   123,   124,   125,   126,   127,     0,
       0,   128,   129,    44,     0,    45,   183,     0,    46,    47,
      48,     0,    49,    50,    51,    52,    53,    54,    55,     0,
       0,    56,     0,     0,    97,    58,    59,    60,    61,     0,
       0,     0,     0,    62,     0,     0,     0,     0,     0,     0,
      63,     0,     0,    64,     0,     0,    27,   112,    44,    66,
      45,     0,     0,    46,    47,    48,     0,    49,    50,    51,
      52,    53,    54,    55,     0,     0,    56,     0,     0,    97,
      58,    59,    60,    61,     0,     0,     0,     0,    62,     0,
       0,     0,     0,     0,     0,    63,     0,   -72,    64,     0,
      44,    27,    45,     0,    66,    46,    47,    48,     0,    49,
      50,    51,    52,    53,    54,    55,     0,     0,    56,     0,
       0,    97,    58,    59,    60,    61,     0,    44,     0,    45,
      62,     0,     0,     0,     0,     0,     0,    63,    51,    52,
      64,    54,    55,    27,     0,     0,    66,     0,    97,    58,
      59,    60,    61,   115,   116,   117,   118,    62,   119,   120,
       0,     0,     0,     0,    63,     0,    98,    64,     0,   115,
     116,   117,   118,    66,   119,   120,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   121,   122,   123,
     124,   125,   126,   127,     0,     0,   128,   129,     0,   141,
       0,     0,     0,   121,   122,   123,   124,   125,   126,   127,
       0,     0,   128,   129,    44,   201,    45,     0,     0,     0,
       0,     0,     0,     0,     0,    51,    52,     0,    54,    55,
       0,     0,     0,     0,     0,    97,    58,    59,    60,    61,
     115,   116,   117,   118,    62,   119,   120,     0,     0,     0,
       0,    63,     0,     0,    64,   115,   116,   -73,   -73,     0,
      66,     0,     0,     0,     0,     0,   115,   116,   117,   118,
       0,     0,     0,     0,   121,   122,   123,   124,   125,   126,
     127,   -73,   -73,   128,   129,     0,     0,     0,     0,   121,
     122,   123,   124,   125,   126,   127,     0,     0,   128,   129,
     121,   122,   123,   124,   125,   126,   127,     0,     0,   128,
     129,     0,     0,     0,     0,   -73,   -73,   123,   124,   125,
     126,   127,     0,     0,   128,   129
};

static const yytype_int16 yycheck[] =
{
       0,    69,    29,    33,    13,    95,    33,    13,    34,   151,
      10,    13,     3,     4,     5,     6,     7,    13,    37,    13,
      37,    49,    37,     3,     4,     5,     6,     7,     0,    32,
      33,    37,    52,    53,    62,    37,    64,   216,    66,    42,
     219,    37,    42,    37,    55,   187,    37,    59,    57,    56,
      56,     3,     4,     5,     6,     7,     8,    37,    85,    47,
      48,    49,    57,    58,    52,    53,    94,    19,    96,    60,
       4,     5,     6,     7,   102,   103,    35,    36,   106,   107,
      60,     9,    10,    11,    12,    37,    14,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
     128,    17,    59,    37,   132,    56,    37,    20,   176,   135,
     178,   201,    57,    37,    58,    43,    44,    45,    46,    47,
      48,    49,    59,   151,    52,    53,    55,    57,    37,    56,
      56,    56,    37,    56,   202,   135,    56,    56,    56,    56,
      37,    56,    56,    55,   174,   175,   214,   174,   175,   177,
      58,    57,   220,   221,   182,    57,    56,    37,    37,   187,
       4,     5,     6,     7,    56,    56,    55,    57,    24,    56,
      58,    57,    16,    55,    18,    59,    57,    21,    22,    23,
     180,    25,    26,    27,    28,    29,    30,    31,    57,    57,
      34,    57,    55,    37,    38,    39,    40,    41,     9,    10,
      11,    12,    46,    14,    15,    55,    57,    39,    61,    53,
      10,    60,    56,    61,   135,    59,    60,    16,    62,     9,
      10,    11,    12,    -1,    14,    15,   103,    -1,    -1,    -1,
      -1,    -1,    43,    44,    45,    46,    47,    48,    49,    -1,
      -1,    52,    53,     9,    10,    11,    12,    -1,    14,    15,
      -1,    -1,    63,    43,    44,    45,    46,    47,    48,    49,
      -1,    -1,    52,    53,     9,    10,    11,    12,    58,    14,
      15,    -1,    -1,    -1,    -1,    -1,    -1,    43,    44,    45,
      46,    47,    48,    49,    -1,    -1,    52,    53,    -1,    -1,
      -1,    57,    -1,    -1,    -1,    -1,    -1,    -1,    43,    44,
      45,    46,    47,    48,    49,    -1,    -1,    52,    53,    -1,
      -1,    -1,    57,     9,    10,    11,    12,    -1,    14,    15,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     9,    10,
      11,    12,    -1,    14,    15,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    43,    44,    45,
      46,    47,    48,    49,    -1,    -1,    52,    53,    -1,    -1,
      -1,    57,    43,    44,    45,    46,    47,    48,    49,    -1,
      -1,    52,    53,    16,    -1,    18,    57,    -1,    21,    22,
      23,    -1,    25,    26,    27,    28,    29,    30,    31,    -1,
      -1,    34,    -1,    -1,    37,    38,    39,    40,    41,    -1,
      -1,    -1,    -1,    46,    -1,    -1,    -1,    -1,    -1,    -1,
      53,    -1,    -1,    56,    -1,    -1,    59,    60,    16,    62,
      18,    -1,    -1,    21,    22,    23,    -1,    25,    26,    27,
      28,    29,    30,    31,    -1,    -1,    34,    -1,    -1,    37,
      38,    39,    40,    41,    -1,    -1,    -1,    -1,    46,    -1,
      -1,    -1,    -1,    -1,    -1,    53,    -1,    55,    56,    -1,
      16,    59,    18,    -1,    62,    21,    22,    23,    -1,    25,
      26,    27,    28,    29,    30,    31,    -1,    -1,    34,    -1,
      -1,    37,    38,    39,    40,    41,    -1,    16,    -1,    18,
      46,    -1,    -1,    -1,    -1,    -1,    -1,    53,    27,    28,
      56,    30,    31,    59,    -1,    -1,    62,    -1,    37,    38,
      39,    40,    41,     9,    10,    11,    12,    46,    14,    15,
      -1,    -1,    -1,    -1,    53,    -1,    55,    56,    -1,     9,
      10,    11,    12,    62,    14,    15,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    43,    44,    45,
      46,    47,    48,    49,    -1,    -1,    52,    53,    -1,    55,
      -1,    -1,    -1,    43,    44,    45,    46,    47,    48,    49,
      -1,    -1,    52,    53,    16,    55,    18,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    27,    28,    -1,    30,    31,
      -1,    -1,    -1,    -1,    -1,    37,    38,    39,    40,    41,
       9,    10,    11,    12,    46,    14,    15,    -1,    -1,    -1,
      -1,    53,    -1,    -1,    56,     9,    10,    11,    12,    -1,
      62,    -1,    -1,    -1,    -1,    -1,     9,    10,    11,    12,
      -1,    -1,    -1,    -1,    43,    44,    45,    46,    47,    48,
      49,     9,    10,    52,    53,    -1,    -1,    -1,    -1,    43,
      44,    45,    46,    47,    48,    49,    -1,    -1,    52,    53,
      43,    44,    45,    46,    47,    48,    49,    -1,    -1,    52,
      53,    -1,    -1,    -1,    -1,    43,    44,    45,    46,    47,
      48,    49,    -1,    -1,    52,    53
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,    19,    37,    65,
      66,    67,    69,    70,    71,    72,    73,    76,    82,    37,
      37,    37,     0,    67,    55,    13,    37,    59,    85,    56,
      17,    77,    59,    56,    68,    70,    71,    74,    75,    37,
      20,    78,    83,    74,    16,    18,    21,    22,    23,    25,
      26,    27,    28,    29,    30,    31,    34,    37,    38,    39,
      40,    41,    46,    53,    56,    60,    62,    69,    85,    86,
      87,    88,    89,    90,    91,    95,    96,    97,    98,   100,
     101,   102,   104,    37,    57,    58,    37,    79,    59,     3,
      60,    71,    84,    57,    56,    56,    56,    37,    55,   100,
      55,    56,    56,    56,    56,    56,    56,    56,   100,    37,
     100,   100,    60,    87,    55,     9,    10,    11,    12,    14,
      15,    43,    44,    45,    46,    47,    48,    49,    52,    53,
      32,    33,    42,    70,    58,    80,    37,    37,   100,    98,
     100,    55,    37,   100,    99,   100,    57,    57,   100,    99,
     103,    56,    57,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,    37,   100,    37,
      60,    69,    72,    81,    56,    56,    57,    55,    57,    57,
      58,    57,    58,    57,    57,   103,    63,    56,    74,    74,
      87,   100,    87,    71,    55,   100,    59,    57,   103,    57,
      57,    55,    24,    57,    92,    57,    55,    55,    98,    87,
      35,    36,    93,    94,    57,    39,    61,    60,    87,    61,
      86,    86
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    64,    65,    66,    66,    67,    67,    67,    67,    68,
      68,    69,    70,    71,    71,    71,    71,    71,    71,    72,
      73,    73,    74,    74,    75,    75,    76,    77,    77,    78,
      78,    79,    79,    80,    80,    81,    81,    82,    83,    83,
      84,    84,    85,    85,    86,    86,    87,    87,    87,    87,
      87,    87,    87,    87,    87,    88,    88,    89,    90,    91,
      92,    92,    93,    93,    94,    94,    94,    95,    95,    96,
      97,    98,    98,    99,    99,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   101,   101,   101,   101,   102,   102,   102,   103,
     103,   104,   104,   104,   104,   104
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     1,     1,     1,     2,
       0,     2,     2,     1,     1,     1,     1,     1,     2,     2,
       5,     5,     1,     0,     3,     1,     7,     2,     0,     2,
       0,     3,     1,     2,     0,     1,     1,     5,     2,     0,
       6,     6,     4,     3,     2,     1,     2,     1,     1,     1,
       1,     1,     1,     1,     1,     5,     7,     5,     9,     8,
       2,     0,     4,     3,     3,     2,     0,     3,     2,     2,
       5,     1,     0,     3,     1,     3,     1,     1,     2,     2,
       1,     1,     3,     3,     3,     3,     3,     3,     2,     3,
       3,     3,     3,     3,     3,     3,     3,     2,     3,     3,
       4,     6,     1,     3,     2,     4,     4,     6,     5,     1,
       0,     1,     1,     1,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
        }                                                               \
    while (0)
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K])


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL

/* Print *YYLOCP on YYO.  Private, do not rely on its existence. */

YY_ATTRIBUTE_UNUSED
static unsigned
yy_location_print_ (FILE *yyo, YYLTYPE const * const yylocp)
{
  unsigned res = 0;
  int end_col = 0 != yylocp->last_column ? yylocp->last_column - 1 : 0;
  if (0 <= yylocp->first_line)
    {
      res += YYFPRINTF (yyo, "%d", yylocp->first_line);
      if (0 <= yylocp->first_column)
        res += YYFPRINTF (yyo, ".%d", yylocp->first_column);
    }
  if (0 <= yylocp->last_line)
    {
      if (yylocp->first_line < yylocp->last_line)
        {
          res += YYFPRINTF (yyo, "-%d", yylocp->last_line);
          if (0 <= end_col)
            res += YYFPRINTF (yyo, ".%d", end_col);
        }
      else if (0 <= end_col && yylocp->first_column < end_col)
        res += YYFPRINTF (yyo, "-%d", end_col);
    }
  return res;
 }

#  define YY_LOCATION_PRINT(File, Loc)          \
  yy_location_print_ (File, &(Loc))

# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  YYUSE (yylocationp);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                       , &(yylsp[(yyi + 1) - (yynrhs)])                       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Location data for the lookahead symbol.  */
YYLTYPE yylloc
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.
       'yyls': related to locations.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[3];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yylsp = yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  yylsp[0] = yylloc;
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;
        YYLTYPE *yyls1 = yyls;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yyls1, yysize * sizeof (*yylsp),
                    &yystacksize);

        yyls = yyls1;
        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
        YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location.  */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 180 "parser.y" /* yacc.c:1646  */
    {
                                      (yylsp[0]);
                                      /* pp2: The @1 is needed to convince
                                       * yacc to set up yylloc. You can remove
                                       * it once you have other uses of @n */
                                      Program *program = new Program((yyvsp[0].declList));
                                      // if no errors, advance to next phase
                                      if (ReportError::NumErrors() == 0)
                                          program->Check();


                                      if (ReportError::NumErrors() == 0)
                                          program->Emit();


                                    }
#line 1724 "y.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 198 "parser.y" /* yacc.c:1646  */
    { ((yyval.declList)=(yyvsp[-1].declList))->Append((yyvsp[0].decl)); }
#line 1730 "y.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 199 "parser.y" /* yacc.c:1646  */
    { ((yyval.declList) = new List<Decl*>)->Append((yyvsp[0].decl)); }
#line 1736 "y.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 202 "parser.y" /* yacc.c:1646  */
    { (yyval.decl)=(yyvsp[0].var); }
#line 1742 "y.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 203 "parser.y" /* yacc.c:1646  */
    { (yyval.decl)=(yyvsp[0].fDecl); }
#line 1748 "y.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 204 "parser.y" /* yacc.c:1646  */
    { (yyval.decl)=(yyvsp[0].cDecl); }
#line 1754 "y.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 205 "parser.y" /* yacc.c:1646  */
    { (yyval.decl)=(yyvsp[0].iDecl); }
#line 1760 "y.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 208 "parser.y" /* yacc.c:1646  */
    { ((yyval.varList)=(yyvsp[-1].varList))->Append((yyvsp[0].var)); }
#line 1766 "y.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 209 "parser.y" /* yacc.c:1646  */
    { (yyval.varList) = new List<VarDecl*>; }
#line 1772 "y.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 212 "parser.y" /* yacc.c:1646  */
    { (yyval.var)=(yyvsp[-1].var); }
#line 1778 "y.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 215 "parser.y" /* yacc.c:1646  */
    { (yyval.var) = new VarDecl(new Identifier((yylsp[0]), (yyvsp[0].identifier)),
                                           (yyvsp[-1].type));
                                    }
#line 1786 "y.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 220 "parser.y" /* yacc.c:1646  */
    { (yyval.type) = Type::intType; }
#line 1792 "y.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 221 "parser.y" /* yacc.c:1646  */
    { (yyval.type) = Type::boolType; }
#line 1798 "y.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 222 "parser.y" /* yacc.c:1646  */
    { (yyval.type) = Type::stringType; }
#line 1804 "y.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 223 "parser.y" /* yacc.c:1646  */
    { (yyval.type) = Type::doubleType; }
#line 1810 "y.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 224 "parser.y" /* yacc.c:1646  */
    { (yyval.type) = new NamedType(
                                           new Identifier((yylsp[0]),(yyvsp[0].identifier)));
                                    }
#line 1818 "y.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 227 "parser.y" /* yacc.c:1646  */
    { (yyval.type) = new ArrayType(Join((yylsp[-1]), (yylsp[0])), (yyvsp[-1].type)); }
#line 1824 "y.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 230 "parser.y" /* yacc.c:1646  */
    { ((yyval.fDecl)=(yyvsp[-1].fDecl))->SetFunctionBody((yyvsp[0].stmtBlock)); }
#line 1830 "y.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 234 "parser.y" /* yacc.c:1646  */
    { (yyval.fDecl) = new FnDecl(new Identifier((yylsp[-3]), (yyvsp[-3].identifier)),
                                           (yyvsp[-4].type), (yyvsp[-1].varList));
                                    }
#line 1838 "y.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 238 "parser.y" /* yacc.c:1646  */
    { (yyval.fDecl) = new FnDecl(new Identifier((yylsp[-3]), (yyvsp[-3].identifier)),
                                           Type::voidType, (yyvsp[-1].varList));
                                    }
#line 1846 "y.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 243 "parser.y" /* yacc.c:1646  */
    { (yyval.varList) = (yyvsp[0].varList); }
#line 1852 "y.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 244 "parser.y" /* yacc.c:1646  */
    { (yyval.varList) = new List<VarDecl*>; }
#line 1858 "y.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 248 "parser.y" /* yacc.c:1646  */
    { ((yyval.varList)=(yyvsp[-2].varList))->Append((yyvsp[0].var)); }
#line 1864 "y.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 249 "parser.y" /* yacc.c:1646  */
    { ((yyval.varList) = new List<VarDecl*>)->Append((yyvsp[0].var)); }
#line 1870 "y.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 253 "parser.y" /* yacc.c:1646  */
    { (yyval.cDecl) = new ClassDecl(
                                           (new Identifier((yylsp[-5]), (yyvsp[-5].identifier))),
                                           (yyvsp[-4].namedType), (yyvsp[-3].namedTypeList), (yyvsp[-1].declList));
                                    }
#line 1879 "y.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 260 "parser.y" /* yacc.c:1646  */
    { (yyval.namedType) = new NamedType(
                                           new Identifier((yylsp[0]), (yyvsp[0].identifier)));
                                    }
#line 1887 "y.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 263 "parser.y" /* yacc.c:1646  */
    { (yyval.namedType) = NULL; }
#line 1893 "y.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 267 "parser.y" /* yacc.c:1646  */
    { (yyval.namedTypeList) = (yyvsp[0].namedTypeList); }
#line 1899 "y.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 268 "parser.y" /* yacc.c:1646  */
    { (yyval.namedTypeList) = new List<NamedType*>; }
#line 1905 "y.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 272 "parser.y" /* yacc.c:1646  */
    { ((yyval.namedTypeList) = (yyvsp[-2].namedTypeList))->Append(new NamedType(
                                                 new Identifier((yylsp[0]), (yyvsp[0].identifier))));
                                    }
#line 1913 "y.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 275 "parser.y" /* yacc.c:1646  */
    { ((yyval.namedTypeList) = new List<NamedType*>)->Append(
                                                 new NamedType(
                                                 new Identifier((yylsp[0]), (yyvsp[0].identifier))));
                                    }
#line 1922 "y.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 281 "parser.y" /* yacc.c:1646  */
    { ((yyval.declList) = (yyvsp[-1].declList))->Append((yyvsp[0].decl)); }
#line 1928 "y.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 282 "parser.y" /* yacc.c:1646  */
    { (yyval.declList) = new List<Decl*>; }
#line 1934 "y.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 285 "parser.y" /* yacc.c:1646  */
    { (yyval.decl) = (yyvsp[0].var); }
#line 1940 "y.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 286 "parser.y" /* yacc.c:1646  */
    { (yyval.decl) = (yyvsp[0].fDecl); }
#line 1946 "y.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 291 "parser.y" /* yacc.c:1646  */
    { (yyval.iDecl) = new InterfaceDecl(
                                           (new Identifier((yylsp[-3]), (yyvsp[-3].identifier))), (yyvsp[-1].declList));
                                    }
#line 1954 "y.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 298 "parser.y" /* yacc.c:1646  */
    { ((yyval.declList) = (yyvsp[-1].declList))->Append((yyvsp[0].fDecl)); }
#line 1960 "y.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 299 "parser.y" /* yacc.c:1646  */
    { (yyval.declList) = new List<Decl*>; }
#line 1966 "y.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 303 "parser.y" /* yacc.c:1646  */
    { (yyval.fDecl) = new FnDecl((new Identifier((yylsp[-4]), (yyvsp[-4].identifier))),
                                           (yyvsp[-5].type), (yyvsp[-2].varList));
                                    }
#line 1974 "y.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 307 "parser.y" /* yacc.c:1646  */
    { (yyval.fDecl) = new FnDecl((new Identifier((yylsp[-4]), (yyvsp[-4].identifier))),
                                           Type::voidType, (yyvsp[-2].varList));
                                    }
#line 1982 "y.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 313 "parser.y" /* yacc.c:1646  */
    { (yyval.stmtBlock) = new StmtBlock((yyvsp[-2].varList), (yyvsp[-1].stmtList)); }
#line 1988 "y.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 314 "parser.y" /* yacc.c:1646  */
    { (yyval.stmtBlock) = new StmtBlock((yyvsp[-1].varList), new List<Stmt *>);
                                    }
#line 1995 "y.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 318 "parser.y" /* yacc.c:1646  */
    { ((yyval.stmtList) = (yyvsp[-1].stmtList))->Append((yyvsp[0].stmt)); }
#line 2001 "y.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 319 "parser.y" /* yacc.c:1646  */
    { ((yyval.stmtList) = new List<Stmt*>)->Append((yyvsp[0].stmt)); }
#line 2007 "y.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 322 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[-1].expr); }
#line 2013 "y.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 323 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[0].ifStmt); }
#line 2019 "y.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 324 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[0].whileStmt); }
#line 2025 "y.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 325 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[0].forStmt); }
#line 2031 "y.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 326 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[0].breakStmt); }
#line 2037 "y.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 327 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[0].switchStmt); }
#line 2043 "y.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 328 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[0].returnStmt); }
#line 2049 "y.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 329 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[0].printStmt); }
#line 2055 "y.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 330 "parser.y" /* yacc.c:1646  */
    { (yyval.stmt) = (yyvsp[0].stmtBlock); }
#line 2061 "y.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 334 "parser.y" /* yacc.c:1646  */
    { (yyval.ifStmt) = new IfStmt((yyvsp[-2].expr), (yyvsp[0].stmt), NULL); }
#line 2067 "y.tab.c" /* yacc.c:1646  */
    break;

  case 56:
#line 336 "parser.y" /* yacc.c:1646  */
    { (yyval.ifStmt) = new IfStmt((yyvsp[-4].expr), (yyvsp[-2].stmt), (yyvsp[0].stmt)); }
#line 2073 "y.tab.c" /* yacc.c:1646  */
    break;

  case 57:
#line 340 "parser.y" /* yacc.c:1646  */
    { (yyval.whileStmt) = new WhileStmt((yyvsp[-2].expr), (yyvsp[0].stmt)); }
#line 2079 "y.tab.c" /* yacc.c:1646  */
    break;

  case 58:
#line 344 "parser.y" /* yacc.c:1646  */
    { (yyval.forStmt) = new ForStmt((yyvsp[-6].expr), (yyvsp[-4].expr), (yyvsp[-2].expr), (yyvsp[0].stmt)); }
#line 2085 "y.tab.c" /* yacc.c:1646  */
    break;

  case 59:
#line 348 "parser.y" /* yacc.c:1646  */
    { if ((yyvsp[-1].caseStmt)) (yyvsp[-2].caseStmtList)->Append((yyvsp[-1].caseStmt));
                                      (yyval.switchStmt) = new SwitchStmt((yyvsp[-5].expr), (yyvsp[-2].caseStmtList));
                                    }
#line 2093 "y.tab.c" /* yacc.c:1646  */
    break;

  case 60:
#line 353 "parser.y" /* yacc.c:1646  */
    { ((yyval.caseStmtList) = (yyvsp[-1].caseStmtList))->Append((yyvsp[0].caseStmt)); }
#line 2099 "y.tab.c" /* yacc.c:1646  */
    break;

  case 61:
#line 354 "parser.y" /* yacc.c:1646  */
    { (yyval.caseStmtList) = new List<CaseStmt*>; }
#line 2105 "y.tab.c" /* yacc.c:1646  */
    break;

  case 62:
#line 358 "parser.y" /* yacc.c:1646  */
    { (yyval.caseStmt) = new CaseStmt(
                                           (new IntConstant((yylsp[-2]), (yyvsp[-2].integerConstant))), (yyvsp[0].stmtList));
                                    }
#line 2113 "y.tab.c" /* yacc.c:1646  */
    break;

  case 63:
#line 362 "parser.y" /* yacc.c:1646  */
    { (yyval.caseStmt) = new CaseStmt(
                                           (new IntConstant((yylsp[-1]), (yyvsp[-1].integerConstant))),
                                           (new List<Stmt*>));
                                    }
#line 2122 "y.tab.c" /* yacc.c:1646  */
    break;

  case 64:
#line 370 "parser.y" /* yacc.c:1646  */
    { (yyval.caseStmt) = new CaseStmt(NULL, (yyvsp[0].stmtList)); }
#line 2128 "y.tab.c" /* yacc.c:1646  */
    break;

  case 65:
#line 371 "parser.y" /* yacc.c:1646  */
    { (yyval.caseStmt) = new CaseStmt(NULL,
                                           new List<Stmt*>);
                                    }
#line 2136 "y.tab.c" /* yacc.c:1646  */
    break;

  case 66:
#line 374 "parser.y" /* yacc.c:1646  */
    { (yyval.caseStmt) = NULL; }
#line 2142 "y.tab.c" /* yacc.c:1646  */
    break;

  case 67:
#line 377 "parser.y" /* yacc.c:1646  */
    { (yyval.returnStmt) = new ReturnStmt((yylsp[-1]), (yyvsp[-1].expr)); }
#line 2148 "y.tab.c" /* yacc.c:1646  */
    break;

  case 68:
#line 378 "parser.y" /* yacc.c:1646  */
    { (yyval.returnStmt) = new ReturnStmt((yylsp[-1]), new EmptyExpr());
                                    }
#line 2155 "y.tab.c" /* yacc.c:1646  */
    break;

  case 69:
#line 382 "parser.y" /* yacc.c:1646  */
    { (yyval.breakStmt) = new BreakStmt((yylsp[-1])); }
#line 2161 "y.tab.c" /* yacc.c:1646  */
    break;

  case 70:
#line 386 "parser.y" /* yacc.c:1646  */
    { (yyval.printStmt) = new PrintStmt((yyvsp[-2].exprList)); }
#line 2167 "y.tab.c" /* yacc.c:1646  */
    break;

  case 71:
#line 389 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 2173 "y.tab.c" /* yacc.c:1646  */
    break;

  case 72:
#line 390 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new EmptyExpr(); }
#line 2179 "y.tab.c" /* yacc.c:1646  */
    break;

  case 73:
#line 393 "parser.y" /* yacc.c:1646  */
    { ((yyval.exprList) = (yyvsp[-2].exprList))->Append((yyvsp[0].expr)); }
#line 2185 "y.tab.c" /* yacc.c:1646  */
    break;

  case 74:
#line 394 "parser.y" /* yacc.c:1646  */
    { ((yyval.exprList) = new List<Expr*>)->Append((yyvsp[0].expr)); }
#line 2191 "y.tab.c" /* yacc.c:1646  */
    break;

  case 75:
#line 397 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new AssignExpr((yyvsp[-2].lValue),
                                           (new Operator((yylsp[-1]), "=")), (yyvsp[0].expr));
                                    }
#line 2199 "y.tab.c" /* yacc.c:1646  */
    break;

  case 76:
#line 400 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 2205 "y.tab.c" /* yacc.c:1646  */
    break;

  case 77:
#line 401 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = (yyvsp[0].lValue); }
#line 2211 "y.tab.c" /* yacc.c:1646  */
    break;

  case 78:
#line 402 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new PostfixExpr((yyvsp[-1].lValue),
                                           (new Operator((yylsp[0]), "++")));
                                    }
#line 2219 "y.tab.c" /* yacc.c:1646  */
    break;

  case 79:
#line 405 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new PostfixExpr((yyvsp[-1].lValue),
                                           (new Operator((yylsp[0]), "--")));
                                    }
#line 2227 "y.tab.c" /* yacc.c:1646  */
    break;

  case 80:
#line 408 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new This((yylsp[0])); }
#line 2233 "y.tab.c" /* yacc.c:1646  */
    break;

  case 81:
#line 409 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = (yyvsp[0].call); }
#line 2239 "y.tab.c" /* yacc.c:1646  */
    break;

  case 82:
#line 410 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = (yyvsp[-1].expr); }
#line 2245 "y.tab.c" /* yacc.c:1646  */
    break;

  case 83:
#line 411 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new ArithmeticExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "+")), (yyvsp[0].expr));
                                    }
#line 2253 "y.tab.c" /* yacc.c:1646  */
    break;

  case 84:
#line 414 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new ArithmeticExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "-")), (yyvsp[0].expr));
                                    }
#line 2261 "y.tab.c" /* yacc.c:1646  */
    break;

  case 85:
#line 417 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new ArithmeticExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "*")), (yyvsp[0].expr));
                                    }
#line 2269 "y.tab.c" /* yacc.c:1646  */
    break;

  case 86:
#line 420 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new ArithmeticExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "/")), (yyvsp[0].expr));
                                    }
#line 2277 "y.tab.c" /* yacc.c:1646  */
    break;

  case 87:
#line 423 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new ArithmeticExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "%")), (yyvsp[0].expr));
                                    }
#line 2285 "y.tab.c" /* yacc.c:1646  */
    break;

  case 88:
#line 426 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new ArithmeticExpr(
                                           (new Operator((yylsp[-1]), "-")), (yyvsp[0].expr));
                                    }
#line 2293 "y.tab.c" /* yacc.c:1646  */
    break;

  case 89:
#line 429 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new RelationalExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "<")), (yyvsp[0].expr));
                                    }
#line 2301 "y.tab.c" /* yacc.c:1646  */
    break;

  case 90:
#line 433 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new RelationalExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "<=")), (yyvsp[0].expr));
                                    }
#line 2309 "y.tab.c" /* yacc.c:1646  */
    break;

  case 91:
#line 436 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new RelationalExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), ">")), (yyvsp[0].expr));
                                    }
#line 2317 "y.tab.c" /* yacc.c:1646  */
    break;

  case 92:
#line 440 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new RelationalExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), ">=")), (yyvsp[0].expr));
                                    }
#line 2325 "y.tab.c" /* yacc.c:1646  */
    break;

  case 93:
#line 443 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new EqualityExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "==")), (yyvsp[0].expr));
                                    }
#line 2333 "y.tab.c" /* yacc.c:1646  */
    break;

  case 94:
#line 446 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new EqualityExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "!=")), (yyvsp[0].expr));
                                    }
#line 2341 "y.tab.c" /* yacc.c:1646  */
    break;

  case 95:
#line 449 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new LogicalExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "&&")), (yyvsp[0].expr));
                                    }
#line 2349 "y.tab.c" /* yacc.c:1646  */
    break;

  case 96:
#line 452 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new LogicalExpr((yyvsp[-2].expr),
                                           (new Operator((yylsp[-1]), "||")), (yyvsp[0].expr));
                                    }
#line 2357 "y.tab.c" /* yacc.c:1646  */
    break;

  case 97:
#line 455 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new LogicalExpr(
                                           (new Operator((yylsp[-1]), "!")), (yyvsp[0].expr));
                                    }
#line 2365 "y.tab.c" /* yacc.c:1646  */
    break;

  case 98:
#line 459 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new ReadIntegerExpr(Join((yylsp[-2]), (yylsp[0]))); }
#line 2371 "y.tab.c" /* yacc.c:1646  */
    break;

  case 99:
#line 460 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new ReadLineExpr(Join((yylsp[-2]), (yylsp[0]))); }
#line 2377 "y.tab.c" /* yacc.c:1646  */
    break;

  case 100:
#line 462 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new NewExpr(Join((yylsp[-3]), (yylsp[0])), (new
                                           NamedType(new Identifier((yylsp[-1]), (yyvsp[-1].identifier)))));
                                    }
#line 2385 "y.tab.c" /* yacc.c:1646  */
    break;

  case 101:
#line 466 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new NewArrayExpr(Join((yylsp[-5]), (yylsp[0])),
                                           (yyvsp[-3].expr), (yyvsp[-1].type));
                                    }
#line 2393 "y.tab.c" /* yacc.c:1646  */
    break;

  case 102:
#line 471 "parser.y" /* yacc.c:1646  */
    { (yyval.lValue) = new FieldAccess(NULL,
                                           (new Identifier((yylsp[0]), (yyvsp[0].identifier))));
                                    }
#line 2401 "y.tab.c" /* yacc.c:1646  */
    break;

  case 103:
#line 475 "parser.y" /* yacc.c:1646  */
    { (yyval.lValue) = new FieldAccess((yyvsp[-2].expr),
                                           (new Identifier((yylsp[0]), (yyvsp[0].identifier))));
                                    }
#line 2409 "y.tab.c" /* yacc.c:1646  */
    break;

  case 104:
#line 478 "parser.y" /* yacc.c:1646  */
    { (yyval.lValue) = new FieldAccess(NULL,
                                           (new Identifier((yylsp[0]), (yyvsp[0].identifier))));
                                    }
#line 2417 "y.tab.c" /* yacc.c:1646  */
    break;

  case 105:
#line 482 "parser.y" /* yacc.c:1646  */
    { (yyval.lValue) = new ArrayAccess(Join((yylsp[-3]), (yylsp[0])),
                                           (yyvsp[-3].expr), (yyvsp[-1].expr));
                                    }
#line 2425 "y.tab.c" /* yacc.c:1646  */
    break;

  case 106:
#line 488 "parser.y" /* yacc.c:1646  */
    { (yyval.call) = new Call(Join((yylsp[-3]), (yylsp[0])), NULL,
                                           (new Identifier((yylsp[-3]), (yyvsp[-3].identifier))), (yyvsp[-1].exprList));
                                    }
#line 2433 "y.tab.c" /* yacc.c:1646  */
    break;

  case 107:
#line 492 "parser.y" /* yacc.c:1646  */
    { (yyval.call) = new Call(Join((yylsp[-5]), (yylsp[0])), (yyvsp[-5].expr),
                                           (new Identifier((yylsp[-3]), (yyvsp[-3].identifier))), (yyvsp[-1].exprList));
                                    }
#line 2441 "y.tab.c" /* yacc.c:1646  */
    break;

  case 108:
#line 496 "parser.y" /* yacc.c:1646  */
    { (yyval.call) = new Call(Join((yylsp[-4]), (yylsp[0])), NULL,
                                           (new Identifier((yylsp[-3]), (yyvsp[-3].identifier))), (yyvsp[-1].exprList));
                                    }
#line 2449 "y.tab.c" /* yacc.c:1646  */
    break;

  case 109:
#line 501 "parser.y" /* yacc.c:1646  */
    { (yyval.exprList) = (yyvsp[0].exprList); }
#line 2455 "y.tab.c" /* yacc.c:1646  */
    break;

  case 110:
#line 502 "parser.y" /* yacc.c:1646  */
    { (yyval.exprList) = new List<Expr*>;}
#line 2461 "y.tab.c" /* yacc.c:1646  */
    break;

  case 111:
#line 505 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new IntConstant((yylsp[0]), (yyvsp[0].integerConstant)); }
#line 2467 "y.tab.c" /* yacc.c:1646  */
    break;

  case 112:
#line 506 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new DoubleConstant((yylsp[0]), (yyvsp[0].doubleConstant)); }
#line 2473 "y.tab.c" /* yacc.c:1646  */
    break;

  case 113:
#line 507 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new BoolConstant((yylsp[0]), (yyvsp[0].boolConstant)); }
#line 2479 "y.tab.c" /* yacc.c:1646  */
    break;

  case 114:
#line 508 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new StringConstant((yylsp[0]), (yyvsp[0].stringConstant)); }
#line 2485 "y.tab.c" /* yacc.c:1646  */
    break;

  case 115:
#line 509 "parser.y" /* yacc.c:1646  */
    { (yyval.expr) = new NullConstant((yylsp[0])); }
#line 2491 "y.tab.c" /* yacc.c:1646  */
    break;


#line 2495 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }

  yyerror_range[1] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval, &yylloc);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  yyerror_range[1] = yylsp[1-yylen];
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;

      yyerror_range[1] = *yylsp;
      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  yyerror_range[2] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, yyerror_range, 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval, &yylloc);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 512 "parser.y" /* yacc.c:1906  */


/* The closing %% above marks the end of the Rules section and the beginning
 * of the User Subroutines section. All text from here to the end of the
 * file is copied verbatim to the end of the generated y.tab.c file.
 * This section is where you put definitions of helper functions.
 */

/* Function: InitParser
 * --------------------
 * This function will be called before any calls to yyparse().  It is designed
 * to give you an opportunity to do anything that must be done to initialize
 * the parser (set global variables, configure starting state, etc.). One
 * thing it already does for you is assign the value of the global variable
 * yydebug that controls whether yacc prints debugging information about
 * parser actions (shift/reduce) and contents of state stack during parser.
 * If set to false, no information is printed. Setting it to true will give
 * you a running trail that might be helpful when debugging your parser.
 * Please be sure the variable is set to false when submitting your final
 * version.
 */
void InitParser()
{
    PrintDebug("parser", "Initializing parser");
    yydebug = false;
}

