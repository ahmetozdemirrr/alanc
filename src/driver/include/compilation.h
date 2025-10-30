/* src/common/include/compilation.h */

/**
 * - Diagnostics Engine
 * - Source Manager
 * - Target information
 * - AST root node
 */
#ifndef COMPILATION_H
#define COMPILATION_H

/* local includes */
#include <arena_core.h>
#include <ast.h>

/* forward declarations */
struct DiagnosticEngine;
struct SourceManager;
struct TargetInfo;

/**
 * @struct CompilerContext
 * @brief Holds the entire global state and memory pools of the compilation process.
 *
 * This struct is passed as a pointer to all major steps of the compiler
 * pipeline (preprocessor, parser, etc.) to provide access to shared resources.
 */
typedef struct
{
    /**
     * @brief The persistent memory pool.
     * Data that must live until the end of compilation, such as AST nodes,
     * Symbol Table entries, and Type information, is stored here.
     */
    Arena* persistent_arena; 

    /**
     * @brief The transient (temporary) memory pool.
     * Data used by a single compilation phase and not needed later is stored here.
     * This arena is reset between phases using `arena_reset()` for high efficiency.
     */
    Arena* transient_arena;

    struct SourceManager* source_manager;
    struct DiagnosticEngine* diagnostics;
    struct TargetInfo* target_info;
    ASTNode* ast_root;
}
Compilation;


/**
 * @brief Creates a new compiler context and initializes its memory arenas.
 * @param persistent_capacity Size in bytes to allocate for the persistent arena.
 * @param transient_capacity Size in bytes to allocate for the transient arena.
 * @return A pointer to the initialized Compilation, or NULL on error.
 */
Compilation* compilation_create(size_t persistent_capacity, size_t transient_capacity);

/**
 * @brief Frees the compiler context and all arenas it owns.
 * @param context The compiler context to be freed.
 */
void compilation_destroy(Compilation* comp);


#endif /* COMPILATION_H */
