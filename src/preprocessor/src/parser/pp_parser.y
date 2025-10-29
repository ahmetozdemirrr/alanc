/* src/preprocessor/parser/pp_parser.y */

%{
    #include <stdio.h>
    #include <stdlib.h>

    int preprocessor_yylex(void);
    void preprocessor_yyerror(const char* s);

    extern FILE* preprocessor_yyin;
%}

%define api.prefix {preprocessor_yy}

%union 
{
    int     integer;
    double  floating;
    char*   string;
}

%token <string> IDENTIFIER STRING_LITERAL CHAR_LITERAL
%token <string> HEADER_NAME
%token <integer> INTEGER_LITERAL
%token <floating> FLOAT_LITERAL

%token KW_INCLUDE KW_DEFINE KW_UNDEF KW_IF KW_IFDEF KW_IFNDEF
%token KW_ELIF KW_ELSE KW_ENDIF KW_ERROR KW_WARNING KW_PRAGMA KW_LINE
%token OP_DEFINED OP_CONCAT
%token HASH
%token NEWLINE
%token ARROW INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP ELLIPSIS

%locations /* for diagnostic macros */

%%
program:
    %empty
    | program line
    ;

line:
    directive
    | other_line
    ;

directive:
    include_directive
    ;

include_directive:
    HASH KW_INCLUDE HEADER_NAME NEWLINE
    {
        /*
         * semantic action:
         * $1: HASH, $2: KW_INCLUDE, $3: HEADER_NAME, $4: NEWLINE holds tokens value
         *
         */
        printf("Parser: recognize a line with header %s .\n", $3);

        /* Lexer'da strdup ile ayırdığımız belleği burada serbest bırak */
        free($3);
    }
    ;

other_line:
    error NEWLINE
    {
        /*
         * 'error' özel bir bison token'ıdır. Bir sözdizimi hatası olduğunda
         * bison'un NEWLINE token'ına kadar her şeyi atlamasını ve devam etmesini söyleri<.
         * Bu, parser'ın ilk hatada çökmesini engeller.
         */
        printf("Parser: other lines.\n");
    }
    | NEWLINE
    ;

%%

void preprocessor_yyerror(const char* s)
{
    fprintf(stderr, "Error: line %d, column %d: %s\n", 
            preprocessor_yylloc.first_line, 
            preprocessor_yylloc.first_column,
            s);
}
