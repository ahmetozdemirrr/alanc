.SILENT:

# Compiler and flags
CC = gcc
# CFLAGS = -Wall -pedantic-errors -std=gnu99
CFLAGS += -D_POSIX_C_SOURCE=200809L -D_GNU_SOURCE
CFLAGS += -D_FILE_OFFSET_BITS=64 -I$(INCLUDE_DIR)
LIBS = -lfl -lm

# Variables
LEXER = Lexer/lexer.l
PARSER = Parser/parser.y
SRC_DIR = src
INCLUDE_DIR = include
LEX_OUTPUT = Lexer/lex.yy.c
PARSER_OUTPUT = Parser/parser.tab.c
PARSER_HEADER = Parser/parser.tab.h
EXEC = parser
TEST_FILE = tests/test.alan

# Targets
all: $(EXEC)

# Generate lexer and parser files
$(LEX_OUTPUT): $(LEXER)
	flex -o $(LEX_OUTPUT) $(LEXER)

$(PARSER_OUTPUT): $(PARSER)
	bison -d -o $(PARSER_OUTPUT) $(PARSER)

# Compile all source files
$(EXEC): $(LEX_OUTPUT) $(PARSER_OUTPUT) $(PARSER_HEADER) $(SRC_DIR)/symbol_table.c $(SRC_DIR)/variables.c $(SRC_DIR)/utils.c
	$(CC) $(LEX_OUTPUT) $(PARSER_OUTPUT) $(SRC_DIR)/symbol_table.c $(SRC_DIR)/variables.c $(SRC_DIR)/utils.c -o $(EXEC) $(CFLAGS) $(LIBS)

# Run the parser with test file
test: $(EXEC)
	./$(EXEC) $(TEST_FILE)

# Clean generated files
clean:
	rm -f $(LEX_OUTPUT) $(PARSER_OUTPUT) $(PARSER_HEADER) Lexer/lex.yy.c Parser/parser.tab.* $(EXEC) *.o

# Run parser
run: $(EXEC)
	./$(EXEC)

# Valgrind memory check
memcheck: $(EXEC)
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(EXEC)

.PHONY: all clean run test memcheck
