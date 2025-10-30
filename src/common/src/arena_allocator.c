/* src/common/src/arena_allocator.c */

/* local includes */
#include <arena_allocator.h>
#include <utils.h>

void* 
arena_alloc(Arena* arena, size_t size)
{
    if (!arena)
    {
        fprintf(stderr, "Error: arena data structure cannot be NULL.\n");
        return NULL;
    }

    if (0 == size)
    {
        fprintf(stderr, "Error: arena allocation size cannot be 0.\n");
        return NULL;
    }

    /* Calculate the next memory address that is aligned to ARENA_ALIGNMENT_SIZE.
     * This is done by rounding the current offset up to the nearest multiple of the alignment size.
     * The bit-masking technique is a fast way to achieve this.
     * For example, with alignment 8: (offset + 7) & ~7
     */
    size_t aligned_offset = (arena->offset + (ARENA_ALIGNMENT_SIZE - 1)) & ~(ARENA_ALIGNMENT_SIZE - 1);

    /* Check if there is enough space left in the arena for the requested size. */
    if (aligned_offset + size > arena->capacity)
    {
        fprintf(stderr, "Error: arena is full, remain %zu byte.\n", (arena->capacity - aligned_offset));
        return NULL;
    }
    
    /* The new pointer is the start of the arena's memory plus the aligned offset. */
    void* ptr     = arena->memory  + aligned_offset;
    arena->offset = aligned_offset + size;

    return ptr;
}

void
arena_reset(Arena* arena)
{
    if (NULL != arena)
    {
        arena->offset = 0;
    }
}
