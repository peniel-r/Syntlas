---
id: "c.stdlib.exit_advanced"
title: Exit and Termination 
category: stdlib
difficulty: intermediate
tags:
  - exit
  - _exit
  - atexit
  - quick_exit
  - abort
keywords:
  - program termination
  - exit handlers
  - cleanup 
  - abort
  - atexit
use_cases:
  - Clean program shutdown
  - Resource cleanup before exit
  - Emergency program termination
  - Running cleanup code on exit
prerequisites:
  - c.functions
  - 
related:
  - 
  - 
next_topics:
  - c.cli.parsing
---

# Exit and Termination 

C provides multiple  for terminating a program with different behaviors and cleanup options.

## Standard Exit 

### exit() - Normal Program Termination

```c
#include <stdlib.h>
#include <stdio.h>

void cleanup_resources(void) {
    printf("Cleaning up resources...\n");
}

int main(void) {
    // Register cleanup function
    atexit(cleanup_resources);

    printf("Program running...\n");

    // Normal exit (calls atexit , flushes buffers)
    // EXIT_SUCCESS (0) or EXIT_FAILURE (1)
    exit(EXIT_SUCCESS);
}
```

### _exit() - Immediate Termination

```c
#include <stdlib.h>
#include <unistd.h> // POSIX

int main(void) {
    printf("This will not be flushed\n");
    // Immediate exit, no cleanup, no buffer flush
    _exit(1);
}
```

### quick_exit() - Quick Termination

```c
#include <stdlib.h>

void quick_cleanup(void) {
    printf("Quick cleanup...\n");
}

int main(void) {
    // Register quick exit handler
    at_quick_exit(quick_cleanup);

    // Quick exit (calls at_quick_exit, not atexit)
    quick_exit(0);
}
```

### abort() - Abnormal Termination

```c
#include <stdlib.h>
#include <stdio.h>

int main(void) {
    printf("About to abort...\n");
    // Abnormal termination, raises SIGABRT
    abort();
}
```

## Exit Handlers

### atexit() - Register Cleanup 

```c
#include <stdlib.h>
#include <stdio.h>

void cleanup1(void) {
    printf("Cleanup 1 executed\n");
}

void cleanup2(void) {
    printf("Cleanup 2 executed\n");
}

void cleanup3(void) {
    printf("Cleanup 3 executed\n");
}

int main(void) {
    // Register handlers (called in reverse order)
    atexit(cleanup1);
    atexit(cleanup2);
    atexit(cleanup3);

    printf("Main function\n");
    return 0;
    // Output:
    // Main function
    // Cleanup 3 executed
    // Cleanup 2 executed
    // Cleanup 1 executed
}
```

### Maximum Number of Handlers

```c
#include <stdlib.h>
#include <stdio.h>

void handler(void) {
    printf("Handler\n");
}

int main(void) {
    int count = 0;
    int max_handlers;

    // Try to register many handlers (POSIX minimum is 32)
    while (atexit(handler) == 0) {
        count++;
    }

    printf("Registered %d handlers\n", count);
    // On error, atexit returns non-zero

    return 0;
}
```

## Practical Example: Resource Management

```c
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

FILE *log_file = NULL;
char *buffer = NULL;

void cleanup(void) {
    printf("Performing cleanup...\n");

    if (buffer != NULL) {
        free(buffer);
        printf("Buffer freed\n");
    }

    if (log_file != NULL) {
        fclose(log_file);
        printf("Log file closed\n");
    }
}

int main(void) {
    // Register cleanup
    atexit(cleanup);

    // Allocate resources
    buffer = malloc(1024);
    if (buffer == NULL) {
        fprintf(stderr, "Failed to allocate buffer\n");
        exit(EXIT_FAILURE);
    }

    log_file = fopen("app.log", "w");
    if (log_file == NULL) {
        fprintf(stderr, "Failed to open log file\n");
        exit(EXIT_FAILURE);
    }

    fprintf(log_file, "Application started\n");

    // Simulate some work
    strcpy(buffer, "Some data");
    printf("Working with: %s\n", buffer);

    // Normal exit (cleanup will be called)
    return EXIT_SUCCESS;
}
```

## Exit Status Codes

```c
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <command>\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Different exit codes for different scenarios
    if (strcmp(argv[1], "success") == 0) {
        return EXIT_SUCCESS;  // 0
    } else if (strcmp(argv[1], "error") == 0) {
        return EXIT_FAILURE;  // 1
    } else {
        return 2;  // Custom exit code
    }
}
```

## Comparison of Exit 

| Function | Cleanup | Buffer Flush | Handlers | Use Case |
|----------|---------|--------------|----------|----------|
| `exit()` | Yes | Yes | atexit() | Normal termination |
| `_exit()` | No | No | None | Immediate exit (child processes) |
| `quick_exit()` | No | No | at_quick_exit() | Fast termination |
| `abort()` | No | No | None | Abnormal termination |

## Best Practices

### Use exit() for Normal Termination

```c
// GOOD - Normal exit
if (error_occurred) {
    fprintf(stderr, "Error: %s\n", error_message);
    exit(EXIT_FAILURE);
}

// AVOID - Using return in complex cleanup code
if (error_occurred) {
    // ... multiple cleanup steps ...
    return EXIT_FAILURE;  // Risky - might miss cleanup
}
```

### Register Cleanup  Early

```c
// GOOD - Register atexit early
int main(void) {
    atexit(cleanup);  // First thing
    // ... rest of program ...
}

// AVOID - Register late
int main(void) {
    // ... lots of code ...
    // ... might exit before this ...
    atexit(cleanup);  // Too late
}
```

### Use _exit() Only in Child Processes

```c
#include <unistd.h>
#include <stdlib.h>

int main(void) {
    pid_t pid = fork();
    if (pid == 0) {
        // Child process
        // Use _exit to avoid flushing buffers twice
        _exit(0);
    } else if (pid > 0) {
        // Parent process
        exit(0);
    }
    return 0;
}
```

### Handle abort() with Signal Handler

```c
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>

void abort_handler(int sig) {
    printf("Aborting... saving crash data...\n");
    // ... save crash information ...
    // Remove handler and re-raise
    signal(SIGABRT, SIG_DFL);
    raise(SIGABRT);
}

int main(void) {
    signal(SIGABRT, abort_handler);

    // This will trigger handler before actual abort
    abort();

    return 0;
}
```

## Common Pitfalls

### 1. Exit in Library Code

```c
// BAD - Library function calling exit()
void process_data(char *data) {
    if (data == NULL) {
        exit(1);  // Don't do this in libraries!
    }
}

// GOOD - Return error code
int process_data(char *data) {
    if (data == NULL) {
        return -1;  // Let caller decide
    }
    return 0;
}
```

### 2. Forgetting Buffer Flush

```c
// BAD - Using _exit() with buffered output
printf("Important message: %s", critical_data);
_exit(0);  // Output lost!

// GOOD - Use exit() or flush explicitly
printf("Important message: %s", critical_data);
fflush(stdout);  // Or just use exit()
_exit(0);
```

### 3. Exceeding atexit() Limit

```c
// BAD - Not checking return value
for (int i = 0; i < 100; i++) {
    atexit(handler);  // Might fail silently
}

// GOOD - Check return value
for (int i = 0; i < 100; i++) {
    if (atexit(handler) != 0) {
        fprintf(stderr, "Too many exit handlers\n");
        break;
    }
}
```

> **Note**: The order of atexit() handler execution is reverse registration order (LIFO). The first registered handler is called last. Also, handlers are not called if you call _exit() or abort(), or if the program terminates abnormally due to a signal.
