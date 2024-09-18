#include "../include/utils.h"

extern int yylineno;
extern int yycolumn;

/* Flex tarafından sağlanan yylex fonksiyonunu dışa aktar */
int yylex();

/* Hata mesajlarını göstermek için yyerror fonksiyonu */
void yyerror(const char * s) 
{
    fprintf(stderr, "Syntax error: %s at line: %d column: %d\n", s, yylineno, yycolumn);
    exit(EXIT_FAILURE);
}
