/* logical.c */

// local includes
#include <logical.h>


/* Convert boolean values to integers */
int bool_to_int(int boolval)
{
    return boolval ? 1 : 0;
}

/* dynamic_epsilon: Calculate dynamic epsilon based on the magnitude of the values */
float dynamic_epsilon(float a, float b)
{
    /* Take the maximum of the absolute values and multiply by a small constant */
    return FLT_EPSILON * fmax(fabs(a), fabs(b));
}

/*---------------------------------------------------------
    type_control: Ensure valid comparisons between types.
    - Allow comparisons between boolean and int/float.
    - Allow comparisons between int and float.
    - Strings can only be compared with other strings.
---------------------------------------------------------*/

void type_control(Variable a, Variable b)
{
    if (a.type == BOOL_TYPE && (b.type == INT_TYPE || b.type == FLOAT_TYPE))
    {
        return; /* bool <-> int, float */
    }
    if (b.type == BOOL_TYPE && (a.type == INT_TYPE || a.type == FLOAT_TYPE))
    {
        return;
    }
    if ((a.type == INT_TYPE && b.type == FLOAT_TYPE) || (a.type == FLOAT_TYPE && b.type == INT_TYPE))
    {
        return; /* int <-> float */
    }
    if (a.type != b.type)
    {
        yyerror("Type mismatch in comparison.\n");
    }
}

/* equal: Check if two variables are equal using dynamic epsilon for float comparisons */
int equal(Variable a, Variable b)
{
    type_control(a, b);

    switch (a.type)
    {
        case INT_TYPE:
            if (b.type == BOOL_TYPE) return a.value.intval == bool_to_int(b.value.boolval);
            return a.value.intval == b.value.intval;

        case FLOAT_TYPE:
            if (b.type == BOOL_TYPE) return fabs(a.value.floatval - bool_to_int(b.value.boolval)) < dynamic_epsilon(a.value.floatval, bool_to_int(b.value.boolval));
            if (b.type == INT_TYPE) return fabs(a.value.floatval - b.value.intval) < dynamic_epsilon(a.value.floatval, b.value.intval);
            return fabs(a.value.floatval - b.value.floatval) < dynamic_epsilon(a.value.floatval, b.value.floatval);

        case STRING_TYPE:
            return strcmp(a.value.strval, b.value.strval) == 0;

        case BOOL_TYPE:
            if (b.type == INT_TYPE) return bool_to_int(a.value.boolval) == b.value.intval;
            if (b.type == FLOAT_TYPE) return fabs(bool_to_int(a.value.boolval) - b.value.floatval) < dynamic_epsilon(bool_to_int(a.value.boolval), b.value.floatval);
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
            if (b.type == BOOL_TYPE) return a.value.intval < bool_to_int(b.value.boolval);
            if (b.type == FLOAT_TYPE) return a.value.intval < b.value.floatval;
            return a.value.intval < b.value.intval;

        case FLOAT_TYPE:
            if (b.type == BOOL_TYPE) return a.value.floatval < bool_to_int(b.value.boolval);
            if (b.type == INT_TYPE) return a.value.floatval < b.value.intval;
            return a.value.floatval < b.value.floatval;

        case STRING_TYPE:
            return strcmp(a.value.strval, b.value.strval) < 0;

        case BOOL_TYPE:
            if (b.type == INT_TYPE) return bool_to_int(a.value.boolval) < b.value.intval;
            if (b.type == FLOAT_TYPE) return bool_to_int(a.value.boolval) < b.value.floatval;
            return a.value.boolval < b.value.boolval;

        default:
            yyerror("Unsupported type in comparison.\n");
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
            if (b.type == BOOL_TYPE) return a.value.intval > bool_to_int(b.value.boolval);
            if (b.type == FLOAT_TYPE) return a.value.intval > b.value.floatval;
            return a.value.intval > b.value.intval;

        case FLOAT_TYPE:
            if (b.type == BOOL_TYPE) return a.value.floatval > bool_to_int(b.value.boolval);
            if (b.type == INT_TYPE) return a.value.floatval > b.value.intval;
            return a.value.floatval > b.value.floatval;

        case STRING_TYPE:
            return strcmp(a.value.strval, b.value.strval) > 0;

        case BOOL_TYPE:
            if (b.type == INT_TYPE) return bool_to_int(a.value.boolval) > b.value.intval;
            if (b.type == FLOAT_TYPE) return bool_to_int(a.value.boolval) > b.value.floatval;
            return a.value.boolval > b.value.boolval;

        default:
            yyerror("Unsupported type in comparison.\n");
    }
}

int greater_equal(Variable a, Variable b)
{
    return greater_than(a, b) || equal(a, b);
}
