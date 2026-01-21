---
id: "c.type-qualifiers"
title: "Type Qualifiers: const, volatile, restrict"
category: language
difficulty: intermediate
tags: [c, qualifiers, types, optimization, pointers]
keywords: [const, volatile, restrict, type-qualifier]
use_cases: [optimization, safety, hardware access]
prerequisites: []
related: []
next_topics: []
---

# Type Qualifiers: const, volatile, restrict

C type qualifiers modify how variables can be used.

## const Qualifier

```c
// Read-only variable
const int x = 42;
// x = 100;  // Error: cannot modify const

// Pointer to const data
const int* ptr1 = &x;
// *ptr1 = 100;  // Error: cannot modify through ptr1
ptr1 = &y;       // OK: can change where ptr1 points

// Const pointer (pointer itself is const)
int* const ptr2 = &x;
*ptr2 = 100;     // OK: can modify data
// ptr2 = &y;     // Error: cannot change ptr2

// Const pointer to const data
const int* const ptr3 = &x;
// *ptr3 = 100;  // Error: cannot modify data
// ptr3 = &y;     // Error: cannot change pointer
```

## const in Function Parameters

```c
// Read-only parameter (prevents modification)
void print_string(const char* str) {
    printf("%s\n", str);
    // str[0] = 'X';  // Error: str is const
}

// Return pointer to const (caller cannot modify)
const char* get_version() {
    static const char version[] = "1.0.0";
    return version;  // Caller cannot modify version
}

// Const reference
void process_data(const struct Data* data) {
    // Can read but not modify
    printf("%d\n", data->value);
    // data->value = 42;  // Error
}
```

## volatile Qualifier

```c
// Tells compiler not to optimize accesses
volatile int* hardware_reg = (volatile int*)0x1234;

// Loop must execute all iterations
for (volatile int i = 0; i < 10; i++) {
    // Compiler won't optimize this away
    // Must check hardware each time
}

// Shared memory flag
volatile int flag = 0;

void wait_for_flag() {
    while (flag == 0) {
        // Busy wait - must check flag each time
        // Compiler won't optimize to infinite loop
    }
}
```

## volatile Use Cases

```c
// 1. Hardware registers
volatile uint32_t* GPIO_ODR = (volatile uint32_t*)0x40020014;

// Set GPIO pin
*GPIO_ODR |= (1 << 5);

// 2. Signal handlers
volatile sig_atomic_t signal_received = 0;

void handler(int sig) {
    signal_received = 1;
}

int main() {
    signal(SIGINT, handler);
    while (!signal_received) {
        // Wait for signal
    }
}

// 3. Shared memory between threads/ISR
volatile int shared_counter = 0;

void increment_counter() {
    shared_counter++;  // Must actually read and write
}
```

## restrict Qualifier (C99)

```c
// Tells compiler pointers don't alias
void copy(int* restrict dest, const int* restrict src, int n) {
    for (int i = 0; i < n; i++) {
        dest[i] = src[i];
    }
    // Compiler knows dest and src don't overlap
    // Can optimize more aggressively
}

// Without restrict (potential aliasing)
void copy_slow(int* dest, const int* src, int n) {
    for (int i = 0; i < n; i++) {
        dest[i] = src[i];  // Might read dest[i] later
        // Must assume aliasing
    }
}
```

## restrict Optimization

```c
// Vector dot product
float dot_product(const float* restrict a,
                const float* restrict b, int n) {
    float sum = 0.0f;
    for (int i = 0; i < n; i++) {
        sum += a[i] * b[i];  // Compiler knows no aliasing
        // Can vectorize this loop
    }
    return sum;
}

// Caller must ensure no aliasing
float a[100], b[100];
float result = dot_product(a, b, 100);  // OK

float c[100];
// result = dot_product(a, c, 100);  // Undefined if they overlap!
```

## Combining Qualifiers

```c
// const + volatile
const volatile int* hardware_reg = (const volatile int*)0x1234;
// Read-only register (can't write)
// Value can change unexpectedly

// restrict + const
void safe_copy(int* restrict dest,
              const int* restrict src, int n);

// restrict + volatile
void process_volatile(int* restrict volatile data);

// All three
const volatile int* restrict reg;
```

## const and Pointers

```c
// Confusing pointer declarations
const int* ptr1;          // Pointer to const int
int const* ptr2;          // Same as above
int* const ptr3;          // Const pointer to int
const int* const ptr4;    // Const pointer to const int

// Multiple pointers
const int* p1, *p2;      // Both pointers to const int
int* const p3, *p4;      // p3 is const, p4 is regular!
```

## const and Arrays

```c
// Const array (read-only)
const int array[5] = {1, 2, 3, 4, 5};
// array[0] = 10;  // Error

// Pointer to const array
void print_array(const int arr[], int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    // arr[i] = 0;  // Error
}
```

## const in Structures

```c
struct Point {
    const int x;
    const int y;
};

struct Point p = {.x = 10, .y = 20};
// p.x = 30;  // Error: x is const

// Const structure
const struct Point cp = {.x = 10, .y = 20};
// cp.x = 30;  // Error: entire struct is const
```

## volatile Best Practices

```c
// 1. Use with signal flags
volatile sig_atomic_t flag = 0;

// 2. Hardware registers
volatile uint32_t* timer = (volatile uint32_t*)0x40000000;

// 3. Shared variables in signal handlers
volatile int shared_data = 0;

// 4. For debugging (disable optimization)
volatile int debug_value = compute();

// ❌ Don't use for:
//  - Normal variables (compiler optimization is better)
//  - Thread synchronization (use atomics instead)
```

## restrict Best Practices

```c
// 1. Performance-critical functions
void memcpy_fast(void* restrict dst,
                const void* restrict src, size_t n);

// 2. Vector/matrix operations
void matmul(const float* restrict A,
            const float* restrict B,
            float* restrict C, int N);

// 3. String operations
void strcpy_fast(char* restrict dst,
                const char* restrict src);

// ❌ Caller responsibility:
// Ensure pointers don't alias!
```

## const Correctness

```c
// Good: Mark const wherever appropriate
int sum(const int* arr, int size);
char* strchr(const char* s, int c);  // Returns non-const

// Bad: Missing const
int sum(int* arr, int size);  // Should be const

// Fixing function signature
int sum(int* arr, int size) {
    // If arr is not modified, make it const:
    int sum(const int* arr, int size) {
```

## Type Qualifier Hierarchy

```c
// Qualifiers can appear in different positions
int x;                          // Regular int
const int x;                      // Const int
int const x;                      // Same as above
volatile int x;                   // Volatile int
int volatile x;                   // Same as above
restrict int* p;                 // Restricted pointer
int* restrict p;                 // Same as above
```

## Practical Example

```c
// Memory-mapped I/O
void configure_hardware() {
    // Read-only register
    const volatile uint32_t* STATUS_REG =
        (const volatile uint32_t*)0x40000000;

    // Write-only register
    volatile uint32_t* CONTROL_REG =
        (volatile uint32_t*)0x40000004;

    // Read status
    uint32_t status = *STATUS_REG;

    // Configure (volatile ensures write happens)
    *CONTROL_REG = 0x12345678;
}

// Safe data processing
void process_data(const int* restrict input,
                int* restrict output, int n) {
    for (int i = 0; i < n; i++) {
        output[i] = input[i] * 2;
        // Compiler knows input/output don't alias
        // Can optimize and vectorize
    }
}
```

> **Note**: `restrict` is only a hint to the compiler. If you violate it (overlapping pointers), behavior is undefined.
