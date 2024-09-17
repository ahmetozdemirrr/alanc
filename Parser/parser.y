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
}

/* Keyword tokens */
%token <boolean> KW_TRUE KW_FALSE
%token <nullval> KW_NULL
%token KW_IF KW_ELSE KW_ELIF KW_INT 
%token KW_FLOAT KW_BOOL KW_STR KW_RETURN
%token KW_FUNCTION KW_PROCEDURE KW_INCLUDE

/* Operator tokens */
%token <intval> INTEGER
%token <floatval> FLOAT
%token <string> IDENTIFIER
%token <string> COMMENT
%token OP_PLUS OP_MINUS OP_MULT OP_DIV OP_EQUAL
%token OP_OPEN_P OP_CLOSE_P OP_OPEN_CURLY OP_CLOSE_CURLY
%token OP_OPEN_SQU OP_CLOSE_SQU OP_COMMA OP_DOT
%token OP_OPEN_ANGLE OP_CLOSE_ANGLE OP_SEMICOLON POINTER

%start PROGRAM
%type <intval>   INT_EXP
%type <intval>   BOOL_EXP
%type <floatval> FLOAT_EXP
%type <floatval> EXPRESSION

%left OP_PLUS OP_MINUS   /* Toplama ve çıkarma operatörleri için sol bağlayıcılık */
%left OP_MULT OP_DIV     /* Çarpma ve bölme operatörleri için sol bağlayıcılık    */

%%
    PROGRAM:
        /* Empty program */
        | PROGRAM STATEMENT
        ;

    STATEMENT:
            EXPRESSION OP_SEMICOLON                                 { printf("Result: %f\n", $1);      }

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
            */

        |   KW_INT   IDENTIFIER OP_EQUAL EXPRESSION OP_SEMICOLON    { set_var(symbol_table, $2, create_int_var($4));    }
        |   KW_FLOAT IDENTIFIER OP_EQUAL EXPRESSION OP_SEMICOLON    { set_var(symbol_table, $2, create_float_var($4));  }
        |   KW_BOOL  IDENTIFIER OP_EQUAL EXPRESSION OP_SEMICOLON    { set_var(symbol_table, $2, create_bool_var($4)); }
        /* |   KW_STR   IDENTIFIER OP_EQUAL EXPRESSION OP_SEMICOLON    { set_var($2, create_bool_var($4));   } */
        ;

    EXPRESSION:
            INT_EXP                         { $$ = $1;      } /* INTEGER, as INT_EXP  */
        |   FLOAT_EXP                       { $$ = $1;      } /* FLOAT, as FLOAT_EXP  */
        |   BOOL_EXP                        { $$ = $1;      } /* BOOLEAN, as BOOL_EXP */
        |   OP_OPEN_P EXPRESSION OP_CLOSE_P { $$ = $2;      }   
        |   EXPRESSION OP_PLUS  EXPRESSION  { $$ = $1 + $3; }
        |   EXPRESSION OP_MINUS EXPRESSION  { $$ = $1 - $3; }
        |   EXPRESSION OP_MULT  EXPRESSION  { $$ = $1 * $3; }
        |   EXPRESSION OP_DIV   EXPRESSION  {
                                                if ($3 == 0)
                                                { 
                                                    yyerror("Division by zero!"); 
                                                } 

                                                else
                                                { 
                                                    $$ = $1 / $3; 
                                                } 
                                            }
        ;

    INT_EXP:
            INTEGER { $$ = $1; }
        ;

    BOOL_EXP:
            KW_TRUE     { $$ = $1; }  /* true  -> 1, lexer'den gelen değer kullanılır */
        |   KW_FALSE    { $$ = $1; }  /* false -> 0, lexer'den gelen değer kullanılır */
        ;

    FLOAT_EXP:
            FLOAT { $$ = $1; }
        ;
%%

int main(int argc, char *argv[])
{
    /* yydebug = 0;   inactivating debugging */
    yydebug = 1;     /* activating debugging */

    symbol_table = create_symbol_table();

    if (argc == 1)
    {
        printf("Type (ctrl+c) for exit\n");
        printf(">\n");
    }

    else if (argc == 2)
    {
        yyin = fopen(argv[1], "r");

        if (yyin == NULL)
        {
            printf("File not found\n");
            return 0;
        }
    }

    else 
    {
        printf("Too many arguments\n");
        printf("Usage: ./gpp_interpreter or ./gpp_interpreter <filename>\n");
        return 0;
    }
    yyparse();
}
/*   

from ../Parser/parser.tab.h tokens index:

enum yytokentype
{
    YYEMPTY = -2,
    YYEOF = 0,                      "end of file" 
    YYerror = 256,                  error
    YYUNDEF = 257,                  "invalid token"
    KW_TRUE = 258,                  KW_TRUE
    KW_FALSE = 259,                 KW_FALSE
    KW_NULL = 260,                  KW_NULL
    KW_IF = 261,                    KW_IF
    KW_ELSE = 262,                  KW_ELSE
    KW_ELIF = 263,                  KW_ELIF
    KW_INT = 264,                   KW_INT
    KW_FLOAT = 265,                 KW_FLOAT
    KW_BOOL = 266,                  KW_BOOL
    KW_STR = 267,                   KW_STR
    KW_FUNCTION = 268,              KW_FUNCTION
    KW_PROCEDURE = 269,             KW_PROCEDURE
    KW_INCLUDE = 270,               KW_INCLUDE
    KW_RETURN = 271,                KW_RETURN 
    INTEGER = 272,                  INTEGER
    IDENTIFIER = 273,               IDENTIFIER
    COMMENT = 274,                  COMMENT
    OP_PLUS = 275,                  OP_PLUS
    OP_MINUS = 276,                 OP_MINUS
    OP_MULT = 277,                  OP_MULT
    OP_DIV = 278,                   OP_DIV
    OP_EQUAL = 279,                 OP_EQUAL
    OP_OPEN_P = 280,                OP_OPEN_P
    OP_CLOSE_P = 281,               OP_CLOSE_P
    OP_OPEN_CURLY = 282,            OP_OPEN_CURLY
    OP_CLOSE_CURLY = 283,           OP_CLOSE_CURLY
    OP_OPEN_SQU = 284,              OP_OPEN_SQU
    OP_CLOSE_SQU = 285,             OP_CLOSE_SQU
    OP_COMMA = 286,                 OP_COMMA
    OP_DOT = 287,                   OP_DOT
    OP_OPEN_ANGLE = 288,            OP_OPEN_ANGLE
    OP_CLOSE_ANGLE = 289,           OP_CLOSE_ANGLE
    OP_SEMICOLON = 290,             OP_SEMICOLON
    POINTER = 291                   POINTER
};
typedef enum yytokentype yytoken_kind_t; 

*/