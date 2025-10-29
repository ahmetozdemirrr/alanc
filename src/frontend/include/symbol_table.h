/* src/frontend/include/symbol_table.h */

#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <utils.h>

typedef enum 
{
    NULL_TYPE,
    INT_TYPE,
    FLOAT_TYPE,
    STRING_TYPE,
    BOOL_TYPE
} 
VariableType;

typedef union 
{
    int    boolval;
    int    intval;
    char*  strval;
    double floatval;
} 
Value;

typedef struct 
{
    VariableType type;
    Value value;
} 
Variable;

typedef struct SymbolTable 
{   
	/*----------------------------- Symbol's --------------------- */
	char* name;                 /* -> name                         */
	Variable value;             /* -> variable type and it's value */
	struct SymbolTable*  next;  /* -> next symbol('s)              */
} 
SymbolTable;

extern SymbolTable* symbol_table;

SymbolTable* create_symbol_table();
Variable* get_var(SymbolTable* table, char* name);

void set_var(SymbolTable** table, char* name, Variable value);
void free_symbol_table(SymbolTable* table);
void print_symbol_table(SymbolTable* table);

#endif /* SYMBOL_TABLE_H */


/*
	For now the symbol table is impelemented as a linked-list. However,
	this has some drawbacks from a language point of view:

	- As in Python interpreters, if there is a variable with the same
	value, instead of creating a new one, the same reference should be
	used in cases where the type and value match the previous ones

		int a = 10;
		int b = 10; -> Instead of occupying a new block of memory for b,
		the address of a is used until the value needs to be changed.

	For this and similar optimizations, the linked-list data structure
	will not be very suitable in terms of element search. Because the
	time complexity is 0(n) in this case. Instead, a hash-table or other
	data structure can be used...
*/
