/* src/common/include/arena_core.h */

#ifndef ARENA_CORE_H
#define ARENA_CORE_H

#include <stddef.h> /* Required for size_t */

/**
 * @struct Arena
 * @brief Manages the state of a memory arena allocator.
 *
 * This structure holds all the necessary information to manage a large,
 * pre-allocated block of memory for fast, sequential allocations.
 *
 * @var Arena::memory
 * A pointer to the start of the large memory block allocated from the OS.
 * @var Arena::capacity
 * The total size in bytes of the allocated memory block.
 * @var Arena::offset (bumb pointer)
 * The current position within the memory block, indicating the next free byte.
 * 
 */
typedef struct
{
    unsigned char*  memory;
    size_t          capacity;
    size_t          offset;
}
Arena;

/**
 * @brief Creates and initializes a new Arena with a specified capacity.
 * @param capacity The total size in bytes to allocate for the arena's memory pool.
 * @return A pointer to the newly created Arena struct, or NULL if allocation fails.
 */
Arena* arena_init(size_t capacity);

/**
 * @brief Frees all memory associated with an Arena.
 * This includes both the main memory pool and the Arena struct itself.
 * @param arena A pointer to the Arena to be freed. It is safe to pass NULL.
 */
void arena_free(Arena* arena);

#endif /* ARENA_CORE_H */
