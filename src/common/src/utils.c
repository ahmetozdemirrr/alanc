/* src/common/src/utils.c */

/* local includes */
#include <utils.h>
#include <arena_core.h> 

void 
cleanup_on_failure(int dummy, ...)
{
    va_list args;
    va_start(args, dummy);

    for (;;)
    {
        CleanupType type = va_arg(args, CleanupType);

        if (CLEANUP_END_FLAG == type)
        {
            break;
        }
        void* ptr = va_arg(args, void*);

        if (ptr)
        {
            switch (type)
            {
                case CLEANUP_TYPE_MALLOC:
                    free(ptr);
                    break;
                    
                case CLEANUP_TYPE_ARENA:
                    arena_free((Arena*) ptr);
                    break;

                case CLEANUP_TYPE_FILE:
                    break;

                default:
                    break;
            }
        }
    }
    va_end(args);
}
