%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    /* local includes */
    #include <utils.h>
    #include <logical.h>
    #include <variables.h>
    #include <symbol_table.h>
    #include <ast.h>

    ASTNode * program_root = NULL;

    #define YYDEBUG 1

    extern FILE * yyin;
    extern int yydebug;
%}

%union
{
    int    intval;
    float  floatval;
    char * string;
    int    boolean;
    void * nullval;
    ASTNode * node;
    ASTNodeList * list;
}

/* Keyword tokens */
%token <node> KW_TRUE KW_FALSE
%token <nullval> KW_NULL
%token KW_IF KW_ELSE KW_ELIF KW_INT
%token KW_FLOAT KW_BOOL KW_STR KW_RETURN
%token KW_FUNCTION KW_PROCEDURE KW_INCLUDE

/* Operator tokens */
%token <node> INTEGER_LITERAL
%token <node> FLOAT_LITERAL
%token <node> STRING_LITERAL
%token <string> IDENTIFIER
%token <string> COMMENT
%token OP_PLUS OP_MINUS OP_MULT OP_DIV OP_ASSIGNMENT NEWLINE OP_EXPO
%token OP_OPEN_P OP_CLOSE_P OP_OPEN_CURLY OP_CLOSE_CURLY OP_MOD
%token OP_OPEN_SQU OP_CLOSE_SQU OP_COMMA OP_DOT OP_QUOTA OP_POW
%token OP_OPEN_ANGLE OP_CLOSE_ANGLE OP_SEMICOLON POINTER
%token OP_AND OP_OR OP_NOT OP_EQ_LESS OP_EQ_GRE OP_IS_EQ OP_ISNT_EQ
%token OP_AUG_PLUS OP_AUG_MINUS OP_AUG_MULT OP_AUG_DIV OP_AUG_MOD

%type <node>    PROGRAM
%type <list>    STATEMENT_LIST
%type <node>    INT_EXP
%type <node>    BOOL_EXP
%type <node>    FLOAT_EXP
%type <node>    STRING_EXP
%type <node>    DECLARATION_STATEMENT
%type <node>    ASSIGNMENT_STATEMENT
%type <node>    EXPRESSION
%type <node>    IF_STATEMENT
%type <node>    STATEMENT
%type <node>    OPTIONAL_IF_TAIL
%type <node>    BLOCK

/* Operators precedences */
%right OP_ASSIGNMENT
%right OP_AUG_PLUS OP_AUG_MINUS
%right OP_AUG_MULT OP_AUG_DIV OP_AUG_MOD
%left  OP_OR
%left  OP_AND
%right OP_NOT
%left  OP_EQ_LESS OP_EQ_GRE OP_IS_EQ OP_ISNT_EQ OP_OPEN_ANGLE OP_CLOSE_ANGLE
%left  OP_PLUS OP_MINUS
%left  OP_MULT OP_DIV OP_MOD
%right UNARY_MINUS
%right OP_POW
%nonassoc KW_ELSE /* for dangling else */

%%
    PROGRAM:
            /* Empty program */  { $$ = new_program_node(NULL); program_root = $$; }
        |   STATEMENT_LIST       { $$ = new_program_node($1); program_root = $$; }
        ;

    STATEMENT_LIST:
            STATEMENT                       { $$ = create_statement_list($1); }
        |   STATEMENT STATEMENT_LIST        { $$ = add_statement_list($2, $1); }
        |   NEWLINE STATEMENT_LIST          { $$ = $2; }
        |   NEWLINE                         { $$ = NULL; }
        ;

    BLOCK:
            OP_OPEN_CURLY STATEMENT_LIST OP_CLOSE_CURLY { $$ = new_block_node($2); }
        |   OP_OPEN_CURLY OP_CLOSE_CURLY                { $$ = new_block_node(NULL); }
        ;

    STATEMENT:
            EXPRESSION OP_SEMICOLON     { $$ = $1; }
        |   DECLARATION_STATEMENT       { $$ = $1; }
        |   ASSIGNMENT_STATEMENT        { $$ = $1; }
        |   IF_STATEMENT                { $$ = $1; }
        ;

    IF_STATEMENT:
            KW_IF OP_OPEN_P EXPRESSION OP_CLOSE_P BLOCK OPTIONAL_IF_TAIL { $$ = new_if_node($3, $5, $6); }
        ;

    OPTIONAL_IF_TAIL:
            /* empty */ { $$ = NULL; }
        |   KW_ELIF OP_OPEN_P EXPRESSION OP_CLOSE_P BLOCK OPTIONAL_IF_TAIL { $$ = new_if_node($3, $5, $6); }
        |   KW_ELSE BLOCK { $$ = $2; }
        ;

    DECLARATION_STATEMENT:
            /* only declaration */
            KW_INT   IDENTIFIER OP_SEMICOLON    { $$ = new_variable_node($2, new_integer_literal(0)); }
        |   KW_FLOAT IDENTIFIER OP_SEMICOLON    { $$ = new_variable_node($2, new_float_literal(0.0)); }
        |   KW_BOOL  IDENTIFIER OP_SEMICOLON    { $$ = new_variable_node($2, new_bool_literal(0));    }
        |   KW_STR   IDENTIFIER OP_SEMICOLON    { $$ = new_variable_node($2, new_string_literal("")); }
            /* declaration with assignment */
        |   KW_INT   IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   { $$ = new_variable_node($2, $4); }
        |   KW_FLOAT IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   { $$ = new_variable_node($2, $4); }
        |   KW_BOOL  IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   { $$ = new_variable_node($2, $4); }
        |   KW_STR   IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   { $$ = new_variable_node($2, $4); }
        ;

    ASSIGNMENT_STATEMENT:
            IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   { $$ = new_assignment_node($1, $3); }

        /*-------------------------------------------------
            SYNOPSIS for Augmented Arithmetic Operators:
            expr1 _augmented_op_ expr2;
            will be evaluated as
            expr1 = expr1 _op_ expr2;
            (a += b;) --> (a = a + b;)
        -------------------------------------------------*/

        |   EXPRESSION OP_AUG_PLUS  EXPRESSION OP_SEMICOLON { $$ = new_augmented_assignment_node(AST_PLUS,     $1, $3); }
        |   EXPRESSION OP_AUG_MINUS EXPRESSION OP_SEMICOLON { $$ = new_augmented_assignment_node(AST_MINUS,    $1, $3); }
        |   EXPRESSION OP_AUG_MULT  EXPRESSION OP_SEMICOLON { $$ = new_augmented_assignment_node(AST_MULTIPLY, $1, $3); }
        |   EXPRESSION OP_AUG_DIV   EXPRESSION OP_SEMICOLON { $$ = new_augmented_assignment_node(AST_DIVIDE,   $1, $3); }
        |   EXPRESSION OP_AUG_MOD   EXPRESSION OP_SEMICOLON { $$ = new_augmented_assignment_node(AST_MODULO,   $1, $3); }
        ;

    EXPRESSION:
            OP_OPEN_P EXPRESSION OP_CLOSE_P { $$ = $2; }
        |   INT_EXP                         { $$ = $1; } /* INTEGER, as INT_EXP   */
        |   FLOAT_EXP                       { $$ = $1; } /* FLOAT, as FLOAT_EXP   */
        |   BOOL_EXP                        { $$ = $1; } /* BOOLEAN, as BOOL_EXP  */
        |   STRING_EXP                      { $$ = $1; } /* STRING, as STRING_EXP */
        |   IDENTIFIER                      { $$ = new_identifier_node($1); } /* Variable reference */
        |   EXPRESSION OP_PLUS  EXPRESSION  { $$ = new_binary_op(AST_PLUS,     $1, $3); }
        |   EXPRESSION OP_MINUS EXPRESSION  { $$ = new_binary_op(AST_MINUS,    $1, $3); }
        |   EXPRESSION OP_MULT  EXPRESSION  { $$ = new_binary_op(AST_MULTIPLY, $1, $3); }
        |   EXPRESSION OP_DIV   EXPRESSION  { $$ = new_binary_op(AST_DIVIDE,   $1, $3); }
        |   EXPRESSION OP_MOD   EXPRESSION  { $$ = new_binary_op(AST_MODULO,   $1, $3); }
        |   EXPRESSION OP_POW   EXPRESSION  { $$ = new_binary_op(AST_POWER,    $1, $3); }

        /*-----------------------------------------------------------------
            When we define both unary and binary - operators, Bison may
            experience ambiguity due to the different uses of this symbol.
            Using %prec, we can resolve this ambiguity by assigning a
            special precedence to the unary minus operator.
        -----------------------------------------------------------------*/

        |   OP_MINUS EXPRESSION %prec UNARY_MINUS   { $$ = new_unary_op (AST_MINUS, $2); }
        |   OP_NOT                      EXPRESSION  { $$ = new_unary_op (AST_NOT, $2); }
        |   EXPRESSION OP_OPEN_ANGLE    EXPRESSION  { $$ = new_binary_op(AST_LESS_THAN,     $1, $3); }
        |   EXPRESSION OP_CLOSE_ANGLE   EXPRESSION  { $$ = new_binary_op(AST_GREATER_THAN,  $1, $3); }
        |   EXPRESSION OP_EQ_LESS       EXPRESSION  { $$ = new_binary_op(AST_LESS_EQUAL,    $1, $3); }
        |   EXPRESSION OP_EQ_GRE        EXPRESSION  { $$ = new_binary_op(AST_GREATER_EQUAL, $1, $3); }
        |   EXPRESSION OP_IS_EQ         EXPRESSION  { $$ = new_binary_op(AST_EQUAL,         $1, $3); }
        |   EXPRESSION OP_ISNT_EQ       EXPRESSION  { $$ = new_binary_op(AST_NOT_EQUAL,     $1, $3); }
        |   EXPRESSION OP_AND           EXPRESSION  { $$ = new_binary_op(AST_AND, $1, $3); }
        |   EXPRESSION OP_OR            EXPRESSION  { $$ = new_binary_op(AST_OR, $1, $3); }
        ;

    INT_EXP:
            INTEGER_LITERAL { $$ = $1; }
        ;

    FLOAT_EXP:
            FLOAT_LITERAL { $$ = $1; }
        ;

    BOOL_EXP:
            KW_TRUE  { $$ = $1; }
        |   KW_FALSE { $$ = $1; }
        ;

    STRING_EXP:
            STRING_LITERAL { $$ = $1; }
        ;
%%

int main(int argc, char * argv[])
{
#ifdef YYDEBUG
    yydebug = 1;
#else
    yydebug = 0;
#endif
yydebug = 0;

    symbol_table = create_symbol_table();

    if (argc == 1)
    {
        printf("Type (ctrl+c) for exit\n");
        yyparse();

        if (program_root)
        {
            printf("\nDisplaying AST:\n");
            display_ast(program_root, 0, 1);
        }
        yyclearin;
    }

    else if (argc == 2)
    {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL)
        {
            printf("File not found\n");
            return 0;
        }

        if (yyparse() == 0 && program_root)
        {
            printf("\nDisplaying AST:\n");
            display_ast(program_root, 0, 1);
        }

        fclose(yyin);
    }

    else
    {
        printf("Too many arguments\n");
        printf("Usage: ./parser or ./parser <filename>\n");
        return 0;
    }
    return 0;
}
