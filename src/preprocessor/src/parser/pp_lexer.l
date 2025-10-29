/* src/preprocessor/parser/lexer/pp_lexer.l */

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    /* local includes */
    #include "pp_parser.tab.h" /* BISON generates this file */

    int preprocessor_yycolumn = 1;

    /* Bison'a konum bilgisini (satır, sütun) iletmek için bir prototip */
    #define YY_USER_ACTION                                          \
        preprocessor_yylloc.first_line   = preprocessor_yylineno;   \
        preprocessor_yylloc.first_column = preprocessor_yycolumn;   \
        preprocessor_yycolumn           += preprocessor_yyleng;     \
        preprocessor_yylloc.last_line    = preprocessor_yylineno;   \
        preprocessor_yylloc.last_column  = preprocessor_yycolumn - 1;
%}

%option noyywrap
%option yylineno
%option prefix="preprocessor_yy"
%x INCLUDE_STATE

/* Regular Expression Definitions */

C_COMMENT          \/\*([^*]|\*+[^/*])*\*+\/
CPP_COMMENT        \/\/[^\n]*
INTEGER_LITERAL    [0-9]+
FLOAT_LITERAL      [0-9]+\.[0-9]+
STRING_LITERAL     \"(\\.|[^\\\"\n])*\"
CHAR_LITERAL       L?'(\\.|[^\\'])+'
IDENTIFIER         [a-zA-Z_][a-zA-Z0-9_]*
WHITESPACE         [ \t]+

%%
{WHITESPACE}        { /* no action. YY_USER_ACTION updates column */ }
{C_COMMENT}         { /* no action */ }
{CPP_COMMENT}       { /* no action */ }
\n                  { 
                        preprocessor_yycolumn = 1; 
                        return NEWLINE; /* Parser'ın satır sonlarını bilmesi gerekebilir. */ 
                    }
\\\n                { preprocessor_yycolumn = 1; /* Yoksay, bir sonraki satıra devam et. */ }
"include"           { 
                        BEGIN(INCLUDE_STATE);
                        return KW_INCLUDE;    
                    }
"define"            { return KW_DEFINE;     }
"undef"             { return KW_UNDEF;      }
"if"                { return KW_IF;         }
"ifdef"             { return KW_IFDEF;      }
"ifndef"            { return KW_IFNDEF;     }
"elif"              { return KW_ELIF;       }
"else"              { return KW_ELSE;       }
"endif"             { return KW_ENDIF;      }
"error"             { return KW_ERROR;      }
"warning"           { return KW_WARNING;    }
"pragma"            { return KW_PRAGMA;     }
"line"              { return KW_LINE;       }
"defined"           { return OP_DEFINED;    }
{IDENTIFIER}        {   
                        preprocessor_yylval.string = strdup(preprocessor_yytext); 
                        return IDENTIFIER;      
                    }
{INTEGER_LITERAL}   { 
                        preprocessor_yylval.integer = atoi(preprocessor_yytext);   
                        return INTEGER_LITERAL; 
                    }
{FLOAT_LITERAL}     {   
                        preprocessor_yylval.floating = atof(preprocessor_yytext);   
                        return FLOAT_LITERAL;   
                    }
{STRING_LITERAL}    {
                        preprocessor_yytext[preprocessor_yyleng-1] = '\0';
                        preprocessor_yylval.string = strdup(preprocessor_yytext + 1);
                        return STRING_LITERAL;
                    }
{CHAR_LITERAL}      {
                        preprocessor_yytext[preprocessor_yyleng-1] = '\0';
                        preprocessor_yylval.string = strdup(preprocessor_yytext + 1);
                        return CHAR_LITERAL;
                    }
"##"                { return OP_CONCAT; }
"->"                { return ARROW;     }
"++"                { return INC_OP;    }
"--"                { return DEC_OP;    }
"<<"                { return LEFT_OP;   }
">>"                { return RIGHT_OP;  }
"<="                { return LE_OP;     }
">="                { return GE_OP;     }
"=="                { return EQ_OP;     }
"!="                { return NE_OP;     }
"&&"                { return AND_OP;    }
"||"                { return OR_OP;     }
"..."               { return ELLIPSIS;  }
"#"                 { return HASH;      }
"&"                 { return '&';       }
"*"                 { return '*';       }
"+"                 { return '+';       }
"-"                 { return '-';       }
"~"                 { return '~';       }
"!"                 { return '!';       }
"/"                 { return '/';       }
"%"                 { return '%';       }
"<"                 { return '<';       }
">"                 { return '>';       }
"^"                 { return '^';       }
"|"                 { return '|';       }
"?"                 { return '?';       }
":"                 { return ':';       }
";"                 { return ';';       }
"="                 { return '=';       }
","                 { return ',';       }
"."                 { return '.';       }
"("                 { return '(';       }
")"                 { return ')';       }
"["                 { return '[';       }
"]"                 { return ']';       }
"{"                 { return '{';       }
"}"                 { return '}';       }
.                   {
                        fprintf(stderr, "Unrecognized character: '%s' at line %d, column %d\n",
                                preprocessor_yytext, 
                                preprocessor_yylineno, 
                                preprocessor_yylloc.first_column);
                        exit(EXIT_FAILURE);
                    }

<INCLUDE_STATE>
{
    {WHITESPACE}        { /* no action */ }
    "<"[^>\n]+">"       {
                            preprocessor_yylval.string = strdup(preprocessor_yytext);
                            BEGIN(INITIAL);
                            return HEADER_NAME;
                        }
    \"[^\"\n]+\"        {
                            preprocessor_yylval.string = strdup(yytext);
                            BEGIN(INITIAL);
                            return HEADER_NAME;
                        }
    \n                  {
                            preprocessor_yycolumn = 1;
                            BEGIN(INITIAL);
                            return NEWLINE;
                        }
    .                   {
                            fprintf(stderr, "Error: Malformed include directive near '%s'\n", preprocessor_yytext);
                            BEGIN(INITIAL);
                        }
}
%%
