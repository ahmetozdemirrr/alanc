/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    KW_TRUE = 258,                 /* KW_TRUE  */
    KW_FALSE = 259,                /* KW_FALSE  */
    KW_NULL = 260,                 /* KW_NULL  */
    KW_IF = 261,                   /* KW_IF  */
    KW_ELSE = 262,                 /* KW_ELSE  */
    KW_ELIF = 263,                 /* KW_ELIF  */
    KW_INT = 264,                  /* KW_INT  */
    KW_FLOAT = 265,                /* KW_FLOAT  */
    KW_BOOL = 266,                 /* KW_BOOL  */
    KW_STR = 267,                  /* KW_STR  */
    KW_RETURN = 268,               /* KW_RETURN  */
    KW_FUNCTION = 269,             /* KW_FUNCTION  */
    KW_PROCEDURE = 270,            /* KW_PROCEDURE  */
    KW_INCLUDE = 271,              /* KW_INCLUDE  */
    INTEGER_LITERAL = 272,         /* INTEGER_LITERAL  */
    FLOAT_LITERAL = 273,           /* FLOAT_LITERAL  */
    STRING_LITERAL = 274,          /* STRING_LITERAL  */
    IDENTIFIER = 275,              /* IDENTIFIER  */
    COMMENT = 276,                 /* COMMENT  */
    OP_PLUS = 277,                 /* OP_PLUS  */
    OP_MINUS = 278,                /* OP_MINUS  */
    OP_MULT = 279,                 /* OP_MULT  */
    OP_DIV = 280,                  /* OP_DIV  */
    OP_EQUAL = 281,                /* OP_EQUAL  */
    NEWLINE = 282,                 /* NEWLINE  */
    OP_OPEN_P = 283,               /* OP_OPEN_P  */
    OP_CLOSE_P = 284,              /* OP_CLOSE_P  */
    OP_OPEN_CURLY = 285,           /* OP_OPEN_CURLY  */
    OP_CLOSE_CURLY = 286,          /* OP_CLOSE_CURLY  */
    OP_OPEN_SQU = 287,             /* OP_OPEN_SQU  */
    OP_CLOSE_SQU = 288,            /* OP_CLOSE_SQU  */
    OP_COMMA = 289,                /* OP_COMMA  */
    OP_DOT = 290,                  /* OP_DOT  */
    OP_QUOTA = 291,                /* OP_QUOTA  */
    OP_OPEN_ANGLE = 292,           /* OP_OPEN_ANGLE  */
    OP_CLOSE_ANGLE = 293,          /* OP_CLOSE_ANGLE  */
    OP_SEMICOLON = 294,            /* OP_SEMICOLON  */
    POINTER = 295,                 /* POINTER  */
    OP_AND = 296,                  /* OP_AND  */
    OP_OR = 297,                   /* OP_OR  */
    OP_NOT = 298,                  /* OP_NOT  */
    OP_EQ_LESS = 299,              /* OP_EQ_LESS  */
    OP_EQ_GRE = 300,               /* OP_EQ_GRE  */
    OP_IS_EQ = 301,                /* OP_IS_EQ  */
    OP_ISNT_EQ = 302,              /* OP_ISNT_EQ  */
    UNARY_MINUS = 303              /* UNARY_MINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 17 "Parser/parser.y"

    int    intval;      /* for Integer types          */
    float  floatval;    /* for Float types            */
    char * string;      /* for String types           */
    int    boolean;     /* for Boolean types (0 or 1) */
    void * nullval;     /* for Null                   */
    Variable var;

#line 121 "Parser/parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_PARSER_TAB_H_INCLUDED  */
