---
id: "c.preprocessor"
title: "Preprocessor Directives"
category: language
difficulty: intermediate
tags: [c, preprocessor, macros, #define, #ifdef, #pragma]
keywords: [define, undef, ifdef, ifndef, elif, else, endif, pragma, include]
use_cases: [conditional compilation, macros, platform-specific code, code generation]
prerequisites: []
related: ["c.functions"]
next_topics: []
---

# Preprocessor Directives

C's preprocessor handles conditional compilation and macros before compilation.

## #define - Create Macros

```c
#define PI 3.14159
#define MAX_SIZE 100
#define VERSION "1.0.0"

#define SQUARE(x) ((x) * (x))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int main() {
    printf("PI: %f\n", PI);
    printf("Max size: %d\n", MAX_SIZE);
    printf("10 squared: %d\n", SQUARE(10));
    printf("Min(5, 10): %d\n", MIN(5, 10));
    return 0;
}
```

## #ifdef / #ifndef - Conditional Compilation

```c
#define PLATFORM_WINDOWS
#ifdef _WIN32
#define PLATFORM_WINDOWS
#endif

// Debug mode
#define DEBUG_MODE

#ifdef DEBUG_MODE
    #define LOG(msg) printf("[DEBUG] %s\n", msg)
#else
    #define LOG(msg) // Debug messages compiled out
#endif

// Feature flags
#define FEATURE_A 1
#define FEATURE_B 0

#ifdef FEATURE_A
    // Feature A code
#else
    // Feature A not available
#endif
```

## #include - File Inclusion

```c
#include <stdio.h>
#include "custom_header.h"

int main() {
    printf("Main program\n");
    return 0;
}
```

## #pragma - Compiler Directives

```c
// Set warnings
#pragma warning(disable: 4996)  // Unused parameter

// Optimization hints
#pragma optimize("O2")

// Struct packing
#pragma pack(push, 1)
struct PackedStruct {
    char a;
    int b;
};
#pragma pack(pop)
```

## Function-like Macros

```c
// Macro with statement
#define PRINT_VAR(var) printf("Value: %d\n", var)

int main() {
    int x = 42;
    PRINT_VAR(x);
    return 0;
}

// Macro with expression
#define ABS(x) ((x) < 0 ? -(x) : (x))
#define MAX3(a, b, c) ((a) > (b) ? ((a) > (c) ? (a) : (c)) : ((b) > (c) ? (b) : (c)))

// Stringification
#define STRINGIFY(x) #x

int main() {
    printf("PI: %s\n", STRINGIFY(PI));
    return 0;
}
```

## #undef - Remove Macros

```c
#define TEMP_MACRO 1

int main() {
    printf("Temporary: %d\n", TEMP_MACRO);
    
#undef TEMP_MACRO  // Remove definition
    
    // This will cause error
    // printf("Undefined: %d\n", TEMP_MACRO);
    
    return 0;
}
```

## Conditional Compilation

```c
// Platform detection
#if defined(_WIN32) || defined(_WIN64)
    #include <windows.h>
#else
    #include <unistd.h>
#endif

// Compiler detection
#if defined(__GNUC__)
    #define COMPILER "GCC"
#elif defined(_MSC_VER)
    #define COMPILER "MSVC"
#else
    #define COMPILER "Unknown"
#endif
```

## Macro Arguments

```c
// Multi-line macro with do-while(0) loop
#define PRINT_LINE(x) do { printf("%s\n", x); } while (0)

int main() {
    PRINT_LINE("Hello, World!");
    return 0;
}

// Macro with arguments
#define SWAP(a, b) do { int temp = (a); (a) = (b); (b) = temp; } while (0)

int main() {
    int x = 10;
    int y = 20;
    printf("Before: x=%d, y=%d\n", x, y);
    SWAP(x, y);
    printf("After:  x=%d, y=%d\n", x, y);
    return 0;
}
```

## Token Pasting and Stringification

```c
#define CAT(a, b) a ## b

// Token concatenation
#define VAR_NAME(name) name ## _var

// Stringify macro
#define TO_STRING(x) #x

int main() {
    int PI_ = 3;
    printf("PI_: %s\n", TO_STRING(PI_));
    return 0;
}
```

## Common Patterns

### Compile-time assertions

```c
#define COMPILE_TIME_CHECK(condition) \
    typedef char assert_failed[2 * (sizeof(condition) - 1)]; \
    extern int assert_failed[(condition) ? 1 : -1]; \
    int main() { COMPILE_TIME_CHECK(1 == 1) }

### Debug/Release macros

```c
#ifdef _DEBUG
    #define DBG_PRINT(msg) printf("[DEBUG] %s\n", msg)
#else
    #define DBG_PRINT(msg)
#endif

int main() {
    DBG_PRINT("Debug build");
    return 0;
}
```

### Include guards

```c
#ifndef CUSTOM_HEADER_H
#define CUSTOM_HEADER_H

void custom_function(void);
int CUSTOM_HEADER_VALUE = 42;

#endif  // End of include guard
```

### Portable integer sizes

```c
// Use standard types for portability
#include <stdint.h>

int main() {
    // Use fixed-width types
    int32_t count = 1000000;
    uint64_t bytes = 0xFFFFFFFF;
    
    printf("Count: %" PRId64 "\n", count);
    printf("Bytes: %" PRIu64 "\n", bytes);
    return 0;
}
```

### Version checks

```c
// Feature detection
#if __STDC_VERSION__ >= 201112L
    // Code requiring C11 or later
#endif

// Detect C17 features
#if defined(__STDC_NO_THREADS__)
    // Need manual threading support
#endif
```

> **Note**: Preprocessor code executes before compilation. Use it judiciously - prefer const and inline functions over complex macros.
