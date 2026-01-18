---
id: 97-variadic-macros
title: Variadic Macros
category: preprocessor
difficulty: intermediate
tags:
  - macros
  - variadic
  - preprocessor
keywords:
  - variadic macros
  - preprocessor
  - __VA_ARGS__
  - macros
use_cases:
  - Logging
  - Debugging
  - Generic macros
  - Code generation
prerequisites:
  - preprocessor
  - macros
related:
  - logging
  - macros
next_topics:
  - x-macros
---

# Variadic Macros

Variadic macros accept variable number of arguments using the preprocessor.

## Basic Variadic Macros

```c
#include <stdio.h>

// Variadic macro with __VA_ARGS__
#define PRINTF(fmt, ...) printf(fmt, ##__VA_ARGS__)

// Macro that accepts variable arguments
#define LOG_INFO(...) printf("[INFO] " __VA_ARGS__)
#define LOG_ERROR(...) fprintf(stderr, "[ERROR] " __VA_ARGS__)

int main(void) {
    PRINTF("Hello %s!\n", "World");
    PRINTF("Number: %d\n", 42);

    LOG_INFO("Application started\n");
    LOG_INFO("Processing %d items\n", 100);
    LOG_ERROR("Connection failed: %s\n", "timeout");

    return 0;
}
```

## Debug Macro

```c
#include <stdio.h>

// Debug macro (only active if DEBUG is defined)
#ifdef DEBUG
    #define DEBUG_PRINT(fmt, ...) \
        printf("[DEBUG] [%s:%d] " fmt "\n", \
               __FILE__, __LINE__, ##__VA_ARGS__)
#else
    #define DEBUG_PRINT(fmt, ...) ((void)0)
#endif

int main(void) {
    DEBUG_PRINT("This will print in debug mode");
    DEBUG_PRINT("Value: %d", 42);

    return 0;
}
```

## Assert Macro

```c
#include <stdio.h>
#include <stdlib.h>

// Custom assert macro
#define ASSERT(condition, ...) \
    do { \
        if (!(condition)) { \
            fprintf(stderr, "Assertion failed: %s\n", #condition); \
            fprintf(stderr, "  File: %s, Line: %d\n", __FILE__, __LINE__); \
            fprintf(stderr, "  Message: " __VA_ARGS__); \
            abort(); \
        } \
    } while(0)

int main(void) {
    int x = 5;
    ASSERT(x == 5, "x should be 5\n");
    ASSERT(x != 10, "x should not be 10\n");

    return 0;
}
```

## Array Size Macro

```c
#include <stdio.h>

// Get array size
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

int main(void) {
    int numbers[] = {1, 2, 3, 4, 5};

    printf("Array size: %zu\n", ARRAY_SIZE(numbers));

    for (int i = 0; i < ARRAY_SIZE(numbers); i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Macro with Multiple Arguments

```c
#include <stdio.h>

// Macro that processes multiple arguments
#define FOREACH_1(what, x) what(x)
#define FOREACH_2(what, x, ...) what(x), FOREACH_1(what, __VA_ARGS__)
#define FOREACH_3(what, x, ...) what(x), FOREACH_2(what, __VA_ARGS__)
#define FOREACH_4(what, x, ...) what(x), FOREACH_3(what, __VA_ARGS__)

// Count arguments
#define COUNT_ARGS(...) COUNT_ARGS_(__VA_ARGS__, 4, 3, 2, 1, 0)
#define COUNT_ARGS_(a1, a2, a3, a4, count, ...) count

int main(void) {
    int x = 5, y = 10, z = 15;

    printf("Sum: %d\n", FOREACH_1(int, x));
    printf("Sum: %d\n", FOREACH_2(int, x, y));
    printf("Sum: %d\n", FOREACH_3(int, x, y, z));

    printf("Argument count: %d\n", COUNT_ARGS(a, b, c, d));
    printf("Argument count: %d\n", COUNT_ARGS(a, b, c));
    printf("Argument count: %d\n", COUNT_ARGS(a, b));
    printf("Argument count: %d\n", COUNT_ARGS(a));

    return 0;
}
```

## Stringification

```c
#include <stdio.h>

// Stringify argument
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

// Concatenate tokens
#define CONCAT(a, b) a##b
#define CONCAT2(a, b) a##b

#define VAR(name) int CONCAT(var_, name) = name

int main(void) {
    printf("Stringified: %s\n", STRINGIFY(Hello World));
    printf("Stringified: %s\n", TOSTRING(42));
    printf("Concatenated: %s\n", CONCAT(hello, _world));

    VAR(100);
    printf("var_100 = %d\n", var_100);

    return 0;
}
```

## Conditional Macro Expansion

```c
#include <stdio.h>

// Choose between two macros
#define CHOOSE_CHOOSER(a4, a3, a2, a1, chooser, ...) chooser
#define CHOOSE_HELPER(chosen) CHOOSE_##chosen
#define CHOOSE_ARG4(f, ...) CHOOSE_HELPER(CHOOSE_CHOOSER(__VA_ARGS__, f, f, f, f, a3, a2, a1))
#define CHOOSE_ARG3(f, ...) CHOOSE_HELPER(CHOOSE_CHOOSER(__VA_ARGS__, f, f, f, a2, a1, a1, a1))
#define CHOOSE_ARG2(f, ...) CHOOSE_HELPER(CHOOSE_CHOOSER(__VA_ARGS__, f, f, a1, a1, a1, a1))
#define CHOOSE_ARG1(f) f

#define MACRO_DISPATCH(func, ...) CHOOSE_ARG3(func, __VA_ARGS__)

#define FUNC_1(x) printf("1 arg: %d\n", x)
#define FUNC_2(x, y) printf("2 args: %d, %d\n", x, y)
#define FUNC_3(x, y, z) printf("3 args: %d, %d, %d\n", x, y, z)

int main(void) {
    MACRO_DISPATCH(FUNC_, 42);
    MACRO_DISPATCH(FUNC_, 42, 43);
    MACRO_DISPATCH(FUNC_, 42, 43, 44);

    return 0;
}
```

## Macro with Code Blocks

```c
#include <stdio.h>

// Macro that contains code block
#define REPEAT(count, block) \
    do { \
        for (int _i = 0; _i < (count); _i++) { \
            block \
        } \
    } while(0)

int main(void) {
    printf("Repeating block 3 times:\n");

    REPEAT(3,
        printf("  Iteration %d\n", _i + 1);
    )

    return 0;
}
```

## Multi-line Macro

```c
#include <stdio.h>

// Multi-line macro with do-while(0)
#define SAFE_DIVIDE(a, b, result) \
    do { \
        if ((b) == 0) { \
            fprintf(stderr, "Division by zero\n"); \
            (result) = 0; \
        } else { \
            (result) = (a) / (b); \
        } \
    } while(0)

int main(void) {
    int result;

    SAFE_DIVIDE(10, 2, result);
    printf("10 / 2 = %d\n", result);

    SAFE_DIVIDE(10, 0, result);
    printf("Result after division by zero: %d\n", result);

    return 0;
}
```

## Best Practices

### Use do-while(0) for Multi-line Macros

```c
// GOOD - Safe for if statements
#define MACRO(x) \
    do { \
        printf("Value: %d\n", (x)); \
    } while(0)

// BAD - Unsafe for if statements
#define MACRO_BAD(x) \
    printf("Value: %d\n", (x))
```

### Use Parentheses Around Arguments

```c
// GOOD - Parentheses for safety
#define ADD(a, b) ((a) + (b))

// BAD - Missing parentheses
#define ADD_BAD(a, b) a + b

// Usage:
// 2 * ADD(3, 4) = 2 * (3 + 4) = 14
// 2 * ADD_BAD(3, 4) = 2 * 3 + 4 = 10
```

### Use Stringify for Debugging

```c
// GOOD - Stringify for debugging
#define DEBUG_EXPR(expr) \
    printf("%s = %d\n", #expr, (expr))

// Usage:
DEBUG_EXPR(5 + 3 * 2);  // Prints: 5 + 3 * 2 = 11
```

## Common Pitfalls

### 1. Side Effects

```c
// WRONG - Multiple evaluation
#define SQR(x) ((x) * (x))
int result = SQR(i++);  // i incremented twice!

// CORRECT - Use inline function
static inline int sqr(int x) { return x * x; }
int result = sqr(i++);  // i incremented once
```

### 2. Operator Precedence

```c
// WRONG - Precedence issues
#define MAX(a, b) a > b ? a : b
int result = MAX(x & 0xFF, y);

// CORRECT - Use parentheses
#define MAX(a, b) ((a) > (b) ? (a) : (b))
```

### 3. Missing Parentheses

```c
// WRONG - Missing parentheses
#define MULTIPLY(a, b) a * b
int result = MULTIPLY(x + y, z);  // x + y * z

// CORRECT - Use parentheses
#define MULTIPLY(a, b) ((a) * (b))
```

> **Note: Variadic macros are powerful but can be error-prone. Always use parentheses around macro arguments. Use do-while(0) for multi-line macros. Be aware of multiple evaluation issues.
