/* ast.c */

#include <ast.h>

/* Creates a new AST node with the given type */
ASTNode * new_ast_node(ASTNodeType type)
{
	ASTNode * node = (ASTNode *)malloc(sizeof(ASTNode));

	if (!node)
	{
		fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
	}
	node->type = type;

	return node;
}

/* Creates a new integer literal AST node */
ASTNode * new_integer_literal(int value)
{
	ASTNode * node = new_ast_node(AST_INT_LITERAL);
	node->data.literal.intValue = value;

	return node;
}

/* Creates a new float literal AST node */
ASTNode * new_float_literal(float value)
{
	ASTNode * node = new_ast_node(AST_FLOAT_LITERAL);
	node->data.literal.floatValue = value;

	return node;
}

/* Creates a new string literal AST node */
ASTNode * new_string_literal(char * value)
{
	ASTNode * node = new_ast_node(AST_STRING_LITERAL);
	node->data.literal.stringValue = strdup(value);

	if (!node->data.literal.stringValue) 
	{
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
	return node;
}

/* Creates a new boolean literal AST node */
ASTNode * new_bool_literal(int value)
{
	ASTNode * node = new_ast_node(AST_BOOL_LITERAL);
	node->data.literal.boolValue = value;

	return node;
}

/* Creates a new binary operation AST node */
ASTNode * new_binary_op(ASTNodeType type, ASTNode * left, ASTNode * right)
{
	ASTNode * node = new_ast_node(type);
	node->data.binaryOp.left  = left;
	node->data.binaryOp.right = right;

	return node;
}

/* Creates a new unary operation AST node */
ASTNode * new_unary_op(ASTNodeType type, ASTNode * operand)
{
	ASTNode * node = new_ast_node(type);
	node->data.unaryOp.operand = operand;

	return node;
}

/* Creates a new if-elif-else statement AST node */
ASTNode * new_if_node(ASTNode * condition, ASTNode * thenBranch, ASTNode * elseBranch)
{
	ASTNode * node = new_ast_node(AST_IF_STATEMENT);

	node->data.ifNode.condition  = condition;
	node->data.ifNode.thenBranch = thenBranch;
	node->data.ifNode.elseBranch = elseBranch;

	return node;
}

ASTNode * new_block_node(ASTNodeList * statements)
{
    ASTNode * node = new_ast_node(AST_BLOCK);
    node->data.statements = statements;
    return node;
}

/* Creates a new variable declaration or assignment AST node */
ASTNode * new_variable_node(char * variableName, ASTNode * expression)
{
	ASTNode * node = new_ast_node(AST_VARIABLE_DECLARATION);
	node->data.variable.variableName = variableName;

	if (!node->data.variable.variableName)
	{
		fprintf(stderr, "Memory allocation failed\n");
		exit(EXIT_FAILURE);
	}
	node->data.variable.expression = expression;

	return node;
}

/* Handling assignment operations */
ASTNode * new_assignment_node(char * variableName, ASTNode * expression)
{
	ASTNode * node = new_ast_node(AST_ASSIGNMENT_STATEMENT);
	node->data.variable.variableName = variableName;

	if (!node->data.variable.variableName)
	{
		fprintf(stderr, "Memory allocation failed\n");
		exit(EXIT_FAILURE);
	}
	node->data.variable.expression = expression;

	return node;
}

/* Handling augmented assignment operations */
ASTNode * new_augmented_assignment_node(ASTNodeType type, ASTNode * variable, ASTNode * expression)
{
	/* Augmented assignment operation (e.g., x += y) is treated as a binary operation */
	ASTNode * node = new_ast_node(type);
	node->data.binaryOp.left = variable;
	node->data.binaryOp.right = expression;

	return node;
}

/* Adds a new statement to a list of statements */
ASTNodeList * add_statement_list(ASTNodeList * list, ASTNode * statement)
{
    ASTNodeList * new_node = (ASTNodeList *)malloc(sizeof(ASTNodeList));

    if (!new_node)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    new_node->statement = statement;
    new_node->next = NULL;

    if (!list)
    {
        return new_node;
    }

    ASTNodeList * current = list;

    while (current->next)
    {
        current = current->next;
    }
    current->next = new_node;

    return list;
}

ASTNodeList * new_statement_list(ASTNode * first, ASTNode * second)
{
    ASTNodeList * list = NULL;
    list = add_statement_list(list, first);
    list = add_statement_list(list, second);

    return list;
}

ASTNodeList * create_statement_list(ASTNode * statement)
{
    ASTNodeList * list = (ASTNodeList *)malloc(sizeof(ASTNodeList));

    if (!list)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    list->statement = statement;
    list->next = NULL;

    return list;
}

ASTNodeList * merge_statement_lists(ASTNodeList * list1, ASTNodeList * list2)
{
    if (!list1) return list2;
    if (!list2) return list1;

    ASTNodeList * current = list1;

    while (current->next)
    {
        current = current->next;
    }
    current->next = list2;

    return list1;
}

// /* Frees the memory of an AST node and its children */
// void free_ast_node(ASTNode * node) 
// {
//     if (!node) 
//     {
//         return;
//     }

//     switch (node->type) 
//     {
//         case AST_INT_LITERAL:
//         case AST_FLOAT_LITERAL:
//         case AST_BOOL_LITERAL:
//             break;

//         case AST_STRING_LITERAL:
//             free(node->data.literal.stringValue);
//             break;

//         case AST_VARIABLE_DECLARATION:
//             free(node->data.variable.variableName);
//             free_ast_node(node->data.variable.expression);
//             break;

//         case AST_IF_STATEMENT:
//             free_ast_node(node->data.ifNode.condition);
//             free_ast_node(node->data.ifNode.thenBranch);
//             free_ast_node(node->data.ifNode.elifBranch);
//             free_ast_node(node->data.ifNode.elseBranch);
//             break;

//         case AST_PLUS:
//         case AST_MINUS:
//         case AST_MULTIPLY:
//         case AST_DIVIDE:
//         case AST_MODULO:
//         case AST_AND:
//         case AST_OR:
//             free_ast_node(node->data.binaryOp.left);
//             free_ast_node(node->data.binaryOp.right);
//             break;

//         case AST_NOT:
//             free_ast_node(node->data.unaryOp.operand);
//             break;

//         default:
//             break;
//     }
//     free(node);
// }

// /* display the all ast */
// void display_ast(ASTNode * node, int indent)
// {
// 	if (node == NULL) return;

// 	for (int i = 0; i < indent; ++i) printf("  ");

// 	switch (node->type) 
// 	{
//         case AST_INT_LITERAL:
//             printf("IntLiteral: %d\n", node->data.literal.intValue);
//             break;

//         case AST_FLOAT_LITERAL:
//             printf("FloatLiteral: %f\n", node->data.literal.floatValue);
//             break;

//         case AST_STRING_LITERAL:
//             printf("StringLiteral: %s\n", node->data.literal.stringValue);
//             break;

//         case AST_BOOL_LITERAL:
//             printf("BoolLiteral: %s\n", node->data.literal.boolValue ? "true" : "false");
//             break;

//         case AST_VARIABLE_DECLARATION:
//             printf("VariableDeclaration: %s\n", node->data.variable.variableName);
//             display_ast(node->data.variable.expression, indent + 1);
//             break;

//         case AST_ASSIGNMENT_STATEMENT:
//             printf("Assignment: %s = \n", node->data.variable.variableName);
//             display_ast(node->data.variable.expression, indent + 1);
//             break;

//         case AST_PLUS:
//             printf("BinaryOp: PLUS\n");
//             display_ast(node->data.binaryOp.left, indent + 1);
//             display_ast(node->data.binaryOp.right, indent + 1);
//             break;

//         case AST_MINUS:
//             printf("BinaryOp: MINUS\n");
//             display_ast(node->data.binaryOp.left, indent + 1);
//             display_ast(node->data.binaryOp.right, indent + 1);
//             break;

//         case AST_MULTIPLY:
//             printf("BinaryOp: MULTIPLY\n");
//             display_ast(node->data.binaryOp.left, indent + 1);
//             display_ast(node->data.binaryOp.right, indent + 1);
//             break;

//         case AST_DIVIDE:
//             printf("BinaryOp: DIVIDE\n");
//             display_ast(node->data.binaryOp.left, indent + 1);
//             display_ast(node->data.binaryOp.right, indent + 1);
//             break;

//         case AST_IF_STATEMENT:
//             printf("IfStatement: \n");
//             printf("  Condition:\n");
//             display_ast(node->data.ifNode.condition, indent + 2);
//             printf("  ThenBranch:\n");
//             display_ast(node->data.ifNode.thenBranch, indent + 2);

//             if (node->data.ifNode.elifBranch) 
//             {
//                 printf("  ElifBranch:\n");
//                 display_ast(node->data.ifNode.elifBranch, indent + 2);
//             }
//             if (node->data.ifNode.elseBranch) 
//             {
//                 printf("  ElseBranch:\n");
//                 display_ast(node->data.ifNode.elseBranch, indent + 2);
//             }
//             break;

//         default:
//             printf("Unknown AST Node Type\n");
//             break;
//     }
// }

// void display_ast_list(ASTNodeList * list, int indent) 
// {
//     ASTNodeList * current = list;

//     while (current != NULL) 
//     {
//         display_ast(current->statement, indent);
//         current = current->next;
//     }
// }
