/* src/common/src/arena_core.c */

#include <stdio.h>
#include <stdlib.h>

/* local includes */
#include <arena_core.h>
#include <utils.h>


Arena* 
arena_init(size_t capacity)
{
    if (!capacity)
    {
        fprintf(stderr, "Error: cannot initialize an arena with zero capacity.\n");
        return NULL;
    }

    Arena* arena = (Arena*)malloc(sizeof(Arena));
    if (!arena)
    {
        fprintf(stderr, "Error: failed to allocate memory for Arena struct.\n");
        return NULL;
    }

    arena->memory = (unsigned char*)malloc(capacity);
    if (!arena->memory)
    {
        fprintf(stderr, "Error: failed to allocate memory for Arena:memory member.\n");

        /* If the pool allocation fails, free the previously allocated manager struct to prevent a leak. */
        cleanup_on_failure(0,
            CLEANUP_TYPE_MALLOC, arena,
            CLEANUP_END_FLAG);
        return NULL;
    }
    /* Set the initial state: full capacity is available, and the offset is at the beginning. */
    arena->capacity = capacity;
    arena->offset   = 0;

    return arena;
}

void 
arena_free(Arena* arena)
{
    if (!arena)
    {
        return;
    }

    if (arena->memory)
    {
        free(arena->memory);
    }
    free(arena);
}
