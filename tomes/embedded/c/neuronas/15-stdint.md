---
id: "c.stdlib.stdint"
title: "Integer Types and Limits"
category: stdlib
stdint.h>
difficulty: novice
tags: [c, stdlib, stdint, integer, limits, ranges]
keywords: [int8_t, int16_t, uint8_t, uint16_t, int32_t, uint32_t, size_t, ptrdiff, PTRDIFF, INT_MAX, limits]
use_cases: [type sizes, integer arithmetic, portability]
prerequisites: []
related: ["c.stdlib.math"]
next_topics: []
---

# Integer Types and Limits

## Fixed-Width Integer Types

```c
#include <stdio.h>
#include <stdint.h>

int main() {
    // Fixed-width integer types
    int8_t i8 = 127;
    uint8_t u8 = 255;
    int16_t i16 = 32767;
    uint16_t u16 = 65535;
    int32_t i32 = 2147483647;
    uint32_t u32 = 4294967295;
    int64_t i64 = 9223372036854775807;
    
    // Print ranges
    printf("int8_t: [%d, %d]\n", INT8_MIN, INT8_MAX);
    printf("uint8_t: [%u, %u]\n", 0, UINT8_MAX);
    printf("int16_t: [%d, %d]\n", INT16_MIN, INT16_MAX);
    printf("uint16_t: [%u, %u]\n", 0, UINT16_MAX);
    printf("int32_t: [%d, %d]\n", INT32_MIN, INT32_MAX);
    printf("uint32_t: [%llu, %llu]\n", 0, UINT32_MAX);
    printf("int64_t: [%lld, %lld]\n", 0, UINT64_MAX);
    
    // Check sizes
    printf("sizeof(int8_t): %zu bytes\n", sizeof(int8_t));
    printf("sizeof(int16_t): %zu bytes\n", sizeof(int16_t));
    printf("sizeof(int32_t): %zu bytes\n", sizeof(int32_t));
    printf("sizeof(int64_t): %zu bytes\n", sizeof(int64_t));
    printf("sizeof(uintptr_t): %zu bytes\n", sizeof(uintptr_t));
    
    return 0;
}
```

## Pointer Difference Types

```c
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

int main() {
    // ptrdiff_t - portable pointer difference type
    printf("PTRDIFF_MIN: %td\n", PTRDIFF_MIN);
    printf("PTRDIFF_MAX: %td\n", PTRDIFF_MAX);
    
    // intptr_t - signed pointer difference type
    printf("INTPTR_MIN: %td\n", INTPTR_MIN);
    printf("INTPTR_MAX: %td\n", INTPTR_MAX);
    
    // size_t - unsigned type
    printf("SIZE_MAX: %zu\n", SIZE_MAX);
    printf("sizeof(size_t): %zu\n", sizeof(size_t));
    
    // uintptr_t - unsigned pointer type
    printf("UINTPTR_MIN: %llu\n", UINTPTR_MIN);
    printf("UINTPTR_MAX: %llu\n", UINTPTR_MAX);
    
    return 0;
}
```

## Integer Constants

```c
#include <limits.h>

int main() {
    // Value ranges
    printf("CHAR_BIT: %d bits\n", CHAR_BIT);
    printf("SHRT_MIN: %d\n", SHRT_MIN);
    printf("SHRT_MAX: %d\n", SHRT_MAX);
    printf("UCHAR_MIN: %u\n", 0, UCHAR_MAX);
    printf("INT_MIN: %d\n", INT_MIN);
    printf("INT_MAX: %d\n", INT_MAX);
    printf("UINT_MAX: %u\n", 0, UINT_MAX);
    
    // Other limits
    printf("MB_LEN_MAX: %d\n", MB_LEN_MAX);
    printf("LONG_MAX: %ld\n", LONG_MAX);
    printf("LLONG_MAX: %lld\n", LLONG_MAX);
    printf("LLONG_MIN: %lld\n", LLONG_MIN);
    printf("ULLONG_MAX: %llu\n", ULLONG_MAX);
    printf("ULLONG_MIN: %llu\n", ULLONG_MIN);
    printf("FLT_RADIX: %e\n", FLT_RADIX);
    printf("DBL_DIG: %e\n", DBL_DIG);
    printf("LDBL_DIG: %e\n", LDBL_DIG);
    printf("FLT_MIN: %e\n", FLT_MIN);
    printf("FLT_MAX: %e\n", FLT_MAX);
    printf("DBL_MIN: %e\n", DBL_MIN);
    printf("DBL_MAX: %e\n", DBL_MAX);
    printf("FLT_DIG: %e\n", FLT_DIG);
    printf("LDBL_MIN: %e\n", LDBL_MIN);
    
    return 0;
}
```

## Integer Overflow Detec.stdlib.stdion

```c
#include <stdint.h>
#include <limits.h>

int main() {
    // Add with overflow check
    int32_t add(int32_t a, int32_t b) {
        if (b > 0 && a > INT32_MAX - b) {
            // Overflow would occur
            fprintf(stderr, "Addition overflow detected\n");
            return INT32_MAX;
        }
        
        return a + b;
    }
    
    // Multiply with overflow check
    int32_t mult(int32_t a, int32_t b) {
        if (b != 0 && a > INT32_MAX / b) {
            fprintf(stderr, "Multiplication overflow detected\n");
            return INT32_MAX;
        }
        
        return a * b;
    }
}
```

## Portable Integer Types

```c
#include <stdio.h>

// Use fixed-width types for portability
typedef int32_t int32;  // Exactly 32-bit signed
typedef uint32_t uint32;  // Exactly 32-bit unsigned
typedef int64_t int64;  // Exactly 64-bit signed
typedef uint64_t uint64;  // Exactly 64-bit unsigned

// Size-independent integer type
typedef ptrdiff_t ptrdiff;  // Pointer difference
typedef intptr_t intptr;  // Signed pointer size
```

## Type Conversion c.preprocessor.macros

```c
#include <stdint.h>

// Safe width-conversions
#define INT8_C(x)   ((int8_t)(x))
#define INT16_C(x)  ((int16_t)(x))
#define INT32_C(x)  ((int32_t)(x))
#define INT64_C(x)  ((int64_t)(x))

// Unsigned versions
#define UINT8_C(x)  ((uint8_t)(x))
#define UINT16_C(x)  ((uint16_t)(x))
#define UINT32_C(x)  ((uint32_t)(x))
#define UINT64_C(x) ((uint64_t)(x))

// Sign conversion
#define TO_INT8_C(x)   ((int8_t)(x))
#define TO_INT16_C(x)  ((int16_t)(x))
#define TO_INT32_C(x) ((int32_t)(x))
```

## Sizeof Patterns

```c
#include <stdint.h>

// Size of types
int main() {
    // Check size assumptions
    static_assert(sizeof(int8_t) == 1, "int8_t must be 1 byte");
    static_assert(sizeof(int16_t) == 2, "int16_t must be 2 bytes");
    static_assert(sizeof(int32_t) == 4, "int32_t must be 4 bytes");
    static_assert(sizeof(int64_t) == 8, "int64_t must be 8 bytes");
    
    printf("All size checks passed\n");
    return 0;
}
```

> **Note**: Use stdint.h> for portable integer types. Always check for integer overflow in arithmetic operations.
