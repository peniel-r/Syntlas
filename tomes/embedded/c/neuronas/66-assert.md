---
id: "c.stdlib.assert"
title: "Assertions (assert.h)"
category: stdlib
difficulty: beginner
tags: [c, stdlib, c.stdlib.assert, debugging, validation]
keywords: [c.stdlib.assert, static_assert, NDEBUG, debugging]
use_cases: [debugging, validation, contracts]
prerequisites: [c.stdlib.stdio]
related: [c.bestpractices.safety]
next_topics: [c.stdlib.misc]
---

# Assertions

## Basic c.stdlib.assert

```c
#include <stdio.h>
#include <assert.h>

int main() {
    int x = 5;

    // Basic assertion
    assert(x == 5);

    printf("Assertion passed\n");

    return 0;
}
```

## c.stdlib.assert with Message

```c
#include <stdio.h>
#include <assert.h>

int main() {
    int x = 5;

    // Assertion with expression
    assert(x > 0 && "x must be positive");

    printf("All assertions passed\n");

    return 0;
}
```

## Array Bounds Check

```c
#include <stdio.h>
#include <assert.h>

int main() {
    int arr[5] = {1, 2, 3, 4, 5};

    for (int i = 0; i < 5; i++) {
        assert(i >= 0 && i < 5 && "Index out of bounds");
        printf("arr[%d] = %d\n", i, arr[i]);
    }

    return 0;
}
```

## Pointer Non-Null Check

```c
#include <stdio.h>
#include <assert.h>

void process(int* ptr) {
    assert(ptr != NULL && "Pointer cannot be NULL");
    *ptr = 42;
}

int main() {
    int value = 10;
    process(&value);

    printf("Value: %d\n", value);

    return 0;
}
```

## Division Check

```c
#include <stdio.h>
#include <assert.h>

int divide(int a, int b) {
    assert(b != 0 && "Divisor cannot be zero");
    return a / b;
}

int main() {
    int result = divide(10, 5);
    printf("Result: %d\n", result);

    result = divide(10, 0);

    return 0;
}
```

## Contract Precondition

```c
#include <stdio.h>
#include <assert.h>

void set_age(int* age, int new_age) {
    // Precondition: new_age must be valid
    assert(new_age >= 0 && new_age < 150 && "Age must be valid");

    *age = new_age;
}

int main() {
    int age;
    set_age(&age, 30);

    printf("Age: %d\n", age);

    set_age(&age, 200);  // Will fail

    return 0;
}
```

## Postcondition Check

```c
#include <stdio.h>
#include <assert.h>

int* allocate_array(int size) {
    int* arr = malloc(size * sizeof(int));

    // Postcondition: array must not be NULL
    assert(arr != NULL && "Memory allocation failed");

    return arr;
}

int main() {
    int* arr = allocate_array(10);

    for (int i = 0; i < 10; i++) {
        arr[i] = i;
    }

    free(arr);
    return 0;
}
```

## Invariant Check

```c
#include <stdio.h>
#include <assert.h>

typedef struct {
    int numerator;
    int denominator;
} Fraction;

bool is_valid_fraction(const Fraction* f) {
    return f->denominator != 0;
}

Fraction add_fractions(const Fraction* a, const Fraction* b) {
    assert(is_valid_fraction(a) && "First fraction is invalid");
    assert(is_valid_fraction(b) && "Second fraction is invalid");

    Fraction result;
    result.numerator = a->numerator + b->numerator;
    result.denominator = b->denominator;  // Incorrect on purpose

    assert(is_valid_fraction(&result) && "Result fraction is invalid");

    return result;
}

int main() {
    Fraction f1 = {1, 2};
    Fraction f2 = {1, 3};

    Fraction result = add_fractions(&f1, &f2);

    return 0;
}
```

## Static c.stdlib.assert (C11)

```c
#include <stdio.h>

// Compile-time assertion
static_assert(sizeof(int) == 4, "int must be 4 bytes");

int main() {
    printf("Static assertions passed at compile time\n");
    return 0;
}
```

## Debug vs Release Builds

```c
#include <stdio.h>
#include <assert.h>

#ifdef DEBUG
    void debug_log(const char* message) {
        printf("[DEBUG] %s\n", message);
    }
#else
    void debug_log(const char* message) {
        // No-op in release
        (void)message;
    }
#endif

int main() {
    debug_log("Starting application");

    int* ptr = malloc(sizeof(int));
    assert(ptr != NULL && "Allocation failed");

    *ptr = 42;
    debug_log("Value set");

    free(ptr);
    debug_log("Cleanup complete");

    printf("Application completed\n");

    return 0;
}
```

## Numeric Range Check

```c
#include <stdio.h>
#include <assert.h>

void validate_percentage(int value) {
    assert(value >= 0 && value <= 100 && "Percentage must be 0-100");
}

void validate_range(int value, int min, int max) {
    assert(value >= min && value <= max && "Value out of range");
}

int main() {
    validate_percentage(85);
    validate_range(10, 0, 20);

    validate_percentage(150);  // Will fail

    return 0;
}
```

## String Length Check

```c
#include <stdio.h>
#include <assert.h>
#include <string.h>

void safe_string_copy(char* dest, const char* src, size_t max_len) {
    assert(src != NULL && "Source cannot be NULL");
    assert(dest != NULL && "Destination cannot be NULL");
    assert(max_len > 0 && "Max length must be positive");

    size_t len = strlen(src);
    assert(len < max_len && "Source string too long");

    strncpy(dest, src, max_len);
    dest[max_len - 1] = '\0';
}

int main() {
    char buffer[100];

    safe_string_copy(buffer, "Hello, World!", sizeof(buffer));

    printf("Copied: %s\n", buffer);

    return 0;
}
```

## Array Size Check

```c
#include <stdio.h>
#include <assert.h>

int sum_array(int* arr, size_t size) {
    assert(arr != NULL && "Array cannot be NULL");
    assert(size > 0 && "Array size must be positive");

    int sum = 0;
    for (size_t i = 0; i < size; i++) {
        sum += arr[i];
    }

    return sum;
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int sum = sum_array(numbers, size);

    printf("Sum: %d\n", sum);

    return 0;
}
```

## Pointer Arithmetic Check

```c
#include <stdio.h>
#include <assert.h>

void safe_pointer_access(int* arr, size_t size, size_t index) {
    assert(arr != NULL && "Array cannot be NULL");
    assert(index < size && "Index out of bounds");

    printf("arr[%zu] = %d\n", index, arr[index]);
}

int main() {
    int arr[5] = {10, 20, 30, 40, 50};
    size_t size = sizeof(arr) / sizeof(arr[0]);

    safe_pointer_access(arr, size, 3);
    safe_pointer_access(arr, size, 5);  // Will fail

    return 0;
}
```

## Function Contract

```c
#include <stdio.h>
#include <assert.h>

// Contract: 0 <= result <= 100
int clamp(int value) {
    assert(value >= -50 && value <= 150 && "Value out of clamping range");

    if (value < 0) return 0;
    if (value > 100) return 100;
    return value;
}

int main() {
    int result = clamp(50);
    printf("Clamped: %d\n", result);

    result = clamp(150);  // Will fail

    return 0;
}
```

## Memory Alignment Check

```c
#include <stdio.h>
#include <assert.h>
#include <stdint.h>

void check_alignment(void* ptr, size_t alignment) {
    uintptr_t addr = (uintptr_t)ptr;

    assert((addr & (alignment - 1)) == 0 && "Pointer is not aligned");

    printf("Address %p is %zu-byte aligned\n", ptr, alignment);
}

int main() {
    int* aligned_ptr = (int*)aligned_alloc(16, sizeof(int));

    if (aligned_ptr != NULL) {
        check_alignment(aligned_ptr, 16);
        free(aligned_ptr);
    }

    return 0;
}
```

## Enum Value Check

```c
#include <stdio.h>
#include <assert.h>

typedef enum {
    COLOR_RED,
    COLOR_GREEN,
    COLOR_BLUE
} Color;

void process_color(Color color) {
    assert(color >= COLOR_RED && color <= COLOR_BLUE && "Invalid color value");
    assert(color != COLOR_BLUE && "Blue is disabled");

    printf("Processing color: %d\n", color);
}

int main() {
    process_color(COLOR_RED);
    process_color(COLOR_GREEN);

    process_color(COLOR_BLUE);  // Will fail

    return 0;
}
```

## File State Check

```c
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

bool is_file_open(FILE* file) {
    // Check if file is valid (simplified check)
    return file != NULL;
}

void write_data(FILE* file, const char* data) {
    assert(is_file_open(file) && "File is not open");
    assert(data != NULL && "Data cannot be NULL");

    fprintf(file, "%s\n", data);
}

int main() {
    FILE* file = fopen("data.txt", "w");

    write_data(file, "Test data");

    fclose(file);

    return 0;
}
```

> **Warning**: Assertions abort the program in debug builds. Use them for debugging, not for normal error handling in production.
