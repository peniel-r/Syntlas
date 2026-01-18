---
id: 95-allocation-pool
title: Memory Allocation Pool
category: memory-management
difficulty: advanced
tags:
  - memory-pool
  - allocator
  - performance
keywords:
  - memory pool
  - allocator
  - custom allocator
  - performance
use_cases:
  - High-performance memory management
  - Real-time systems
  - Embedded systems
  - Game development
prerequisites:
  - memory-management
  - pointers
  - dynamic-alloc
related:
  - memory-bestpractices
  - dynamic-alloc
next_topics:
  - garbage-collection
---

# Memory Allocation Pool

Memory pools provide fast, efficient memory allocation for fixed-size objects.

## Simple Memory Pool

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define BLOCK_SIZE 64
#define POOL_SIZE 1024

typedef struct {
    char *memory;
    bool *used;
    int total_blocks;
    int used_blocks;
} MemoryPool;

MemoryPool *pool_create(int block_size, int num_blocks) {
    MemoryPool *pool = malloc(sizeof(MemoryPool));
    if (pool == NULL) return NULL;

    pool->memory = malloc(block_size * num_blocks);
    if (pool->memory == NULL) {
        free(pool);
        return NULL;
    }

    pool->used = calloc(num_blocks, sizeof(bool));
    if (pool->used == NULL) {
        free(pool->memory);
        free(pool);
        return NULL;
    }

    pool->total_blocks = num_blocks;
    pool->used_blocks = 0;

    return pool;
}

void *pool_alloc(MemoryPool *pool) {
    for (int i = 0; i < pool->total_blocks; i++) {
        if (!pool->used[i]) {
            pool->used[i] = true;
            pool->used_blocks++;
            return pool->memory + (i * BLOCK_SIZE);
        }
    }

    return NULL;  // Pool full
}

void pool_free(MemoryPool *pool, void *ptr) {
    if (ptr == NULL) return;

    int block_index = (ptr - pool->memory) / BLOCK_SIZE;

    if (block_index >= 0 && block_index < pool->total_blocks) {
        pool->used[block_index] = false;
        pool->used_blocks--;
    }
}

void pool_destroy(MemoryPool *pool) {
    if (pool == NULL) return;

    free(pool->memory);
    free(pool->used);
    free(pool);
}

int main(void) {
    MemoryPool *pool = pool_create(BLOCK_SIZE, POOL_SIZE);
    if (pool == NULL) {
        fprintf(stderr, "Failed to create pool\n");
        return 1;
    }

    printf("Memory pool created: %d blocks of %d bytes\n",
           pool->total_blocks, BLOCK_SIZE);

    // Allocate blocks
    void *blocks[10];
    int allocated = 0;

    for (int i = 0; i < 10; i++) {
        blocks[i] = pool_alloc(pool);
        if (blocks[i] != NULL) {
            printf("Allocated block %d\n", i);
            strcpy(blocks[i], "Block data");
            allocated++;
        }
    }

    printf("Allocated %d blocks (%d free)\n",
           pool->used_blocks, pool->total_blocks - pool->used_blocks);

    // Free blocks
    for (int i = 0; i < allocated; i++) {
        pool_free(pool, blocks[i]);
    }

    printf("Freed all blocks (%d free)\n",
           pool->total_blocks - pool->used_blocks);

    pool_destroy(pool);
    return 0;
}
```

## Object Pool

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_OBJECTS 100

typedef struct {
    int id;
    char name[32];
    bool active;
} Object;

typedef struct {
    Object objects[MAX_OBJECTS];
    int active_count;
} ObjectPool;

void pool_init(ObjectPool *pool) {
    for (int i = 0; i < MAX_OBJECTS; i++) {
        pool->objects[i].active = false;
        pool->objects[i].id = i;
    }
    pool->active_count = 0;
}

Object *pool_allocate(ObjectPool *pool) {
    for (int i = 0; i < MAX_OBJECTS; i++) {
        if (!pool->objects[i].active) {
            pool->objects[i].active = true;
            pool->active_count++;
            return &pool->objects[i];
        }
    }

    return NULL;  // Pool full
}

void pool_release(ObjectPool *pool, Object *obj) {
    if (obj == NULL) return;

    obj->active = false;
    pool->active_count--;
}

int main(void) {
    ObjectPool pool;
    pool_init(&pool);

    printf("Object pool initialized\n");

    // Allocate objects
    Object *obj1 = pool_allocate(&pool);
    if (obj1) {
        snprintf(obj1->name, sizeof(obj1->name), "Object %d", obj1->id);
        printf("Allocated: %s\n", obj1->name);
    }

    Object *obj2 = pool_allocate(&pool);
    if (obj2) {
        snprintf(obj2->name, sizeof(obj2->name), "Object %d", obj2->id);
        printf("Allocated: %s\n", obj2->name);
    }

    printf("Active objects: %d/%d\n", pool.active_count, MAX_OBJECTS);

    // Release objects
    pool_release(&pool, obj1);
    pool_release(&pool, obj2);

    printf("After release: %d/%d\n", pool.active_count, MAX_OBJECTS);

    return 0;
}
```

## Stack Allocator

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *memory;
    size_t size;
    size_t used;
} StackAllocator;

StackAllocator *stack_create(size_t size) {
    StackAllocator *allocator = malloc(sizeof(StackAllocator));
    if (allocator == NULL) return NULL;

    allocator->memory = malloc(size);
    if (allocator->memory == NULL) {
        free(allocator);
        return NULL;
    }

    allocator->size = size;
    allocator->used = 0;

    return allocator;
}

void *stack_alloc(StackAllocator *allocator, size_t size) {
    // Align to 8 bytes
    size = (size + 7) & ~7;

    if (allocator->used + size > allocator->size) {
        return NULL;  // Out of memory
    }

    void *ptr = allocator->memory + allocator->used;
    allocator->used += size;

    return ptr;
}

void stack_reset(StackAllocator *allocator) {
    allocator->used = 0;
}

void stack_destroy(StackAllocator *allocator) {
    if (allocator == NULL) return;

    free(allocator->memory);
    free(allocator);
}

int main(void) {
    StackAllocator *allocator = stack_create(1024);
    if (allocator == NULL) {
        fprintf(stderr, "Failed to create allocator\n");
        return 1;
    }

    printf("Stack allocator created: %zu bytes\n", allocator->size);

    // Allocate from stack
    char *str1 = stack_alloc(allocator, 100);
    strcpy(str1, "First allocation");
    printf("Allocated: %s (%zu bytes used)\n", str1, allocator->used);

    int *numbers = stack_alloc(allocator, 10 * sizeof(int));
    for (int i = 0; i < 10; i++) {
        numbers[i] = i * 10;
    }
    printf("Allocated array (%zu bytes used)\n", allocator->used);

    // Reset allocator
    stack_reset(allocator);
    printf("After reset: %zu bytes used\n", allocator->used);

    stack_destroy(allocator);
    return 0;
}
```

## Arena Allocator

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ARENA_SIZE 4096

typedef struct Arena {
    char *memory;
    size_t size;
    size_t used;
} Arena;

Arena *arena_create(size_t size) {
    Arena *arena = malloc(sizeof(Arena));
    if (arena == NULL) return NULL;

    arena->memory = malloc(size);
    if (arena->memory == NULL) {
        free(arena);
        return NULL;
    }

    arena->size = size;
    arena->used = 0;

    return arena;
}

void *arena_alloc(Arena *arena, size_t size) {
    if (arena->used + size > arena->size) {
        return NULL;  // Out of memory
    }

    void *ptr = arena->memory + arena->used;
    arena->used += size;

    return ptr;
}

void arena_reset(Arena *arena) {
    arena->used = 0;
}

void arena_destroy(Arena *arena) {
    if (arena == NULL) return;

    free(arena->memory);
    free(arena);
}

int main(void) {
    Arena *arena = arena_create(ARENA_SIZE);
    if (arena == NULL) {
        fprintf(stderr, "Failed to create arena\n");
        return 1;
    }

    printf("Arena created: %zu bytes\n", arena->size);

    // Allocate from arena
    char *data1 = arena_alloc(arena, 100);
    strcpy(data1, "Data 1");
    printf("Allocated: %s\n", data1);

    int *data2 = arena_alloc(arena, sizeof(int) * 5);
    for (int i = 0; i < 5; i++) {
        data2[i] = i * 100;
    }
    printf("Allocated array (%zu bytes used)\n", arena->used);

    // Reset arena
    arena_reset(arena);
    printf("After reset: %zu bytes used\n", arena->used);

    arena_destroy(arena);
    return 0;
}
```

## Thread-Safe Pool

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdbool.h>

#define BLOCK_SIZE 64
#define POOL_SIZE 1024

typedef struct {
    char *memory;
    bool *used;
    int total_blocks;
    int used_blocks;
    pthread_mutex_t mutex;
} ThreadSafePool;

ThreadSafePool *ts_pool_create(int block_size, int num_blocks) {
    ThreadSafePool *pool = malloc(sizeof(ThreadSafePool));
    if (pool == NULL) return NULL;

    pool->memory = malloc(block_size * num_blocks);
    pool->used = calloc(num_blocks, sizeof(bool));

    if (pool->memory == NULL || pool->used == NULL) {
        free(pool->memory);
        free(pool->used);
        free(pool);
        return NULL;
    }

    pool->total_blocks = num_blocks;
    pool->used_blocks = 0;
    pthread_mutex_init(&pool->mutex, NULL);

    return pool;
}

void *ts_pool_alloc(ThreadSafePool *pool) {
    pthread_mutex_lock(&pool->mutex);

    void *ptr = NULL;
    for (int i = 0; i < pool->total_blocks; i++) {
        if (!pool->used[i]) {
            pool->used[i] = true;
            pool->used_blocks++;
            ptr = pool->memory + (i * BLOCK_SIZE);
            break;
        }
    }

    pthread_mutex_unlock(&pool->mutex);
    return ptr;
}

void ts_pool_free(ThreadSafePool *pool, void *ptr) {
    if (ptr == NULL) return;

    int block_index = (ptr - pool->memory) / BLOCK_SIZE;

    pthread_mutex_lock(&pool->mutex);

    if (block_index >= 0 && block_index < pool->total_blocks) {
        pool->used[block_index] = false;
        pool->used_blocks--;
    }

    pthread_mutex_unlock(&pool->mutex);
}

void ts_pool_destroy(ThreadSafePool *pool) {
    if (pool == NULL) return;

    pthread_mutex_destroy(&pool->mutex);
    free(pool->memory);
    free(pool->used);
    free(pool);
}

int main(void) {
    ThreadSafePool *pool = ts_pool_create(BLOCK_SIZE, POOL_SIZE);
    if (pool == NULL) {
        fprintf(stderr, "Failed to create pool\n");
        return 1;
    }

    void *block = ts_pool_alloc(pool);
    if (block) {
        strcpy(block, "Thread-safe block");
        printf("Allocated from thread-safe pool\n");
        ts_pool_free(pool, block);
    }

    ts_pool_destroy(pool);
    return 0;
}
```

## Best Practices

### Use Appropriate Allocator

```c
// Memory pool - Fixed-size objects, fast allocation/deallocation

// Stack allocator - LIFO allocation, fast reset

// Arena allocator - Temporary allocations, bulk reset

// Standard malloc - General purpose, variable sizes
```

### Always Check Allocation

```c
// GOOD - Check return value
void *ptr = pool_alloc(pool);
if (ptr == NULL) {
    // Handle out of memory
    return NULL;
}

// BAD - Not checking
void *ptr = pool_alloc(pool);
strcpy(ptr, data);  // Might crash!
```

### Clean Up Properly

```c
// GOOD - Always destroy when done
pool_destroy(pool);

// BAD - Memory leak
pool_create(size);
// Forgot to destroy!
```

## Common Pitfalls

### 1. Out of Bounds

```c
// WRONG - No bounds checking
void *ptr = pool_alloc(pool);
strcpy(ptr, data);  // Might overflow block

// CORRECT - Check size
void *ptr = pool_alloc(pool);
if (ptr != NULL) {
    strncpy(ptr, data, BLOCK_SIZE - 1);
    ptr[BLOCK_SIZE - 1] = '\0';
}
```

### 2. Double Free

```c
// WRONG - Freeing twice
pool_free(pool, ptr);
pool_free(pool, ptr);  // Corruption!

// CORRECT - Track freed blocks
if (!ptr->freed) {
    pool_free(pool, ptr);
    ptr->freed = true;
}
```

### 3. Memory Leaks

```c
// WRONG - Not freeing pool
Pool *pool = pool_create(size);
// Use pool...
// Forgot to destroy!

// CORRECT - Always free
Pool *pool = pool_create(size);
// Use pool...
pool_destroy(pool);
```

> **Note: Memory pools are excellent for performance-critical code with many small allocations. Choose the right allocator for your use case. Always check for allocation failures. Thread-safe pools require proper mutex usage.
