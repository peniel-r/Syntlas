---
id: "c.patterns.datastructures"
title: Advanced Data Structures
category: c.algorithms.sorting
difficulty: advanced
tags:
  - 
  - linked-list
  - tree
  - hash-table
keywords:
  - linked list
  - tree
  - binary search tree
  - hash table
  - graph
use_cases:
  - Efficient data storage
  - Algorithm implementation
  - Data organization
  - Performance optimization
prerequisites:
  - 
  - 
  - c.dynamic.alloc
related:
  - c.algorithms.sorting
  - c.dynamic.alloc
next_topics:
  - c.algorithms.sorting
---

# Advanced Data Structures

Complex data structures for efficient data management.

## Binary Search Tree

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node *left;
    struct Node *right;
} Node;

Node *node_create(int data) {
    Node *node = malloc(sizeof(Node));
    if (node) {
        node->data = data;
        node->left = NULL;
        node->right = NULL;
    }
    return node;
}

Node *bst_insert(Node *root, int data) {
    if (root == NULL) {
        return node_create(data);
    }

    if (data < root->data) {
        root->left = bst_insert(root->left, data);
    } else if (data > root->data) {
        root->right = bst_insert(root->right, data);
    }

    return root;
}

Node *bst_search(Node *root, int data) {
    if (root == NULL || root->data == data) {
        return root;
    }

    if (data < root->data) {
        return bst_search(root->left, data);
    } else {
        return bst_search(root->right, data);
    }
}

void bst_inorder(Node *root) {
    if (root != NULL) {
        bst_inorder(root->left);
        printf("%d ", root->data);
        bst_inorder(root->right);
    }
}

void bst_free(Node *root) {
    if (root != NULL) {
        bst_free(root->left);
        bst_free(root->right);
        free(root);
    }
}

int main(void) {
    Node *root = NULL;

    root = bst_insert(root, 50);
    bst_insert(root, 30);
    bst_insert(root, 70);
    bst_insert(root, 20);
    bst_insert(root, 40);
    bst_insert(root, 60);
    bst_insert(root, 80);

    printf("Inorder traversal: ");
    bst_inorder(root);
    printf("\n");

    Node *found = bst_search(root, 40);
    printf("Search 40: %s\n", found ? "found" : "not found");

    bst_free(root);
    return 0;
}
```

## Hash Table (Chaining)

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 10

typedef struct HashEntry {
    char *key;
    int value;
    struct HashEntry *next;
} HashEntry;

typedef struct {
    HashEntry **entries;
    int size;
} HashTable;

unsigned int hash(const char *key) {
    unsigned int hash = 0;
    while (*key) {
        hash = (hash << 5) + *key++;
    }
    return hash % TABLE_SIZE;
}

HashTable *hash_table_create(int size) {
    HashTable *table = malloc(sizeof(HashTable));
    table->entries = calloc(size, sizeof(HashEntry *));
    table->size = size;
    return table;
}

void hash_table_put(HashTable *table, const char *key, int value) {
    unsigned int index = hash(key);

    HashEntry *entry = table->entries[index];
    HashEntry *prev = NULL;

    while (entry != NULL && strcmp(entry->key, key) != 0) {
        prev = entry;
        entry = entry->next;
    }

    if (entry == NULL) {
        entry = malloc(sizeof(HashEntry));
        entry->key = strdup(key);
        entry->value = value;
        entry->next = NULL;

        if (prev == NULL) {
            table->entries[index] = entry;
        } else {
            prev->next = entry;
        }
    } else {
        entry->value = value;
    }
}

int hash_table_get(HashTable *table, const char *key, int *value) {
    unsigned int index = hash(key);
    HashEntry *entry = table->entries[index];

    while (entry != NULL) {
        if (strcmp(entry->key, key) == 0) {
            *value = entry->value;
            return 1;
        }
        entry = entry->next;
    }

    return 0;
}

void hash_table_free(HashTable *table) {
    for (int i = 0; i < table->size; i++) {
        HashEntry *entry = table->entries[i];
        while (entry != NULL) {
            HashEntry *next = entry->next;
            free(entry->key);
            free(entry);
            entry = next;
        }
    }
    free(table->entries);
    free(table);
}

int main(void) {
    HashTable *table = hash_table_create(TABLE_SIZE);

    hash_table_put(table, "name", 42);
    hash_table_put(table, "age", 30);
    hash_table_put(table, "score", 95);

    int value;
    if (hash_table_get(table, "name", &value)) {
        printf("name: %d\n", value);
    }
    if (hash_table_get(table, "age", &value)) {
        printf("age: %d\n", value);
    }

    hash_table_free(table);
    return 0;
}
```

## Graph (Adjacency List)

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int vertex;
    struct Node *next;
} Node;

typedef struct {
    int num_vertices;
    Node **adj_lists;
} Graph;

Graph *graph_create(int vertices) {
    Graph *graph = malloc(sizeof(Graph));
    graph->num_vertices = vertices;
    graph->adj_lists = calloc(vertices, sizeof(Node *));
    return graph;
}

void graph_add_edge(Graph *graph, int src, int dest) {
    Node *new_node = malloc(sizeof(Node));
    new_node->vertex = dest;
    new_node->next = graph->adj_lists[src];
    graph->adj_lists[src] = new_node;

    // For undirected graph, add edge in reverse directionn
    /*
    new_node = malloc(sizeof(Node));
    new_node->vertex = src;
    new_node->next = graph->adj_lists[dest];
    graph->adj_lists[dest] = new_node;
    */
}

void graph_bfs(Graph *graph, int start) {
    int *visited = calloc(graph->num_vertices, sizeof(int));
    int *queue = malloc(graph->num_vertices * sizeof(int));
    int front = 0, rear = 0;

    visited[start] = 1;
    queue[rear++] = start;

    printf("BFS starting from vertex %d: ", start);

    while (front < rear) {
        int current = queue[front++];
        printf("%d ", current);

        Node *temp = graph->adj_lists[current];
        while (temp != NULL) {
            if (!visited[temp->vertex]) {
                visited[temp->vertex] = 1;
                queue[rear++] = temp->vertex;
            }
            temp = temp->next;
        }
    }
    printf("\n");

    free(visited);
    free(queue);
}

void graph_dfs(Graph *graph, int vertex, int *visited) {
    visited[vertex] = 1;
    printf("%d ", vertex);

    Node *temp = graph->adj_lists[vertex];
    while (temp != NULL) {
        if (!visited[temp->vertex]) {
            graph_dfs(graph, temp->vertex, visited);
        }
        temp = temp->next;
    }
}

void graph_free(Graph *graph) {
    for (int i = 0; i < graph->num_vertices; i++) {
        Node *temp = graph->adj_lists[i];
        while (temp != NULL) {
            Node *next = temp->next;
            free(temp);
            temp = next;
        }
    }
    free(graph->adj_lists);
    free(graph);
}

int main(void) {
    int vertices = 5;
    Graph *graph = graph_create(vertices);

    graph_add_edge(graph, 0, 1);
    graph_add_edge(graph, 0, 2);
    graph_add_edge(graph, 1, 3);
    graph_add_edge(graph, 2, 4);
    graph_add_edge(graph, 3, 4);

    graph_bfs(graph, 0);

    printf("DFS: ");
    int *visited = calloc(vertices, sizeof(int));
    graph_dfs(graph, 0, visited);
    printf("\n");
    free(visited);

    graph_free(graph);
    return 0;
}
```

## Priority Queue (Binary Heap)

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int *data;
    int size;
    int capacity;
} PriorityQueue;

PriorityQueue *pq_create(int capacity) {
    PriorityQueue *pq = malloc(sizeof(PriorityQueue));
    pq->data = malloc(capacity * sizeof(int));
    pq->size = 0;
    pq->capacity = capacity;
    return pq;
}

void pq_swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void pq_heapify(PriorityQueue *pq, int i) {
    int smallest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < pq->size && pq->data[left] < pq->data[smallest]) {
        smallest = left;
    }

    if (right < pq->size && pq->data[right] < pq->data[smallest]) {
        smallest = right;
    }

    if (smallest != i) {
        pq_swap(&pq->data[i], &pq->data[smallest]);
        pq_heapify(pq, smallest);
    }
}

void pq_insert(PriorityQueue *pq, int value) {
    if (pq->size >= pq->capacity) {
        return;  // Heap full
    }

    pq->data[pq->size++] = value;

    int i = pq->size - 1;
    while (i != 0 && pq->data[(i - 1) / 2] > pq->data[i]) {
        pq_swap(&pq->data[i], &pq->data[(i - 1) / 2]);
        i = (i - 1) / 2;
    }
}

int pq_extract_min(PriorityQueue *pq) {
    if (pq->size <= 0) {
        return -1;
    }

    int min = pq->data[0];
    pq->data[0] = pq->data[--pq->size];

    pq_heapify(pq, 0);
    return min;
}

void pq_free(PriorityQueue *pq) {
    free(pq->data);
    free(pq);
}

int main(void) {
    PriorityQueue *pq = pq_create(10);

    pq_insert(pq, 30);
    pq_insert(pq, 20);
    pq_insert(pq, 15);
    pq_insert(pq, 40);
    pq_insert(pq, 50);

    printf("Extracted elements: ");
    while (pq->size > 0) {
        printf("%d ", pq_extract_min(pq));
    }
    printf("\n");

    pq_free(pq);
    return 0;
}
```

## Best Practices

### Choose Appropriate Data Structure

```c
// Arrays: Fast access by index, fixed size
// Linked Lists: Dynamic size, easy insertion/deletion
// Hash Tables: Fast lookup, memory overhead
// Trees: Ordered data, balanced operations
// Graphs: Representing relationships
// Heaps: Priority operations
```

### Free Memory Properly

```c
// GOOD - Free all allocated memory
while (head != NULL) {
    Node *temp = head;
    head = head->next;
    free(temp);
}

// BAD - Memory leak
while (head != NULL) {
    head = head->next;
}
```

### Handle Edge Cases

```c
// GOOD - Check for NULL
if (root == NULL) return;

// GOOD - Handle empty structures
if (size == 0) return;
```

## Common Pitfalls

### 1. Memory Leaks

```c
// WRONG - Not freeing nodes
while (head->next != NULL) {
    head = head->next;
}

// CORRECT - Free each node
while (head != NULL) {
    Node *temp = head;
    head = head->next;
    free(temp);
}
```

### 2. Null Pointer Dereference

```c
// WRONG - Might crash
node->next = new_node;

// CORRECT - Check for NULL
if (node != NULL) {
    node->next = new_node;
}
```

### 3. Stack Overflow

```c
// WRONG - Recursive on large inputs
void process_large_tree(Node *node) {
    if (node == NULL) return;
    process_large_tree(node->left);
    process_large_tree(node->right);
}

// CORRECT - Use iterative approach
void process_large_tree_iterative(Node *root) {
    // Use stack/queue
}
```

> **Note: Choose data structures based on your use case. Consider time and space complexity. Always free allocated memory. Handle edge cases properly.
