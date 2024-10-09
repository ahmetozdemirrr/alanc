#include "../include/utils.h"

extern int yylineno;
extern int yycolumn;

/* Flex tarafından sağlanan yylex fonksiyonunu dışa aktar */
int yylex();

/* Hata mesajlarını göstermek için yyerror fonksiyonu */
void yyerror(const char * s) 
{
    fprintf(stderr, "at %d:%d: error: %s\n", yylineno, yycolumn, s);
    exit(EXIT_FAILURE);
}
