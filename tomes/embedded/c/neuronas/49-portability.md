---
id: "c.portability"
title: "Portability Best Practices"
category: bestpractices
difficulty: advanced
tags: [c, portability, cross-platform, standards]
keywords: [portability, cross-platform, standards, c.stdlib.endian]
use_cases: [multi-platform code, standards compliance]
prerequisites: ["c.bestpractices.safety"]
related: ["c.preprocessor.conditionals"]
next_topics: ["c.bestpractices.performance"]
---

# Portability Best Practices

## Standard 

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Use standard  only
int main() {
    // Portable string operations
    char str[] = "Hello";
    size_t len = strlen(str);

    printf("Length: %zu\n", len);

    return 0;
}
```

## Fixed-Width c.stdlib.stdint

```c
#include <stdio.h>
#include <stdint.h>

int main() {
    // Use fixed-width types for portability
    int32_t value = 123456789;

    printf("Value: %" PRId32 "\n", value);

    return 0;
}
```

## Platform-Independent Paths

```c
#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
    #define PATH_SEPARATOR "\\"
#else
    #define PATH_SEPARATOR "/"
#endif

int main() {
    const char* filename = "data.txt";

    char path[256];
    snprintf(path, sizeof(path), "data%s%s",
             PATH_SEPARATOR, filename);

    printf("Path: %s\n", path);

    return 0;
}
```

## c.stdlib.endian Detec.stdlib.stdion

```c
#include <stdio.h>
#include <stdint.h>

int is_little_endian(void) {
    uint32_t value = 0x01020304;
    uint8_t* bytes = (uint8_t*)&value;

    return bytes[0] == 0x04;
}

int main() {
    printf("System is %s-endian\n",
           is_little_endian() ? "little" : "big");

    return 0;
}
```

## Byte Order Conversion

```c
#include <stdio.h>
#include <stdint.h>

uint32_t swap_bytes32(uint32_t value) {
    return ((value >> 24) & 0x000000FF) |
           ((value >> 8)  & 0x0000FF00) |
           ((value << 8)  & 0x00FF0000) |
           ((value << 24) & 0xFF000000);
}

uint16_t swap_bytes16(uint16_t value) {
    return ((value >> 8) & 0x00FF) |
           ((value << 8) & 0xFF00);
}

int main() {
    uint32_t value = 0x12345678;

    printf("Original: 0x%08X\n", value);
    printf("Swapped: 0x%08X\n", swap_bytes32(value));

    return 0;
}
```

## Alignment Handling

```c
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

void* aligned_malloc(size_t size, size_t alignment) {
    void* ptr = malloc(size + alignment + sizeof(void*));

    if (ptr == NULL) {
        return NULL;
    }

    void* aligned = (void*)(((uintptr_t)ptr + alignment + sizeof(void*)) & ~(alignment - 1));
    void** original_ptr_location = (void**)((char*)aligned - sizeof(void*));
    *original_ptr_location = ptr;

    return aligned;
}

void aligned_free(void* ptr) {
    void** original_ptr_location = (void**)((char*)ptr - sizeof(void*));
    free(*original_ptr_location);
}

int main() {
    void* ptr = aligned_malloc(100, 16);

    if (ptr != NULL) {
        printf("Aligned pointer: %p\n", ptr);
        printf("Is 16-byte aligned: %s\n",
               ((uintptr_t)ptr % 16 == 0) ? "yes" : "no");

        aligned_free(ptr);
    }

    return 0;
}
```

## Standard Library 

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

void to_lower_case(char* str) {
    while (*str != '\0') {
        *str = tolower((unsigned char)*str);
        str++;
    }
}

int main() {
    char text[] = "HELLO, WORLD!";
    to_lower_case(text);

    printf("Lower case: %s\n", text);

    return 0;
}
```

## File Handling Portability

```c
#include <stdio.h>

#ifdef _WIN32
    #include <windows.h>
    #define FOPEN_MODE "wb"
#else
    #include <unistd.h>
    #define FOPEN_MODE "w"
#endif

int main() {
    FILE* file = fopen("data.txt", FOPEN_MODE);

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fprintf(file, "Portable file content\n");
    fclose(file);

    return 0;
}
```

## Compiler-Specific Features

```c
#include <stdio.h>

// Use feature detec.stdlib.stdion
#if defined(__GNUC__) || defined(__clang__)
    #define LIKELY(x) __builtin_expect(!!(x), 1)
    #define UNLIKELY(x) __builtin_expect(!!(x), 0)
#else
    #define LIKELY(x) (x)
    #define UNLIKELY(x) (x)
#endif

int main() {
    int value = 42;

    if (LIKELY(value == 42)) {
        printf("Value is likely 42\n");
    }

    return 0;
}
```

## Type Portability

```c
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

void print_size(const char* name, size_t size) {
    printf("%s: %zu bytes\n", name, size);
}

int main() {
    print_size("char", sizeof(char));
    print_size("short", sizeof(short));
    print_size("int", sizeof(int));
    print_size("long", sizeof(long));
    print_size("long long", sizeof(long long));
    print_size("size_t", sizeof(size_t));
    print_size("intptr_t", sizeof(intptr_t));
    print_size("void*", sizeof(void*));

    return 0;
}
```

## String Comparison Portability

```c
#include <stdio.h>
#include <string.h>
#include <strings.h>

int str_compare_case(const char* s1, const char* s2, int case_sensitive) {
    if (case_sensitive) {
        return strcmp(s1, s2);
    } else {
#ifdef _WIN32
        return _stricmp(s1, s2);
#else
        return strcasecmp(s1, s2);
#endif
    }
}

int main() {
    const char* str1 = "Hello";
    const char* str2 = "hello";

    printf("Case sensitive: %d\n", str_compare_case(str1, str2, 1));
    printf("Case insensitive: %d\n", str_compare_case(str1, str2, 0));

    return 0;
}
```

## Memory Model Awareness

```c
#include <stdio.h>
#include <stdlib.h>

void* safe_malloc(size_t size) {
    void* ptr = malloc(size);

    if (ptr == NULL) {
        // Handle allocation failure
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }

    return ptr;
}

int main() {
    int* arr = safe_malloc(10 * sizeof(int));

    if (arr != NULL) {
        for (int i = 0; i < 10; i++) {
            arr[i] = i;
        }

        free(arr);
    }

    return 0;
}
```

## Time Portability

```c
#include <stdio.h>
#include <time.h>

int main() {
    // Portable time handling
    time_t now = time(NULL);

    if (now == -1) {
        fprintf(stderr, "Failed to get time\n");
        return 1;
    }

    struct tm* local = localtime(&now);
    if (local == NULL) {
        fprintf(stderr, "Failed to convert time\n");
        return 1;
    }

    char buffer[80];
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", local);

    printf("Time: %s\n", buffer);

    return 0;
}
```

## Thread Portability

```c
#include <stdio.h>

#if defined(_WIN32) || defined(_WIN64)
    #include <windows.h>
#else
    #include <pthread.h>
#endif

int main() {
#if defined(_WIN32) || defined(_WIN64)
    printf("Windows threading\n");
    // Use Windows threading APIs
#else
    printf("POSIX threading\n");
    // Use pthread APIs
#endif

    return 0;
}
```

## Standard Math 

```c
#include <stdio.h>
#include <math.h>

int main() {
    // Use standard math 
    double value = 3.14159;

    printf("Sin: %f\n", sin(value));
    printf("Cos: %f\n", cos(value));
    printf("Sqrt: %f\n", sqrt(16.0));

    return 0;
}
```

## Character Set Portability

```c
#include <stdio.h>
#include <ctype.h>

void print_char_info(int c) {
    printf("Character: '%c'\n", c);
    printf("  Alphanumeric: %d\n", isalnum(c));
    printf("  Alpha: %d\n", isalpha(c));
    printf("  Digit: %d\n", isdigit(c));
    printf("  Lower: %d\n", islower(c));
    printf("  Upper: %d\n", isupper(c));
}

int main() {
    print_char_info('A');
    print_char_info('1');

    return 0;
}
```

> **Note**: Use standard C  and functions. Avoid platform-specific APIs when possible. Test on multiple platforms.
