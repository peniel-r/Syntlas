---
id: "c.stdlib.assert"
title: "Assert Library"
category: stdlib
difficulty: intermediate
tags: [c, stdlib, assert, testing, debugging]
keywords: [assert, static_assert, NDEBUG, NDEBUG]
use_cases: [runtime checks, compile-time checks, debugging]
prerequisites: []
related: ["c.stdlib.math"]
next_topics: []
---

# Assert Library

C's <assert.h> provides runtime and compile-time assertion checking.

## Runtime Asserts

```c
#include <stdio.h>
#include <assert.h>

int main() {
    int x = 5;
    int y = 10;
    
    // Assert condition is true
    assert(x + y == 15);
    
    // This will fail and abort
    // assert(x + y == 16);
    
    printf("Assertions passed\n");
    return 0;
}
```

## Compile-Time Asserts (C11+)

```c
#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 201112L)
#include <assert.h>

// static_assert - compile-time assertion
static_assert(sizeof(int) == 4, "int must be 4 bytes");
static_assert(sizeof(void*) >= sizeof(int), "Pointer must be at least int size");

#endif
```

## Disabling Assertions

```c
// Disable assertions for production build
#ifdef NDEBUG
    assert(x > 0);  // Disabled - expression still evaluated
#endif

int main() {
    int x = 5;
    
    assert(x > 0);  // This will fail if not NDEBUG
    printf("Program continues even with failed assert\n");
    return 0;
}
```

## Custom Assert Macros

```c
#include <stdio.h>

// Create custom assertion macro
#define ASSERT(condition, message) \
    do { \
        if (!(condition)) { \
            fprintf(stderr, "Assertion failed: %s\n", message); \
            abort(); \
        } \
    } while (0)

int main() {
    int value = 42;
    
    ASSERT(value == 42, "Value must be 42");
    
    printf("Custom assertion passed\n");
    return 0;
}
```

## Safe Comparison Functions

```c
#include <stdio.h>

// Safe equality with side-effect checks
int safe_equal_int(int a, int b) {
    return a == b;
}

int safe_equal_str(const char* a, const char* b) {
    if (a == NULL || b == NULL) {
        if (a == NULL || *a == '\0') {
            return b == NULL;
        }
        return strcmp(a, b) == 0;
    }
    
    return 0;
}
```

## Debug Assertion Helpers

```c
#include <stdio.h>

#ifdef DEBUG
    #define DEBUG_PRINT(msg) fprintf(stderr, "[DEBUG] %s\n", msg)
    #define DEBUG_ASSERT(condition, message) ASSERT(condition, message)

#else
    #define DEBUG_PRINT(msg)
    #define DEBUG_ASSERT(condition, message)
#endif

int main() {
    int value = 42;
    
    DEBUG_ASSERT(value == 42, "Value check in debug mode");
    
    printf("Debug build complete\n");
    return 0;
}
```

## Assert Disable for Release

```c
// Release build - assertions disabled
#ifndef NDEBUG
    void test_release() {
    assert(0 == 1);  // Compiled out in release
}
#endif

int main() {
    #ifndef NDEBUG
        test_release();
    #endif
    
    printf("Release build\n");
    return 0;
}
```

> **Note**: Use assertions liberally for catching programming errors early. Disable them in release builds to avoid performance overhead.
