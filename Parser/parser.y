%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "../include/utils.h"
    #include "../include/variables.h"
    #include "../include/symbol_table.h"
    
    #define YYDEBUG 1

    extern FILE * yyin; /* for printing to file */
    extern int yydebug; /* for debugging mode   */
%}  

%union 
{
    int    intval;      /* for Integer types          */
    float  floatval;    /* for Float types            */
    char * string;      /* for String types           */
    int    boolean;     /* for Boolean types (0 or 1) */
    void * nullval;     /* for Null                   */
    Variable var;
}

/* Keyword tokens */
%token <boolean> KW_TRUE KW_FALSE
%token <nullval> KW_NULL
%token KW_IF KW_ELSE KW_ELIF KW_INT 
%token KW_FLOAT KW_BOOL KW_STR KW_RETURN
%token KW_FUNCTION KW_PROCEDURE KW_INCLUDE

/* Operator tokens */
%token <intval> INTEGER_LITERAL
%token <floatval> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <string> IDENTIFIER
%token <string> COMMENT
%token OP_PLUS OP_MINUS OP_MULT OP_DIV OP_EQUAL NEWLINE
%token OP_OPEN_P OP_CLOSE_P OP_OPEN_CURLY OP_CLOSE_CURLY
%token OP_OPEN_SQU OP_CLOSE_SQU OP_COMMA OP_DOT OP_QUOTA
%token OP_OPEN_ANGLE OP_CLOSE_ANGLE OP_SEMICOLON POINTER

%start PROGRAM
%type <intval>   INT_EXP
%type <intval>   BOOL_EXP
%type <floatval> FLOAT_EXP
%type <string>   STRING_EXP
%type <var>      EXPRESSION

%left OP_PLUS OP_MINUS   /* Toplama ve çıkarma operatörleri için sol bağlayıcılık */
%left OP_MULT OP_DIV     /* Çarpma ve bölme operatörleri için sol bağlayıcılık    */
%right UNARY_MINUS

%%
    PROGRAM:
        /* Empty program */
        |   PROGRAM STATEMENT
        |   PROGRAM NEWLINE
        ;

    STATEMENT:
            EXPRESSION OP_SEMICOLON    { 
                                            switch ($1.type) 
                                            {
                                                case INT_TYPE:
                                                    printf("Result: %d\n", $1.value.intval);
                                                    break;
                                                case FLOAT_TYPE:
                                                    printf("Result: %f\n", $1.value.floatval);
                                                    break;
                                                case STRING_TYPE:
                                                    printf("Result: %s\n", $1.value.strval);
                                                    break;
                                                case BOOL_TYPE:
                                                    printf("Result: %s\n", $1.value.boolval ? "true" : "false");
                                                    break;
                                                default:
                                                    printf("Unknown type\n");
                                            }      
                                        }

            /* TO DO:
                
                - add control for redefining of variables
                - add synactic definitions for updating variables: 
                (
                    int a = 5; 
                    # ...code... 
                    a = 6;
                )
                - add string type of language (Pyhton like definition)
                - add boolean statement (if-elif-else)
                - type mismatch control
            */

        |   KW_INT   IDENTIFIER OP_EQUAL EXPRESSION OP_SEMICOLON    { set_var(symbol_table, $2, create_int_var($4.value.intval));     }
        |   KW_FLOAT IDENTIFIER OP_EQUAL EXPRESSION OP_SEMICOLON    { set_var(symbol_table, $2, create_float_var($4.value.floatval)); }
        |   KW_BOOL  IDENTIFIER OP_EQUAL EXPRESSION OP_SEMICOLON    { set_var(symbol_table, $2, create_bool_var($4.value.boolval));   }
        |   KW_STR   IDENTIFIER OP_EQUAL EXPRESSION OP_SEMICOLON    { set_var(symbol_table, $2, create_str_var($4.value.strval));     }
        |   OP_SEMICOLON 
        ;

    EXPRESSION:
            INT_EXP                         { $$ = create_int_var($1);   } /* INTEGER, as INT_EXP   */
        |   FLOAT_EXP                       { $$ = create_float_var($1); } /* FLOAT, as FLOAT_EXP   */
        |   BOOL_EXP                        { $$ = create_bool_var($1);  } /* BOOLEAN, as BOOL_EXP  */
        |   STRING_EXP                      { $$ = create_str_var($1);   } /* STRING, as STRING_EXP */
        |   OP_OPEN_P EXPRESSION OP_CLOSE_P { $$ = $2;      }   
        |   EXPRESSION OP_PLUS EXPRESSION   {
                                                if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_int_var($1.value.intval + $3.value.intval);
                                                }

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval + $3.value.floatval);
                                                }

                                                else if ($1.type == STRING_TYPE && $3.type == STRING_TYPE) 
                                                {
                                                    /* String birleştirme */
                                                    char * concat = malloc(strlen($1.value.strval) + strlen($3.value.strval) + 1);
                                                    strcpy(concat, $1.value.strval);
                                                    strcat(concat, $3.value.strval);
                                                    $$ = create_str_var(concat);
                                                    free(concat);
                                                }

                                                else 
                                                {
                                                    yyerror("Type mismatch: Not suitable types for '+' operator.");
                                                    YYERROR;
                                                }
                                            }
        |   EXPRESSION OP_MINUS EXPRESSION  {
                                                if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_int_var($1.value.intval - $3.value.intval);
                                                } 

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval - $3.value.floatval);
                                                } 

                                                else {
                                                    yyerror("Type mismatch: Unsupported types for '*' operator.");
                                                    YYERROR;
                                                }  
                                            }
        |   EXPRESSION OP_MULT  EXPRESSION  {
                                                if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_int_var($1.value.intval * $3.value.intval);
                                                } 

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval * $3.value.floatval);
                                                } 

                                                else {
                                                    yyerror("Type mismatch: Unsupported types for '*' operator.");
                                                    YYERROR;
                                                } 
                                            }
        |   EXPRESSION OP_DIV   EXPRESSION  {
                                                if ($3.value.floatval == 0) 
                                                {
                                                    yyerror("Division by zero.");
                                                    YYERROR;
                                                } 

                                                else if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_float_var((float) $1.value.intval / $3.value.intval);
                                                } 

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval / $3.value.floatval);
                                                } 

                                                else 
                                                {
                                                    yyerror("Type mismatch: Unsupported types for '/' operator.");
                                                    YYERROR;
                                                }
                                            }
        /*-----------------------------------------------------------------
            When we define both unary and binary - operators, Bison may
            experience ambiguity due to the different uses of this symbol.
            Using %prec, we can resolve this ambiguity by assigning a 
            special precedence to the unary minus operator.
        -----------------------------------------------------------------*/
        | OP_MINUS EXPRESSION %prec UNARY_MINUS {
                                                    if ($2.type == INT_TYPE) 
                                                    {
                                                        $$ = create_int_var(-$2.value.intval);
                                                    } 

                                                    else if ($2.type == FLOAT_TYPE) 
                                                    {
                                                        $$ = create_float_var(-$2.value.floatval);
                                                    } 

                                                    else 
                                                    {
                                                        yyerror("Unary minus can only be applied to numbers.");
                                                        YYERROR;
                                                    } 
                                                }
        ;

    INT_EXP:
            INTEGER_LITERAL { $$ = $1; }
        ;

    BOOL_EXP:
            KW_TRUE { $$ = $1; }  /* true  -> 1, lexer'den gelen değer kullanılır */
        |   KW_FALSE { $$ = $1; }  /* false -> 0, lexer'den gelen değer kullanılır */
        ;

    FLOAT_EXP:
            FLOAT_LITERAL { $$ = $1; }
        ;

    STRING_EXP:
            STRING_LITERAL { $$ = $1; }
        ;
%%

int main(int argc, char * argv[])
{
    /* yydebug = 0;   inactivating debugging */
    yydebug = 0;     /* activating debugging */

    symbol_table = create_symbol_table();

    if (argc == 1)
    {
        printf("Type (ctrl+c) for exit\n");

        while (1)
        {
            printf("> ");
            yyparse();
            /* cleaning input */
            yyclearin;
        }
    }

    else if (argc == 2)
    {
        yyin = fopen(argv[1], "r");

        if (yyin == NULL)
        {
            printf("File not found\n");
            return 0;
        }
        yyparse();
    }
    
    else
    {
        printf("Too many arguments\n");
        printf("Usage: ./parser or ./parser <filename>\n");
        return 0;
    }

    return 0;
}

/*   

from ../Parser/parser.tab.h tokens index:

// Token kinds.
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,
    YYerror = 256,
    YYUNDEF = 257, 
    KW_TRUE = 258,
    KW_FALSE = 259,
    KW_NULL = 260,
    KW_IF = 261,
    KW_ELSE = 262,
    KW_ELIF = 263,
    KW_INT = 264, 
    KW_FLOAT = 265,
    KW_BOOL = 266, 
    KW_STR = 267,  
    KW_RETURN = 268,
    KW_FUNCTION = 269,
    KW_PROCEDURE = 270,
    KW_INCLUDE = 271,  
    INTEGER_LITERAL = 272,
    FLOAT_LITERAL = 273,  
    STRING_LITERAL = 274, 
    IDENTIFIER = 275,     
    COMMENT = 276,        
    OP_PLUS = 277,        
    OP_MINUS = 278,       
    OP_MULT = 279,        
    OP_DIV = 280,         
    OP_EQUAL = 281,       
    NEWLINE = 282,        
    OP_OPEN_P = 283,      
    OP_CLOSE_P = 284,     
    OP_OPEN_CURLY = 285,  
    OP_CLOSE_CURLY = 286, 
    OP_OPEN_SQU = 287,    
    OP_CLOSE_SQU = 288,   
    OP_COMMA = 289,       
    OP_DOT = 290,         
    OP_QUOTA = 291,       
    OP_OPEN_ANGLE = 292,  
    OP_CLOSE_ANGLE = 293, 
    OP_SEMICOLON = 294,   
    POINTER = 295,        
    UNARY_MINUS = 296     
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

// Value type.  
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 16 "Parser/parser.y"

    int    intval;      // for Integer types          
    float  floatval;    // for Float types            
    char * string;      // for String types           
    int    boolean;     // for Boolean types (0 or 1) 
    void * nullval;     // for Null                   
    Variable var;

#line 114 "Parser/parser.tab.h"

*/
