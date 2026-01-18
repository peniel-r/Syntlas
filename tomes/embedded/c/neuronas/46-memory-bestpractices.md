---
id: "c.bestpractices.memory"
title: "Memory Best Practices"
category: bestpractices
difficulty: intermediate
tags: [c, bestpractices, memory, leaks, safety]
keywords: [memory, leak, safety, alloc, free]
use_cases: [robust code, debugging, reliability]
prerequisites: ["c.pointers", "c.stdlib"]
related: ["c.stdlib.exit"]
next_topics: ["c.bestpractices.safety"]
---

# Memory Best Practices

## Initialize Pointers

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Always initialize pointers
    int* ptr = NULL;

    // Check before use
    if (ptr != NULL) {
        *ptr = 42;
    }

    return 0;
}
```

## Pair malloc with free

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int* arr = malloc(10 * sizeof(int));
    if (arr == NULL) {
        return 1;
    }

    // Use arr
    for (int i = 0; i < 10; i++) {
        arr[i] = i;
    }

    // Always free
    free(arr);

    return 0;
}
```

## Free After realloc

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int* arr = malloc(10 * sizeof(int));
    if (arr == NULL) {
        return 1;
    }

    // Use arr...

    // Resize
    int* new_arr = realloc(arr, 20 * sizeof(int));
    if (new_arr == NULL) {
        free(arr);  // Free original
        return 1;
    }

    // new_arr may be same as arr or new
    arr = new_arr;

    // Use arr...

    free(arr);

    return 0;
}
```

## Double Free Protection

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int* ptr = malloc(sizeof(int));
    if (ptr == NULL) {
        return 1;
    }

    *ptr = 42;
    free(ptr);
    ptr = NULL;  // Set to NULL after free

    if (ptr != NULL) {
        free(ptr);  // This won't execute
    }

    return 0;
}
```

## Memory Leak Detection

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_ALLOCATIONS 1000

typedef struct {
    void* ptr;
    size_t size;
    const char* file;
    int line;
} Allocation;

static Allocation allocations[MAX_ALLOCATIONS];
static int alloc_count = 0;

void* tracked_malloc(size_t size, const char* file, int line) {
    void* ptr = malloc(size);
    if (ptr != NULL && alloc_count < MAX_ALLOCATIONS) {
        allocations[alloc_count].ptr = ptr;
        allocations[alloc_count].size = size;
        allocations[alloc_count].file = file;
        allocations[alloc_count].line = line;
        alloc_count++;
    }
    return ptr;
}

void tracked_free(void* ptr, const char* file, int line) {
    if (ptr == NULL) return;

    for (int i = 0; i < alloc_count; i++) {
        if (allocations[i].ptr == ptr) {
            allocations[i] = allocations[--alloc_count];
            free(ptr);
            return;
        }
    }

    printf("Free of untracked pointer: %p at %s:%d\n", ptr, file, line);
}

void report_leaks(void) {
    printf("Memory leaks detected:\n");
    for (int i = 0; i < alloc_count; i++) {
        printf("  %p: %zu bytes at %s:%d\n",
               allocations[i].ptr,
               allocations[i].size,
               allocations[i].file,
               allocations[i].line);
    }
}

#define MALLOC(size) tracked_malloc(size, __FILE__, __LINE__)
#define FREE(ptr) tracked_free(ptr, __FILE__, __LINE__)

int main() {
    int* a = MALLOC(sizeof(int));
    int* b = MALLOC(sizeof(int));

    FREE(a);
    // b is leaked

    report_leaks();

    return 0;
}
```

## Use calloc for Zero-Initialized Memory

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // calloc zeros memory
    int* arr = calloc(10, sizeof(int));
    if (arr == NULL) {
        return 1;
    }

    // All values are 0
    for (int i = 0; i < 10; i++) {
        printf("%d ", arr[i]);  // All 0s
    }
    printf("\n");

    free(arr);

    return 0;
}
```

## Allocate with Size Calculation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* name;
    int age;
} Person;

Person* create_person(const char* name, int age) {
    // Allocate struct + name
    Person* p = malloc(sizeof(Person));
    if (p == NULL) {
        return NULL;
    }

    p->name = malloc(strlen(name) + 1);
    if (p->name == NULL) {
        free(p);
        return NULL;
    }

    strcpy(p->name, name);
    p->age = age;

    return p;
}

void free_person(Person* p) {
    if (p != NULL) {
        free(p->name);  // Free name first
        free(p);
    }
}

int main() {
    Person* p = create_person("Alice", 30);
    if (p != NULL) {
        printf("%s: %d\n", p->name, p->age);
        free_person(p);
    }

    return 0;
}
```

## Check malloc Return

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int* ptr = malloc(10000000000);  // Large allocation

    if (ptr == NULL) {
        printf("Allocation failed\n");
        return 1;
    }

    free(ptr);
    return 0;
}
```

## Memory Pool for Fixed-Size Objects

```c
#include <stdio.h>
#include <stdlib.h>

#define POOL_SIZE 100

typedef struct {
    int data;
    struct Node* next;
} Node;

typedef struct {
    Node* free_list;
    Node* pool;
} MemoryPool;

void pool_init(MemoryPool* pool) {
    pool->pool = malloc(POOL_SIZE * sizeof(Node));
    if (pool->pool == NULL) {
        pool->free_list = NULL;
        return;
    }

    // Initialize free list
    for (int i = 0; i < POOL_SIZE - 1; i++) {
        pool->pool[i].next = &pool->pool[i + 1];
    }
    pool->pool[POOL_SIZE - 1].next = NULL;
    pool->free_list = pool->pool;
}

Node* pool_alloc(MemoryPool* pool) {
    if (pool->free_list == NULL) {
        return NULL;  // Pool exhausted
    }

    Node* node = pool->free_list;
    pool->free_list = node->next;
    return node;
}

void pool_free(MemoryPool* pool, Node* node) {
    node->next = pool->free_list;
    pool->free_list = node;
}

void pool_cleanup(MemoryPool* pool) {
    if (pool->pool != NULL) {
        free(pool->pool);
    }
}

int main() {
    MemoryPool pool;
    pool_init(&pool);

    Node* a = pool_alloc(&pool);
    Node* b = pool_alloc(&pool);

    if (a != NULL) a->data = 1;
    if (b != NULL) b->data = 2;

    if (a != NULL) pool_free(&pool, a);
    if (b != NULL) pool_free(&pool, b);

    pool_cleanup(&pool);

    return 0;
}
```

## Use sizeof with Correct Type

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Correct: sizeof(*ptr)
    int* ptr1 = malloc(sizeof(*ptr1));

    // Also correct: sizeof(int)
    int* ptr2 = malloc(sizeof(int));

    // Wrong: sizeof(ptr) - allocates pointer size
    // int* ptr3 = malloc(sizeof(ptr));

    free(ptr1);
    free(ptr2);

    return 0;
}
```

## Avoid Buffer Overflow

```c
#include <stdio.h>
#include <string.h>

void safe_copy(char* dest, const char* src, size_t dest_size) {
    if (dest_size == 0) return;

    strncpy(dest, src, dest_size - 1);
    dest[dest_size - 1] = '\0';
}

int main() {
    char buffer[10];

    safe_copy(buffer, "Hello, World!", sizeof(buffer));
    printf("Buffer: %s\n", buffer);

    return 0;
}
```

## Memory Alignment

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Aligned allocation
    void* ptr = aligned_alloc(16, 64);

    if (ptr != NULL) {
        printf("Address: %p\n", ptr);
        printf("Is 16-byte aligned: %s\n",
               ((uintptr_t)ptr % 16 == 0) ? "yes" : "no");

        free(ptr);
    }

    return 0;
}
```

## Use Valgrind-Friendly Code

```c
#include <stdio.h>
#include <stdlib.h>

void valgrind_friendly(void) {
    // Initialize all variables
    int value = 0;
    int* ptr = NULL;

    // Check before use
    ptr = malloc(sizeof(int));
    if (ptr != NULL) {
        *ptr = 42;
        value = *ptr;
        free(ptr);
        ptr = NULL;
    }

    printf("Value: %d\n", value);
}

int main() {
    valgrind_friendly();
    return 0;
}
```

## Stack vs Heap

```c
#include <stdio.h>
#include <stdlib.h>

void stack_example(void) {
    // Stack allocation (fast, auto-free)
    int arr[100];

    for (int i = 0; i < 100; i++) {
        arr[i] = i;
    }

    // Auto-freed when function returns
}

void heap_example(void) {
    // Heap allocation (slower, manual-free)
    int* arr = malloc(100 * sizeof(int));

    if (arr != NULL) {
        for (int i = 0; i < 100; i++) {
            arr[i] = i;
        }

        free(arr);  // Must free manually
    }
}

int main() {
    stack_example();
    heap_example();

    return 0;
}
```

> **Note**: Always pair `malloc` with `free`. Use `calloc` for zero-initialized memory. Check allocations for NULL.
