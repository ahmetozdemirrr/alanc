#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum 
{
	AST_PROGRAM,
	AST_STATEMENTS,

	AST_INT_LITERAL,
	AST_FLOAT_LITERAL,
	AST_STRING_LITERAL,
	AST_BOOL_LITERAL,
	AST_NULL_LITERAL,

	AST_VARIABLE_DECLARATION,
	AST_ASSIGNMENT_STATEMENT,
	AST_IDENTIFIER,

	AST_PLUS,
	AST_MINUS,
	AST_MULTIPLY,
	AST_DIVIDE,
	AST_MODULO,
	AST_POWER,
	AST_AND,
	AST_OR,
	AST_NOT,

	AST_LESS_THAN,
	AST_GREATER_THAN,
	AST_LESS_EQUAL,
	AST_GREATER_EQUAL,
	AST_EQUAL,
	AST_NOT_EQUAL,

	AST_IF_STATEMENT,
	AST_ELIF_STATEMENT,
	AST_ELSE_STATEMENT,

	AST_FOR_STATEMENT,

	AST_FUNCTION_DECLARATION,
	AST_FUNCTION_CALL,

	AST_PROCEDURE_DECLARATION,
	AST_PROCEDURE_CALL,

	AST_BLOCK,
	AST_EXPRESSION
} 
ASTNodeType;

struct ASTNode;

typedef union
{
	int intValue;
	float floatValue;
	char * stringValue;
	int boolValue;
}
LiteralValue;


/* Structure for unary operation nodes */
typedef struct
{
	struct ASTNode * operand;
} 
UnaryOpNode;


/* Structure for binary operation nodes */
typedef struct
{
	struct ASTNode * left;
	struct ASTNode * right;
}
BinaryOpNode;


/* Structure for if-elif-else nodes */
typedef struct
{
	struct ASTNode * condition;
	struct ASTNode * thenBranch;
	struct ASTNode * elseBranch;
}
IfNode;

typedef struct
{
	struct ASTNode * initialization;
	struct ASTNode * condition;
	struct ASTNode * increment;
	struct ASTNode * body;
}
ForNode;

/* struct for variable declaration/assignment nodes */
typedef struct 
{
	char * variableName;
	struct ASTNode * expression;
}
VariableNode;


/* Structure for list of statements */
typedef struct ASTNodeList
{
	struct ASTNode * statement;
	struct ASTNodeList * next;
}
ASTNodeList;


/* Main AST node structure */
typedef struct ASTNode 
{
	ASTNodeType type;

	union
	{
		LiteralValue 	 literal;
		BinaryOpNode 	binaryOp;
		UnaryOpNode 	 unaryOp;
		IfNode 			  ifNode;
		ForNode			 forNode;
		VariableNode 	variable;
		ASTNodeList * statements;
	}
	data;
} 
ASTNode;

ASTNode * new_ast_node(ASTNodeType type);
ASTNode * new_integer_literal(int value);
ASTNode * new_float_literal(float value);
ASTNode * new_string_literal(char * value);
ASTNode * new_bool_literal(int value);
ASTNode * new_identifier_node(char * variableName);
ASTNode * new_binary_op(ASTNodeType type, ASTNode * left, ASTNode * right);
ASTNode * new_unary_op(ASTNodeType type, ASTNode * operand);
ASTNode * new_if_node(ASTNode * condition, ASTNode * thenBranch, ASTNode * elseBranch);
ASTNode * new_for_node(ASTNode * initialization, ASTNode * condition, ASTNode * increment, ASTNode * body);
ASTNode * new_block_node(ASTNodeList * statements);
ASTNode * new_variable_node(char * variableName, ASTNode * expression);
ASTNode * new_assignment_node(char * variableName, ASTNode * expression);
ASTNode * new_augmented_assignment_node(ASTNodeType type, ASTNode * variable, ASTNode * expression);
ASTNode * new_program_node(ASTNodeList * statements);

ASTNodeList * add_statement_list(ASTNodeList * list1, ASTNode * statement);
ASTNodeList * create_statement_list(ASTNode * statement);
ASTNodeList * new_statement_list(ASTNode * first, ASTNode * second);
ASTNodeList * merge_statement_lists(ASTNodeList * list1, ASTNodeList * list2);

void free_ast_node(ASTNode * node);
void display_ast(ASTNode * node, int indent, int is_last);
void display_ast_list(ASTNodeList * list, int indent);

#endif /* AST_H */
