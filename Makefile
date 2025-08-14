# programs
CC = cc
FLEX = flex
YACC = yacc

CFLAGS = -g -Wall
YACCFLAGS = -Wcex

INTERNAL_CFLAGS = 		\
	-std=gnu99 		\
	-D_GNU_SOURCE 		\
	-D_FILE_OFFSET_BITS=64 	\
	-Iinclude 		\
	-Icommon/include 	\
	$(CFLAGS)
INTERNAL_LDFLAGS = $(LDFLAGS)
INTERNAL_LIBS = -lfl -lm $(LDLIBS)
INTERNAL_YACCFLAGS = $(YACCFLAGS)

# Variables
LEXER_SOURCE = parser/lexer/lexer.l
LEXER_OUTPUT = parser/lexer/lex.yy.c
LEXER_HEADER = parser/lexer/lex.yy.h
LEXER_OBJECT = parser/lexer/lex.yy.o

PARSER_SOURCE = parser/parser.y
PARSER_OUTPUT = parser/parser.tab.c
PARSER_HEADER = parser/parser.tab.h
PARSER_OBJECT = parser/parser.tab.o

PROGRAM = alanc
OBJECTS = 			\
	src/symbol_table.o 	\
	src/utils.o 		\
	src/ast.o 		\
	common/src/hash_table.o \
	$(LEXER_OBJECT) 	\
	$(PARSER_OBJECT)
HEADERS = 				\
	include/symbol_table.h 		\
	include/utils.h 		\
	include/ast.h 			\
	common/include/hash_table.h 	\
	$(LEXER_HEADER) 		\
	$(PARSER_HEADER)

TEST_FILE = tests/test.alan

# Targets
all: $(PROGRAM)

$(OBJECTS): $(HEADERS) $(OBJECTS:.o=.c)

.SUFFIXES: .c .o
.c.o:
	$(CC) $(INTERNAL_CFLAGS) -c -o $@ $<

$(PROGRAM): $(OBJECTS)
	$(CC) $(INTERNAL_LDFLAGS) -o $@ $(OBJECTS) $(INTERNAL_LIBS)

$(LEXER_OUTPUT) $(LEXER_HEADER): $(LEXER_SOURCE)
	$(FLEX) --header-file=$(LEXER_HEADER) -o $(LEXER_OUTPUT) $(LEXER_SOURCE)

$(PARSER_OUTPUT) $(PARSER_HEADER): $(PARSER_SOURCE)
	$(YACC) -d $(INTERNAL_YACCFLAGS) -o $(PARSER_OUTPUT) $(PARSER_SOURCE)

# Run the parser with test file
test: $(PROGRAM)
	./$(PROGRAM) $(TEST_FILE)

# Run parser
run: $(PROGRAM)
	./$(PROGRAM)

# Valgrind memory check
memcheck: $(PROGRAM)
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(PROGRAM)

# Clean generated files
clean:
	rm -f $(LEXER_HEADER) $(LEXER_OBJECT) $(LEXER_OUTPUT)
	rm -f $(PARSER_HEADER) $(PARSER_OBJECT) $(PARSER_OUTPUT)
	rm -f $(PROGRAM) src/*.o common/src/*.o

.PHONY: all clean run test memcheck
