/* src/common/src/compiler_context.c */

#include <stdio.h>
#include <stdlib.h>

/* local includes */
#include <compiler_context.h>
#include <utils.h>


CompilerContext*
context_init(size_t persistent_capacity, size_t transient_capacity)
{
    CompilerContext* context = malloc(sizeof(CompilerContext));
    if (!context)
    {
        return NULL;
    }

    context->persistent_arena = arena_init(persistent_capacity);
    if (!context->persistent_arena)
    {
        /* If persistent arena fails, cleanup the context struct. */
        cleanup_on_failure(0, 
            CLEANUP_TYPE_MALLOC, context, 
            CLEANUP_END_FLAG);
        return NULL;
    }

    context->transient_arena = arena_init(transient_capacity);
    if (!context->transient_arena)
    {
        /* If transient arena fails, cleanup both the context and the persistent arena. */
        cleanup_on_failure(0, 
            CLEANUP_TYPE_ARENA,  context->persistent_arena, 
            CLEANUP_TYPE_MALLOC, context, 
            CLEANUP_END_FLAG);
        return NULL;
    }
    return context;
}

void 
context_free(CompilerContext* context)
{
    if (context)
    {
        arena_free(context->persistent_arena);
        arena_free(context->transient_arena);
        free(context);
    }
}
