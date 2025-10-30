/* hash_table.c */

#include <hash_table.h>

/**
 * @brief Hashes a string key using the djb2 algorithm.
 *
 * The formula is: hash(i) = hash(i-1) * 33 + str[i]
 * @param key The null-terminated string to hash.
 * @return An unsigned long representing the hash value.
 */
static unsigned long
ht_hash(const char* key)
{
	/* Start with a magic prime number. */
	unsigned long hash = 5381;
	int c;

	/* Iterate through each character of the key. */
	while((c = *key++))
	{
		hash = ((hash << 5) + hash) + c; 
	}
	return hash;
}

HashTable* 
ht_create(size_t capacity)
{
	/* TODO: Implementation needed.
	 * 1. Allocate memory for the HashTable struct.
	 * 2. Allocate memory for the 'buckets' array (size = capacity * sizeof(HashNode*)).
	 * 3. Initialize all buckets to NULL.
	 * 4. Set table->capacity and table->size.
	 * 5. Return the new table.
	 */
	 return NULL;
}

void 
ht_free(HashTable* table)
{
	/* TODO: Implementation needed.
	 * 1. Iterate through each bucket.
	 * 2. For each bucket, iterate through the linked list of HashNodes.
	 * 3. Free each HashNode.
	 * 4. Free the 'buckets' array.
	 * 5. Free the HashTable struct itself.
	 */
}

void 
ht_insert(HashTable* table, const char* key, void* value)
{
	/* TODO: Implementation needed.
	 * 1. Hash the key to get a bucket index (hash % table->capacity).
	 * 2. Check if the key already exists in the bucket's linked list.
	 * - If yes, update the value.
	 * - If no, create a new HashNode, fill it, and add it to the front
	 * of the linked list in that bucket.
	 * 3. Increment table->size.
	 * 4. Consider resizing the table if the load factor (size/capacity) is too high.
	 */
}

void* 
ht_lookup(HashTable* table, const char* key)
{
	/* TODO: Implementation needed.
	 * 1. Hash the key to get the bucket index.
	 * 2. Traverse the linked list at that bucket.
	 * 3. For each node, compare the key with the node's key (using strcmp).
	 * 4. If a match is found, return the node's value.
	 * 5. If the end of the list is reached with no match, return NULL.
	 */
	 return NULL;
}
