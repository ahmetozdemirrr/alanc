/* hash_table.c */

#include <hash_table.h>

/* for hashing we will use djb2 algorithm.. */
static unsigned long
ht_hash(const char * key)
{
	unsigned long hash = 5381;
	int c;

	while((c = *key++)){
		hash = ((hash << 5) + hash) + c; /* ==> hash * 33 + c */
	}
	return hash;
}

HashTable * ht_create(int size)
{

}

void ht_free(HashTable * table)
{

}

void ht_insert(HashTable * table, const char * key, void * value)
{

}

void * ht_lookup(HashTable * table, const char * key)
{

}
