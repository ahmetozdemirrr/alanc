/* src/main.c */

/*
    - Orchestrator of compiler collection
    - Defines pipeline of compiler steps:
        * preprocessor
        * lexer/parser
        * ast generation
        * ast traversal, semantic actions
        * feeding the LLVM backend with IR generated from the AST.
        * entegration of GNU toolchains (assembler, linker etc.)
*/

#include <stdio.h>

int main(int argc, char** argv)
{
    printf("Alanc Compiler is Work...\n");
    
    if (argc < 2) 
	{
        printf("Usage: ./alanc <file_name>\n");
        return 1;
	}  
    (void)argv;
	
    return 0;
}
