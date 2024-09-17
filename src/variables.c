#include <stdlib.h>
#include <string.h>
#include "../include/variables.h"

Variable create_int_var(int value) 
{
    Variable var;
    var.type = INT_TYPE;
    var.value.intval = value;

    return var;
}

Variable create_float_var(float value) 
{
    Variable var;
    var.type = FLOAT_TYPE;
    var.value.floatval = value;
    
    return var;
}

Variable create_bool_var(int value) 
{
    Variable var;
    var.type = BOOL_TYPE;
    var.value.boolval = value;
    
    return var;
}

/* 
Variable create_str_var(float value) 
{
    Variable var;
    var.type = FLOAT_TYPE;
    var.value.floatval = value;
    
    return var;
}
 */
