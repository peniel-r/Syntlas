---
id: "c.stdlib.stddef"
title: "Standard Definitions (size_t, ptrdiff_t, NULL)"
category: stdlib
difficulty: beginner
tags: [c, stddef, size_t, ptrdiff_t, offsetof, null]
keywords: [size_t, ptrdiff_t, offsetof, NULL, max_align_t]
use_cases: [portability, memory sizes, pointer arithmetic]
prerequisites: []
related: ["c.stdlib.stdint"]
next_topics: ["c.stdlib.stdbool"]
---

# Standard Definitions

## size_t - Size Type

```c
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // Size of types
    printf("sizeof(int) = %zu\n", sizeof(int));
    printf("sizeof(double) = %zu\n", sizeof(double));
    printf("sizeof(void*) = %zu\n", sizeof(void*));

    // String length returns size_t
    const char* str = "Hello";
    size_t len = strlen(str);
    printf("String length: %zu\n", len);

    // Memory allocation
    void* ptr = malloc(10 * sizeof(int));
    if (ptr != NULL) {
        printf("Allocated %zu bytes\n", 10 * sizeof(int));
        free(ptr);
    }

    return 0;
}
```

## ptrdiff_t - Pointer Difference

```c
#include <stdio.h>
#include <stddef.h>

int main() {
    int arr[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

    int* p1 = &arr[2];
    int* p2 = &arr[7];

    ptrdiff_t diff = p2 - p1;
    printf("Difference: %td\n", diff);  // 5

    return 0;
}
```

## NULL - Null Pointer

```c
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>

int main() {
    int* ptr = NULL;

    if (ptr == NULL) {
        printf("Pointer is NULL\n");
    }

    // Allocate and check
    int* allocated = malloc(sizeof(int));
    if (allocated != NULL) {
        printf("Allocation successful\n");
        free(allocated);
    }

    return 0;
}
```

## offsetof - Member Offset

```c
#include <stdio.h>
#include <stddef.h>

typedef struct {
    char   c;
    int    i;
    double d;
    char   arr[10];
} MyStruct;

int main() {
    printf("Offset of c: %zu\n", offsetof(MyStruct, c));
    printf("Offset of i: %zu\n", offsetof(MyStruct, i));
    printf("Offset of d: %zu\n", offsetof(MyStruct, d));
    printf("Offset of arr: %zu\n", offsetof(MyStruct, arr));

    return 0;
}
```

## max_align_t - Maximum Alignment

```c
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>

int main() {
    printf("Alignment of max_align_t: %zu\n", alignof(max_align_t));

    // Allocate with maximum alignment
    void* ptr = aligned_alloc(alignof(max_align_t), 64);

    if (ptr != NULL) {
        printf("Address aligned: %p\n", ptr);
        free(ptr);
    }

    return 0;
}
```

## Portable Memory Copy

```c
#include <stdio.h>
#include <stddef.h>
#include <string.h>

void safe_memcpy(void* dest, const void* src, size_t n) {
    if (dest == NULL || src == NULL) {
        return;
    }
    memcpy(dest, src, n);
}

int main() {
    int src[] = {1, 2, 3, 4, 5};
    int dest[5];

    safe_memcpy(dest, src, sizeof(src));

    for (size_t i = 0; i < 5; i++) {
        printf("%d ", dest[i]);
    }
    printf("\n");

    return 0;
}
```

## Array Size Macro

```c
#include <stdio.h>
#include <stddef.h>

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    const char* words[] = {"apple", "banana", "cherry"};

    printf("Array size: %zu\n", ARRAY_SIZE(numbers));
    printf("Words count: %zu\n", ARRAY_SIZE(words));

    return 0;
}
```

## Safe String Copy

```c
#include <stdio.h>
#include <stddef.h>
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
    const char* long_str = "This is a very long string";

    safe_strcpy(buffer, long_str, sizeof(buffer));
    printf("Buffer: %s\n", buffer);

    return 0;
}
```

## Pointer Arithmetic Safety

```c
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>

int* safe_advance(int* ptr, ptrdiff_t offset, size_t size) {
    // Check if offset would go out of bounds
    if (offset < 0 || offset >= (ptrdiff_t)size) {
        return NULL;
    }
    return ptr + offset;
}

int main() {
    int arr[] = {10, 20, 30, 40, 50};
    size_t size = sizeof(arr) / sizeof(arr[0]);

    int* result = safe_advance(arr, 2, size);
    if (result != NULL) {
        printf("Element: %d\n", *result);  // 30
    }

    result = safe_advance(arr, 10, size);
    if (result == NULL) {
        printf("Out of bounds\n");
    }

    return 0;
}
```

## Memory Pool with size_t

```c
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    void* data;
    size_t size;
    size_t capacity;
} Buffer;

Buffer* buffer_create(size_t initial_capacity) {
    Buffer* buf = malloc(sizeof(Buffer));
    if (buf == NULL) return NULL;

    buf->data = malloc(initial_capacity);
    if (buf->data == NULL) {
        free(buf);
        return NULL;
    }

    buf->size = 0;
    buf->capacity = initial_capacity;

    return buf;
}

void buffer_append(Buffer* buf, const void* data, size_t len) {
    if (buf == NULL || data == NULL) return;

    if (buf->size + len > buf->capacity) {
        size_t new_capacity = buf->capacity * 2;
        void* new_data = realloc(buf->data, new_capacity);
        if (new_data == NULL) return;

        buf->data = new_data;
        buf->capacity = new_capacity;
    }

    memcpy((char*)buf->data + buf->size, data, len);
    buf->size += len;
}

void buffer_destroy(Buffer* buf) {
    if (buf != NULL) {
        free(buf->data);
        free(buf);
    }
}

int main() {
    Buffer* buf = buffer_create(16);
    if (buf == NULL) return 1;

    const char* text = "Hello, World!";
    buffer_append(buf, text, strlen(text));

    printf("Buffer: %.*s\n", (int)buf->size, (char*)buf->data);

    buffer_destroy(buf);

    return 0;
}
```

## Container of Pattern

```c
#include <stdio.h>
#include <stddef.h>

typedef struct {
    int x, y;
} Point;

typedef struct {
    Point a, b;
} Line;

Line* get_line_from_point_a(Point* p) {
    return (Line*)((char*)p - offsetof(Line, a));
}

int main() {
    Line line = {
        .a = {1, 2},
        .b = {3, 4}
    };

    Point* pa = &line.a;
    Line* parent = get_line_from_point_a(pa);

    printf("Line: (%d,%d) to (%d,%d)\n",
           parent->a.x, parent->a.y,
           parent->b.x, parent->b.y);

    return 0;
}
```

## Type Safety Macros

```c
#include <stdio.h>
#include <stddef.h>

#define MIN(a, b) ({ \
    __typeof__(a) _a = (a); \
    __typeof__(b) _b = (b); \
    _a < _b ? _a : _b; \
})

#define MAX(a, b) ({ \
    __typeof__(a) _a = (a); \
    __typeof__(b) _b = (b); \
    _a > _b ? _a : _b; \
})

#define CLAMP(x, lo, hi) ({ \
    __typeof__(x) _x = (x); \
    __typeof__(lo) _lo = (lo); \
    __typeof__(hi) _hi = (hi); \
    _x < _lo ? _lo : (_x > _hi ? _hi : _x); \
})

int main() {
    int a = 10, b = 20;
    printf("MIN(%d, %d) = %d\n", a, b, MIN(a, b));
    printf("MAX(%d, %d) = %d\n", a, b, MAX(a, b));

    double x = 15.5;
    printf("CLAMP(%.1f, 5, 10) = %.1f\n", x, CLAMP(x, 5.0, 10.0));

    return 0;
}
```

## Loop Macro

```c
#include <stdio.h>
#include <stddef.h>

#define FOR_EACH(i, arr) \
    for (size_t i = 0; i < ARRAY_SIZE(arr); i++)

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

int main() {
    int numbers[] = {1, 2, 3, 4, 5};

    FOR_EACH(i, numbers) {
        printf("numbers[%zu] = %d\n", i, numbers[i]);
    }

    return 0;
}
```

## Byte Operations

```c
#include <stdio.h>
#include <stddef.h>

typedef unsigned char byte;

void print_bytes(const void* data, size_t size) {
    const byte* bytes = (const byte*)data;

    for (size_t i = 0; i < size; i++) {
        printf("%02x ", bytes[i]);
        if ((i + 1) % 16 == 0) printf("\n");
    }
    printf("\n");
}

int main() {
    int value = 0x12345678;
    print_bytes(&value, sizeof(value));

    return 0;
}
```

> **Note**: `size_t` is unsigned, so avoid subtracting that could result in negative values. Use `ptrdiff_t` for signed pointer differences.
