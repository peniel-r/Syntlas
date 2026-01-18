---
id: 100-api-design
title: API Design Principles
category: bestpractices
difficulty: advanced
tags:
  - api-design
  - interface-design
  - libraries
keywords:
  - API design
  - interface design
  - library design
  - public API
use_cases:
  - Library development
  - API design
  - Public interfaces
  - Component design
prerequisites:
  - functions
  - headers
  - compilation
related:
  - shared-libraries
  - static-libraries
next_topics:
  - documentation
---

# API Design Principles

Good API design is crucial for usable, maintainable libraries.

## Consistent Naming Conventions

```c
// GOOD - Consistent naming convention
// Prefix for library functions (e.g., mylib_)
mylib_init();
mylib_cleanup();
mylib_process();
mylib_get_value();
mylib_set_value();

// BAD - Inconsistent naming
mylib_init();
cleanup();
process_mylib();
GetValue();
setvalue();
```

## Clear Function Names

```c
// GOOD - Self-documenting names
int database_connect(const char *host, int port);
int database_disconnect(void);
int database_query(const char *sql, Result *result);

// BAD - Ambiguous names
int db_open(char *h, int p);
int db_close(void);
int db_do(char *s, Result *r);
```

## Error Handling

```c
// GOOD - Return error codes
typedef enum {
    MYLIB_SUCCESS = 0,
    MYLIB_ERROR_NULL,
    MYLIB_ERROR_INVALID_PARAM,
    MYLIB_ERROR_OUT_OF_MEMORY
} MyLibError;

MyLibError mylib_init(Context *ctx) {
    if (ctx == NULL) {
        return MYLIB_ERROR_NULL;
    }
    // Initialize...
    return MYLIB_SUCCESS;
}

// BAD - Using exceptions (C doesn't have them)
void mylib_init(Context *ctx) {
    if (ctx == NULL) {
        throw "Null pointer";  // Not valid C
    }
}
```

## Resource Management

```c
// GOOD - RAII-like pattern in C
typedef struct {
    void *handle;
    int initialized;
} MyLibContext;

MyLibContext *mylib_create(void) {
    MyLibContext *ctx = malloc(sizeof(MyLibContext));
    if (ctx) {
        ctx->initialized = 0;
        ctx->handle = NULL;
    }
    return ctx;
}

int mylib_init(MyLibContext *ctx) {
    if (ctx->initialized) {
        return MYLIB_ERROR_ALREADY_INIT;
    }
    // Initialize...
    ctx->initialized = 1;
    return MYLIB_SUCCESS;
}

void mylib_destroy(MyLibContext *ctx) {
    if (ctx && ctx->initialized) {
        // Cleanup...
        ctx->initialized = 0;
    }
    free(ctx);
}

// Usage
MyLibContext *ctx = mylib_create();
mylib_init(ctx);
// Use ctx...
mylib_destroy(ctx);
```

## Versioning

```c
// GOOD - Version information in API
#define MYLIB_VERSION_MAJOR 1
#define MYLIB_VERSION_MINOR 0
#define MYLIB_VERSION_PATCH 0

#define MYLIB_VERSION_STRING "1.0.0"

typedef struct {
    int major;
    int minor;
    int patch;
} MyLibVersion;

MyLibVersion mylib_version(void) {
    MyLibVersion v = {
        MYLIB_VERSION_MAJOR,
        MYLIB_VERSION_MINOR,
        MYLIB_VERSION_PATCH
    };
    return v;
}

// Usage
MyLibVersion v = mylib_version();
printf("Library version: %d.%d.%d\n", v.major, v.minor, v.patch);
```

## Header Organization

```c
// GOOD - Well-organized header
#ifndef MYLIB_H
#define MYLIB_H

// Includes
#include <stddef.h>
#include <stdint.h>

// Version information
#define MYLIB_VERSION 0x010000

// Type definitions
typedef struct MyLibContext MyLibContext;
typedef enum { /* ... */ } MyLibError;

// Function declarations
MyLibContext *mylib_create(void);
int mylib_init(MyLibContext *ctx);
void mylib_destroy(MyLibContext *ctx);

// Inline functions
static inline int mylib_get_version(void) {
    return MYLIB_VERSION;
}

#endif // MYLIB_H
```

## Const Correctness

```c
// GOOD - Use const where appropriate
int mylib_get_value(const MyLibContext *ctx, int *value);

const char *mylib_get_string(const MyLibContext *ctx);

// BAD - Missing const
int mylib_get_value(MyLibContext *ctx, int *value);
char *mylib_get_string(MyLibContext *ctx);
```

## Opaque Types

```c
// mylib.h - Public header
typedef struct MyLibContext MyLibContext;

MyLibContext *mylib_create(void);
void mylib_destroy(MyLibContext *ctx);

// mylib.c - Implementation
struct MyLibContext {
    int internal_data;
    void *private_handle;
};

MyLibContext *mylib_create(void) {
    MyLibContext *ctx = malloc(sizeof(MyLibContext));
    // Initialize...
    return ctx;
}

void mylib_destroy(MyLibContext *ctx) {
    // Cleanup...
    free(ctx);
}
```

## Callback Design

```c
// GOOD - Clean callback interface
typedef void (*ProgressCallback)(int percent, void *user_data);

typedef struct {
    ProgressCallback callback;
    void *user_data;
} ProgressInfo;

int mylib_process_with_progress(const char *input,
                                ProgressInfo *progress,
                                Result *result);

// Usage
void progress_handler(int percent, void *user_data) {
    printf("Progress: %d%%\n", percent);
}

ProgressInfo info = {progress_handler, NULL};
mylib_process_with_progress("input.txt", &info, &result);
```

## Documentation Comments

```c
/**
 * @brief Initialize the library context
 *
 * @param ctx Pointer to context structure
 * @return MYLIB_SUCCESS on success, error code on failure
 *
 * @note Must be called before any other library functions
 * @see mylib_destroy()
 */
MyLibError mylib_init(MyLibContext *ctx);

/**
 * @brief Process data and return results
 *
 * @param ctx Initialized context
 * @param input Input data buffer
 * @param input_size Size of input data in bytes
 * @param output Buffer to store output
 * @param output_size Size of output buffer (in/out)
 * @return MYLIB_SUCCESS on success, error code on failure
 *
 * @note output_size must be initialized to buffer size
 * @note On return, contains actual output size
 */
MyLibError mylib_process(MyLibContext *ctx,
                         const void *input,
                         size_t input_size,
                         void *output,
                         size_t *output_size);
```

## Thread Safety

```c
// GOOD - Document thread safety
/**
 * @brief Get configuration value
 *
 * @param ctx Context structure
 * @param key Configuration key
 * @return Value or NULL if not found
 *
 * @note Thread-safe: Multiple threads can call concurrently
 */
const char *mylib_get_config(const MyLibContext *ctx, const char *key);

/**
 * @brief Set configuration value
 *
 * @param ctx Context structure
 * @param key Configuration key
 * @param value Value to set
 * @return MYLIB_SUCCESS on success, error code on failure
 *
 * @note NOT thread-safe: Must be called with external synchronization
 */
MyLibError mylib_set_config(MyLibContext *ctx,
                            const char *key,
                            const char *value);
```

## Best Practices

### Be Minimal

```c
// GOOD - Minimal API surface
void mylib_process(Context *ctx);

// BAD - Too many similar functions
void mylib_process_fast(Context *ctx);
void mylib_process_slow(Context *ctx);
void mylib_process_safe(Context *ctx);
void mylib_process_optimized(Context *ctx);
```

### Fail Fast

```c
// GOOD - Validate parameters early
MyLibError mylib_init(Context *ctx) {
    if (ctx == NULL) return MYLIB_ERROR_NULL;
    if (ctx->initialized) return MYLIB_ERROR_ALREADY_INIT;
    // Initialize...
}

// BAD - Defer validation
MyLibError mylib_init(Context *ctx) {
    // Some initialization...
    if (ctx == NULL) return MYLIB_ERROR_NULL;  // Too late!
}
```

### Provide High-Level Abstractions

```c
// GOOD - High-level API
MyLibError mylib_do_task(Context *ctx);

// BAD - Low-level, requires many steps
MyLibError mylib_step1(Context *ctx);
MyLibError mylib_step2(Context *ctx);
MyLibError mylib_step3(Context *ctx);
```

## Common Pitfalls

### 1. Breaking ABI

```c
// WRONG - Changing struct layout breaks ABI
struct MyLibContext {
    int field1;
    int new_field;  // Added field
    int field2;
};

// CORRECT - Add new fields at end
struct MyLibContext {
    int field1;
    int field2;
    int new_field;  // Added at end
};
```

### 2. Global State

```c
// WRONG - Global state causes problems
static Context *global_ctx = NULL;

void mylib_init(void) {
    global_ctx = create_context();
}

// CORRECT - Context passed explicitly
void mylib_init(Context **ctx) {
    *ctx = create_context();
}
```

### 3. Inconsistent Error Handling

```c
// WRONG - Mixed error handling
int func1(void);  // Returns 0 on success
int func2(void);  // Returns non-zero on success
void func3(void);  // Never fails

// CORRECT - Consistent error codes
MyLibError func1(Context *ctx);
MyLibError func2(Context *ctx);
MyLibError func3(Context *ctx);
```

> **Note: Good API design is an art. Be consistent. Document everything. Think about future evolution. Consider thread safety. Minimize API surface. Make it easy to use correctly and hard to use incorrectly.
