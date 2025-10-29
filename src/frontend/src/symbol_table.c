/* src/frontend/src/symbol_table.c */

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/* local includes */
#include <symbol_table.h>

SymbolTable* symbol_table = NULL;

SymbolTable* create_symbol_table()
{
    return NULL;
}

void set_var(SymbolTable** table, char* name, Variable value)
{
    if (*table == NULL)
    {
        *table = (SymbolTable*)malloc(sizeof(SymbolTable));
        (*table)->name = strdup(name);
        (*table)->value = value;
        (*table)->next = NULL;
    }

    else
    {
        SymbolTable* entry = *table;

        while (entry != NULL)
        {
            if (strcmp(entry->name, name) == 0)
            {
                char error_msg_buffer[100];
                sprintf(error_msg_buffer, "Error: Variable '%s' is already defined.\n", name);
                yyerror(error_msg_buffer);
            }
            entry = entry->next;
        }
        SymbolTable* newEntry = (SymbolTable*)malloc(sizeof(SymbolTable));
        newEntry->name = strdup(name);
        newEntry->value = value;
        newEntry->next = *table;
        *table = newEntry;
    }
    // print_symbol_table(*table);
}


/*------------------------------------------------
    TO DO:
    - add control for predefined variables

    Here's how it works now:
    ___________________
    > str a = "ahmet";
    > int a = 4;
    > a + a;
    > Result: 8
    ___________________

------------------------------------------------*/

Variable* get_var(SymbolTable* table, char* name)
{
    while (table != NULL)
    {
        if (table->name != NULL && strcmp(table->name, name) == 0)
        {
            return &table->value;
        }
        table = table->next;
    }
    return NULL;
}

void free_symbol_table(SymbolTable* table)
{
    while (table != NULL)
    {
        SymbolTable* temp = table;
        table = table->next;
        free(temp->name);
        destroy_variable(&temp->value); /* Değişkeni serbest bırak */
        free(temp);
    }
}

void print_symbol_table(SymbolTable* table)
{
    SymbolTable* entry = table;

    printf("Symbol Table:\n");
    printf("-----------------------------\n");

    while (entry != NULL)
    {
        printf("Name: %s, Type: ", entry->name);

        switch (entry->value.type)
        {
            case INT_TYPE:
                printf("INT, Value: %d\n", entry->value.value.intval);
                break;

            case FLOAT_TYPE:
                printf("FLOAT, Value: %f\n", entry->value.value.floatval);
                break;

            case STRING_TYPE:
                printf("STRING, Value: %s\n", entry->value.value.strval);
                break;

            case BOOL_TYPE:
                printf("BOOL, Value: %s\n", entry->value.value.boolval ? "true" : "false");
                break;

            case NULL_TYPE:
                printf("NULL\n");
                break;
        }
        entry = entry->next;
    }
    printf("-----------------------------\n");
}

void destroy_variable(Variable* var)
{
    if (var == NULL)
    {
        return;
    }

    if (var->type == STRING_TYPE && var->value.strval != NULL)
    {
        free(var->value.strval);
        var->value.strval = NULL;
    }
}
