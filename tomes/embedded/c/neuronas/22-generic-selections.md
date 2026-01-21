---
id: "c.generic-selections"
title: "Generic Selections (_Generic)"
category: language
difficulty: advanced
tags: [c, c11, generic selections, type-selection, metaprogramming]
keywords: [_Generic, generic selections, type dispatch, overloading]
use_cases: [type-safe functions, generic code, polymorphism]
prerequisites: []
related: []
next_topics: []
---

# Generic Selections

Generic selections provide compile-time type-based dispatch.

## _Generic Syntax

```c
_Generic(
    expression,               // Expression to match
    type-name-1: expression-1,  // If type matches
    type-name-2: expression-2,
    ...
    default: expression-n       // Default case
)
```

## Basic Example

```c
#include <stdio.h>

void print_int(int x) {
    printf("Integer: %d\n", x);
}

void print_float(float x) {
    printf("Float: %f\n", x);
}

void print_string(const char* x) {
    printf("String: %s\n", x);
}

// Generic print function
#define print(x) _Generic((x), \
    int: print_int, \
    float: print_float, \
    const char*: print_string, \
    default: printf("Unknown type\n") \
)(x)

// Usage
print(42);              // Integer: 42
print(3.14f);         // Float: 3.140000
print("Hello");         // String: Hello
print(3.14);          // Unknown type (double, not float)
```

## Type Matching Rules

```c
// Exact type match
_Generic((int*)0, int*: 1, default: 0);  // Returns 1
_Generic((int)0, int: 1, default: 0);     // Returns 1

// Array to pointer decay
_Generic((int[]){0}, int*: 1, default: 0);  // Returns 1

// Integer promotions
_Generic((char)0, int: 1, default: 0);    // Returns 1

// Floating point promotions
_Generic((float)0.0f, double: 1, default: 0);  // Returns 0 (no promotion)
```

## Generic Math Functions

```c
// Type-safe absolute value
#define abs(x) _Generic((x), \
    int: abs, \
    long: labs, \
    long long: llabs, \
    float: fabsf, \
    double: fabs, \
    long double: fabsl \
)(x)

// Usage
printf("%d\n", abs(-5));          // int
printf("%ld\n", abs(-5L));        // long
printf("%f\n", abs(-5.0f));       // float
printf("%f\n", abs(-5.0));       // double
```

## Generic Max Function

```c
// Maximum function for all numeric types
#define MAX(x, y) _Generic((x), \
    int: ((x) > (y) ? (x) : (y)), \
    long: ((x) > (y) ? (x) : (y)), \
    long long: ((x) > (y) ? (x) : (y)), \
    float: ((x) > (y) ? (x) : (y)), \
    double: ((x) > (y) ? (x) : (y)), \
    long double: ((x) > (y) ? (x) : (y)) \
)

// Usage
int i_max = MAX(10, 20);         // int
float f_max = MAX(1.5f, 2.5f);  // float
```

## String Length Generic

```c
#include <wchar.h>
#define str_len(s) _Generic((s), \
    char*: strlen, \
    const char*: strlen, \
    wchar_t*: wcslen, \
    const wchar_t*: wcslen \
)(s)

// Usage
char* ascii = "Hello";
wchar_t* wide = L"Hello";

printf("%zu\n", str_len(ascii));  // 5
printf("%zu\n", str_len(wide));  // 5
```

## Type Checking Macro

```c
// Check if type is signed
#define IS_SIGNED(x) (_Generic((x), \
    signed char: 1, \
    short: 1, \
    int: 1, \
    long: 1, \
    long long: 1, \
    float: 0, \
    double: 0, \
    long double: 0, \
    default: 0 \
))

// Usage
printf("%d\n", IS_SIGNED((int)0));      // 1
printf("%d\n", IS_SIGNED((unsigned)0));  // 0
printf("%d\n", IS_SIGNED((float)0.0));  // 0
```

## Generic Swap

```c
#include <string.h>

// Swap two values
#define SWAP(a, b) do { \
    _Generic((a), \
        int: swap_int, \
        float: swap_float, \
        double: swap_double, \
        default: memcpy \
    )(&(a), &(b), sizeof(a)); \
} while(0)

void swap_int(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void swap_float(float* a, float* b) {
    float temp = *a;
    *a = *b;
    *b = temp;
}

// Usage
int x = 10, y = 20;
SWAP(x, y);
// x = 20, y = 10
```

## Type to String

```c
// Convert type to string
#define TYPE_NAME(x) _Generic((x), \
    char: "char", \
    signed char: "signed char", \
    unsigned char: "unsigned char", \
    short: "short", \
    int: "int", \
    long: "long", \
    long long: "long long", \
    float: "float", \
    double: "double", \
    void*: "void*", \
    default: "other" \
)

// Usage
printf("%s\n", TYPE_NAME((int)42));       // int
printf("%s\n", TYPE_NAME((float)3.14));   // float
printf("%s\n", TYPE_NAME((char)'A'));     // char
```

## Generic Print with Format

```c
// Print with correct format specifier
#define PRINT(x) printf( \
    _Generic((x), \
        int: "%d", \
        unsigned int: "%u", \
        long: "%ld", \
        unsigned long: "%lu", \
        long long: "%lld", \
        float: "%f", \
        double: "%lf", \
        char*: "%s", \
        void*: "%p" \
    ), x \
)

// Usage
PRINT(42);             // 42
PRINT(3.14);          // 3.140000
PRINT("Hello");        // Hello
PRINT((void*)0x1234); // 0x1234
```

## Generic Array Element Size

```c
// Get element size of array
#define ELEMENT_SIZE(x) ( \
    _Generic((&(x)), \
        char(*)[1]: sizeof(char), \
        int(*)[1]: sizeof(int), \
        float(*)[1]: sizeof(float), \
        default: sizeof(*(x)) \
    ) \
)

// Usage
int arr[10];
printf("%zu\n", ELEMENT_SIZE(arr));  // 4
```

## Generic Pointer Cast

```c
// Safe pointer cast with type checking
#define SAFE_CAST(ptr, type) \
    (type)( \
        _Generic((ptr), \
            void*: (ptr), \
            const void*: (ptr), \
            default: (void*)(ptr) \
        ) \
    )

// Usage
int x = 42;
void* generic = &x;
int* specific = SAFE_CAST(generic, int*);
```

## Complex Dispatch

```c
// Process different types
void process(int x) { printf("int: %d\n", x); }
void process_long(long x) { printf("long: %ld\n", x); }
void process_float(float x) { printf("float: %f\n", x); }
void process_default() { printf("unknown\n"); }

#define PROCESS(x) _Generic((x), \
    int: process, \
    long: process_long, \
    float: process_float, \
    default: process_default \
)(x)

// Usage
PROCESS((int)42);          // int: 42
PROCESS((long)42L);        // long: 42
PROCESS((float)3.14f);      // float: 3.140000
PROCESS((double)3.14);     // unknown
```

## Generic Const Handling

```c
// Handle both const and non-const
#define MUTABLE_COPY(x) _Generic((x), \
    const char*: strdup, \
    char*: strdup, \
    const int*: copy_int, \
    int*: copy_int, \
    default: memcpy \
)

// Usage
const char* str = "Hello";
char* mutable_str = MUTABLE_COPY(str);  // strdup
free(mutable_str);
```

## Type Traits

```c
// Check if type is integer
#define IS_INTEGER(x) _Generic((x), \
    char: 1, \
    signed char: 1, \
    unsigned char: 1, \
    short: 1, \
    unsigned short: 1, \
    int: 1, \
    unsigned int: 1, \
    long: 1, \
    unsigned long: 1, \
    long long: 1, \
    unsigned long long: 1, \
    default: 0 \
)

// Check if type is floating point
#define IS_FLOATING(x) _Generic((x), \
    float: 1, \
    double: 1, \
    long double: 1, \
    default: 0 \
)
```

## Generic Zero

```c
// Get zero value for any type
#define ZERO(x) _Generic((x), \
    int: 0, \
    long: 0L, \
    long long: 0LL, \
    float: 0.0f, \
    double: 0.0, \
    long double: 0.0L, \
    void*: NULL \
)

// Usage
int i = ZERO(i);
float f = ZERO(f);
void* p = ZERO(p);
```

## Common Patterns

### Type-safe container

```c
typedef struct {
    void* data;
    size_t size;
    size_t element_size;
} Container;

// Get element with type safety
#define GET(container, index, type) \
    ((type*)((char*)(container)->data + (index) * (container)->element_size))

// Set element with type safety
#define SET(container, index, type, value) \
    *(GET(container, index, type)) = (value)

// Usage
Container c = create_container(sizeof(int), 10);
SET(&c, 0, int, 42);
int value = GET(&c, 0, int);
```

### Generic comparison

```c
// Compare values
#define COMPARE(a, b) _Generic((a), \
    int: compare_int, \
    float: compare_float, \
    double: compare_double, \
    const char*: strcmp, \
    default: memcmp \
)

int compare_int(int a, int b) { return a - b; }
int compare_float(float a, float b) {
    if (a < b) return -1;
    if (a > b) return 1;
    return 0;
}

// Usage
qsort(array, n, sizeof(int),
      (int (*)(const void*, const void*))COMPARE);
```

### Generic print function

```c
#define GENERIC_PRINT(x) _Generic((x), \
    char: print_char, \
    int: print_int, \
    float: print_float, \
    double: print_double, \
    const char*: print_string, \
    default: print_unknown \
)(x)

void print_char(char c) { printf("char: '%c'\n", c); }
void print_int(int i) { printf("int: %d\n", i); }
void print_float(float f) { printf("float: %f\n", f); }
void print_double(double d) { printf("double: %lf\n", d); }
void print_string(const char* s) { printf("string: \"%s\"\n", s); }
void print_unknown() { printf("unknown type\n"); }
```

## Limitations

```c
// 1. Cannot handle all types
#define MY_GENERIC(x) _Generic((x), \
    int: handle_int, \
    float: handle_float \
)

MY_GENERIC((double)3.14);  // No match for double!

// 2. No partial specialization
// Can't do: "pointer to int" specific

// 3. Expression evaluated twice (side effects!)
#define DOUBLE(x) _Generic((x), \
    int: ((x) * 2), \
    float: ((x) * 2.0f) \
)

DOUBLE(x++);  // x incremented twice!

// 4. Limited compile-time features
// Can't do: type traits, reflection, etc.
```

## Best Practices

```c
// ✅ Good: Type safety
#define PRINT(x) _Generic((x), \
    int: printf("%d", x), \
    float: printf("%f", x) \
)

// ✅ Good: Use with macros
#define ABS(x) _Generic((x), int: abs, float: fabsf)(x)

// ❌ Bad: Repeated expression evaluation
#define SQUARE(x) _Generic((x), \
    int: ((x) * (x)), \
    float: ((x) * (x)) \
)

// ❌ Bad: Missing default case
#define HALF(x) _Generic((x), \
    int: ((x) / 2), \
    float: ((x) / 2.0f) \
)

HALF((double)3.14);  // No match!
```

> **Note**: Generic selections are C11 feature. They provide type-safe polymorphism but are limited compared to C++ templates.
