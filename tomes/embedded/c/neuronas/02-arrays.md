---
id: "c.arrays"
title: "Arrays and Array Operations"
category: stdlib
difficulty: novice
tags: [c, , iteration, multi-dimensional, initialization]
keywords: [array, index, bounds, multidimensional, iteration]
use_cases: [fixed-size , data structures, c.controlflow, matrix operations]
prerequisites: []
related: ["c.stdlib.string"]
next_topics: ["c.functions"]
---

#  and Array Operations

C provides both single and multi-dimensional arrays.

## Array Declaration

```c
// Single-dimensional array
int numbers[5] = {1, 2, 3, 4, 5};

// Initialize with zeros
int zeros[10] = {0};  // All elements zero

// Initialize with specific values
int values[3] = {10, 20, 30};

// Character array (string)
char message[] = "Hello";
```

## Array Access

```c
int main() {
    int arr[5] = {10, 20, 30, 40, 50};
    
    // Direct access
    int first = arr[0];      // 10
    int last = arr[4];       // 50
    
    // Out of bounds - undefined behavior
    // int invalid = arr[5];   // Undefined!
    
    printf("First: %d, Last: %d\n", first, last);
    return 0;
}
```

## Array Iteration

```c
#include <stdio.h>

int main() {
    int numbers[5] = {1, 2, 3, 4, 5};
    int sum = 0;
    
    // Indexed loop
    for (int i = 0; i < 5; i++) {
        sum += numbers[i];
        printf("Element %d: %d\n", i, numbers[i]);
    }
    
    printf("Sum: %d\n", sum);
    return 0;
}
```

## Array Size

```c
#include <stdio.h>

int main() {
    int arr[5] = {1, 2, 3, 4, 5};
    
    // Using sizeof
    size_t size = sizeof(arr);           // 20 bytes
    size_t count = sizeof(arr) / sizeof(arr[0]);  // 5 elements
    
    // Compile-time array length macro
    printf("Size: %zu bytes, %zu elements\n", size, count);
    return 0;
}
```

## Multi-dimensional 

```c
#include <stdio.h>

int main() {
    // 2D array (3 rows, 4 columns)
    int matrix[3][4] = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10, 11, 12}
    };
    
    // Access: matrix[row][col]
    int value = matrix[1][2];  // 7
    
    printf("Matrix[1][2]: %d\n", value);
    return 0;
}
```

## Array Initialization

```c
#include <stdio.h>

int main() {
    // Designated initializers (C99)
    struct Point {
        int x;
        int y;
    };
    
    struct Point points[3] = {
        {.x = 1, .y = 2},
        {.x = 10, .y = 20},
        {.x = 30, .y = 40}
    };
    
    printf("Point 1: (%d, %d)\n", points[0].x, points[0].y);
    printf("Point 2: (%d, %d)\n", points[1].x, points[1].y);
    printf("Point 3: (%d, %d)\n", points[2].x, points[2].y);
    
    return 0;
}
```

## Array Copying

```c
#include <stdio.h>
#include <string.h>

int main() {
    int src[5] = {1, 2, 3, 4, 5};
    int dest[5];
    
    // Element-wise copy (not in standard C, use loop)
    for (int i = 0; i < 5; i++) {
        dest[i] = src[i];
    }
    
    // Using memcpy
    int dest2[5];
    memcpy(dest2, src, sizeof(src));
    
    printf("Copied arrays\n");
    return 0;
}
```

## Array Searching

```c
#include <stdio.h>

int main() {
    int numbers[10] = {1, 3, 5, 7, 9, 11, 13, 17, 19, 23};
    int target = 13;
    int found = -1;
    
    // Linear search
    for (int i = 0; i < 10; i++) {
        if (numbers[i] == target) {
            found = i;
            break;
        }
    }
    
    if (found != -1) {
        printf("Found at index %d\n", found);
    } else {
        printf("Not found\n");
    }
    
    return 0;
}
```

## Array Sorting

```c
#include <stdio.h>
#include <stdlib.h>

// Comparison function for qsort
int compare(const void* a, const void* b) {
    int ia = *(const int*)a;
    int ib = *(const int*)b;
    return (ia - ib);
}

int main() {
    int numbers[5] = {5, 3, 1, 4, 2};
    
    // qsort - standard library sort
    qsort(numbers, 5, sizeof(int), compare);
    
    printf("Sorted: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    return 0;
}
```

## Dynamic  (Simulated)

```c
#include <stdio.h>
#include <stdlib.h>

// C doesn't have built-in dynamic 
// Simulate with  and malloc
int* create_array(size_t size) {
    return (int*)malloc(sizeof(int) * size);
}

void free_array(int* arr) {
    free(arr);
}

int main() {
    size_t size = 10;
    int* arr = create_array(size);
    
    if (arr == NULL) {
        printf("Allocation failed\n");
        return -1;
    }
    
    // Use like array
    for (size_t i = 0; i < size; i++) {
        arr[i] = i * 2;
    }
    
    free_array(arr);
    return 0;
}
```

## String 

```c
#include <stdio.h>

int main() {
    // Array of strings (array of pointers)
    const char* words[] = {"Hello", "World", "C"};
    
    // Access individual strings
    const char* first = words[0];
    const char* second = words[1];
    
    printf("First: %s, Second: %s\n", first, second);
    return 0;
}
```

## Array Bounds Checking

```c
#include <stdio.h>

int safe_access(int arr[], size_t index, size_t size) {
    // Check bounds before access
    if (index >= size) {
        printf("Index %zu out of bounds (size: %zu)\n", index, size);
        return -1;
    }
    
    return arr[index];
}

int main() {
    int numbers[5] = {1, 2, 3, 4, 5};
    int value = safe_access(numbers, 2, 5);
    printf("Value: %d\n", value);
    return 0;
}
```

## Common Patterns

### Find array length

```c
#include <stdio.h>

int main() {
    int arr[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(arr) / sizeof(arr[0]);
    printf("Array size: %zu\n", size);
    return 0;
}
```

### Fill array with values

```c
#include <stdio.h>
#include <string.h>

int main() {
    int zeros[10] = {0};  // Already zero-initialized
    
    // Fill with value using loop
    int values[10];
    for (int i = 0; i < 10; i++) {
        values[i] = 42;
    }
    
    printf("Values filled\n");
    return 0;
}
```

### Reverse array in place

```c
#include <stdio.h>

void reverse_array(int arr[], size_t size) {
    int temp;
    for (size_t i = 0; i < size / 2; i++) {
        temp = arr[i];
        arr[i] = arr[size - 1 - i];
        arr[size - 1 - i] = temp;
    }
}

int main() {
    int numbers[5] = {1, 2, 3, 4, 5};
    reverse_array(numbers, 5);
    
    printf("Reversed: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    return 0;
}
```

### Rotate array

```c
#include <stdio.h>

void rotate_left(int arr[], size_t size, size_t k) {
    if (size == 0) return;
    
    int temp[k];
    size_t i;
    
    // Save first k elements
    for (i = 0; i < k; i++) {
        temp[i] = arr[i];
    }
    
    // Shift remaining elements
    for (i = 0; i < size - k; i++) {
        arr[i] = arr[i + k];
    }
    
    // Put saved elements at end
    for (i = 0; i < k; i++) {
        arr[size - k + i] = temp[i];
    }
}
```

> **Note**: Out-of-bounds array access in C is undefined behavior - always check array bounds before accessing elements.
