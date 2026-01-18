---
id: "c.dynamic.alloc"
title: "Dynamic Memory Allocation"
category: stdlib
difficulty: intermediate
tags: [c, malloc, calloc, realloc, free, dynamic, heap, pointer]
keywords: [malloc, calloc, realloc, free, memory, allocation, pointer]
use_cases: [dynamic arrays, memory management, heap allocation, pointer arithmetic]
prerequisites: ["c.pointers"]
related: ["c.stdlib.string"]
next_topics: ["c.functions"]
---

# Dynamic Memory Allocation

C's <stdlib.h> provides functions for dynamic memory allocation.

## malloc - Basic Allocation

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate uninitialized memory
    int* ptr = (int*)malloc(sizeof(int) * 10);
    if (ptr == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }
    
    // Use memory
    for (int i = 0; i < 10; i++) {
        ptr[i] = i + 1;
    }
    
    // Free memory
    free(ptr);
    
    printf("Allocation successful\n");
    return 0;
}
```

## calloc - Zero-Initialized Allocation

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate zero-initialized memory
    int* ptr = (int*)calloc(10, sizeof(int));
    if (ptr == NULL) {
        fprintf(stderr, "calloc failed\n");
        return 1;
    }
    
    printf("First value: %d\n", ptr[0]);  // All zeros
    
    free(ptr);
    return 0;
}
```

## realloc - Resizing Allocation

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate initial array
    int* arr = (int*)malloc(sizeof(int) * 5);
    if (arr == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }
    
    // Initialize
    for (int i = 0; i < 5; i++) {
        arr[i] = i;
    }
    
    // Resize array
    int* new_arr = (int*)realloc(arr, sizeof(int) * 10);
    if (new_arr == NULL) {
        fprintf(stderr, "realloc failed\n");
        free(arr);
        return 1;
    }
    
    // Initialize new elements
    for (int i = 5; i < 10; i++) {
        new_arr[i] = i;
    }
    
    printf("Resized from %d to %d elements\n", 5, 10);
    
    free(new_arr);
    return 0;
}
```

## aligned_alloc - Aligned Allocation

```c
#include <stdlib.h>
#include <stdio.h>

int main() {
    // Allocate aligned memory
    int* ptr = (int*)aligned_alloc(16, sizeof(int) * 10);
    if (ptr == NULL) {
        fprintf(stderr, "aligned_alloc failed\n");
        return 1;
    }
    
    for (int i = 0; i < 10; i++) {
        ptr[i] = i * 2;
    }
    
    free(ptr);
    return 0;
}
```

## free - Free Memory

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate and immediately free (demonstration)
    int* ptr = malloc(sizeof(int));
    if (ptr == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }
    
    // Free memory
    free(ptr);
    
    // ptr is now invalid - accessing is undefined behavior
    // int invalid = *ptr;  // Dangerous!
    
    printf("Memory freed\n");
    return 0;
}
```

## Memory Pool Pattern

```c
#include <stdio.h>
#include <stdlib.h>

#define POOL_SIZE 100

typedef struct {
    void* pool[POOL_SIZE];
    int next_free;
} MemoryPool;

void init_pool(MemoryPool* pool) {
    for (int i = 0; i < POOL_SIZE; i++) {
        pool->pool[i] = NULL;
    }
    pool->next_free = 0;
}

void* pool_alloc(MemoryPool* pool, size_t size) {
    if (size > POOL_SIZE) return NULL;
    
    for (int i = pool->next_free; i < POOL_SIZE; i++) {
        if (i + size <= POOL_SIZE) {
            void* block = pool->pool[i];
            pool->pool[i] = block;
            pool->next_free = i + 1;
            return block;
        }
    }
    
    return NULL;  // Pool exhausted
}

void pool_free(MemoryPool* pool, void* ptr) {
    for (int i = 0; i < POOL_SIZE; i++) {
        if (pool->pool[i] == ptr) {
            pool->pool[i] = NULL;
            pool->next_free--;
            return;
        }
    }
}

int main() {
    MemoryPool pool;
    init_pool(&pool);
    
    void* ptr1 = pool_alloc(&pool, sizeof(int));
    void* ptr2 = pool_alloc(&pool, sizeof(int));
    void* ptr3 = pool_alloc(&pool, sizeof(int));
    
    // Free allocations
    pool_free(&pool, ptr1);
    pool_free(&pool, ptr2);
    pool_free(&pool, ptr3);
    
    printf("Pool operations completed\n");
    return 0;
}
```

## Stack vs Heap

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Stack allocation (fast, automatic cleanup)
    int stack_array[100];
    for (int i = 0; i < 100; i++) {
        stack_array[i] = i;
    }
    
    // Heap allocation (slower, manual cleanup)
    int* heap_array = (int*)malloc(sizeof(int) * 100);
    if (heap_array == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }
    
    for (int i = 0; i < 100; i++) {
        heap_array[i] = i;
    }
    
    free(heap_array);
    
    printf("Comparison complete\n");
    return 0;
}
```

## Memory Leak Prevention

```c
#include <stdio.h>
#include <stdlib.h>

void process_data(void) {
    int* data = malloc(sizeof(int) * 100);
    if (data == NULL) return;
    
    // Use data
    int sum = 0;
    for (int i = 0; i < 100; i++) {
        sum += data[i];
    }
    
    // CRITICAL: Free before returning
    free(data);
}

int main() {
    process_data();
    printf("Memory freed properly\n");
    return 0;
}
```

## Tracking Allocations

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_ALLOCATIONS 1000

typedef struct {
    void* allocations[MAX_ALLOCATIONS];
    size_t sizes[MAX_ALLOCATIONS];
    int count;
} AllocationTracker;

void init_tracker(AllocationTracker* tracker) {
    tracker->count = 0;
    for (int i = 0; i < MAX_ALLOCATIONS; i++) {
        tracker->allocations[i] = NULL;
        tracker->sizes[i] = 0;
    }
}

void track_alloc(AllocationTracker* tracker, void* ptr, size_t size) {
    if (tracker->count >= MAX_ALLOCATIONS) {
        // Replace oldest allocation
        free(tracker->allocations[0]);
        tracker->allocations[0] = ptr;
        tracker->sizes[0] = size;
    } else {
        tracker->allocations[tracker->count] = ptr;
        tracker->sizes[tracker->count] = size;
        tracker->count++;
    }
}

void cleanup_tracker(AllocationTracker* tracker) {
    for (int i = 0; i < tracker->count; i++) {
        free(tracker->allocations[i]);
    }
    tracker->count = 0;
}

int main() {
    AllocationTracker tracker;
    init_tracker(&tracker);
    
    void* ptrs[10];
    for (int i = 0; i < 10; i++) {
        ptrs[i] = malloc(sizeof(int));
        track_alloc(&tracker, ptrs[i], sizeof(int));
    }
    
    cleanup_tracker(&tracker);
    printf("Allocations tracked\n");
    return 0;
}
```

## Array vs Pointer for Strings

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    // String as pointer (null-terminated)
    const char* str1 = "Hello";
    char* str1_copy = malloc(strlen(str1) + 1);
    if (str1_copy != NULL) {
        strcpy(str1_copy, str1);
        str1_copy[strlen(str1)] = '\0';
    }
    
    // String array (array of pointers)
    const char* strings[] = {"Hello", "World", "Test"};
    char* copies[3];
    
    for (int i = 0; i < 3; i++) {
        copies[i] = malloc(strlen(strings[i]) + 1);
        if (copies[i] != NULL) {
            strcpy(copies[i], strings[i]);
        }
    }
    
    printf("Copies created\n");
    
    for (int i = 0; i < 3; i++) {
        free(copies[i]);
    }
    
    return 0;
}
```

> **Note**: Always pair malloc with free to prevent memory leaks. Use calloc for zero-initialized memory. Consider using memory pools for frequent small allocations.
