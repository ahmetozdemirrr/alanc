/* src/common/include/utils.h */

#ifndef UTILS_H_
#define UTILS_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

/**
 * @enum CleanupType
 * @brief Defines different types of resources that can be managed by cleanup_on_failure.
 */
typedef enum
{
    CLEANUP_TYPE_MALLOC,
    CLEANUP_TYPE_ARENA,
    CLEANUP_TYPE_FILE,
    /* A sentinel value to mark the end of the variadic argument list. */
    CLEANUP_END_FLAG
}
CleanupType;

/**
 * @brief A variadic function to clean up multiple resources upon failure.
 *
 * This function takes a variable number of arguments in pairs: a CleanupType
 * and a pointer to the resource. It iterates until it finds CLEANUP_END_FLAG.
 * @param dummy A dummy integer argument required to initialize va_list.
 */
void cleanup_on_failure(int dummy, ...);

void frontend_yyerror(const char* s);

#endif /* UTILS_H_ */
