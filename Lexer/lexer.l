%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "../include/tokens.h"
    #include "../include/keywords.h"
    // #include "y.tab.h" // BİSON generates this file
%}

%option noyywrap

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

COMMENT         [#].*
INTEGER         [0-9]+
IDENTIFIER      [a-zA-Z][a-zA-Z0-9_]{0,31} 
WHITESPACE      [ \t\n]+
WHITESPACES     [\\t\\n]+
SIGN            [^+-/*()= \n\t{}[].,<>;] 
POINTER         "->"
NEWLINE         \n

/* KEYWORD, OPERATOR and other tokens */

%%

[+]             { return OP_PLUS;         }
[-]             { return OP_MINUS;        }
[*]             { return OP_MULT;         }
[/]             { return OP_DIV;          }
[(]             { return OP_OPEN_P;       }
[)]             { return OP_CLOSE_P;      }
[=]             { return OP_EQUAL;        }
"->"            { return POINTER;         }
[.]             { return OP_DOT;          }
[,]             { return OP_COMMA;        }
[{]             { return OP_OPEN_CURLY;   }
[}]             { return OP_CLOSE_CURLY;  }
[[]             { return OP_OPEN_SQU;     }
[]]             { return OP_CLOSE_SQU;    }
[<]             { return OP_OPEN_ANGLE;   }
[>]             { return OP_CLOSE_ANGLE;  }
[;]             { return OP_SEMICOLON;    }

if              { return KW_IF;           }
else            { return KW_ELSE;         }
elif            { return KW_ELIF;         }
true            { return KW_TRUE;         }
false           { return KW_FALSE;        }
int             { return KW_INT;          }
float           { return KW_FLOAT;        }
bool            { return KW_BOOL;         }
str             { return KW_STR;          }
null            { return KW_NULL;         }
function        { return KW_FUNCTION;     }
procedure       { return KW_PROCEDURE;    }
include         { return KW_INCLUDE;      }
return          { return KW_RETURN;       }

{COMMENT}       { return COMMENT;         }

{IDENTIFIER}    { 
                    //yylval.string = strdup(yytext); 
                    return IDENTIFIER;  
                }

{INTEGER}       {
                    //yylval.string = strdup(yytext); 
                    return INTEGER;     
                }

{WHITESPACE}    { ; }
{WHITESPACES}   { ; }


{SIGN}+[a-zA-Z0-9]+         { 
                                fprintf(stderr, "SYNTAX ERROR '%s' cannot be tokenized\n",yytext); 
                                exit(EXIT_FAILURE);
                            }  

{SIGN}+[a-zA-Z0-9]+{SIGN}+  { 
                                fprintf(stderr, "SYNTAX ERROR '%s' cannot be tokenized\n",yytext); 
                                exit(EXIT_FAILURE);
                            }         

.                           {    
                                /* Any other overlap errors */
                                fprintf(stderr, "SYNTAX ERROR: '%s' cannot be tokenized\n", yytext);
                                exit(EXIT_FAILURE); 
                            }
%%

int main() /* main function for testing */
{
    int control;

    /* 
        yylex(), bir token akışı sağlayan ve girdiyi satır satır veya 
        karakter karakter tarayıp belirli kalıplara (örneğin sayılar, 
        kelimeler, operatörler) göre token'lar döndüren işlevdir.

        yylex() Fonksiyonunun İşlevi:

        - Token Üretme: yylex() girdiyi analiz eder ve her çağrıldığında 
        bir sonraki token'ı döndürür. Bu token, dilin yapısına uygun bir 
        enum değeri olabilir (örneğin: OP_PLUS veya KW_IF).

        - Girdi Tarama: yylex() fonksiyonu girdiyi satır satır tarar ve 
        lexer tarafından tanımlanan regular expression'lara (düzenli 
        ifadelere) uygun parçaları yakalar. Her yakalanan kısım bir token 
        olarak işlenir.

        - Girdi Akışını İşlemek: yylex() genellikle kaynak dosya veya 
        standart giriş (stdin) üzerinden çalışır. Dosyadaki veya 
        girdideki her satırı okur ve karakterleri tanımlanan düzenli 
        ifadelere göre token'lara ayırır.
    */
    while(control = yylex())
    {
        switch (control)
        {
            case 1:
                printf("OP_PLUS\n");
                break;

            case 2:
                printf("OP_MINUS\n");
                break;

            case 3:
                printf("OP_MULT\n");
                break;

            case 4:
                printf("OP_DIV\n");
                break;

            case 5:
                printf("OP_OPEN_P\n");
                break;  

            case 6:
                printf("OP_CLOSE_P\n");
                break;  

            case 7:
                printf("INTEGER\n");
                break;   

            case 8:
                printf("IDENTIFIER\n");
                break;

            case 9:
                printf("COMMENT\n");
                break;     

            case 10:
                printf("OP_EQUAL\n");
                break; 

            case 11:
                printf("POINTER\n");
                break; 

            case 12:
                printf("OP_OPEN_CURLY\n");
                break; 

            case 13:
                printf("OP_CLOSE_CURLY\n");
                break; 

            case 14:
                printf("OP_OPEN_SQU\n");
                break; 

            case 15:
                printf("OP_CLOSE_SQU\n");
                break; 

            case 16:
                printf("OP_COMMA\n");
                break; 

            case 17:
                printf("OP_DOT\n");
                break; 

            case 18:
                printf("OP_OPEN_ANGLE\n");
                break; 

            case 19:
                printf("OP_CLOSE_ANGLE\n");
                break; 

            case 20:
                printf("OP_SEMICOLON\n");
                break; 

            case 21:
                printf("KW_IF\n");
                break;

            case 22:
                printf("KW_ELSE\n");
                break;

            case 23:
                printf("KW_ELIF\n");
                break;

            case 24:
                printf("KW_TRUE\n");
                break;

            case 25:
                printf("KW_FALSE\n");
                break;  

            case 26:
                printf("KW_INT\n");
                break;  

            case 27:
                printf("KW_FLOAT\n");
                break;   

            case 28:
                printf("KW_BOOL\n");
                break;

            case 29:
                printf("KW_STR\n");
                break;     

            case 30:
                printf("KW_NULL\n");
                break; 

            case 31:
                printf("KW_FUNCTION\n");
                break; 

            case 32:
                printf("KW_PROCEDURE\n");
                break; 

            case 33:
                printf("KW_INCLUDE\n");
                break; 

            case 34:
                printf("KW_RETURN\n");
                break;

            default:
                break;
        }
    }
    return 0;
}
