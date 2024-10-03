# programs
CC = cc
FLEX = flex
YACC = bison

# CFLAGS = -Wall -pedantic-errors -std=gnu99
INTERNAL_CFLAGS = \
	-D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 \
	-Iinclude \
	$(CFLAGS)
INTERNAL_LDFLAGS = $(LDFLAGS)
INTERNAL_LIBS = -lfl -lm $(LDLIBS)
INTERNAL_YACCFLAGS = -Wcounterexamples $(YACCFLAGS)

# Variables
LEXER_SOURCE = Lexer/lexer.l
LEXER_OUTPUT = Lexer/lex.yy.c
LEXER_HEADER = Lexer/lex.yy.h
LEXER_OBJECT = Lexer/lex.yy.o

PARSER_SOURCE = Parser/parser.y
PARSER_OUTPUT = Parser/parser.tab.c
PARSER_HEADER = Parser/parser.tab.h
PARSER_OBJECT = Parser/parser.tab.o

PROGRAM = parser
OBJECTS = \
      src/logical.o \
      src/symbol_table.o \
      src/utils.o \
      src/variables.o \
      $(LEXER_OBJECT) \
      $(PARSER_OBJECT)
HEADERS = \
	  include/logical.h \
	  include/symbol_table.h \
	  include/utils.h \
	  include/variables.h \
	  $(LEXER_HEADER) \
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

# Clean generated files
clean:
	rm -f $(LEXER_OUTPUT) $(PARSER_OUTPUT) $(PARSER_HEADER) $(LEXER_HEADER) $(PROGRAM) src/*.o Lexer/*.o Parser/*.o

# Run parser
run: $(PROGRAM)
	./$(PROGRAM)

# Valgrind memory check
memcheck: $(PROGRAM)
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(PROGRAM)

.PHONY: all clean run test memcheck
