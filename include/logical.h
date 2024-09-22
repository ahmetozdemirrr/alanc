#ifndef LOGICAL_H
#define LOGICAL_H

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "variables.h"

int equal(Variable a, Variable b);
int not_equal(Variable a, Variable b);
int less_than(Variable a, Variable b);
int less_equal(Variable a, Variable b);
int greater_than(Variable a, Variable b);
int greater_equal(Variable a, Variable b);
void type_control(Variable a, Variable b);


#endif /* LOGICAL_H */
