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
