#ifndef LOGICAL_H
#define LOGICAL_H

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "variables.h"
#include "utils.h"

/* Define a minimum epsilon value */
#define FLT_EPSILON 1.19209e-07

int bool_to_int(int boolval);
int equal(Variable a, Variable b);
int not_equal(Variable a, Variable b);
int less_than(Variable a, Variable b);
int less_equal(Variable a, Variable b);
int greater_than(Variable a, Variable b);
int greater_equal(Variable a, Variable b);
void type_control(Variable a, Variable b);
float dynamic_epsilon(float a, float b);

#endif /* LOGICAL_H */
