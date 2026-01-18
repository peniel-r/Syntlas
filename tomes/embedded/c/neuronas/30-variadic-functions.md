---
id: "c.stdlib.stdarg"
title: "Variable Arguments (va_list, va_start, va_end)"
category: stdlib
difficulty: intermediate
tags: [c, stdarg, variadic, va_list, printf]
keywords: [va_list, va_start, va_arg, va_end, variadic]
use_cases: [custom printf, , flexible ]
prerequisites: ["c.functions"]
related: ["c.stdlib.stdio"]
next_topics: ["c.stdlib.stdbool"]
---

# Variable Arguments

## Basic Variadic Function

```c
#include <stdio.h>
#include <stdarg.h>

int sum(int count, ...) {
    va_list args;
    va_start(args, count);

    int total = 0;
    for (int i = 0; i < count; i++) {
        total += va_arg(args, int);
    }

    va_end(args);
    return total;
}

int main() {
    printf("Sum of 1+2+3 = %d\n", sum(3, 1, 2, 3));
    printf("Sum of 5+10+15+20 = %d\n", sum(4, 5, 10, 15, 20));

    return 0;
}
```

## Custom printf

```c
#include <stdio.h>
#include <stdarg.h>

void my_printf(const char* format, ...) {
    va_list args;
    va_start(args, format);

    vprintf(format, args);

    va_end(args);
}

int main() {
    my_printf("Hello %s! Number: %d\n", "World", 42);

    return 0;
}
```

##  Function

```c
#include <stdio.h>
#include <stdarg.h>
#include <time.h>

void log_message(const char* level, const char* format, ...) {
    // Get current time
    time_t now = time(NULL);
    char time_str[64];
    strftime(time_str, sizeof(time_str), "%Y-%m-%d %H:%M:%S", localtime(&now));

    // Print timestamp and level
    printf("[%s] [%s] ", time_str, level);

    // Print formatted message
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);

    printf("\n");
}

int main() {
    log_message("INFO", "Application started");
    log_message("ERROR", "Failed to open file: %s", "data.txt");
    log_message("DEBUG", "Variable value: %d", 42);

    return 0;
}
```

## Mixed Types

```c
#include <stdio.h>
#include <stdarg.h>

void print_mixed(int count, ...) {
    va_list args;
    va_start(args, count);

    for (int i = 0; i < count; i++) {
        int type = va_arg(args, int);

        switch (type) {
            case 0:
                printf("Int: %d\n", va_arg(args, int));
                break;
            case 1:
                printf("Double: %f\n", va_arg(args, double));
                break;
            case 2:
                printf("String: %s\n", va_arg(args, char*));
                break;
        }
    }

    va_end(args);
}

int main() {
    print_mixed(3,
        0, 42,
        1, 3.14,
        2, "Hello"
    );

    return 0;
}
```

## String Builder

```c
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

char* build_string(const char* format, ...) {
    va_list args1, args2;
    va_start(args1, format);
    va_copy(args2, args1);

    // Calculate required length
    int len = vsnprintf(NULL, 0, format, args1);
    va_end(args1);

    // Allocate buffer
    char* result = malloc(len + 1);
    if (result == NULL) {
        va_end(args2);
        return NULL;
    }

    // Format string
    vsnprintf(result, len + 1, format, args2);
    va_end(args2);

    return result;
}

int main() {
    char* str = build_string("Hello %s! Age: %d", "Alice", 30);
    if (str != NULL) {
        printf("%s\n", str);
        free(str);
    }

    return 0;
}
```

## Max Function

```c
#include <stdio.h>
#include <stdarg.h>

int max(int count, ...) {
    if (count <= 0) return 0;

    va_list args;
    va_start(args, count);

    int maximum = va_arg(args, int);

    for (int i = 1; i < count; i++) {
        int value = va_arg(args, int);
        if (value > maximum) {
            maximum = value;
        }
    }

    va_end(args);
    return maximum;
}

int main() {
    printf("Max of 5, 3, 9, 2 = %d\n", max(4, 5, 3, 9, 2));
    printf("Max of 1, 10, 5 = %d\n", max(3, 1, 10, 5));

    return 0;
}
```

## Average Function

```c
#include <stdio.h>
#include <stdarg.h>

double average(int count, ...) {
    if (count <= 0) return 0.0;

    va_list args;
    va_start(args, count);

    double sum = 0.0;
    for (int i = 0; i < count; i++) {
        sum += va_arg(args, double);
    }

    va_end(args);
    return sum / count;
}

int main() {
    printf("Average: %.2f\n", average(3, 1.0, 2.0, 3.0));
    printf("Average: %.2f\n", average(5, 10.0, 20.0, 30.0, 40.0, 50.0));

    return 0;
}
```

## Error Reporting

```c
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

void error_exit(const char* format, ...) {
    va_list args;
    va_start(args, format);

    fprintf(stderr, "ERROR: ");
    vfprintf(stderr, format, args);
    fprintf(stderr, "\n");

    va_end(args);
    exit(EXIT_FAILURE);
}

int main() {
    int value = -1;

    if (value < 0) {
        error_exit("Invalid value: %d", value);
    }

    return 0;
}
```

## Format String with Prefix

```c
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

void format_with_prefix(const char* prefix, const char* format, ...) {
    printf("%s: ", prefix);

    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);

    printf("\n");
}

int main() {
    format_with_prefix("INFO", "Server started on port %d", 8080);
    format_with_prefix("WARN", "Memory usage: %d%%", 85);

    return 0;
}
```

## Count Matches

```c
#include <stdio.h>
#include <stdarg.h>
#include <stdbool.h>

int count_matches(int count, int target, ...) {
    va_list args;
    va_start(args, count);

    int matches = 0;
    for (int i = 0; i < count; i++) {
        if (va_arg(args, int) == target) {
            matches++;
        }
    }

    va_end(args);
    return matches;
}

int main() {
    int result = count_matches(6, 5, 1, 5, 3, 5, 2, 5);
    printf("Number of 5s: %d\n", result);  // 3

    return 0;
}
```

## Array Builder

```c
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

int* build_array(int count, ...) {
    int* array = malloc(count * sizeof(int));
    if (array == NULL) return NULL;

    va_list args;
    va_start(args, count);

    for (int i = 0; i < count; i++) {
        array[i] = va_arg(args, int);
    }

    va_end(args);
    return array;
}

int main() {
    int* arr = build_array(5, 10, 20, 30, 40, 50);
    if (arr != NULL) {
        printf("Array: ");
        for (int i = 0; i < 5; i++) {
            printf("%d ", arr[i]);
        }
        printf("\n");

        free(arr);
    }

    return 0;
}
```

## String Concatenation

```c
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

char* concatenate_strings(int count, ...) {
    va_list args;
    va_start(args, count);

    // Calculate total length
    size_t total_len = 0;
    for (int i = 0; i < count; i++) {
        const char* str = va_arg(args, const char*);
        total_len += strlen(str);
    }

    va_end(args);

    // Allocate buffer
    char* result = malloc(total_len + 1);
    if (result == NULL) return NULL;

    // Concatenate strings
    va_start(args, count);
    size_t pos = 0;
    for (int i = 0; i < count; i++) {
        const char* str = va_arg(args, const char*);
        size_t len = strlen(str);
        strcpy(result + pos, str);
        pos += len;
    }
    result[pos] = '\0';

    va_end(args);
    return result;
}

int main() {
    char* combined = concatenate_strings(4, "Hello", " ", "World", "!");
    if (combined != NULL) {
        printf("Combined: %s\n", combined);
        free(combined);
    }

    return 0;
}
```

## Debug Print

```c
#include <stdio.h>
#include <stdarg.h>
#include <stdbool.h>

static bool debug_enabled = false;

void set_debug(bool enabled) {
    debug_enabled = enabled;
}

void debug_print(const char* format, ...) {
    if (!debug_enabled) return;

    va_list args;
    va_start(args, format);

    printf("[DEBUG] ");
    vprintf(format, args);
    printf("\n");

    va_end(args);
}

int main() {
    debug_print("This won't print");

    set_debug(true);
    debug_print("This will print: value = %d", 42);

    return 0;
}
```

> **Note**: Always call `va_end` after `va_start`. Use `va_copy` if you need to iterate arguments multiple times.
