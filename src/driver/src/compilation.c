/* src/common/src/compilation.c */

#include <stdio.h>
#include <stdlib.h>

/* local includes */
#include <compilation.h>
#include <utils.h>


Compilation*
compilation_create(size_t persistent_capacity, size_t transient_capacity)
{
    Compilation* comp = malloc(sizeof(Compilation));
    if (!comp)
    {
        return NULL;
    }

    comp->persistent_arena = arena_init(persistent_capacity);
    if (!comp->persistent_arena)
    {
        /* If persistent arena fails, cleanup the comp struct. */
        cleanup_on_failure(0, 
            CLEANUP_TYPE_MALLOC, comp, 
            CLEANUP_END_FLAG);
        return NULL;
    }

    comp->transient_arena = arena_init(transient_capacity);
    if (!comp->transient_arena)
    {
        /* If transient arena fails, cleanup both the comp and the persistent arena. */
        cleanup_on_failure(0, 
            CLEANUP_TYPE_ARENA,  comp->persistent_arena, 
            CLEANUP_TYPE_MALLOC, comp, 
            CLEANUP_END_FLAG);
        return NULL;
    }
    comp->source_manager = NULL;
    comp->diagnostics = NULL;
    comp->target_info = NULL;
    comp->ast_root = NULL;

    return comp;
}

void 
compilation_destroy(Compilation* comp)
{
    if (comp)
    {
        arena_free(comp->persistent_arena);
        arena_free(comp->transient_arena);
        free(comp);
    }
}
