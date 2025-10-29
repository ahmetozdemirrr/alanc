/* src/common/src/utils.c */

#include <utils.h>

/* export yylex function which provided by flex */
int yylex();

/* yyerror function for printing error messages */
void yyerror(const char* s)
{
    fprintf(stderr, "at %d:%d: error: %s\n", yylineno, yycolumn, s);
    exit(EXIT_FAILURE);
}
