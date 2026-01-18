---
id: "c.pointers"
title: "Pointers and Memory Management"
category: language
difficulty: intermediate
tags: [c, pointers, malloc, free, memory, stack, heap]
keywords: [pointer, address, dereference, malloc, free, sizeof]
use_cases: [dynamic memory, pointer arithmetic, manual memory management]
prerequisites: []
related: ["c.arrays", "c.functions"]
next_topics: ["c.stdlib.string"]
---

# Pointers and Memory Management

C provides direct memory manipulation through pointers.

## Pointer Basics

```c
int x = 42;
int* ptr = &x;  // Address of x

// Dereference
int value = *ptr;  // 42

// Pointer to pointer
int** ptr_to_ptr = &ptr;
int value2 = **ptr_to_ptr;  // 42
```

## Dynamic Memory Allocation

```c
#include <stdlib.h>

// Allocate memory
int* ptr = (int*)malloc(sizeof(int) * 10);
if (ptr == NULL) {
    // Handle allocation failure
    return -1;
}

// Use allocated memory
for (int i = 0; i < 10; i++) {
    ptr[i] = i;
}

// Free memory
free(ptr);
```

## Null Pointer Checks

```c
int* ptr = get_pointer();

// Always check NULL before dereferencing
if (ptr != NULL) {
    int value = *ptr;
    // Use value
}

// Better: initialize to NULL
int* safe_ptr = NULL;
safe_ptr = get_pointer();
if (safe_ptr != NULL) {
    *safe_ptr = 42;
}
```

## Pointer Arithmetic

```c
int arr[5] = {1, 2, 3, 4, 5};
int* ptr = arr;  // Points to first element

// Pointer arithmetic
int* third = ptr + 2;  // &arr[2]
int value = *third;  // 3

// Array indexing via pointers
for (int i = 0; i < 5; i++) {
    printf("%d\n", *(ptr + i));  // arr[i]
}
```

## Arrays vs Pointers

```c
// Array decay to pointer
void func(int arr[]) {
    // arr decays to int* (pointer to first element)
    int* ptr = arr;  // Same as &arr[0]
}

// Pass array size to avoid decay
void func_better(int arr[], size_t size) {
    // Explicit size
}
```

## Function Pointers

```c
#include <stdio.h>

// Function pointer type
typedef int (*Operation)(int, int);

// Function taking function pointer
int apply(Operation op, int a, int b) {
    return op(a, b);
}

int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

int main() {
    int (*ops[2])(int, int) = {add, multiply};
    
    int result1 = apply(ops[0], 5, 3);  // 8
    int result2 = apply(ops[1], 5, 3);  // 15
    
    printf("Results: %d, %d\n", result1, result2);
}
```

## void* - Generic Pointer

```c
#include <stdlib.h>

// Generic pointer to any data
void* generic_ptr = malloc(100);
if (generic_ptr == NULL) {
    return -1;
}

// Cast to specific type
int* int_ptr = (int*)generic_ptr;
*int_ptr = 42;

char* char_ptr = (char*)generic_ptr;
*char_ptr = 'A';

// Don't forget to free
free(generic_ptr);
```

## const vs volatile Pointers

```c
// const - value cannot be modified through pointer
const int value = 42;
const int* const_ptr = &value;
// *const_ptr = 100;  // Error: cannot modify

// volatile - tells compiler not to optimize
volatile int* hardware_reg = (volatile int*)0x1234;
int status = *hardware_reg;  // Reads from hardware register
```

## Common Patterns

### Memory allocation wrapper

```c
typedef struct {
    void* data;
    size_t size;
} Buffer;

Buffer* allocate_buffer(size_t size) {
    Buffer* buf = malloc(sizeof(Buffer));
    if (buf == NULL) return NULL;
    
    buf->data = malloc(size);
    buf->size = size;
    
    return buf;
}

void free_buffer(Buffer* buf) {
    if (buf != NULL) {
        free(buf->data);
        free(buf);
    }
}

// Usage
Buffer* buf = allocate_buffer(1024);
if (buf != NULL) {
    // Use buf->data
    free_buffer(buf);
}
```

### Safe string copying

```c
#include <string.h>

char* safe_copy(const char* src) {
    if (src == NULL) return NULL;
    
    size_t len = strlen(src);
    char* dest = malloc(len + 1);
    if (dest == NULL) return NULL;
    
    strncpy(dest, src, len);
    dest[len] = '\0';
    
    return dest;
}

// Caller must free
// char* copy = safe_copy("hello");
// free(copy);
```

### Array as pointer

```c
void process_array(int* arr, size_t size) {
    for (size_t i = 0; i < size; i++) {
        printf("Element %zu: %d\n", i, arr[i]);
    }
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    process_array(numbers, 5);
}
```

### Double pointer (pointer to pointer)

```c
void allocate_array(int** arr_ptr, size_t size) {
    *arr_ptr = malloc(sizeof(int) * size);
    if (*arr_ptr == NULL) return;
    
    for (size_t i = 0; i < size; i++) {
        (*arr_ptr)[i] = i;
    }
}

int main() {
    int* arr = NULL;
    allocate_array(&arr, 10);
    
    // Use allocated array
    for (int i = 0; i < 10; i++) {
        printf("%d\n", arr[i]);
    }
    
    free(arr);
}
```

### Realloc - Resizing Allocations

```c
#include <stdlib.h>

int* resize_array(int* old_arr, size_t old_size, size_t new_size) {
    int* new_arr = realloc(old_arr, sizeof(int) * new_size);
    if (new_arr == NULL) return NULL;
    
    return new_arr;
}
```

### Calloc - Zero-initialized Memory

```c
#include <stdlib.h>

int* allocate_zeroed(size_t count) {
    // calloc zero-initializes memory
    int* arr = (int*)calloc(count, sizeof(int));
    if (arr == NULL) return NULL;
    
    // All bytes are zero
    for (size_t i = 0; i < count; i++) {
        printf("%d\n", arr[i]);  // All zeros
    }
    
    free(arr);
}
```

### Stack allocation (VLA - Variable Length Arrays)

```c
void process_data(size_t count) {
    // Variable length array (VLA) - stack allocated
    int arr[count];  // Stack allocation, automatically freed
    
    for (size_t i = 0; i < count; i++) {
        arr[i] = i;
    }
}
```

> **Warning**: Manual memory management in C requires careful discipline. Always free allocated memory and check for NULL before dereferencing.
