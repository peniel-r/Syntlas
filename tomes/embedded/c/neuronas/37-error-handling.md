---
id: "c.error.errno"
title: "Error Handling (errno, perror, strerror)"
category: stdlib
difficulty: beginner
tags: [c, error, errno, perror, strerror, exceptions]
keywords: [errno, perror, strerror, error handling]
use_cases: [file operations, system calls, error reporting]
prerequisites: ["c.io"]
related: ["c.stdlib.exit"]
next_topics: ["c.stdlib.signal"]
---

# Error Handling

## errno - Error Code

```c
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE* file = fopen("nonexistent.txt", "r");

    if (file == NULL) {
        printf("Error code: %d\n", errno);
        printf("Error: %s\n", strerror(errno));
        return 1;
    }

    fclose(file);
    return 0;
}
```

## perror - Print Error

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE* file = fopen("nonexistent.txt", "r");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fclose(file);
    return 0;
}
```

## strerror - Error String

```c
#include <stdio.h>
#include <errno.h>
#include <string.h>

void print_error(const char* message) {
    fprintf(stderr, "%s: %s\n", message, strerror(errno));
}

int main() {
    int* ptr = malloc(SIZE_MAX);

    if (ptr == NULL) {
        print_error("Memory allocation failed");
        return 1;
    }

    free(ptr);
    return 0;
}
```

## Common Error Codes

```c
#include <stdio.h>
#include <errno.h>

void print_errno_info(int err) {
    switch (err) {
        case EPERM:
            printf("Operation not permitted\n");
            break;
        case ENOENT:
            printf("No such file or directory\n");
            break;
        case EACCES:
            printf("Permission denied\n");
            break;
        case EEXIST:
            printf("File exists\n");
            break;
        case ENOMEM:
            printf("Out of memory\n");
            break;
        default:
            printf("Error code: %d\n", err);
    }
}

int main() {
    print_errno_info(ENOENT);
    print_errno_info(EACCES);
    print_errno_info(ENOMEM);

    return 0;
}
```

## Error Checking Wrapper

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

FILE* safe_fopen(const char* filename, const char* mode) {
    errno = 0;
    FILE* file = fopen(filename, mode);

    if (file == NULL) {
        fprintf(stderr, "Failed to open %s: %s\n",
                filename, strerror(errno));
    }

    return file;
}

int main() {
    FILE* file = safe_fopen("test.txt", "r");

    if (file == NULL) {
        return 1;
    }

    fclose(file);
    return 0;
}
```

## Retry on Error

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>

FILE* open_with_retry(const char* filename, int retries) {
    FILE* file = NULL;

    for (int i = 0; i < retries; i++) {
        file = fopen(filename, "r");
        if (file != NULL) {
            return file;
        }

        if (errno != EINTR) {
            break;
        }

        sleep(1);
    }

    return NULL;
}

int main() {
    FILE* file = open_with_retry("data.txt", 3);

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fclose(file);
    return 0;
}
```

## Custom Error Messages

```c
#include <stdio.h>
#include <errno.h>

void handle_file_error(const char* filename) {
    switch (errno) {
        case ENOENT:
            fprintf(stderr, "File not found: %s\n", filename);
            break;
        case EACCES:
            fprintf(stderr, "Permission denied: %s\n", filename);
            break;
        case EISDIR:
            fprintf(stderr, "Is a directory: %s\n", filename);
            break;
        default:
            fprintf(stderr, "Error opening %s: %s\n",
                    filename, strerror(errno));
    }
}

int main() {
    FILE* file = fopen("nonexistent.txt", "r");

    if (file == NULL) {
        handle_file_error("nonexistent.txt");
        return 1;
    }

    fclose(file);
    return 0;
}
```

## Error with Context

```c
#include <stdio.h>
#include <errno.h>

typedef struct {
    int code;
    const char* message;
    const char* file;
    int line;
} Error;

Error make_error(int code, const char* message, const char* file, int line) {
    Error err = {code, message, file, line};
    return err;
}

void print_error(const Error* err) {
    fprintf(stderr, "Error %d at %s:%d: %s\n",
            err->code, err->file, err->line, err->message);
}

int main() {
    FILE* file = fopen("test.txt", "r");

    if (file == NULL) {
        Error err = make_error(errno, "Failed to open file", __FILE__, __LINE__);
        print_error(&err);
        return 1;
    }

    fclose(file);
    return 0;
}
```

## Signal Interruption

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

void safe_write(FILE* file, const void* data, size_t size) {
    size_t written = fwrite(data, 1, size, file);

    if (written < size) {
        if (ferror(file)) {
            if (errno == EINTR) {
                printf("Write interrupted, retrying...\n");
                // Retry logic here
            } else {
                perror("Write failed");
            }
        }
    }
}

int main() {
    FILE* file = fopen("data.txt", "w");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    const char* text = "Hello, World!";
    safe_write(file, text, strlen(text));

    fclose(file);
    return 0;
}
```

## Memory Error Handling

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

void* safe_malloc(size_t size) {
    void* ptr = malloc(size);

    if (ptr == NULL) {
        fprintf(stderr, "Memory allocation failed: %s\n",
                strerror(errno));
        exit(EXIT_FAILURE);
    }

    return ptr;
}

int main() {
    int* array = safe_malloc(10 * sizeof(int));

    for (int i = 0; i < 10; i++) {
        array[i] = i;
    }

    free(array);
    return 0;
}
```

## Error Logger

```c
#include <stdio.h>
#include <time.h>
#include <errno.h>

void log_error(const char* message) {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    char time_str[64];
    strftime(time_str, sizeof(time_str), "%Y-%m-%d %H:%M:%S", local);

    fprintf(stderr, "[%s] ERROR: %s (%d: %s)\n",
            time_str, message, errno, strerror(errno));
}

int main() {
    FILE* file = fopen("nonexistent.txt", "r");

    if (file == NULL) {
        log_error("Failed to open file");
        return 1;
    }

    fclose(file);
    return 0;
}
```

## Error Stack

```c
#include <stdio.h>
#include <string.h>

#define MAX_ERRORS 10

typedef struct {
    char messages[MAX_ERRORS][256];
    int count;
} ErrorStack;

void error_stack_push(ErrorStack* stack, const char* message) {
    if (stack->count < MAX_ERRORS) {
        strncpy(stack->messages[stack->count], message, 255);
        stack->messages[stack->count][255] = '\0';
        stack->count++;
    }
}

void error_stack_print(const ErrorStack* stack) {
    for (int i = 0; i < stack->count; i++) {
        fprintf(stderr, "Error %d: %s\n", i + 1, stack->messages[i]);
    }
}

int main() {
    ErrorStack stack = {0};

    error_stack_push(&stack, "Step 1 failed");
    error_stack_push(&stack, "Step 2 failed");

    error_stack_print(&stack);

    return 0;
}
```

## Error Recovery

```c
#include <stdio.h>
#include <errno.h>

int process_file(const char* filename) {
    FILE* file = fopen(filename, "r");

    if (file == NULL) {
        switch (errno) {
            case ENOENT:
                printf("File doesn't exist, creating...\n");
                file = fopen(filename, "w");
                break;
            case EACCES:
                printf("Permission denied\n");
                return -1;
            default:
                perror("Failed to open file");
                return -1;
        }
    }

    if (file != NULL) {
        fclose(file);
        return 0;
    }

    return -1;
}

int main() {
    int result = process_file("data.txt");

    if (result == 0) {
        printf("Success\n");
    } else {
        printf("Failed\n");
    }

    return 0;
}
```

## Try-Catch Pattern

```c
#include <stdio.h>
#include <setjmp.h>

jmp_buf try_buffer;

int try(void) {
    return setjmp(try_buffer);
}

void throw(int value) {
    longjmp(try_buffer, value);
}

int main() {
    int result = try();

    if (result == 0) {
        printf("In try block\n");

        // Simulate error
        if (1) {
            throw(1);
        }

        printf("This won't execute\n");
    } else {
        printf("Caught error: %d\n", result);
    }

    return 0;
}
```

> **Warning**: `errno` is thread-local but may be modified by library functions. Save it immediately after an error if needed.
