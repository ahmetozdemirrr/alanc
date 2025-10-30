PROGRAM = alanc
CC = gcc
CXX = g++
FLEX = flex
BISON = bison

BUILD_DIR = build
SRC_DIR = src

# --- Compiler & Linker Flags ---
CFLAGS = -g -Wall -Wextra -std=gnu11
CXXFLAGS = -g -Wall -Wextra -std=c++17

INCLUDES =  -I$(SRC_DIR)/common/include       \
            -I$(SRC_DIR)/driver/include       \
            -I$(SRC_DIR)/frontend/include     \
            -I$(SRC_DIR)/semantic/include     \
            -I$(SRC_DIR)/backend/include      \
            -I$(BUILD_DIR)/frontend/src/parser \
            -I$(BUILD_DIR)/preprocessor/src/parser
LDFLAGS =
LDLIBS = -lm

# --- Automatic File Detection ---
C_SOURCES   = $(shell find $(SRC_DIR) -name '*.c')
CPP_SOURCES = $(shell find $(SRC_DIR) -name '*.cpp')
Y_SOURCES   = $(shell find $(SRC_DIR) -name '*.y')
L_SOURCES   = $(shell find $(SRC_DIR) -name '*.l')

# --- Output File Definitions ---
C_OBJECTS   = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SOURCES))
CPP_OBJECTS = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(CPP_SOURCES))
Y_OBJECTS   = $(patsubst $(SRC_DIR)/%.y, $(BUILD_DIR)/%.tab.o, $(Y_SOURCES))
L_OBJECTS   = $(patsubst $(SRC_DIR)/%.l, $(BUILD_DIR)/%.yy.o, $(L_SOURCES))

OBJECTS = $(C_OBJECTS) $(CPP_OBJECTS) $(Y_OBJECTS) $(L_OBJECTS)

PARSER_C = $(patsubst $(SRC_DIR)/%.y, $(BUILD_DIR)/%.tab.c, $(Y_SOURCES))
PARSER_H = $(patsubst $(SRC_DIR)/%.y, $(BUILD_DIR)/%.tab.h, $(Y_SOURCES))
LEXER_C  = $(patsubst $(SRC_DIR)/%.l, $(BUILD_DIR)/%.yy.c, $(L_SOURCES))

TARGET = $(PROGRAM)

.PHONY: all clean run test memcheck

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

# Rule to compile C source files (.c -> .o)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@

# Rule to compile C++ source files (.cpp -> .o)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(INCLUDES) $(CXXFLAGS) -c $< -o $@

# Rule to generate parser (.tab.c, .tab.h) from .y
$(BUILD_DIR)/%.tab.c $(BUILD_DIR)/%.tab.h: $(SRC_DIR)/%.y
	@mkdir -p $(dir $@)
	$(BISON) -d --warnings=all -o $(patsubst %.h,%,$@) $<

# Rule to generate scanner (.yy.c) from .l
$(BUILD_DIR)/%.yy.c: $(SRC_DIR)/%.l $(PARSER_H)
	@mkdir -p $(dir $@)
	$(FLEX) -o $@ $<

# Rule to compile generated .tab.c files
$(BUILD_DIR)/%.tab.o: $(BUILD_DIR)/%.tab.c
	@mkdir -p $(dir $@)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@

# Rule to compile generated .yy.c files
$(BUILD_DIR)/%.yy.o: $(BUILD_DIR)/%.yy.c
	@mkdir -p $(dir $@)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR) $(TARGET)

test: all
	./$(TARGET) tests/test.alan

run: all
	./$(TARGET)

memcheck: all
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(TARGET) tests/test.alan
