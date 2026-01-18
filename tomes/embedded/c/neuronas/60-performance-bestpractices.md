---
id: "c.bestpractices.performance"
title: "Performance Best Practices"
category: bestpractices
difficulty: advanced
tags: [c, performance, optimization, profiling]
keywords: [performance, optimization, profiling, cache, branch]
use_cases: [performance tuning, optimization, speed]
prerequisites: [c.portability]
related: [c.algorithms.sorting]
next_topics: [c.algorithms.parallel]
---

# Performance Best Practices

## Loop Unrolling

```c
#include <stdio.h>

void sum_array(int* arr, size_t size) {
    // Unrolled loop (better for small sizes)
    size_t i;
    int sum = 0;

    for (i = 0; i < size; i += 4) {
        sum += arr[i];
        if (i + 1 < size) sum += arr[i + 1];
        if (i + 2 < size) sum += arr[i + 2];
        if (i + 3 < size) sum += arr[i + 3];
    }

    // Handle remaining elements
    for (; i < size; i++) {
        sum += arr[i];
    }

    printf("Sum: %d\n", sum);
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    sum_array(numbers, size);

    return 0;
}
```

## Branch Predic.stdlib.stdion

```c
#include <stdio.h>

int main() {
    // Likely branch
    int x = 100;

    if (__builtin_expect(x > 0, 1)) {
        printf("x is positive\n");
    } else {
        printf("x is non-positive\n");
    }

    // Unlikely branch
    int y = 0;

    if (__builtin_expect(y > 0, 0)) {
        printf("y is positive\n");
    } else {
        printf("y is non-positive\n");
    }

    return 0;
}
```

## Inline 

```c
#include <stdio.h>

// Inline function for small operations
static inline int square(int x) {
    return x * x;
}

// Compare with macro
#define SQUARE_MACRO(x) ((x) * (x))

int main() {
    printf("square(5) = %d\n", square(5));
    printf("SQUARE_MACRO(5) = %d\n", SQUARE_MACRO(5));

    return 0;
}
```

## Avoid Premature Optimization

```c
#include <stdio.h>
#include <string.h>

// Simple, readable version
void count_characters(const char* str) {
    int count = 0;
    while (*str != '\0') {
        count++;
        str++;
    }
    printf("Characters: %d\n", count);
}

// Prematurely optimized version (harder to read)
void count_characters_optimized(const char* str) {
    // Use pointer arithmetic
    const char* start = str;
    while (*str++ != '\0');
    printf("Characters: %ld\n", str - start);
}

int main() {
    const char* text = "Hello, World!";

    count_characters(text);
    count_characters_optimized(text);

    return 0;
}
```

## Cache Locality

```c
#include <stdio.h>
#include <stdlib.h>

#define SIZE 1000

void process_row_major(int** matrix, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j]++;
        }
    }
}

void process_column_major(int** matrix, int rows, int cols) {
    for (int j = 0; j < cols; j++) {
        for (int i = 0; i < rows; i++) {
            matrix[i][j]++;
        }
    }
}

int main() {
    int** matrix = malloc(SIZE * sizeof(int*));
    for (int i = 0; i < SIZE; i++) {
        matrix[i] = malloc(SIZE * sizeof(int));
    }

    // Row-major (better cache locality for sequential access)
    process_row_major(matrix, SIZE, SIZE);

    // Column-major (better for sequential column access)
    process_column_major(matrix, SIZE, SIZE);

    for (int i = 0; i < SIZE; i++) {
        free(matrix[i]);
    }
    free(matrix);

    return 0;
}
```

## Memory Pool for Frequent Allocations

```c
#include <stdio.h>
#include <stdlib.h>

#define POOL_SIZE 1000
#define BLOCK_SIZE 64

typedef struct Block {
    char data[BLOCK_SIZE];
    struct Block* next;
} Block;

typedef struct {
    Block blocks[POOL_SIZE];
    Block* free_list;
} MemoryPool;

void pool_init(MemoryPool* pool) {
    pool->free_list = NULL;

    for (int i = POOL_SIZE - 1; i >= 0; i--) {
        pool->blocks[i].next = pool->free_list;
        pool->free_list = &pool->blocks[i];
    }
}

void* pool_alloc(MemoryPool* pool) {
    if (pool->free_list == NULL) {
        return NULL;  // Pool exhausted
    }

    Block* block = pool->free_list;
    pool->free_list = block->next;

    return block->data;
}

void pool_free(MemoryPool* pool, void* ptr) {
    Block* block = (Block*)((char*)ptr - offsetof(Block, data));

    block->next = pool->free_list;
    pool->free_list = block;
}

int main() {
    MemoryPool pool;
    pool_init(&pool);

    // Allocate from pool
    void* ptr1 = pool_alloc(&pool);
    void* ptr2 = pool_alloc(&pool);

    // Use allocations...
    printf("Allocated from pool\n");

    // Free back to pool
    pool_free(&pool, ptr1);
    pool_free(&pool, ptr2);

    printf("Freed to pool\n");

    return 0;
}
```

## String Length Optimization

```c
#include <stdio.h>

// Store string length
typedef struct {
    const char* data;
    size_t length;
} StringWithLength;

void process_string(StringWithLength* str) {
    // Use pre-computed length
    for (size_t i = 0; i < str->length; i++) {
        putchar(str->data[i]);
    }
}

int main() {
    StringWithLength str = {"Hello, World!", 13};

    process_string(&str);

    return 0;
}
```

## Bitwise Operations

```c
#include <stdio.h>

int main() {
    // Use bitwise instead of division/modulo when possible
    int x = 12345;

    // Check if odd (bitwise is faster)
    if (x & 1) {
        printf("%d is odd\n", x);
    }

    // Divide by 2 (bitwise right shift is faster)
    int half = x >> 1;
    printf("%d / 2 = %d\n", x, half);

    // Check if power of 2
    if (x & (x - 1) == 0) {
        printf("%d is power of 2\n", x);
    }

    return 0;
}
```

## Loop Optimization

```c
#include <stdio.h>

void optimized_loop(int* arr, size_t size) {
    size_t i = 0;
    int* end = arr + size;

    // Store loop bound in register
    while (arr + i < end) {
        arr[i]++;
        i++;
    }
}

int main() {
    int numbers[1000];
    for (int i = 0; i < 1000; i++) {
        numbers[i] = i;
    }

    optimized_loop(numbers, 1000);

    return 0;
}
```

## SIMD-like Operations (Generic)

```c
#include <stdio.h>

void parallel_add(int* a, int* b, int* result, int size) {
    // Process 4 elements at a time
    for (int i = 0; i < size; i += 4) {
        result[i] = a[i] + b[i];
        if (i + 1 < size) result[i + 1] = a[i + 1] + b[i + 1];
        if (i + 2 < size) result[i + 2] = a[i + 2] + b[i + 2];
        if (i + 3 < size) result[i + 3] = a[i + 3] + b[i + 3];
    }
}

int main() {
    int a[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int b[] = {10, 9, 8, 7, 6, 5, 4, 3, 2, 1};
    int result[10];

    parallel_add(a, b, result, 10);

    printf("Result[0] = %d\n", result[0]);

    return 0;
}
```

## Lookup Table

```c
#include <stdio.h>

// Pre-computed lookup table
static const int sin_table[360] = {
    0, 17, 34, 52, 69, 87, 104, 121, 139,
    // ... (full table would have 360 entries)
    0, -17, -34, -52, -69, -87, -104, -121, -139
};

int fast_sin(int degrees) {
    int index = (degrees + 360) % 360;
    return sin_table[index];
}

int main() {
    printf("sin(30) = %d (approx)\n", fast_sin(30));
    printf("sin(60) = %d (approx)\n", fast_sin(60));

    return 0;
}
```

## String Concatenation Optimization

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* concatenate(const char* s1, const char* s2) {
    // Pre-calculate total length
    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);

    char* result = malloc(len1 + len2 + 1);
    if (result == NULL) {
        return NULL;
    }

    memcpy(result, s1, len1);
    memcpy(result + len1, s2, len2 + 1);

    return result;
}

int main() {
    const char* str1 = "Hello, ";
    const char* str2 = "World!";

    char* combined = concatenate(str1, str2);

    printf("Combined: %s\n", combined);

    free(combined);

    return 0;
}
```

> **Note**: Profile before optimizing. Use compiler flags (-O2, -O3). Prefer readability for maintainability.
