#include "../include/utils.h"

/* Flex tarafından sağlanan yylex fonksiyonunu dışa aktar */
int yylex();

/* Hata mesajlarını göstermek için yyerror fonksiyonu */
void yyerror(const char * s) 
{
    fprintf(stderr, "Syntax error: %s\n", s);
    exit(EXIT_FAILURE);
}
