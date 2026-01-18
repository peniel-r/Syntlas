---
id: "c.algorithms.hash"
title: "Hash Tables"
category: algorithms
difficulty: intermediate
tags: [c, algorithms, hash, hash table, collision]
keywords: [hash, hash table, chaining, probing, collision]
use_cases: [fast lookup, deduplication, caching]
prerequisites: ["c.algorithms.datastructures"]
related: ["c.algorithms.greedy"]
next_topics: ["c.algorithms.sort"]
---

# Hash Tables

## Simple Hash Function

```c
#include <stdio.h>

unsigned int simple_hash(const char* str) {
    unsigned int hash = 0;

    while (*str != '\0') {
        hash = (hash << 5) + *str++;
    }

    return hash;
}

int main() {
    const char* keys[] = {"hello", "world", "test"};

    for (int i = 0; i < 3; i++) {
        printf("Hash of '%s': %u\n", keys[i], simple_hash(keys[i]));
    }

    return 0;
}
```

## Hash Table with Chaining

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 10

typedef struct Node {
    char* key;
    int value;
    struct Node* next;
} Node;

typedef struct {
    Node* table[TABLE_SIZE];
} HashTable;

unsigned int hash_function(const char* key) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash += *key++;
    }
    return hash % TABLE_SIZE;
}

void ht_init(HashTable* ht) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        ht->table[i] = NULL;
    }
}

void ht_insert(HashTable* ht, const char* key, int value) {
    unsigned int index = hash_function(key);

    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->key = strdup(key);
    new_node->value = value;
    new_node->next = ht->table[index];

    ht->table[index] = new_node;
}

bool ht_get(HashTable* ht, const char* key, int* value) {
    unsigned int index = hash_function(key);
    Node* current = ht->table[index];

    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            *value = current->value;
            return true;
        }
        current = current->next;
    }

    return false;
}

void ht_free(HashTable* ht) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        Node* current = ht->table[i];

        while (current != NULL) {
            Node* temp = current;
            current = current->next;
            free(temp->key);
            free(temp);
        }
    }
}

int main() {
    HashTable ht;
    ht_init(&ht);

    ht_insert(&ht, "apple", 1);
    ht_insert(&ht, "banana", 2);
    ht_insert(&ht, "cherry", 3);

    int value;
    if (ht_get(&ht, "banana", &value)) {
        printf("Found banana: %d\n", value);
    }

    ht_free(&ht);

    return 0;
}
```

## Linear Probing

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 10

typedef struct {
    char* key;
    int value;
    bool occupied;
} Entry;

typedef struct {
    Entry table[TABLE_SIZE];
} LinearProbingHT;

unsigned int hash_function(const char* key) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash += *key++;
    }
    return hash % TABLE_SIZE;
}

void lpht_init(LinearProbingHT* ht) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        ht->table[i].occupied = false;
    }
}

bool lpht_insert(LinearProbingHT* ht, const char* key, int value) {
    unsigned int index = hash_function(key);
    unsigned int start_index = index;

    while (ht->table[index].occupied) {
        if (strcmp(ht->table[index].key, key) == 0) {
            ht->table[index].value = value;
            return true;
        }
        index = (index + 1) % TABLE_SIZE;

        if (index == start_index) {
            return false;  // Table full
        }
    }

    ht->table[index].key = strdup(key);
    ht->table[index].value = value;
    ht->table[index].occupied = true;

    return true;
}

bool lpht_get(LinearProbingHT* ht, const char* key, int* value) {
    unsigned int index = hash_function(key);
    unsigned int start_index = index;

    while (ht->table[index].occupied) {
        if (strcmp(ht->table[index].key, key) == 0) {
            *value = ht->table[index].value;
            return true;
        }
        index = (index + 1) % TABLE_SIZE;

        if (index == start_index) {
            break;
        }
    }

    return false;
}

void lpht_free(LinearProbingHT* ht) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (ht->table[i].occupied) {
            free(ht->table[i].key);
        }
    }
}

int main() {
    LinearProbingHT ht;
    lpht_init(&ht);

    lpht_insert(&ht, "apple", 1);
    lpht_insert(&ht, "banana", 2);
    lpht_insert(&ht, "cherry", 3);

    int value;
    if (lpht_get(&ht, "banana", &value)) {
        printf("Found banana: %d\n", value);
    }

    lpht_free(&ht);

    return 0;
}
```

## Quadratic Probing

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 10

typedef struct {
    char* key;
    int value;
    bool occupied;
} Entry;

typedef struct {
    Entry table[TABLE_SIZE];
} QuadraticProbingHT;

unsigned int hash_function(const char* key) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash += *key++;
    }
    return hash % TABLE_SIZE;
}

void qpht_init(QuadraticProbingHT* ht) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        ht->table[i].occupied = false;
    }
}

bool qpht_insert(QuadraticProbingHT* ht, const char* key, int value) {
    unsigned int hash = hash_function(key);

    for (int i = 0; i < TABLE_SIZE; i++) {
        unsigned int index = (hash + i * i) % TABLE_SIZE;

        if (!ht->table[index].occupied) {
            ht->table[index].key = strdup(key);
            ht->table[index].value = value;
            ht->table[index].occupied = true;
            return true;
        } else if (strcmp(ht->table[index].key, key) == 0) {
            ht->table[index].value = value;
            return true;
        }
    }

    return false;  // Table full
}

bool qpht_get(QuadraticProbingHT* ht, const char* key, int* value) {
    unsigned int hash = hash_function(key);

    for (int i = 0; i < TABLE_SIZE; i++) {
        unsigned int index = (hash + i * i) % TABLE_SIZE;

        if (ht->table[index].occupied) {
            if (strcmp(ht->table[index].key, key) == 0) {
                *value = ht->table[index].value;
                return true;
            }
        } else {
            break;
        }
    }

    return false;
}

void qpht_free(QuadraticProbingHT* ht) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (ht->table[i].occupied) {
            free(ht->table[i].key);
        }
    }
}

int main() {
    QuadraticProbingHT ht;
    qpht_init(&ht);

    qpht_insert(&ht, "apple", 1);
    qpht_insert(&ht, "banana", 2);
    qpht_insert(&ht, "cherry", 3);

    int value;
    if (qpht_get(&ht, "banana", &value)) {
        printf("Found banana: %d\n", value);
    }

    qpht_free(&ht);

    return 0;
}
```

## Double Hashing

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 11

typedef struct {
    char* key;
    int value;
    bool occupied;
} Entry;

typedef struct {
    Entry table[TABLE_SIZE];
} DoubleHashHT;

unsigned int hash1(const char* key) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash = hash * 31 + *key++;
    }
    return hash % TABLE_SIZE;
}

unsigned int hash2(const char* key) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash = hash * 37 + *key++;
    }
    return 7 - (hash % 7);
}

void dht_init(DoubleHashHT* ht) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        ht->table[i].occupied = false;
    }
}

bool dht_insert(DoubleHashHT* ht, const char* key, int value) {
    unsigned int h1 = hash1(key);
    unsigned int h2 = hash2(key);

    for (int i = 0; i < TABLE_SIZE; i++) {
        unsigned int index = (h1 + i * h2) % TABLE_SIZE;

        if (!ht->table[index].occupied) {
            ht->table[index].key = strdup(key);
            ht->table[index].value = value;
            ht->table[index].occupied = true;
            return true;
        } else if (strcmp(ht->table[index].key, key) == 0) {
            ht->table[index].value = value;
            return true;
        }
    }

    return false;
}

bool dht_get(DoubleHashHT* ht, const char* key, int* value) {
    unsigned int h1 = hash1(key);
    unsigned int h2 = hash2(key);

    for (int i = 0; i < TABLE_SIZE; i++) {
        unsigned int index = (h1 + i * h2) % TABLE_SIZE;

        if (ht->table[index].occupied) {
            if (strcmp(ht->table[index].key, key) == 0) {
                *value = ht->table[index].value;
                return true;
            }
        } else {
            break;
        }
    }

    return false;
}

void dht_free(DoubleHashHT* ht) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (ht->table[i].occupied) {
            free(ht->table[i].key);
        }
    }
}

int main() {
    DoubleHashHT ht;
    dht_init(&ht);

    dht_insert(&ht, "apple", 1);
    dht_insert(&ht, "banana", 2);
    dht_insert(&ht, "cherry", 3);

    int value;
    if (dht_get(&ht, "banana", &value)) {
        printf("Found banana: %d\n", value);
    }

    dht_free(&ht);

    return 0;
}
```

## Resizable Hash Table

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Node {
    char* key;
    int value;
    struct Node* next;
} Node;

typedef struct {
    Node** table;
    int size;
    int count;
} ResizableHT;

unsigned int hash_function(const char* key, int size) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash += *key++;
    }
    return hash % size;
}

void rht_init(ResizableHT* ht, int initial_size) {
    ht->size = initial_size;
    ht->count = 0;
    ht->table = (Node**)calloc(initial_size, sizeof(Node*));
}

void rht_resize(ResizableHT* ht) {
    int new_size = ht->size * 2;
    Node** new_table = (Node**)calloc(new_size, sizeof(Node*));

    for (int i = 0; i < ht->size; i++) {
        Node* current = ht->table[i];

        while (current != NULL) {
            unsigned int new_index = hash_function(current->key, new_size);
            Node* next = current->next;
            current->next = new_table[new_index];
            new_table[new_index] = current;
            current = next;
        }
    }

    free(ht->table);
    ht->table = new_table;
    ht->size = new_size;
}

void rht_insert(ResizableHT* ht, const char* key, int value) {
    if (ht->count > ht->size * 0.7) {
        rht_resize(ht);
    }

    unsigned int index = hash_function(key, ht->size);

    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->key = strdup(key);
    new_node->value = value;
    new_node->next = ht->table[index];

    ht->table[index] = new_node;
    ht->count++;
}

bool rht_get(ResizableHT* ht, const char* key, int* value) {
    unsigned int index = hash_function(key, ht->size);
    Node* current = ht->table[index];

    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            *value = current->value;
            return true;
        }
        current = current->next;
    }

    return false;
}

void rht_free(ResizableHT* ht) {
    for (int i = 0; i < ht->size; i++) {
        Node* current = ht->table[i];

        while (current != NULL) {
            Node* temp = current;
            current = current->next;
            free(temp->key);
            free(temp);
        }
    }

    free(ht->table);
}

int main() {
    ResizableHT ht;
    rht_init(&ht, 10);

    rht_insert(&ht, "apple", 1);
    rht_insert(&ht, "banana", 2);
    rht_insert(&ht, "cherry", 3);

    int value;
    if (rht_get(&ht, "banana", &value)) {
        printf("Found banana: %d\n", value);
    }

    printf("Load factor: %.2f\n", (double)ht->count / ht->size);

    rht_free(&ht);

    return 0;
}
```

## Hash Set

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define TABLE_SIZE 10

typedef struct Node {
    char* key;
    struct Node* next;
} Node;

typedef struct {
    Node* table[TABLE_SIZE];
} HashSet;

unsigned int hash_function(const char* key) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash += *key++;
    }
    return hash % TABLE_SIZE;
}

void hs_init(HashSet* hs) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        hs->table[i] = NULL;
    }
}

bool hs_insert(HashSet* hs, const char* key) {
    unsigned int index = hash_function(key);
    Node* current = hs->table[index];

    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            return true;  // Already exists
        }
        current = current->next;
    }

    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->key = strdup(key);
    new_node->next = hs->table[index];
    hs->table[index] = new_node;

    return true;
}

bool hs_contains(HashSet* hs, const char* key) {
    unsigned int index = hash_function(key);
    Node* current = hs->table[index];

    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            return true;
        }
        current = current->next;
    }

    return false;
}

void hs_free(HashSet* hs) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        Node* current = hs->table[i];

        while (current != NULL) {
            Node* temp = current;
            current = current->next;
            free(temp->key);
            free(temp);
        }
    }
}

int main() {
    HashSet hs;
    hs_init(&hs);

    hs_insert(&hs, "apple");
    hs_insert(&hs, "banana");
    hs_insert(&hs, "cherry");

    printf("Contains banana: %d\n", hs_contains(&hs, "banana"));
    printf("Contains orange: %d\n", hs_contains(&hs, "orange"));

    hs_free(&hs);

    return 0;
}
```

## Hash Map Delete

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 10

typedef struct Node {
    char* key;
    int value;
    struct Node* next;
} Node;

typedef struct {
    Node* table[TABLE_SIZE];
} HashMap;

unsigned int hash_function(const char* key) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash += *key++;
    }
    return hash % TABLE_SIZE;
}

void hm_init(HashMap* hm) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        hm->table[i] = NULL;
    }
}

bool hm_insert(HashMap* hm, const char* key, int value) {
    unsigned int index = hash_function(key);

    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->key = strdup(key);
    new_node->value = value;
    new_node->next = hm->table[index];

    hm->table[index] = new_node;

    return true;
}

bool hm_get(HashMap* hm, const char* key, int* value) {
    unsigned int index = hash_function(key);
    Node* current = hm->table[index];

    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            *value = current->value;
            return true;
        }
        current = current->next;
    }

    return false;
}

bool hm_delete(HashMap* hm, const char* key) {
    unsigned int index = hash_function(key);
    Node* current = hm->table[index];
    Node* prev = NULL;

    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            if (prev == NULL) {
                hm->table[index] = current->next;
            } else {
                prev->next = current->next;
            }
            free(current->key);
            free(current);
            return true;
        }
        prev = current;
        current = current->next;
    }

    return false;
}

void hm_free(HashMap* hm) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        Node* current = hm->table[i];

        while (current != NULL) {
            Node* temp = current;
            current = current->next;
            free(temp->key);
            free(temp);
        }
    }
}

int main() {
    HashMap hm;
    hm_init(&hm);

    hm_insert(&hm, "apple", 1);
    hm_insert(&hm, "banana", 2);
    hm_insert(&hm, "cherry", 3);

    int value;
    if (hm_get(&hm, "banana", &value)) {
        printf("Found banana: %d\n", value);
    }

    if (hm_delete(&hm, "banana")) {
        printf("Deleted banana\n");
    }

    hm_free(&hm);

    return 0;
}
```

## Universal Hashing

```c
#include <stdio.h>
#include <stdlib.h>

#define TABLE_SIZE 100
#define PRIME 101

unsigned int universal_hash(const char* key, int a, int b, int m) {
    unsigned int hash = 0;
    while (*key != '\0') {
        hash = a * hash + *key++;
    }
    return (a * hash + b) % m;
}

int main() {
    const char* keys[] = {"hello", "world", "test"};
    int a = 31;
    int b = 7;

    for (int i = 0; i < 3; i++) {
        unsigned int hash1 = universal_hash(keys[i], a, b, PRIME);
        unsigned int hash2 = universal_hash(keys[i], a * 2, b * 2, PRIME);

        printf("Hash of '%s': %u, %u\n", keys[i], hash1, hash2);
    }

    return 0;
}
```

> **Note**: Hash tables provide O(1) average case operations. Choose hash function and collision resolution based on use case.
