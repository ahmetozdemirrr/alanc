%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "../include/utils.h"
    #include "../include/logical.h"
    #include "../include/variables.h"
    #include "../include/symbol_table.h"
    
    #define YYDEBUG 1

    extern FILE * yyin; /* for printing to file */
    extern int yydebug; /* for debugging mode   */
%}  

%union 
{
    int    intval;      /* for Integer types          */
    float  floatval;    /* for Float types            */
    char * string;      /* for String types           */
    int    boolean;     /* for Boolean types (0 or 1) */
    void * nullval;     /* for Null                   */
    Variable var;
}

/* Keyword tokens */
%token <boolean> KW_TRUE KW_FALSE
%token <nullval> KW_NULL
%token KW_IF KW_ELSE KW_ELIF KW_INT 
%token KW_FLOAT KW_BOOL KW_STR KW_RETURN
%token KW_FUNCTION KW_PROCEDURE KW_INCLUDE

/* Operator tokens */
%token <intval> INTEGER_LITERAL
%token <floatval> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <string> IDENTIFIER
%token <string> COMMENT
%token OP_PLUS OP_MINUS OP_MULT OP_DIV OP_ASSIGNMENT NEWLINE OP_EXPO
%token OP_OPEN_P OP_CLOSE_P OP_OPEN_CURLY OP_CLOSE_CURLY OP_MOD
%token OP_OPEN_SQU OP_CLOSE_SQU OP_COMMA OP_DOT OP_QUOTA OP_POW
%token OP_OPEN_ANGLE OP_CLOSE_ANGLE OP_SEMICOLON POINTER
%token OP_AND OP_OR OP_NOT OP_EQ_LESS OP_EQ_GRE OP_IS_EQ OP_ISNT_EQ
%token OP_AUG_PLUS OP_AUG_MINUS OP_AUG_MULT OP_AUG_DIV OP_AUG_MOD


%start PROGRAM
%type <intval>   INT_EXP
%type <intval>   BOOL_EXP
%type <floatval> FLOAT_EXP
%type <string>   STRING_EXP
%type <var>      EXPRESSION
%type <var>      STATEMENT


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


%%
    PROGRAM:
        /* Empty program */
        |   PROGRAM STATEMENT
        |   PROGRAM NEWLINE
        ;

    STATEMENT:
            EXPRESSION OP_SEMICOLON     { 
                                            switch ($1.type) 
                                            {
                                                case INT_TYPE:
                                                    printf("Result: %d\n", $1.value.intval);
                                                    break;
                                                case FLOAT_TYPE:
                                                    printf("Result: %f\n", $1.value.floatval);
                                                    break;
                                                case STRING_TYPE:
                                                    printf("Result: %s\n", $1.value.strval);
                                                    break;
                                                case BOOL_TYPE:
                                                    printf("Result: %s\n", $1.value.boolval ? "true" : "false");
                                                    break;
                                                default:
                                                    printf("Unknown type\n");
                                            }      
                                        }

        |   KW_INT   IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   { 
                                                                            if ($4.type != INT_TYPE) 
                                                                            {
                                                                                yyerror("Type mismatch: Expected INT type\n");
                                                                                YYERROR;
                                                                            }

                                                                            else
                                                                            {
                                                                                $$ = $4; 
                                                                                set_var(&symbol_table, $2, create_int_var($4.value.intval));
                                                                            }
                                                                        }
        |   KW_FLOAT IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   { 
                                                                            if ($4.type != FLOAT_TYPE && $4.type != INT_TYPE)
                                                                            {
                                                                                yyerror("Type mismatch: Expected FLOAT or INT type\n");
                                                                                YYERROR;
                                                                            }

                                                                            else
                                                                            {
                                                                                if ($4.type == INT_TYPE)
                                                                                {
                                                                                    $$ = create_float_var((float)$4.value.intval);
                                                                                    set_var(&symbol_table, $2, $$); 
                                                                                }

                                                                                else
                                                                                {
                                                                                    $$ = $4; 
                                                                                    set_var(&symbol_table, $2, create_float_var($4.value.floatval)); 
                                                                                }
                                                                            }
                                                                        }
        |   KW_BOOL  IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   {
                                                                            if ($4.type != BOOL_TYPE)
                                                                            {
                                                                                yyerror("Type mismatch: Expected BOOL type\n");
                                                                                YYERROR;
                                                                            }

                                                                            else
                                                                            {
                                                                                $$ = $4; 
                                                                                set_var(&symbol_table, $2, create_bool_var($4.value.boolval)); 
                                                                            }  
                                                                        }
        |   KW_STR   IDENTIFIER OP_ASSIGNMENT EXPRESSION OP_SEMICOLON   {
                                                                            if ($4.type != STRING_TYPE)
                                                                            {
                                                                                yyerror("Type mismatch: Expected STR type\n");
                                                                                YYERROR;
                                                                            }

                                                                            else 
                                                                            {
                                                                                $$ = $4; 
                                                                                set_var(&symbol_table, $2, create_str_var($4.value.strval));  
                                                                            }    
                                                                        }
        |   KW_INT   IDENTIFIER OP_SEMICOLON    { 
                                                    if (get_var(symbol_table, $2) != NULL) 
                                                    {
                                                        yyerror("Variable already defined\n");
                                                        YYERROR;
                                                    } 

                                                    else 
                                                    {
                                                        set_var(&symbol_table, $2, create_int_var(0));     
                                                    }
                                                }
        |   KW_FLOAT IDENTIFIER OP_SEMICOLON    {
                                                    if (get_var(symbol_table, $2) != NULL) 
                                                    {
                                                        yyerror("Variable already defined\n");
                                                        YYERROR;
                                                    } 

                                                    else
                                                    {
                                                        set_var(&symbol_table, $2, create_float_var(0.0)); 
                                                    }
                                                }
        |   KW_BOOL  IDENTIFIER OP_SEMICOLON    { 
                                                    if (get_var(symbol_table, $2) != NULL) 
                                                    {
                                                        yyerror("Variable already defined\n");
                                                        YYERROR;
                                                    }

                                                    else
                                                    {
                                                        set_var(&symbol_table, $2, create_bool_var(0));   
                                                    } 
                                                }
        |   KW_STR   IDENTIFIER OP_SEMICOLON    { 
                                                    if (get_var(symbol_table, $2) != NULL) 
                                                    {
                                                        yyerror("Variable already defined\n");
                                                        YYERROR;
                                                    } 

                                                    else
                                                    {
                                                        set_var(&symbol_table, $2, create_str_var(NULL));     
                                                    }
                                                }
        |   OP_SEMICOLON    { 
                                Variable null_var;
                                null_var.type = NULL_TYPE;
                                $$ = null_var;
                            }
        ;

    EXPRESSION:
            INT_EXP                         { $$ = create_int_var($1);   } /* INTEGER, as INT_EXP   */
        |   FLOAT_EXP                       { $$ = create_float_var($1); } /* FLOAT, as FLOAT_EXP   */
        |   BOOL_EXP                        { $$ = create_bool_var($1);  } /* BOOLEAN, as BOOL_EXP  */
        |   STRING_EXP                      { $$ = create_str_var($1);   } /* STRING, as STRING_EXP */
        |   IDENTIFIER                      {
                                                Variable * var = get_var(symbol_table, $1);
                                                
                                                if (var == NULL) 
                                                {
                                                    yyerror("Undefined variable\n");
                                                }
                                                $$ = *var;
                                            }
        |   OP_OPEN_P EXPRESSION OP_CLOSE_P { $$ = $2; }   
        |   EXPRESSION OP_PLUS EXPRESSION   {
                                                if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_int_var($1.value.intval + $3.value.intval);
                                                }

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval + $3.value.floatval);
                                                }

                                                else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval + (float)$3.value.intval);
                                                }

                                                else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var((float)$1.value.intval + $3.value.floatval);
                                                }

                                                else if ($1.type == STRING_TYPE && $3.type == STRING_TYPE) 
                                                {
                                                    char * concat = malloc(strlen($1.value.strval) + strlen($3.value.strval) + 1);
                                                    strcpy(concat, $1.value.strval);
                                                    strcat(concat, $3.value.strval);
                                                    $$ = create_str_var(concat);
                                                    free(concat);
                                                }

                                                else 
                                                {
                                                    yyerror("Type mismatch: Not suitable types for '+' operator\n");
                                                    YYERROR;
                                                }
                                            }
        |   EXPRESSION OP_MINUS EXPRESSION  {
                                                if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_int_var($1.value.intval - $3.value.intval);
                                                } 

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval - $3.value.floatval);
                                                } 

                                                else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var((float)$1.value.intval - $3.value.floatval);
                                                } 

                                                else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval - (float)$3.value.intval);
                                                } 

                                                else {
                                                    yyerror("Type mismatch: Unsupported types for '*' operator\n");
                                                    YYERROR;
                                                }  
                                            }
        |   EXPRESSION OP_MULT  EXPRESSION  {
                                                if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_int_var($1.value.intval * $3.value.intval);
                                                } 

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval * $3.value.floatval);
                                                } 

                                                else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var((float)$1.value.intval * $3.value.floatval);
                                                } 

                                                else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval * (float)$3.value.intval);
                                                } 

                                                else {
                                                    yyerror("Type mismatch: Unsupported types for '*' operator\n");
                                                    YYERROR;
                                                } 
                                            }
        |   EXPRESSION OP_DIV   EXPRESSION  {
                                                if (($3.type == INT_TYPE   && $3.value.intval == 0) ||
                                                    ($3.type == FLOAT_TYPE && $3.value.floatval == 0.0)) 
                                                {
                                                    yyerror("Division by zero\n");
                                                    YYERROR;
                                                } 

                                                else if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_float_var((float)$1.value.intval / $3.value.intval);
                                                } 

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var($1.value.floatval / $3.value.floatval);
                                                } 

                                                else 
                                                {
                                                    yyerror("Type mismatch: Unsupported types for '/' operator\n");
                                                    YYERROR;
                                                }
                                            }
        |   EXPRESSION OP_MOD   EXPRESSION  {
                                                if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    
                                                    if ($3.value.intval == 0) 
                                                    {
                                                        yyerror("Division by zero in modulus operation\n");
                                                        YYERROR;
                                                    } 

                                                    else 
                                                    {
                                                        $$ = create_int_var($1.value.intval % $3.value.intval);
                                                    }
                                                } 

                                                else 
                                                {
                                                    yyerror("Type mismatch: Modulus requires integer operands\n");
                                                    YYERROR;
                                                }
                                            }
        |   EXPRESSION OP_POW   EXPRESSION  {
                                                if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_int_var((int)pow($1.value.intval, $3.value.intval));
                                                }

                                                else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var(pow($1.value.floatval, $3.value.floatval));
                                                }

                                                else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) 
                                                {
                                                    $$ = create_float_var(pow((float) $1.value.intval, $3.value.floatval));
                                                }

                                                else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                {
                                                    $$ = create_float_var(pow($1.value.floatval, (float) $3.value.intval));
                                                }

                                                else 
                                                {
                                                    yyerror("Type mismatch: Unsupported types for power operator\n");
                                                    YYERROR;
                                                }
                                            }

        |   IDENTIFIER OP_ASSIGNMENT EXPRESSION {
                                                    Variable * var = get_var(symbol_table, $1);

                                                    if (var == NULL) 
                                                    {
                                                        yyerror("Variable not defined\n");
                                                        YYERROR;
                                                    } 

                                                    else 
                                                    {
                                                        if (var->type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                        {
                                                            var->value.floatval = (float)$3.value.intval;
                                                        }
                                                        else if (var->type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                        {
                                                            var->value.floatval = $3.value.floatval;
                                                        }
                                                        else if (var->type == INT_TYPE && $3.type == INT_TYPE) 
                                                        {
                                                            var->value.intval = $3.value.intval;
                                                        } 

                                                        else
                                                        {
                                                            yyerror("Type mismatch in assignment\n");
                                                            YYERROR;
                                                        }
                                                    }
                                                    
                                                }
        /*-------------------------------------------------
            SYNOPSIS for Augmented Arithmetic Operators:

            expr1 _augmented_op_ expr2; 
            will be evaluated as
            expr1 = expr1 _op_ expr2;
            (a += b;) --> (a = a + b;)
        -------------------------------------------------*/

        |   EXPRESSION OP_AUG_PLUS  EXPRESSION  {
                                                    if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.intval += $3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                    {
                                                        $1.value.floatval += $3.value.floatval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) 
                                                    {
                                                        float temp = (float)$1.value.intval;
                                                        temp += $3.value.floatval;
                                                        $1.value.floatval = temp;
                                                        $1.type = FLOAT_TYPE;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.floatval += (float)$3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == STRING_TYPE && $3.type == STRING_TYPE) 
                                                    {
                                                        char * concat = malloc(strlen($1.value.strval) + strlen($3.value.strval) + 1);
                                                        strcpy(concat, $1.value.strval);
                                                        strcat(concat, $3.value.strval);
                                                        free($1.value.strval);
                                                        $1.value.strval = concat;
                                                        $$ = $1;
                                                    } 

                                                    else 
                                                    {
                                                        yyerror("Type mismatch: incompatible types for '+='\n");
                                                        YYERROR;
                                                    }
                                                }
        |   EXPRESSION OP_AUG_MINUS EXPRESSION  {
                                                    if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.intval -= $3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                    {
                                                        $1.value.floatval -= $3.value.floatval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) 
                                                    {
                                                        float temp = (float)$1.value.intval;
                                                        temp += $3.value.floatval;
                                                        $1.value.floatval = temp; // INT -> FLOAT dönüşüm
                                                        $1.type = FLOAT_TYPE; // Tipi float yapıyoruz
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.floatval -= (float)$3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else 
                                                    {
                                                        yyerror("Type mismatch: incompatible types for '-='\n");
                                                        YYERROR;
                                                    }
                                                }
        |   EXPRESSION OP_AUG_MULT  EXPRESSION  {
                                                    if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.intval *= $3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                    {
                                                        $1.value.floatval *= $3.value.floatval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) 
                                                    {
                                                        float temp = (float)$1.value.intval;
                                                        temp += $3.value.floatval;
                                                        $1.value.floatval = temp; // INT -> FLOAT dönüşüm
                                                        $1.type = FLOAT_TYPE; // Tipi float yapıyoruz
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.floatval *= (float)$3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else 
                                                    {
                                                        yyerror("Type mismatch: incompatible types for '*='\n");
                                                        YYERROR;
                                                    }
                                                }
        |   EXPRESSION OP_AUG_DIV   EXPRESSION  {
                                                    if (($3.type == INT_TYPE   && $3.value.intval == 0) ||
                                                        ($3.type == FLOAT_TYPE && $3.value.floatval == 0.0)) 
                                                    {
                                                        yyerror("Division by zero\n");
                                                        YYERROR;
                                                    } 

                                                    else if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.intval /= $3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) 
                                                    {
                                                        $1.value.floatval /= $3.value.floatval;
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) 
                                                    {
                                                        float temp = (float)$1.value.intval;
                                                        temp += $3.value.floatval;
                                                        $1.value.floatval = temp; // INT -> FLOAT dönüşüm
                                                        $1.type = FLOAT_TYPE; // Tipi float yapıyoruz
                                                        $$ = $1;
                                                    } 

                                                    else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.floatval /= (float)$3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else 
                                                    {
                                                        yyerror("Type mismatch: incompatible types for '/='\n");
                                                        YYERROR;
                                                    }
                                                }
        |   EXPRESSION OP_AUG_MOD   EXPRESSION  {
                                                    if ($3.type == INT_TYPE && $3.value.intval == 0) 
                                                    {
                                                        yyerror("Division by zero\n");
                                                        YYERROR;
                                                    } 

                                                    else if ($1.type == INT_TYPE && $3.type == INT_TYPE) 
                                                    {
                                                        $1.value.intval %= $3.value.intval;
                                                        $$ = $1;
                                                    } 

                                                    else 
                                                    {
                                                        yyerror("Type mismatch: incompatible types for '%='\n");
                                                        YYERROR;
                                                    }
                                                }

        /*-----------------------------------------------------------------
            When we define both unary and binary - operators, Bison may
            experience ambiguity due to the different uses of this symbol.
            Using %prec, we can resolve this ambiguity by assigning a 
            special precedence to the unary minus operator.
        -----------------------------------------------------------------*/

        |   OP_MINUS EXPRESSION %prec UNARY_MINUS   {
                                                        if ($2.type == INT_TYPE)
                                                        {
                                                            $$ = create_int_var(-$2.value.intval);
                                                        } 

                                                        else if ($2.type == FLOAT_TYPE)
                                                        {
                                                            $$ = create_float_var(-$2.value.floatval);
                                                        } 

                                                        else
                                                        {
                                                            yyerror("Unary minus can only be applied to numbers\n");
                                                            YYERROR;
                                                        } 
                                                    }
        /*
            TO DO and some notes:

            - What action should we take if there is a type difference between 
              operands in comparison and relational operators? 
            
            For example:
                
                bool val1 = 4.5 < 5;
                
            - Should and, or and not only accept booleans?
            - Implement CFG for sequentially strung comparison operators, e.g:
                
                bool val2 = 4 < 5 < 6;
                
                Here is the logic that I think should happen here: 
                
                ex1 = 4 < 5;
                ex2 = 5 < 6;
                ex3 = ex1 and ex2;
        */

        |   EXPRESSION OP_OPEN_ANGLE    EXPRESSION  {
                                                        $$ = create_bool_var(less_than($1, $3));
                                                    }
        |   EXPRESSION OP_CLOSE_ANGLE   EXPRESSION  {
                                                        $$ = create_bool_var(greater_than($1, $3));
                                                    }
        |   EXPRESSION OP_EQ_LESS       EXPRESSION  {
                                                        $$ = create_bool_var(less_equal($1, $3));
                                                    }
        |   EXPRESSION OP_EQ_GRE        EXPRESSION  {
                                                        $$ = create_bool_var(greater_equal($1, $3));
                                                    }
        |   EXPRESSION OP_IS_EQ         EXPRESSION  {
                                                        $$ = create_bool_var(equal($1, $3));
                                                    }
        |   EXPRESSION OP_ISNT_EQ       EXPRESSION  {
                                                        $$ = create_bool_var(not_equal($1, $3));
                                                    }
        |   EXPRESSION OP_AND           EXPRESSION  {
                                                        if ($1.type == BOOL_TYPE && $3.type == BOOL_TYPE)
                                                        {
                                                            $$ = create_bool_var($1.value.boolval && $3.value.boolval);
                                                        } 

                                                        else
                                                        {
                                                            yyerror("Type mismatch: 'and' operator requires boolean operands\n");
                                                            YYERROR;
                                                        }
                                                    }
        |   EXPRESSION OP_OR            EXPRESSION  {
                                                        if ($1.type == BOOL_TYPE && $3.type == BOOL_TYPE)
                                                        {
                                                            $$ = create_bool_var($1.value.boolval || $3.value.boolval);
                                                        } 

                                                        else
                                                        {
                                                            yyerror("Type mismatch: 'or' operator requires boolean operands\n");
                                                            YYERROR;
                                                        }                                                    
                                                    }
        |   OP_NOT                      EXPRESSION  {
                                                        if ($2.type == BOOL_TYPE)
                                                        {
                                                            $$ = create_bool_var(!($2.value.boolval));
                                                        } 

                                                        else
                                                        {
                                                            yyerror("Type mismatch: 'not' operator requires a boolean operand\n");
                                                            YYERROR;
                                                        }
                                                    }                                                                                                                                                                                              
        ;

    INT_EXP:
            INTEGER_LITERAL { $$ = $1; }
        ;

    BOOL_EXP:
            KW_TRUE  { $$ = $1; }  /* true  -> 1, from lexer */
        |   KW_FALSE { $$ = $1; }  /* false -> 0, from lexer */
        ;

    FLOAT_EXP:
            FLOAT_LITERAL { $$ = $1; }
        ;

    STRING_EXP:
            STRING_LITERAL { $$ = $1; }
        ;
%%

int main(int argc, char * argv[])
{
    /* yydebug = 0;   inactivating debugging */
    yydebug = 0;     /* activating debugging */

    symbol_table = create_symbol_table();

    if (argc == 1)
    {
        printf("Type (ctrl+c) for exit\n");

        yyparse();
        /* cleaning input */
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
        yyparse();
    }
    
    else
    {
        printf("Too many arguments\n");
        printf("Usage: ./parser or ./parser <filename>\n");
        return 0;
    }
    return 0;
}

/*________________________________________________________________________________

    SUMMARY 30.10.2024
    __________________

    Added by Ahmet Özdemir
    __________________

    The work done today is as follows: 
    
    _______________________________________________________________________________

    Detecting and Checking Variable Type Mismatches: For variable types such as int, 
    float, bool, and str, we checked whether there is a mismatch between the type of 
    the expression on the right and the type of the variable on the left during 
    definition. If the types do not match, the program throws an error with the 
    appropriate error message (Type mismatch: Expected ... type). 

    For example: 

    int a = 5.5; 
    will give a Type mismatch: Expected INT type error. 

    str b = 45; 
    will give a Type mismatch: Expected STR type error.
    _______________________________________________________________________________
    _______________________________________________________________________________

    Checking if the variable is already defined: Before defining a new variable, it is 
    checked if the variable is already defined in the symbol table. If the variable is 
    already defined, an error Variable already defined is returned, preventing it from 
    being defined again with the same name. 

    Example: 
    int a; int a; will return Variable already defined error.
    _______________________________________________________________________________
    _______________________________________________________________________________

    Type Incompatibility Check for Mathematical and Logical Operators: When mathematical 
    and logical operators (for example, +, -, *, /, and, or) are used, it is checked 
    whether the types of the operands are compatible with each other. If the operands 
    are of incompatible types, error messages are returned. 

    Example: In the expression a + b, if a and b are of different types, a Type m
    ismatch: Not suitable types for '+' operator error will be given. Using 
    incompatible types like true + 5 with an operator will return a 
    Type mismatch: Not suitable types for '+' operator error.
    _______________________________________________________________________________
    _______________________________________________________________________________

    Variable Assignment Checks: When a new value is assigned to a variable, it is 
    checked whether the type of the assigned value matches the type of the variable. 
    If the types do not match, a Type mismatch in assignment error is thrown. 

    Example: int a = 10; a = "hello"; will give a Type mismatch in assignment error.
    _______________________________________________________________________________
*/
