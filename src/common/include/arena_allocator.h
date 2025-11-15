/* src/common/include/arena_allocator.h */

#ifndef ARENA_ALLOCATOR_H
#define ARENA_ALLOCATOR_H

#include <stddef.h> 
#include <string.h>

/* local includes */
#include <arena_core.h>
#include <alanc_types.h>

/**
 * @def ARENA_ALIGNMENT_SIZE
 * @brief Defines the memory alignment boundary in bytes.
 * All allocations will start at an address that is a multiple of this value.
 * A value of 8 is safe for most data types on 64-bit systems.
 */
#define ARENA_ALIGNMENT_SIZE 8

/**
 * @brief Allocates a block of memory from the given arena.
 *
 * This function implements a "bump pointer" strategy, returning a
 * memory block of the specified size, ensuring the starting address is properly
 * aligned according to ARENA_ALIGNMENT_SIZE.
 *
 * @param arena A pointer to the Arena from which to allocate.
 * @param size The size of the memory block to allocate, in bytes.
 * @return A void pointer to the start of the allocated block, or NULL if
 * the arena is out of memory or the inputs are invalid.
 */
void* arena_alloc(Arena* arena, size_t size, ALANC_BOOLEAN_TYPES init_with_null);

/**
 * @brief Resets an arena, making its memory available for new allocations.
 *
 * This does not free memory back to the OS. It simply resets the internal
 * offset, effectively invalidating all previous allocations. This is an O(1) operation.
 *
 * @param arena A pointer to the Arena to be reset.
 */
void arena_reset(Arena* arena);

#endif /* ARENA_ALLOCATOR_H */
