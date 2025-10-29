/* src/frontend/src/parser/lexer/lexer.l */

%{
    #include <stdio.h>
    #include <stdlib.h>

    /* local includes */
    #include <ast.h>
    #include "parser.tab.h" /* BİSON generates this file */

    int frontend_yycolumn = 1;

    #define YY_USER_ACTION                                  \
        frontend_yylloc.first_line   = frontend_yylineno;   \
        frontend_yylloc.first_column = frontend_yycolumn;   \
        frontend_yycolumn           += frontend_yyleng;     \
        frontend_yylloc.last_line    = frontend_yylineno;   \
        frontend_yylloc.last_column  = frontend_yycolumn - 1;
%}

%option noyywrap
%option yylineno
%option prefix="frontend_yy"

/*regular expressions*/

C_COMMENT          \/\*([^*]|\*+[^/*])*\*+\/
CPP_COMMENT        \/\/[^\n]*
INTEGER_LITERAL    [0-9]+
FLOAT_LITERAL      [0-9]+[.][0-9]+
STRING_LITERAL     \"(\\.|[^\\\"\n])*\"
IDENTIFIER         [a-zA-Z_][a-zA-Z0-9_]*
WHITESPACE         [ \t]+
SIGN               [^*+-/()= \n\t{}[].,<>;]
POINTER            "->"

/* KEYWORD, OPERATOR and other tokens */

%%

["]                 { return OP_QUOTA;          }
[+]                 { return OP_PLUS;           }
[-]                 { return OP_MINUS;          }
[*]                 { return OP_MULT;           }
"**"                { return OP_POW;            }
[/]                 { return OP_DIV;            }
[%]                 { return OP_MOD;            }
[(]                 { return OP_OPEN_P;         }
[)]                 { return OP_CLOSE_P;        }
[=]                 { return OP_ASSIGNMENT;     }
"->"                { return POINTER;           }
[.]                 { return OP_DOT;            }
[,]                 { return OP_COMMA;          }
[{]                 { return OP_OPEN_CURLY;     }
[}]                 { return OP_CLOSE_CURLY;    }
[[]                 { return OP_OPEN_SQU;       }
[]]                 { return OP_CLOSE_SQU;      }
[;]                 { return OP_SEMICOLON;      }
[<]                 { return OP_OPEN_ANGLE;     }
[>]                 { return OP_CLOSE_ANGLE;    }
"<="                { return OP_EQ_LESS;        }
">="                { return OP_EQ_GRE;         }
"=="                { return OP_IS_EQ;          }
"!="                { return OP_ISNT_EQ;        }
"+="                { return OP_AUG_PLUS;       }
"-="                { return OP_AUG_MINUS;      }
"*="                { return OP_AUG_MULT;       }
"/="                { return OP_AUG_DIV;        }
"%="                { return OP_AUG_MOD;        }
and                 { return OP_AND;            }
or                  { return OP_OR;             }
not                 { return OP_NOT;            }
if                  { return KW_IF;             }
else                { return KW_ELSE;           }
elif                { return KW_ELIF;           }
int                 { return KW_INT;            }
float               { return KW_FLOAT;          }
bool                { return KW_BOOL;           }
str                 { return KW_STR;            }
function            { return KW_FUNCTION;       }
procedure           { return KW_PROCEDURE;      }
for                 { return KW_FOR;            }
return              { return KW_RETURN;         }
\n                  { frontend_yycolumn = 1;    }
true                { 
                        frontend_yylval.node = new_bool_literal(1);
                        return KW_TRUE;
                    }
false               {
                        frontend_yylval.node = new_bool_literal(0);
                        return KW_FALSE;
                    }
null                {
                        frontend_yylval.nullval = NULL;
                        return KW_NULL;
                    }
{IDENTIFIER}        {
                        frontend_yylval.string = strdup(frontend_yytext);
                        return IDENTIFIER;
                    }
{INTEGER_LITERAL}   {
                        frontend_yylval.node = new_integer_literal(atoi(frontend_yytext));
                        return INTEGER_LITERAL;
                    }
{FLOAT_LITERAL}     {
                        frontend_yylval.node = new_float_literal(atof(frontend_yytext));
                        return FLOAT_LITERAL;
                    }
{STRING_LITERAL}    {
                        frontend_yylval.node = new_string_literal(strdup(frontend_yytext + 1));  /* Başlangıçtaki tırnağı atla */
                        frontend_yylval.node->data.literal.stringValue[strlen(frontend_yylval.node->data.literal.stringValue) - 1] = '\0';
                        return STRING_LITERAL;
                    }
{WHITESPACE}        { /* no action */ }
{C_COMMENT}         { /* no action */ }
{CPP_COMMENT}       { /* no action */ }

{SIGN}+[a-zA-Z0-9]+         {
                                /* give syntax error if identifiers are preceded by a SIGN */
                                fprintf(stderr, "SYNTAX ERROR '%s' cannot be tokenized\n",frontend_yytext);
                                exit(EXIT_FAILURE);
                            }
{SIGN}+[a-zA-Z0-9]+{SIGN}+  {
                                /* give syntax error if identifiers are contain a SIGN */
                                fprintf(stderr, "SYNTAX ERROR '%s' cannot be tokenized\n",frontend_yytext);
                                exit(EXIT_FAILURE);
                            }
.                           {
                                /* Any other overlap errors */
                                fprintf(stderr, "Unrecognized character: '%s'\n", frontend_yytext);
                                exit(EXIT_FAILURE);
                            }
%%
