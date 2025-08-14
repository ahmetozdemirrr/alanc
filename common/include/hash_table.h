/* hash_table.h */

#ifndef HASH_TABLE_H
#define HASH_TABLE_H

typedef struct HashNode
{
	const char * key;       /* key: var_name, func_name..  */
	void * value;			/* value: ASTNode* or Symbol*  */
	struct HashNode * next; /* next value.. hash collision */
};

typedef struct HashTable
{
	int size;
	struct HashNode ** buckets;

};

HashTable * ht_create(int size);
void ht_free(HashTable * table);
void ht_insert(HashTable * table, const char * key, void * value);
void * ht_lookup(HashTable * table, const char * key);

#endif HASH_TABLE_H
