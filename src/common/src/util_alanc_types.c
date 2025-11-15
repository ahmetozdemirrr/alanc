/* src/common/src/util_alanc_types.c */

#include <stdio.h>

/* local includes */
#include <util_alanc_types.h>

const char*
str_bool(ALANC_BOOLEAN_TYPE value)
{
    switch (value)
    {
        case 0:
            return "TRUE";
        case 1:
            return "FALSE";
        default:
            return "UNKNOWN_ALANC_BOOLEAN_TYPE";
    }
}
