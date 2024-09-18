# Syntax for Tokens



This document contains the token-based syntax rules added so far. As this file will be changed frequently, it may not be in a very uniform format. 

Now let's look at the tokens already used in the A language.

### Operators:

* [+] -> OP_PLUS: for arithmetic adding operation
* [-]  -> OP_MINUS: for arithmetic substract and negative operation
* [*] -> OP_MULT: for arithmetic multiplication operation
* [/] -> OP_DIV: for arithmetiz division operation
* [(] -> OP_OPEN_P
* [)] -> OP_CLOSE_P
* [=] -> OP_EQUAL: for assignment statements
* [.] -> OP_DOT: non-functional for now
* [,] -> OP_COMMA: separator atom in function, procedure and array definitions
* [{] -> OP_OPEN_CURLY: body start seperator 
* [}] -> OP_CLOSE_CURLY: body end seperator
* [[] -> OP_OPEN_SQU: for array definitions
* []] -> OP_CLOSE_SQU
* [<] -> OP_OPEN_ANGLE: for logical operations
* [>] -> OP_CLOSE_ANGLE
* [;] -> OP_SEMICOLON: end-of-line token (mandatory for each line -C like-)
* [->] -> POINTER: address assigner (for ex. a -> b; (now b holds the address of a))



### Keywords:

Here we have classically limited the data types to booleans, integers, floats and strings. Our aim here is to simplify the language. 

* int
* float
* bool
* str 

We made a distinction between `function`s and `procedure`s. Because we want pure functional features in our language. In particular, we aim to build lisp-like logic in these functions, which will increase our chances of optimizing for recursive code blocks. Procedures will work as classically known `procedure`s.

* function
* procedure

We will also use the `include` keyword to include a library. We don't plan to use any separators on the left and right side of the library name (for ex. `include standardALan;`).

* include

Other keywords...

* if 
* else
* elif
* return
* true
* false
* null



In this language, comment lines are specified with the `#` operator. We do not plan to add the multiple comment line feature for now. 



```
# This is a comment!
```



### Literals:

There are currently three literals in our language: variable names, float numbers and integer numbers.



- Variable names will be case-sensitive and cannot contain characters other than `_` (underscore) and digits. However, variable names cannot start with a number. In addition, we limit the length of variable names to 32 characters.
- Integer values can be any mixture of digit(s).
- Float numbers can also be classically defined with a point in the middle.



Sample Code for `ALan`:

```ALan
include standart.ALan

function foo(int a, float b)
{
    if (a < 0)
    {
        return a;
    }
    return (a * (foo(a - 3, b + 3));
}

procedure poo()
{
    int b1 = 3;
    int * b2;
    int b3 = true;

    if (b3)
    {
        b1 -> b2;
    }
    
    else
    {
        return;
    }

    print(Procedure end!);
}

procedure main()
{
    int array[] = {2, 3, 4};

    poo(foo());

    input(Enter a number:);
    
    return EXIT_SUCCESS;
}

# This is a comment and this is a expression ; x = y + 5 (but in a comment line)

```
