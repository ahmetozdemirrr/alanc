/*
    This file defines the basic data types of the language and 
    performs operations associated with these data types.
*/

#ifndef VARIABLES_H
#define VARIABLES_H

/*
    This enum specifies the type of variables. It is used to 
    define the type of a variable in a program (integer, float, 
    string, boolean or null).
*/
typedef enum { INT_TYPE, FLOAT_TYPE, STRING_TYPE, BOOL_TYPE, NULL_TYPE } VarType;

typedef struct 
{
    VarType type;

    union 
    {
        int    intval;
        int    boolval;
        float  floatval;
        char * strval;
    } 
    value;
} 
Variable;

Variable create_int_var(int value);
Variable create_float_var(float value);
Variable create_bool_var(int value);

/* 
Variable create_string_var(const char * value);
 */

#endif /* VARIABLES_H */

/*
    The reason we use union in this file is that a Variable structure 
    can only hold one data type. With union, only one field occupies 
    memory at a time. So a Variable can be either an integer, a float 
    or a string. This saves memory.
*/