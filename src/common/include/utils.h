/* src/common/include/utils.h */

#ifndef UTILS_H_
#define UTILS_H_

#include <stdio.h>
#include <stdlib.h>

/*
 * This header file declares utility functions and variables
 * that are used across the compiler, especially by the parser.
 */

extern int yylineno;
extern int yycolumn;

int yylex(void);
void yyerror(const char* s);

#endif /* UTILS_H_ */
