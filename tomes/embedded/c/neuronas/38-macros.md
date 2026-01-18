---
id: "c.preprocessor.macros"
title: "Macros (#define, #undef, #, ##)"
category: preprocessor
difficulty: intermediate
tags: [c, preprocessor, macros, define, undef]
keywords: [define, undef, macro, token-pasting, stringification]
use_cases: [code generation, constants, debugging]
prerequisites: []
related: ["c.preprocessor.conditionals"]
next_topics: ["c.preprocessor.include"]
---

# Macros

## Simple Macros

```c
#include <stdio.h>

#define PI 3.14159
#define MAX_SIZE 100

int main() {
    printf("PI: %f\n", PI);
    printf("Max size: %d\n", MAX_SIZE);

    return 0;
}
```

## Function-like Macros

```c
#include <stdio.h>

#define SQUARE(x) ((x) * (x))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int main() {
    printf("Square of 5: %d\n", SQUARE(5));
    printf("Max of 10, 20: %d\n", MAX(10, 20));
    printf("Min of 10, 20: %d\n", MIN(10, 20));

    return 0;
}
```

## Stringification (#)

```c
#include <stdio.h>

#define STR(x) #x
#define PRINT_VAR(x) printf(#x " = %d\n", x)

int main() {
    int value = 42;

    printf("%s\n", STR(Hello World));
    PRINT_VAR(value);

    return 0;
}
```

## Token Pasting (##)

```c
#include <stdio.h>

#define CONCAT(a, b) a##b
#define DECLARE_VAR(name) int CONCAT(var_, name) = 0

int main() {
    int CONCAT(hello, world) = 123;

    printf("%d\n", hello_world);

    return 0;
}
```

## Multi-line Macros

```c
#include <stdio.h>

#define PRINT_ELEMENTS(arr, size) \
    for (int i = 0; i < size; i++) { \
        printf("%d ", arr[i]); \
    } \
    printf("\n")

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    PRINT_ELEMENTS(numbers, size);

    return 0;
}
```

## Debug Macros

```c
#include <stdio.h>

#ifdef DEBUG
    #define DEBUG_PRINT(fmt, ...) printf(fmt, ##__VA_ARGS__)
#else
    #define DEBUG_PRINT(fmt, ...) ((void)0)
#endif

int main() {
    DEBUG_PRINT("Debug mode enabled\n");
    DEBUG_PRINT("Value: %d\n", 42);

    return 0;
}
```

## Assert Macro

```c
#include <stdio.h>
#include <stdlib.h>

#define ASSERT(condition) \
    if (!(condition)) { \
        fprintf(stderr, "Assertion failed: %s\n", #condition); \
        exit(1); \
    }

int main() {
    int x = 5;
    ASSERT(x == 5);
    ASSERT(x > 0);

    return 0;
}
```

## Undefine Macros

```c
#include <stdio.h>

#define VERSION 1

int main() {
    printf("Version: %d\n", VERSION);

    #undef VERSION

    // VERSION is now undefined
    // printf("%d\n", VERSION);  // Error

    return 0;
}
```

## Macro Guards

```c
#include <stdio.h>

#ifndef MAX
    #define MAX(a, b) ((a) > (b) ? (a) : (b))
#endif

int main() {
    printf("Max: %d\n", MAX(10, 20));

    return 0;
}
```

## Conditional Macros

```c
#include <stdio.h>

#if defined(UNIX)
    #define PLATFORM "UNIX"
#elif defined(WINDOWS)
    #define PLATFORM "WINDOWS"
#else
    #define PLATFORM "UNKNOWN"
#endif

int main() {
    printf("Platform: %s\n", PLATFORM);

    return 0;
}
```

## Error Macros

```c
#include <stdio.h>

#define ERROR_MSG(msg) \
    fprintf(stderr, "Error: %s\n", msg); \
    exit(1)

int main() {
    int x = -1;

    if (x < 0) {
        ERROR_MSG("Invalid value");
    }

    return 0;
}
```

## Array Size Macro

```c
#include <stdio.h>

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

int main() {
    int numbers[] = {1, 2, 3, 4, 5};

    printf("Array size: %zu\n", ARRAY_SIZE(numbers));

    return 0;
}
```

## Bit Manipulation Macros

```c
#include <stdio.h>

#define SET_BIT(var, bit) ((var) |= (1 << (bit)))
#define CLEAR_BIT(var, bit) ((var) &= ~(1 << (bit)))
#define TOGGLE_BIT(var, bit) ((var) ^= (1 << (bit)))
#define GET_BIT(var, bit) (((var) >> (bit)) & 1)

int main() {
    unsigned int flags = 0;

    SET_BIT(flags, 2);
    printf("Set bit 2: 0x%x\n", flags);

    CLEAR_BIT(flags, 2);
    printf("Cleared bit 2: 0x%x\n", flags);

    return 0;
}
```

## Range Check Macro

```c
#include <stdio.h>

#define IN_RANGE(val, min, max) \
    ((val) >= (min) && (val) <= (max))

int main() {
    int value = 5;

    if (IN_RANGE(value, 1, 10)) {
        printf("%d is in range [1, 10]\n", value);
    }

    return 0;
}
```

## Loop Macros

```c
#include <stdio.h>

#define FOR_EACH(item, array, size) \
    for (size_t i = 0; i < size; i++) { \
        item = array[i];

#define END_FOR }

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);
    int item;

    FOR_EACH(item, numbers, size)
        printf("%d ", item);
    END_FOR

    printf("\n");

    return 0;
}
```

## Swap Macro

```c
#include <stdio.h>

#define SWAP(a, b, type) \
    do { \
        type temp = (a); \
        (a) = (b); \
        (b) = temp; \
    } while(0)

int main() {
    int x = 5, y = 10;

    printf("Before: x=%d, y=%d\n", x, y);

    SWAP(x, y, int);

    printf("After: x=%d, y=%d\n", x, y);

    return 0;
}
```

> **Warning**: Always use parentheses around macro parameters. Use `do { ... } while(0)` for multi-statement macros.
