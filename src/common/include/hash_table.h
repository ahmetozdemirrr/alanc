/* hash_table.h */

#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#include <stddef.h>

/* local includes */
#include <arena_allocator.h>

/**
 * @struct HashNode
 * @brief A single entry in a hash table bucket.
 *
 * It forms a singly-linked list to handle hash collisions.
 * @var HashNode::next Pointer to the next node in the same bucket (on collision).
 * @var HashNode::key The string key for this entry.
 * @var HashNode::value A generic pointer to the value associated with the key.
 */
typedef struct HashNode
{
	struct HashNode* 	next;
	const char* 		key;
	void* 				value;
}
HashNode;

/**
 * @struct HashTable
 * @brief Represents a hash table for storing key-value pairs.
 * @var HashTable::buckets An array of pointers to HashNodes (the buckets).
 * @var HashTable::size The number of items currently in the table.
 * @var HashTable::capacity The number of available buckets.
 */
typedef struct
{
	HashNode** 	buckets;
	size_t 		size;
	size_t 		capacity;
}
HashTable;


HashTable* ht_create(Arena* arena, size_t capacity);
void ht_free(HashTable* table);
void ht_insert(HashTable* table, const char* key, void* value);
void* ht_lookup(HashTable* table, const char* key);

#endif /* HASH_TABLE_H */
