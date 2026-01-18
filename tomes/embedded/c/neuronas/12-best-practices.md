---
id: "c.best-practices"
title: "C Best Practices"
category: pattern
difficulty: advanced
tags: [c, best-practices, security, portability, conventions]
keywords: [const, static, volatile, inline, error handling, memory]
use_cases: [code quality, maintainability, security, cross-platform]
prerequisites: []
related: ["c.algorithms"]
next_topics: []
---

# C Best Practices

Follow these guidelines for safe, portable, and maintainable C code.

## Const Correctness

```c
#include <stdio.h>

// GOOD - use const for immutable values
const int MAX_SIZE = 100;
const char* DEFAULT_CONFIG = "default.conf";

// AVOID - const for magic numbers
// #define MAGIC_NUMBER 0xdeadbeef  // No magic numbers

// Use enums for constants
enum ConfigType {
    CONFIG_DEBUG,
    CONFIG_RELEASE,
    CONFIG_TEST,
};

const ConfigType CURRENT_CONFIG = CONFIG_RELEASE;
```

## Portability

```c
#include <stdio.h>

// Use standard C89 where possible
void portable_function(int param) {
    int result = param * 2;
}

// Platform detection (abstracted)
#if defined(_WIN32)
    void windows_specific() {}
#elif defined(_WIN64)
    void windows_64_specific() {}
#elif defined(__linux__)
    void linux_specific() {}
#elif defined(__APPLE__)
    void macos_specific() {}
#else
    void other_platform_specific() {}
#endif
```

## Memory Safety

```c
#include <stdlib.h>
#include <string.h>

// Initialize pointers to NULL
int* ptr = NULL;
char* str = NULL;

// Always check return values
int* allocate_array(size_t size) {
    int* arr = malloc(sizeof(int) * size);
    if (arr == NULL) {
        return NULL;
    }
    
    // Initialize array
    for (size_t i = 0; i < size; i++) {
        arr[i] = 0;
    }
    
    return arr;
}

void free_safely(void* ptr) {
    if (ptr != NULL) {
        free(ptr);
        ptr = NULL;
    }
}
```

## Error Handling

```c
#include <stdio.h>
#include <errno.h>

// Return error codes instead of -1
int parse_int(const char* str, int* result) {
    char* endptr;
    int value = (int)strtol(str, &endptr, 10);
    
    if (endptr == str || *endptr != '\0') {
        *result = -1;
        return -1;  // Parse error
    }
    
    *result = value;
    return 0;  // Success
}
```

## Function Design

```c
// Keep functions small and focused
int calculate_area(int width, int height) {
    return width * height;
}

// Use const for parameters that shouldn't change
void process_data(const struct Data* data) {
    // Read-only access to data
}
```

## Resource Management

```c
#include <stdio.h>

// Use scope-based resource management
void process_resource(void) {
    FILE* file = fopen("data.txt", "r");
    if (file == NULL) return;
    
    // Use resource
    fclose(file);
}

// Use RAII pattern for resources
typedef struct Resource {
    void* handle;
    void (*cleanup)(void*);
};

void init_resource(Resource* res) {
    res->handle = NULL;
    res->cleanup = NULL;
}

void use_resource(Resource* res, void (*operation)(void* handle)) {
    operation(res->handle);
}
```

## Naming Conventions

```c
// Lowercase with underscores
int calculate_total(int a, int b) {
    return a + b;
}

// Types in all caps for macros/constants
#define MAX_FILE_SIZE 1000
#define DEFAULT_TIMEOUT 30

// Structs use PascalCase
typedef struct UserInfo {
    char username[50];
    int user_id;
};
```

## Documentation Comments

```c
/**
 * @brief Brief description
 *
 * @param param1 Parameter description
 * @return Return value description
 *
 * Example usage:
 * @code
 * int result = function_call();
 *
 * @note Additional notes
 * @warning Important warnings
 */
```

## Common Patterns

### Initialization

```c
// Compound literal
const struct Point origin = {0, 0};
const struct Point current = {0, 0};

// Designated initializers
const Config config = {
    .max_size = 1024,
    .buffer_size = 8192,
};

// Default initialization
int uninitialized_value; // Dangerous
int initialized_value = 0;  // Better
```

### Bounds Checking

```c
// Always validate array indices
void safe_array_access(int arr[], size_t size, size_t index) {
    if (index >= size) {
        printf("Index %zu out of bounds\n", index);
        return;
    }
    
    int value = arr[index];
    printf("Value at index %zu: %d\n", index, value);
}
```

### String Handling

```c
// Use safe string functions
size_t safe_copy(char* dest, const char* src, size_t max_len) {
    size_t len = 0;
    
    // Copy with length limit
    while (len < max_len && src[len] != '\0') {
        dest[len++] = src[len];
        len++;
    }
    
    dest[len] = '\0';  // Null terminate
}
```

### File Operations

```c
// Always check file handles
void safe_file_write(const char* filename, const char* content) {
    FILE* file = fopen(filename, "w");
    if (file == NULL) {
        perror("Failed to open file");
        return;
    }
    
    // Write and check for errors
    if (fprintf(file, "%s", content) < 0) {
        perror("Write failed");
        fclose(file);
        return;
    }
    
    fclose(file);
}
```

## Testing

```c
// Use assertions for invariants
#include <assert.h>

int divide(int numerator, int denominator) {
    assert(denominator != 0);
    
    return numerator / denominator;
}
```

> **Note**: C best practices emphasize safety, portability, and clear code structure. Always validate assumptions and handle errors gracefully.
