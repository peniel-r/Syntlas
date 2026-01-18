---
id: "c.preprocessor.conditionals"
title: "Conditional Compilation (#ifdef, #ifndef, #if, #else, #elif)"
category: preprocessor
difficulty: intermediate
tags: [c, preprocessor, ifdef, ifndef, conditional]
keywords: [ifdef, ifndef, if, else, elif, defined]
use_cases: [platform code, debug builds, feature toggles]
prerequisites: []
related: ["c.preprocessor.macros"]
next_topics: ["c.preprocessor.include"]
---

# Conditional Compilation

## #ifdef / #ifndef

```c
#include <stdio.h>

#define USE_FEATURE

int main() {
    #ifdef USE_FEATURE
        printf("Feature enabled\n");
    #else
        printf("Feature disabled\n");
    #endif

    #ifndef NO_FEATURE
        printf("Default feature active\n");
    #endif

    return 0;
}
```

## #if / #elif / #else

```c
#include <stdio.h>

#define VERSION 2

int main() {
    #if VERSION == 1
        printf("Version 1\n");
    #elif VERSION == 2
        printf("Version 2\n");
    #else
        printf("Unknown version\n");
    #endif

    return 0;
}
```

## Platform Detection

```c
#include <stdio.h>

int main() {
    #if defined(__linux__)
        printf("Linux platform\n");
    #elif defined(_WIN32) || defined(_WIN64)
        printf("Windows platform\n");
    #elif defined(__APPLE__)
        printf("macOS platform\n");
    #else
        printf("Unknown platform\n");
    #endif

    return 0;
}
```

## Debug Builds

```c
#include <stdio.h>

#define DEBUG

void debug_print(const char* message) {
    #ifdef DEBUG
        printf("[DEBUG] %s\n", message);
    #endif
}

int main() {
    debug_print("Starting application");
    debug_print("Processing data");

    return 0;
}
```

## Feature Toggles

```c
#include <stdio.h>

#define FEATURE_A
#define FEATURE_B
// #define FEATURE_C

int main() {
    #ifdef FEATURE_A
        printf("Feature A enabled\n");
    #endif

    #ifdef FEATURE_B
        printf("Feature B enabled\n");
    #endif

    #ifdef FEATURE_C
        printf("Feature C enabled\n");
    #endif

    return 0;
}
```

## Compiler Detection

```c
#include <stdio.h>

int main() {
    #if defined(__GNUC__)
        printf("GCC compiler\n");
    #elif defined(__clang__)
        printf("Clang compiler\n");
    #elif defined(_MSC_VER)
        printf("MSVC compiler\n");
    #else
        printf("Unknown compiler\n");
    #endif

    return 0;
}
```

## Configuration Selection

```c
#include <stdio.h>

#define CONFIG_PRODUCTION

int main() {
    #if defined(CONFIG_DEVELOPMENT)
        printf("Development mode\n");
        #define LOG_LEVEL 3
    #elif defined(CONFIG_TESTING)
        printf("Testing mode\n");
        #define LOG_LEVEL 2
    #elif defined(CONFIG_PRODUCTION)
        printf("Production mode\n");
        #define LOG_LEVEL 1
    #else
        printf("Unknown mode\n");
        #define LOG_LEVEL 0
    #endif

    printf("Log level: %d\n", LOG_LEVEL);

    return 0;
}
```

## Architecture Detection

```c
#include <stdio.h>

int main() {
    #if defined(__x86_64__) || defined(_M_X64)
        printf("x86_64 architecture\n");
    #elif defined(__i386__) || defined(_M_IX86)
        printf("x86 architecture\n");
    #elif defined(__arm__) || defined(_M_ARM)
        printf("ARM architecture\n");
    #else
        printf("Unknown architecture\n");
    #endif

    return 0;
}
```

## C Standard Version

```c
#include <stdio.h>

int main() {
    #if __STDC_VERSION__ >= 201112L
        printf("C11 or later\n");
    #elif __STDC_VERSION__ >= 199901L
        printf("C99 or later\n");
    #elif defined(__STDC__)
        printf("ANSI C\n");
    #else
        printf("Pre-ANSI C\n");
    #endif

    return 0;
}
```

## Byte Order

```c
#include <stdio.h>

int main() {
    #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
        printf("Little endian\n");
    #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
        printf("Big endian\n");
    #else
        printf("Unknown byte order\n");
    #endif

    return 0;
}
```

## Optimization Level

```c
#include <stdio.h>

int main() {
    #if defined(__OPTIMIZE__)
        printf("Optimization enabled\n");
        #if __OPTIMIZE__ > 2
            printf("High optimization\n");
        #endif
    #else
        printf("No optimization\n");
    #endif

    return 0;
}
```

## Conditional Attributes

```c
#include <stdio.h>

void deprecated_function(void) {
    #if defined(__GNUC__) || defined(__clang__)
        __attribute__((deprecated))
    #elif defined(_MSC_VER)
        __declspec(deprecated)
    #endif
    printf("This function is deprecated\n");
}

int main() {
    // deprecated_function();  // May generate warning
    printf("Main function\n");

    return 0;
}
```

## Thread Local Storage

```c
#include <stdio.h>

void thread_local_example(void) {
    #if defined(__STDC_NO_THREADS__)
        printf("Threads not supported\n");
    #else
        #if defined(__GNUC__) || defined(__clang__)
            __thread int tls_var = 0;
        #elif defined(_MSC_VER)
            __declspec(thread) int tls_var = 0;
        #endif
        printf("Thread local storage supported\n");
    #endif
}

int main() {
    thread_local_example();
    return 0;
}
```

## Inline Keywords

```c
#include <stdio.h>

static inline int add(int a, int b) {
    return a + b;
}

int main() {
    #if defined(__GNUC__) || defined(__clang__)
        printf("Using __attribute__((always_inline))\n");
    #elif defined(_MSC_VER)
        printf("Using __forceinline\n");
    #endif

    printf("Result: %d\n", add(5, 3));

    return 0;
}
```

## Memory Alignment

```c
#include <stdio.h>

int main() {
    #if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 201112L)
        _Alignas(16) int aligned_var;
        printf("C11 alignment supported\n");
    #else
        #if defined(__GNUC__) || defined(__clang__)
            __attribute__((aligned(16))) int aligned_var;
        #elif defined(_MSC_VER)
            __declspec(align(16)) int aligned_var;
        #endif
        printf("Compiler-specific alignment\n");
    #endif

    return 0;
}
```

## Conditional Includes

```c
#include <stdio.h>

int main() {
    #if defined(HAVE_FEATURE_A)
        #include "feature_a.h"
        printf("Feature A available\n");
    #elif defined(HAVE_FEATURE_B)
        #include "feature_b.h"
        printf("Feature B available\n");
    #endif

    return 0;
}
```

> **Note**: Use `#if defined(MACRO)` instead of `#ifdef` when checking multiple macros.
