%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "../include/variables.h"
    #include "../Parser/parser.tab.h" /* BİSON generates this file */

    int yycolumn = 1;
%}

%option noyywrap
%option yylineno

/*----------------------------------------------------------------------------------------------
|                                                                                              |
| 1 - COMMENT's will cover the right side of the lines containing the '#' characters           |
| 2 - INTEGER's can be any integer mixture                                                     |
| 3 - Variable names (IDENTIFIER) must start with a letter character, also up to 32 characters |
|     can be long.                                                                             |
| 4 - Handle whitespace characters; we will have no action for these characters.               |
| 5 - We ensure that the operators other than the operators we will use do not come next to    | 
|     the identifiers in any way. This marks a case like (?variableX) as a syntax error,       |
|     without marking a case like (+variableX) as a syntax error.                              |
|                                                                                              |
----------------------------------------------------------------------------------------------*/

/*regular expressions*/

COMMENT            [#].*
INTEGER_LITERAL    [0-9]+
FLOAT_LITERAL      [0-9]+[.][0-9]+
STRING_LITERAL     \"(\\.|[^\\\"\n])*\" 
IDENTIFIER         [a-zA-Z][a-zA-Z0-9_]{0,31} 
WHITESPACE         [ \t]+
SIGN               [^*+-/()= \n\t{}[].,<>;] 
POINTER            "->"

/* KEYWORD, OPERATOR and other tokens */

%%

["]                 {
                        yycolumn += yyleng; 
                        return OP_QUOTA;    
                    }   
[+]                 {
                        yycolumn += yyleng; 
                        return OP_PLUS;
                    }
[-]                 {
                        yycolumn += yyleng; 
                        return OP_MINUS;        
                    }
[*]                 {
                        yycolumn += yyleng; 
                        return OP_MULT;         
                    }
[/]                 {
                        yycolumn += yyleng; 
                        return OP_DIV;          
                    }
[(]                 {
                        yycolumn += yyleng; 
                        return OP_OPEN_P;       
                    }
[)]                 {
                        yycolumn += yyleng; 
                        return OP_CLOSE_P;      
                    }
[=]                 {
                        yycolumn += yyleng; 
                        return OP_EQUAL;        
                    }
"->"                {
                        yycolumn += yyleng; 
                        return POINTER;         
                    }
[.]                 {
                        yycolumn += yyleng; 
                        return OP_DOT;          
                    }
[,]                 {
                        yycolumn += yyleng; 
                        return OP_COMMA;        
                    }
[{]                 {
                        yycolumn += yyleng; 
                        return OP_OPEN_CURLY;   
                    }
[}]                 {
                        yycolumn += yyleng; 
                        return OP_CLOSE_CURLY;  
                    }
[[]                 {
                        yycolumn += yyleng; 
                        return OP_OPEN_SQU;     
                    }
[]]                 {
                        yycolumn += yyleng; 
                        return OP_CLOSE_SQU;    
                    }
[<]                 {
                        yycolumn += yyleng; 
                        return OP_OPEN_ANGLE;   
                    }
[>]                 {
                        yycolumn += yyleng; 
                        return OP_CLOSE_ANGLE;  
                    }
[;]                 {
                        yycolumn += yyleng; 
                        return OP_SEMICOLON;    
                    }            
if                  {
                        yycolumn += yyleng; 
                        return KW_IF;           
                    }
else                {
                        yycolumn += yyleng; 
                        return KW_ELSE;         
                    }
elif                {
                        yycolumn += yyleng; 
                        return KW_ELIF;         
                    }
int                 {
                        yycolumn += yyleng; 
                        return KW_INT;          
                    }
float               {
                        yycolumn += yyleng; 
                        return KW_FLOAT;        
                    }
bool                {
                        yycolumn += yyleng; 
                        return KW_BOOL;         
                    }
str                 {
                        yycolumn += yyleng; 
                        return KW_STR;          
                    }
function            {
                        yycolumn += yyleng; 
                        return KW_FUNCTION;     
                    }
procedure           {
                        yycolumn += yyleng; 
                        return KW_PROCEDURE;    
                    }
include             {
                        yycolumn += yyleng; 
                        return KW_INCLUDE;      
                    }
return              {
                        yycolumn += yyleng; 
                        return KW_RETURN;       
                    }
\n                  {
                        yycolumn += yyleng; 
                        yycolumn = 1;
                        return NEWLINE; 
                    }
true                {
                        yycolumn += yyleng;
                        yylval.boolean = 1; 
                        return KW_TRUE;         
                    }
false               {
                        yycolumn += yyleng; 
                        yylval.boolean = 0;
                        return KW_FALSE;        
                    }
null                {
                        yycolumn += yyleng; 
                        yylval.nullval = NULL;
                        return KW_NULL;         
                    }
{IDENTIFIER}        {
                        yycolumn += yyleng; 
                        yylval.string = strdup(yytext); 
                        return IDENTIFIER;  
                    }
{INTEGER_LITERAL}   {
                        yycolumn += yyleng;
                        yylval.intval = atoi(yytext); 
                        return INTEGER_LITERAL;     
                    }
{FLOAT_LITERAL}     {
                        yycolumn += yyleng;
                        yylval.floatval = atof(yytext); 
                        return FLOAT_LITERAL;     
                    }
{STRING_LITERAL}    {
                        yycolumn += yyleng;
                        yylval.string = strdup(yytext);
                        return STRING_LITERAL;
                    }
{WHITESPACE}        { yycolumn += yyleng;   }
{COMMENT}           { /* return COMMENT; ... no action */ }

{SIGN}+[a-zA-Z0-9]+         { 
                                /* give syntax error if identifiers are preceded by a SIGN */
                                fprintf(stderr, "SYNTAX ERROR '%s' cannot be tokenized\n",yytext); 
                                exit(EXIT_FAILURE);
                            }  
{SIGN}+[a-zA-Z0-9]+{SIGN}+  { 
                                /* give syntax error if identifiers are contain a SIGN */
                                fprintf(stderr, "SYNTAX ERROR '%s' cannot be tokenized\n",yytext); 
                                exit(EXIT_FAILURE);
                            }  
.                           {    
                                /* Any other overlap errors */
                                fprintf(stderr, "Unrecognized character: '%s'\n", yytext);
                                exit(EXIT_FAILURE); 
                            }
%%

/* 

int main()  main function for testing 
{
    int control;

    yylex(), which provides a stream of tokens and inputs line by line or 
    scans character by character and matches certain patterns (e.g. numbers, 
    It is a function that returns tokens based on (words, operators).

    Function of yylex() Function:

    - Token Generation: yylex() analyzes the input and generates it every time it is called. 
    Returns the next token. This token is in accordance with the structure of the language. 
    It can be an enum value (for example: OP_PLUS or KW_IF).

    - Input Scanning: yylex() function scans the input line by line and 
    Regular expressions defined by lexer 
    captures the appropriate parts (expressions). Each captured portion is a token 
    It is processed as .

    - Processing the Input Stream: yylex() is usually the source file or 
    It runs over standard input (stdin). in the file or 
    reads each line in the input and reads the characters in the defined order 
    It divides into tokens according to expressions.
    
    while(control = yylex())
    {
        printf("Token: %d\n", control);
    }
    return 0;
} 

*/
