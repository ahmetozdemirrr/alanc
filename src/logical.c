/* logical.c */

#include "logical.h"

int equal(Variable a, Variable b) 
{
    type_control(a, b);

    switch (a.type) 
    {
        case INT_TYPE:
            return a.value.intval == b.value.intval;
        case FLOAT_TYPE:
            return a.value.floatval == b.value.floatval;
        case STRING_TYPE:
            return strcmp(a.value.strval, b.value.strval) == 0;
        case BOOL_TYPE:
            return a.value.boolval == b.value.boolval;
        default:
            return 0;
    }
}

int not_equal(Variable a, Variable b) 
{
    return !equal(a, b);
}

int less_than(Variable a, Variable b) 
{
    type_control(a, b);

    switch (a.type) 
    {
        case INT_TYPE:
            return a.value.intval < b.value.intval;
        case FLOAT_TYPE:
            return a.value.floatval < b.value.floatval;
        case STRING_TYPE:
            return strcmp(a.value.strval, b.value.strval) < 0;
        case BOOL_TYPE:
            return a.value.boolval < b.value.boolval;
        default:
            yyerror("Unsupported type in equality comparison.\n");
    }
}

int less_equal(Variable a, Variable b) 
{
    return less_than(a, b) || equal(a, b);
}

int greater_than(Variable a, Variable b) 
{
    type_control(a, b);

    switch (a.type) 
    {
        case INT_TYPE:
            return a.value.intval > b.value.intval;
        case FLOAT_TYPE:
            return a.value.floatval > b.value.floatval;
        case STRING_TYPE:
            return strcmp(a.value.strval, b.value.strval) > 0;
        case BOOL_TYPE:
            return a.value.boolval > b.value.boolval;
        default:
            yyerror("Unsupported type in equality comparison.\n");
    }
}

int greater_equal(Variable a, Variable b) 
{
    return greater_than(a, b) || equal(a, b);
}


/*-------------------------------------------------------
    TO DO:
    _______________________________________________
    What is required here is to identify types that
    cannot be processed in relation to each other 
    and return an appropriate response. 
    _______________________________________________

    For Example:

    4 > true;
    should also be considered valid. Because 'true' 
    is actually held as 1. However

    “number” > 3; 
    should not be considered valid.
    |
    |
    v
-------------------------------------------------------*/

void type_control(Variable a, Variable b)
{
	if (a.type != b.type) 
    {
        yyerror("Type mismatch in comparison.\n");
    }
}
