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
            fprintf(stderr, "Unsupported type in equality comparison.\n");
            exit(EXIT_FAILURE);
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
            fprintf(stderr, "Unsupported type in equality comparison.\n");
            exit(EXIT_FAILURE);
    }
}

int greater_equal(Variable a, Variable b) 
{
    return greater_than(a, b) || equal(a, b);
}

void type_control(Variable a, Variable b)
{
	if (a.type != b.type) 
    {
        fprintf(stderr, "Type mismatch in equality comparison.\n");
        exit(EXIT_FAILURE);
    }
}
