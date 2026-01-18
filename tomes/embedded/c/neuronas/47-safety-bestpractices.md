---
id: "c.bestpractices.safety"
title: "Safety Best Practices"
category: bestpractices
difficulty: intermediate
tags: [c, bestpractices, safety, validation, bounds]
keywords: [safety, validation, bounds, buffer, overflow]
use_cases: [robust code, security, reliability]
prerequisites: ["c.bestpractices.memory"]
related: ["c.error.errno"]
next_topics: ["c.bestpractices.portability"]
---

# Safety Best Practices

## Array Bounds Checking

```c
#include <stdio.h>
#include <stdbool.h>

bool is_valid_index(size_t index, size_t size) {
    return index < size;
}

int main() {
    int arr[5] = {1, 2, 3, 4, 5};
    size_t index = 10;

    if (is_valid_index(index, 5)) {
        printf("Value: %d\n", arr[index]);
    } else {
        printf("Index out of bounds\n");
    }

    return 0;
}
```

## Integer Overflow Protection

```c
#include <stdio.h>
#include <stdbool.h>
#include <limits.h>

bool safe_add(int a, int b, int* result) {
    if (b > 0 && a > INT_MAX - b) {
        return false;  // Overflow
    }
    if (b < 0 && a < INT_MIN - b) {
        return false;  // Underflow
    }
    *result = a + b;
    return true;
}

int main() {
    int a = INT_MAX - 1;
    int b = 2;
    int result;

    if (safe_add(a, b, &result)) {
        printf("Sum: %d\n", result);
    } else {
        printf("Overflow detected\n");
    }

    return 0;
}
```

## String Length Safety

```c
#include <stdio.h>
#include <string.h>

void safe_strcpy(char* dest, const char* src, size_t dest_size) {
    if (dest == NULL || src == NULL || dest_size == 0) {
        return;
    }

    strncpy(dest, src, dest_size - 1);
    dest[dest_size - 1] = '\0';
}

int main() {
    char buffer[10];

    safe_strcpy(buffer, "This is a very long string", sizeof(buffer));
    printf("Buffer: %s\n", buffer);

    return 0;
}
```

## Null Pointer Checks

```c
#include <stdio.h>
#include <stdlib.h>

void safe_dereference(int* ptr) {
    if (ptr == NULL) {
        printf("Null pointer dereference prevented\n");
        return;
    }

    printf("Value: %d\n", *ptr);
}

int main() {
    int* ptr = NULL;

    safe_dereference(ptr);

    ptr = malloc(sizeof(int));
    if (ptr != NULL) {
        *ptr = 42;
        safe_dereference(ptr);
        free(ptr);
    }

    return 0;
}
```

## Input Validation

```c
#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>

bool is_valid_number(const char* str) {
    if (str == NULL || *str == '\0') {
        return false;
    }

    while (*str != '\0') {
        if (!isdigit((unsigned char)*str)) {
            return false;
        }
        str++;
    }

    return true;
}

int main() {
    const char* inputs[] = {"123", "abc", "12a3"};

    for (int i = 0; i < 3; i++) {
        printf("'%s': %s\n", inputs[i],
               is_valid_number(inputs[i]) ? "valid" : "invalid");
    }

    return 0;
}
```

## Secure Memory Clear

```c
#include <stdio.h>
#include <string.h>

void secure_clear(void* ptr, size_t size) {
    // Explicitly clear sensitive data
    if (ptr != NULL && size > 0) {
        memset(ptr, 0, size);
    }
}

int main() {
    char password[20] = "secret123";

    // Use password...

    secure_clear(password, sizeof(password));
    printf("Password cleared\n");

    return 0;
}
```

## File Handle Safety

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    FILE* file;
    const char* path;
} SafeFile;

SafeFile* safe_open(const char* path, const char* mode) {
    SafeFile* sf = malloc(sizeof(SafeFile));
    if (sf == NULL) {
        return NULL;
    }

    sf->path = path;
    sf->file = fopen(path, mode);

    if (sf->file == NULL) {
        free(sf);
        return NULL;
    }

    return sf;
}

void safe_close(SafeFile* sf) {
    if (sf != NULL) {
        if (sf->file != NULL) {
            fclose(sf->file);
        }
        free(sf);
    }
}

int main() {
    SafeFile* sf = safe_open("data.txt", "w");

    if (sf != NULL) {
        fprintf(sf->file, "Hello, World!\n");
        safe_close(sf);
    } else {
        printf("Failed to open file\n");
    }

    return 0;
}
```

## Division by Zero Check

```c
#include <stdio.h>
#include <stdbool.h>

bool safe_divide(int a, int b, int* result) {
    if (b == 0) {
        return false;
    }

    *result = a / b;
    return true;
}

int main() {
    int a = 10, b = 0;
    int result;

    if (safe_divide(a, b, &result)) {
        printf("Result: %d\n", result);
    } else {
        printf("Division by zero prevented\n");
    }

    return 0;
}
```

## Array Size Passing

```c
#include <stdio.h>

void process_array(int* arr, size_t size) {
    for (size_t i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    process_array(numbers, size);

    return 0;
}
```

## Resource Acquisition

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    FILE* file;
    void* memory;
} Resources;

bool acquire_resources(Resources* res) {
    res->memory = malloc(100);
    if (res->memory == NULL) {
        return false;
    }

    res->file = fopen("data.txt", "w");
    if (res->file == NULL) {
        free(res->memory);
        return false;
    }

    return true;
}

void release_resources(Resources* res) {
    if (res->file != NULL) {
        fclose(res->file);
        res->file = NULL;
    }

    if (res->memory != NULL) {
        free(res->memory);
        res->memory = NULL;
    }
}

int main() {
    Resources res = {NULL, NULL};

    if (acquire_resources(&res)) {
        printf("Resources acquired\n");

        // Use resources...

        release_resources(&res);
        printf("Resources released\n");
    } else {
        printf("Failed to acquire resources\n");
    }

    return 0;
}
```

## Format String Safety

```c
#include <stdio.h>

void safe_print(const char* format, const char* input) {
    // Use %s to avoid format string vulnerabilities
    printf("%s: %s\n", format, input);
}

int main() {
    const char* user_input = "Hello";

    safe_print("User input", user_input);

    // Don't do this:
    // printf(user_input);  // Vulnerable if input contains %

    return 0;
}
```

## Assert Preconditions

```c
#include <stdio.h>
#include <assert.h>

void divide(int a, int b) {
    // Precondition: b must not be zero
    assert(b != 0);

    printf("Result: %d\n", a / b);
}

int main() {
    divide(10, 2);

    // This will trigger assertion
    // divide(10, 0);

    return 0;
}
```

## Use const Correctly

```c
#include <stdio.h>

void process_string(const char* str) {
    // str cannot be modified
    printf("String: %s\n", str);
}

int main() {
    char text[] = "Hello";

    process_string(text);

    return 0;
}
```

## Buffer Size Macros

```c
#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE(x) (sizeof(x) / sizeof((x)[0]))

void safe_sprintf(char* buffer, size_t buffer_size, const char* format, ...) {
    va_list args;
    va_start(args, format);

    vsnprintf(buffer, buffer_size - 1, format, args);
    buffer[buffer_size - 1] = '\0';

    va_end(args);
}

int main() {
    char buffer[256];
    int value = 42;

    safe_sprintf(buffer, BUFFER_SIZE(buffer), "Value: %d", value);
    printf("Buffer: %s\n", buffer);

    return 0;
}
```

## Use size_t for Sizes

```c
#include <stdio.h>
#include <string.h>

void print_size_info(const char* str) {
    size_t len = strlen(str);

    printf("String length: %zu\n", len);
    printf("Size with null terminator: %zu\n", len + 1);
}

int main() {
    const char* text = "Hello, World!";
    print_size_info(text);

    return 0;
}
```

> **Note**: Always validate inputs. Check bounds. Use `size_t` for sizes. Handle errors gracefully.
