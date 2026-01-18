---
id: "c.algorithms.datastructures"
title: "Data Structures"
category: c.algorithms.sorting
difficulty: intermediate
tags: [c, data structures, stack, queue, list, tree]
keywords: [stack, queue, linked list, tree, hash]
use_cases: [data organization, c.algorithms.sorting, memory management]
prerequisites: ["c.pointers", "c.patterns.structs"]
related: ["c.algorithms.search"]
next_topics: ["c.algorithms.graph"]
---

# Data Structures

## Stack

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_SIZE 100

typedef struct {
    int data[MAX_SIZE];
    int top;
} Stack;

void stack_init(Stack* s) {
    s->top = -1;
}

bool stack_push(Stack* s, int value) {
    if (s->top >= MAX_SIZE - 1) {
        return false;
    }
    s->data[++s->top] = value;
    return true;
}

bool stack_pop(Stack* s, int* value) {
    if (s->top < 0) {
        return false;
    }
    *value = s->data[s->top--];
    return true;
}

bool stack_is_empty(const Stack* s) {
    return s->top < 0;
}

int main() {
    Stack s;
    stack_init(&s);

    stack_push(&s, 10);
    stack_push(&s, 20);
    stack_push(&s, 30);

    while (!stack_is_empty(&s)) {
        int value;
        stack_pop(&s, &value);
        printf("Popped: %d\n", value);
    }

    return 0;
}
```

## Queue

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_SIZE 100

typedef struct {
    int data[MAX_SIZE];
    int front, rear;
    int count;
} Queue;

void queue_init(Queue* q) {
    q->front = 0;
    q->rear = -1;
    q->count = 0;
}

bool queue_enqueue(Queue* q, int value) {
    if (q->count >= MAX_SIZE) {
        return false;
    }
    q->rear = (q->rear + 1) % MAX_SIZE;
    q->data[q->rear] = value;
    q->count++;
    return true;
}

bool queue_dequeue(Queue* q, int* value) {
    if (q->count <= 0) {
        return false;
    }
    *value = q->data[q->front];
    q->front = (q->front + 1) % MAX_SIZE;
    q->count--;
    return true;
}

bool queue_is_empty(const Queue* q) {
    return q->count <= 0;
}

int main() {
    Queue q;
    queue_init(&q);

    queue_enqueue(&q, 10);
    queue_enqueue(&q, 20);
    queue_enqueue(&q, 30);

    while (!queue_is_empty(&q)) {
        int value;
        queue_dequeue(&q, &value);
        printf("Dequeued: %d\n", value);
    }

    return 0;
}
```

## Linked List

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node* next;
} Node;

Node* list_create(int value) {
    Node* node = malloc(sizeof(Node));
    if (node != NULL) {
        node->data = value;
        node->next = NULL;
    }
    return node;
}

void list_append(Node** head, int value) {
    Node* new_node = list_create(value);

    if (*head == NULL) {
        *head = new_node;
    } else {
        Node* current = *head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
    }
}

void list_print(const Node* head) {
    const Node* current = head;
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}

void list_free(Node* head) {
    while (head != NULL) {
        Node* temp = head;
        head = head->next;
        free(temp);
    }
}

int main() {
    Node* head = NULL;

    list_append(&head, 10);
    list_append(&head, 20);
    list_append(&head, 30);

    list_print(head);
    list_free(head);

    return 0;
}
```

## Doubly Linked List

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node* prev;
    struct Node* next;
} Node;

Node* dllist_create(int value) {
    Node* node = malloc(sizeof(Node));
    if (node != NULL) {
        node->data = value;
        node->prev = NULL;
        node->next = NULL;
    }
    return node;
}

void dllist_append(Node** head, int value) {
    Node* new_node = dllist_create(value);

    if (*head == NULL) {
        *head = new_node;
    } else {
        Node* current = *head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
        new_node->prev = current;
    }
}

void dllist_print(const Node* head) {
    const Node* current = head;
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}

void dllist_free(Node* head) {
    while (head != NULL) {
        Node* temp = head;
        head = head->next;
        free(temp);
    }
}

int main() {
    Node* head = NULL;

    dllist_append(&head, 10);
    dllist_append(&head, 20);
    dllist_append(&head, 30);

    dllist_print(head);
    dllist_free(head);

    return 0;
}
```

## Binary Tree

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct TreeNode {
    int data;
    struct TreeNode* left;
    struct TreeNode* right;
} TreeNode;

TreeNode* tree_create(int value) {
    TreeNode* node = malloc(sizeof(TreeNode));
    if (node != NULL) {
        node->data = value;
        node->left = NULL;
        node->right = NULL;
    }
    return node;
}

void tree_insert(TreeNode** root, int value) {
    if (*root == NULL) {
        *root = tree_create(value);
        return;
    }

    if (value < (*root)->data) {
        tree_insert(&(*root)->left, value);
    } else {
        tree_insert(&(*root)->right, value);
    }
}

void tree_print_inorder(const TreeNode* root) {
    if (root != NULL) {
        tree_print_inorder(root->left);
        printf("%d ", root->data);
        tree_print_inorder(root->right);
    }
}

void tree_free(TreeNode* root) {
    if (root != NULL) {
        tree_free(root->left);
        tree_free(root->right);
        free(root);
    }
}

int main() {
    TreeNode* root = NULL;

    tree_insert(&root, 50);
    tree_insert(&root, 30);
    tree_insert(&root, 70);
    tree_insert(&root, 20);
    tree_insert(&root, 40);

    printf("Inorder traversal: ");
    tree_print_inorder(root);
    printf("\n");

    tree_free(root);

    return 0;
}
```

## Hash Table

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

typedef struct HashEntry {
    const char* key;
    int value;
    struct HashEntry* next;
} HashEntry;

typedef struct {
    HashEntry* entries[TABLE_SIZE];
} HashTable;

unsigned int hash(const char* key) {
    unsigned long hash = 5381;
    int c;

    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c;
    }

    return hash % TABLE_SIZE;
}

void ht_init(HashTable* table) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->entries[i] = NULL;
    }
}

void ht_insert(HashTable* table, const char* key, int value) {
    unsigned int index = hash(key);

    HashEntry* new_entry = malloc(sizeof(HashEntry));
    new_entry->key = key;
    new_entry->value = value;
    new_entry->next = table->entries[index];
    table->entries[index] = new_entry;
}

bool ht_get(const HashTable* table, const char* key, int* value) {
    unsigned int index = hash(key);
    HashEntry* entry = table->entries[index];

    while (entry != NULL) {
        if (strcmp(entry->key, key) == 0) {
            *value = entry->value;
            return true;
        }
        entry = entry->next;
    }

    return false;
}

int main() {
    HashTable table;
    ht_init(&table);

    ht_insert(&table, "apple", 1);
    ht_insert(&table, "banana", 2);
    ht_insert(&table, "cherry", 3);

    int value;
    if (ht_get(&table, "banana", &value)) {
        printf("banana = %d\n", value);
    }

    return 0;
}
```

## Priority Queue

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_SIZE 100

typedef struct {
    int data[MAX_SIZE];
    int size;
} PriorityQueue;

void pq_init(PriorityQueue* pq) {
    pq->size = 0;
}

void pq_swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void pq_heapify(PriorityQueue* pq, int index) {
    int largest = index;
    int left = 2 * index + 1;
    int right = 2 * index + 2;

    if (left < pq->size && pq->data[left] > pq->data[largest]) {
        largest = left;
    }

    if (right < pq->size && pq->data[right] > pq->data[largest]) {
        largest = right;
    }

    if (largest != index) {
        pq_swap(&pq->data[index], &pq->data[largest]);
        pq_heapify(pq, largest);
    }
}

bool pq_insert(PriorityQueue* pq, int value) {
    if (pq->size >= MAX_SIZE) {
        return false;
    }

    pq->data[pq->size++] = value;

    for (int i = pq->size / 2 - 1; i >= 0; i--) {
        pq_heapify(pq, i);
    }

    return true;
}

bool pq_extract_max(PriorityQueue* pq, int* value) {
    if (pq->size <= 0) {
        return false;
    }

    *value = pq->data[0];
    pq->data[0] = pq->data[--pq->size];

    pq_heapify(pq, 0);
    return true;
}

int main() {
    PriorityQueue pq;
    pq_init(&pq);

    pq_insert(&pq, 30);
    pq_insert(&pq, 10);
    pq_insert(&pq, 20);
    pq_insert(&pq, 40);

    printf("Extracted: ");
    int value;
    while (pq_extract_max(&pq, &value)) {
        printf("%d ", value);
    }
    printf("\n");

    return 0;
}
```

## Set (using Hash Table)

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define SET_SIZE 100

typedef struct SetNode {
    int data;
    struct SetNode* next;
} SetNode;

typedef struct {
    SetNode* buckets[SET_SIZE];
    int count;
} Set;

unsigned int set_hash(int value) {
    return (unsigned int)(value * 31) % SET_SIZE;
}

void set_init(Set* s) {
    for (int i = 0; i < SET_SIZE; i++) {
        s->buckets[i] = NULL;
    }
    s->count = 0;
}

bool set_add(Set* s, int value) {
    unsigned int index = set_hash(value);
    SetNode* node = s->buckets[index];

    // Check if already exists
    while (node != NULL) {
        if (node->data == value) {
            return false;
        }
        node = node->next;
    }

    // Add new node
    SetNode* new_node = malloc(sizeof(SetNode));
    new_node->data = value;
    new_node->next = s->buckets[index];
    s->buckets[index] = new_node;
    s->count++;

    return true;
}

bool set_contains(const Set* s, int value) {
    unsigned int index = set_hash(value);
    SetNode* node = s->buckets[index];

    while (node != NULL) {
        if (node->data == value) {
            return true;
        }
        node = node->next;
    }

    return false;
}

int main() {
    Set s;
    set_init(&s);

    set_add(&s, 10);
    set_add(&s, 20);
    set_add(&s, 30);

    printf("Contains 20: %d\n", set_contains(&s, 20));
    printf("Contains 40: %d\n", set_contains(&s, 40));

    return 0;
}
```

## Deque (Double-Ended Queue)

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_SIZE 100

typedef struct {
    int data[MAX_SIZE];
    int front, rear;
    int count;
} Deque;

void deque_init(Deque* dq) {
    dq->front = 0;
    dq->rear = -1;
    dq->count = 0;
}

bool deque_push_front(Deque* dq, int value) {
    if (dq->count >= MAX_SIZE) {
        return false;
    }

    dq->front = (dq->front - 1 + MAX_SIZE) % MAX_SIZE;
    dq->data[dq->front] = value;
    dq->count++;
    return true;
}

bool deque_push_back(Deque* dq, int value) {
    if (dq->count >= MAX_SIZE) {
        return false;
    }

    dq->rear = (dq->rear + 1) % MAX_SIZE;
    dq->data[dq->rear] = value;
    dq->count++;
    return true;
}

bool deque_pop_front(Deque* dq, int* value) {
    if (dq->count <= 0) {
        return false;
    }

    *value = dq->data[dq->front];
    dq->front = (dq->front + 1) % MAX_SIZE;
    dq->count--;
    return true;
}

bool deque_pop_back(Deque* dq, int* value) {
    if (dq->count <= 0) {
        return false;
    }

    *value = dq->data[dq->rear];
    dq->rear = (dq->rear - 1 + MAX_SIZE) % MAX_SIZE;
    dq->count--;
    return true;
}

int main() {
    Deque dq;
    deque_init(&dq);

    deque_push_back(&dq, 10);
    deque_push_back(&dq, 20);
    deque_push_front(&dq, 5);

    int value;
    deque_pop_front(&dq, &value);
    printf("Popped front: %d\n", value);

    deque_pop_back(&dq, &value);
    printf("Popped back: %d\n", value);

    return 0;
}
```

## Circular Buffer

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define BUFFER_SIZE 10

typedef struct {
    int data[BUFFER_SIZE];
    int head, tail;
    int count;
} CircularBuffer;

void cb_init(CircularBuffer* cb) {
    cb->head = 0;
    cb->tail = 0;
    cb->count = 0;
}

bool cb_write(CircularBuffer* cb, int value) {
    if (cb->count >= BUFFER_SIZE) {
        return false;
    }

    cb->data[cb->head] = value;
    cb->head = (cb->head + 1) % BUFFER_SIZE;
    cb->count++;
    return true;
}

bool cb_read(CircularBuffer* cb, int* value) {
    if (cb->count <= 0) {
        return false;
    }

    *value = cb->data[cb->tail];
    cb->tail = (cb->tail + 1) % BUFFER_SIZE;
    cb->count--;
    return true;
}

int main() {
    CircularBuffer cb;
    cb_init(&cb);

    cb_write(&cb, 1);
    cb_write(&cb, 2);
    cb_write(&cb, 3);

    int value;
    while (cb_read(&cb, &value)) {
        printf("Read: %d\n", value);
    }

    return 0;
}
```

> **Note**: Choose data structure based on use case: Stack (LIFO), Queue (FIFO), Hash Table (O(1) lookup).
