Sample Code:

```
/* main.alan */

#include <standart.alan>

#define PI 3.14

function foo(int a, float b) : float
{
		if (a)
		{
				return foo(a - 1, b) * b;
		} 
    return b;
}

procedure poo(float input) : void
{
    bool b1 = true;
    bool b2 = false;

    if (b1 == b2)
    {
        b1 -> (bool) input;
    }

    else
    {
				print("Procedure end!");
        return;
  	} 
}

procedure main() : int
{
    int a;
		float b;

		input("Enter a number:", &a);
		input("Enter a number:", &b);

    poo(foo(a, b));

    return EXIT_SUCCESS;
}

// This is a comment and this is a expression ; x = y + 5 (but in a comment line)
```
