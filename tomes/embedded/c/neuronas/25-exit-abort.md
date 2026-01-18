---
id: "c.stdlib.exit"
title: "Program Termination (exit, abort, atexit)"
category: stdlib
difficulty: beginner
tags: [c, stdlib, exit, abort, termination, cleanup]
keywords: [exit, abort, atexit, quick_exit, _Exit]
use_cases: [error handling, cleanup, program termination]
prerequisites: ["c.functions"]
related: ["c.error.errno"]
next_topics: ["c.stdlib.signal"]
---

# Program Termination

## exit - Normal Termination

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("Starting program\n");

    // Exit with success code
    exit(EXIT_SUCCESS);

    printf("This will not execute\n");

    return 0;
}
```

## exit with Error Code

```c
#include <stdio.h>
#include <stdlib.h>

void process_file(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        fprintf(stderr, "Error: Cannot open file %s\n", filename);
        exit(EXIT_FAILURE);
    }

    // Process file...
    fclose(file);
}

int main() {
    process_file("nonexistent.txt");
    return 0;
}
```

## abort - Abnormal Termination

```c
#include <stdio.h>
#include <stdlib.h>

void critical_error(void) {
    fprintf(stderr, "Critical error occurred!\n");

    // Abnormal termination, dumps core (if enabled)
    abort();

    printf("This will not execute\n");
}

int main() {
    critical_error();
    return 0;
}
```

## atexit - Cleanup Functions

```c
#include <stdio.h>
#include <stdlib.h>

void cleanup1(void) {
    printf("Cleanup function 1\n");
}

void cleanup2(void) {
    printf("Cleanup function 2\n");
}

int main() {
    // Register cleanup functions
    atexit(cleanup1);
    atexit(cleanup2);

    printf("Main function\n");

    return 0;
    // Output:
    // Main function
    // Cleanup function 2 (LIFO order)
    // Cleanup function 1
}
```

## atexit with Resources

```c
#include <stdio.h>
#include <stdlib.h>

FILE* global_file = NULL;

void close_file(void) {
    if (global_file != NULL) {
        fclose(global_file);
        printf("File closed\n");
    }
}

int main() {
    global_file = fopen("data.txt", "w");

    if (global_file == NULL) {
        exit(EXIT_FAILURE);
    }

    // Register cleanup
    atexit(close_file);

    // Use file...
    fprintf(global_file, "Hello, World!\n");

    // File will be automatically closed on exit
    return 0;
}
```

## quick_exit - Fast Termination

```c
#include <stdio.h>
#include <stdlib.h>

void fast_cleanup(void) {
    printf("Fast cleanup\n");
}

int main() {
    at_quick_exit(fast_cleanup);

    printf("Before quick_exit\n");

    // Terminates without calling atexit handlers
    quick_exit(EXIT_SUCCESS);

    printf("This will not execute\n");

    return 0;
}
```

## _Exit - Immediate Termination

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("Before _Exit\n");

    // Immediate termination, no cleanup
    _Exit(EXIT_SUCCESS);

    printf("This will not execute\n");

    return 0;
}
```

## Multiple atexit Handlers

```c
#include <stdio.h>
#include <stdlib.h>

void handler1(void) {
    printf("Handler 1\n");
}

void handler2(void) {
    printf("Handler 2\n");
}

void handler3(void) {
    printf("Handler 3\n");
}

int main() {
    atexit(handler1);
    atexit(handler2);
    atexit(handler3);

    printf("Main\n");

    return 0;
    // Output:
    // Main
    // Handler 3 (last registered)
    // Handler 2
    // Handler 1 (first registered)
}
```

## Exit Status Codes

```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <status>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int status = atoi(argv[1]);

    // Custom status codes
    if (status == 0) {
        printf("Success\n");
        return EXIT_SUCCESS;
    } else {
        printf("Failure\n");
        return EXIT_FAILURE;
    }
}
```

## Conditional Exit

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

bool validate_input(int value) {
    if (value < 0 || value > 100) {
        fprintf(stderr, "Error: Value must be 0-100\n");
        return false;
    }
    return true;
}

int main() {
    int input;

    printf("Enter a value (0-100): ");
    scanf("%d", &input);

    if (!validate_input(input)) {
        exit(EXIT_FAILURE);
    }

    printf("Processing: %d\n", input);

    return EXIT_SUCCESS;
}
```

## Exit with Message

```c
#include <stdio.h>
#include <stdlib.h>

void die(const char* message) {
    fprintf(stderr, "Error: %s\n", message);
    exit(EXIT_FAILURE);
}

int main() {
    int* ptr = malloc(sizeof(int) * 10);

    if (ptr == NULL) {
        die("Memory allocation failed");
    }

    // Use allocated memory
    free(ptr);

    return EXIT_SUCCESS;
}
```

## Exit Handler with Context

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char name[50];
    int value;
} Context;

static Context* global_context = NULL;

void cleanup_context(void) {
    if (global_context != NULL) {
        printf("Cleaning up context: %s\n", global_context->name);
        free(global_context);
        global_context = NULL;
    }
}

int main() {
    global_context = malloc(sizeof(Context));
    if (global_context == NULL) {
        exit(EXIT_FAILURE);
    }

    strcpy(global_context->name, "MyContext");
    global_context->value = 42;

    atexit(cleanup_context);

    printf("Using context: %s\n", global_context->name);

    return EXIT_SUCCESS;
}
```

> **Note**: `atexit` handlers are called in reverse order (LIFO). `_Exit` and `quick_exit` don't call `atexit` handlers.
