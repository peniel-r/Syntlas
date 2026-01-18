---
id: 77-debugging-practices
title: Debugging Practices
category: bestpractices
difficulty: intermediate
tags:
  - debugging
  - gdb
  - valgrind
  - troubleshooting
keywords:
  - debugging
  - gdb
  - valgrind
  - breakpoints
  - tracing
use_cases:
  - Troubleshooting bugs
  - Performance analysis
  - Memory debugging
  - Code inspection
prerequisites:
  - memory-management
  - pointers
  - error-handling
related:
  - error-handling
  - logging
  - memory-bestpractices
next_topics:
  - build-systems
---

# Debugging Practices

Effective debugging techniques and tools are essential for identifying and fixing issues in C programs.

## GDB Basics

```c
// sample.c
#include <stdio.h>

int add(int a, int b) {
    int result = a + b;
    return result;
}

int main(void) {
    int x = 5;
    int y = 10;
    int sum = add(x, y);
    printf("Sum: %d\n", sum);
    return 0;
}
```

```bash
# Compile with debugging symbols
gcc -g -o sample sample.c

# Run with GDB
gdb ./sample

# Common GDB commands:
(gdb) break main           # Set breakpoint
(gdb) run                 # Start program
(gdb) next                # Step over
(gdb) step                # Step into
(gdb) print x             # Print variable
(gdb) display x           # Display variable continuously
(gdb) continue            # Continue execution
(gdb) bt                  # Backtrace (call stack)
(gdb) info locals         # Show local variables
(gdb) info args           # Show function arguments
(gdb) finish              # Finish current function
(gdb) quit                # Exit GDB
```

## Conditional Breakpoints

```bash
# Set breakpoint that stops only when condition is met
(gdb) break add if a == 5

# Set breakpoint at specific line with condition
(gdb) break sample.c:10 if x > 100

# Ignore breakpoint N times before stopping
(gdb) ignore 1 3  # Ignore breakpoint #1 three times
```

## Watching Variables

```bash
# Watch variable for changes
(gdb) watch sum

# Watch memory location
(gdb) watch *0x7fffffffe000

# Display expression value at each stop
(gdb) display x + y

# List all displays
(gdb) info display

# Disable display
(gdb) undisplay 1
```

## Examining Memory

```bash
# Examine memory at address
(gdb) x/10x &buffer      # 10 words in hex
(gdb) x/20s str          # 20 strings
(gdb) x/1dw ptr          # 1 double word

# Formats:
# x - hexadecimal
# d - decimal
# u - unsigned decimal
# t - binary
# o - octal
# a - address
# c - char
# f - float
# s - string
# i - instruction
```

## Call Stack Navigation

```bash
# View call stack
(gdb) bt                 # Full backtrace
(gdb) bt 5               # Last 5 frames

# Move between stack frames
(gdb) up                 # Move up one frame
(gdb) down               # Move down one frame
(gdb) frame 2            # Go to frame 2

# View variables in different frames
(gdb) up
(gdb) print local_var
```

## Core File Analysis

```bash
# Enable core dumps
ulimit -c unlimited

# Run program (will create core file on crash)
./program

# Analyze core file
gdb ./program core

# Examine state at crash
(gdb) bt                 # See where it crashed
(gdb) print errno        # Check error
(gdb) info registers     # CPU state
```

## Valgrind for Memory Debugging

```bash
# Compile with debugging symbols
gcc -g -o program program.c

# Run with valgrind
valgrind --leak-check=full ./program

# Common valgrind output:
# - Invalid read/write
# - Use of uninitialized values
# - Memory leaks
# - Invalid free
```

```bash
# Useful valgrind options:
valgrind --leak-check=full --show-leak-kinds=all ./program
valgrind --tool=massif ./program           # Memory profiling
valgrind --tool=callgrind ./program        # Profiling
valgrind --track-origins=yes ./program     # Track uninitialized values
```

## Address Sanitizer (ASan)

```c
// Compile with Address Sanitizer
gcc -fsanitize=address -g -o program program.c

// ASan detects:
// - Out-of-bounds accesses
// - Use-after-free
// - Double-free
// - Memory leaks
// - Stack overflow
```

```bash
# Run program (ASan will detect issues)
./program

# Common ASan output:
# ==12345==ERROR: AddressSanitizer: heap-use-after-free
# ==12345==ERROR: AddressSanitizer: stack-buffer-overflow
```

## Undefined Behavior Sanitizer (UBSan)

```bash
# Compile with UBSan
gcc -fsanitize=undefined -g -o program program.c

# UBSan detects:
// - Signed integer overflow
// - Misaligned pointer access
// - Null pointer dereference
// - Invalid enum values
```

## Printf Debugging

```c
#include <stdio.h>

void process_data(int *data, int count) {
    printf("DEBUG: process_data called with count=%d\n", count);

    for (int i = 0; i < count; i++) {
        printf("DEBUG: Processing index %d, value=%d\n", i, data[i]);

        if (data[i] > 100) {
            printf("DEBUG: Found large value at index %d\n", i);
        }
    }

    printf("DEBUG: process_data completed\n");
}
```

## Conditional Debugging

```c
// Enable/disable debugging with preprocessor
#ifdef DEBUG
    #define DEBUG_PRINT(fmt, ...) \
        fprintf(stderr, "[DEBUG] %s:%d: " fmt "\n", \
                __FILE__, __LINE__, ##__VA_ARGS__)
#else
    #define DEBUG_PRINT(fmt, ...) ((void)0)
#endif

void process(int value) {
    DEBUG_PRINT("Processing value: %d", value);

    if (value > 100) {
        DEBUG_PRINT("Value too large");
        return;
    }

    DEBUG_PRINT("Processing complete");
}

// Compile with -DDEBUG to enable
gcc -DDEBUG -o program program.c
```

## Assertions for Debugging

```c
#include <assert.h>

int divide(int a, int b) {
    assert(b != 0 && "Divisor cannot be zero");
    return a / b;
}

void process_array(int *array, int size) {
    assert(array != NULL && "Array cannot be NULL");
    assert(size > 0 && "Size must be positive");
    assert(size <= 1000 && "Size too large");

    for (int i = 0; i < size; i++) {
        assert(array[i] >= 0 && "Array values must be non-negative");
    }
}
```

## Tracing Execution

```c
#include <stdio.h>
#include <time.h>

#define TRACE_CALL() \
    printf("[%s:%d] %s called\n", __FILE__, __LINE__, __func__)

#define TRACE_RETURN(val) \
    do { \
        printf("[%s:%d] %s returning: %d\n", \
               __FILE__, __LINE__, __func__, (val)); \
        return (val); \
    } while(0)

int compute(int x) {
    TRACE_CALL();

    int result = x * 2;
    TRACE_RETURN(result);
}

int main(void) {
    compute(5);
    return 0;
}
```

## Timing Debugging

```c
#include <stdio.h>
#include <time.h>

void timed_function(void) {
    clock_t start = clock();

    printf("Starting operation...\n");

    // Simulate work
    for (volatile int i = 0; i < 1000000; i++);

    clock_t end = clock();
    double elapsed = ((double)(end - start)) / CLOCKS_PER_SEC;

    printf("Operation took %.6f seconds\n", elapsed);
}

void measure_with_timespec(void) {
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    // Do work
    for (volatile int i = 0; i < 10000000; i++);

    clock_gettime(CLOCK_MONOTONIC, &end);

    double elapsed = (end.tv_sec - start.tv_sec) +
                     (end.tv_nsec - start.tv_nsec) / 1e9;

    printf("Time: %.9f seconds\n", elapsed);
}
```

## Signal Handling for Debugging

```c
#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

void signal_handler(int sig) {
    printf("\nReceived signal: %d\n", sig);
    printf("Backtrace:\n");

    // Print backtrace (requires execinfo.h)
    void *array[10];
    size_t size = backtrace(array, 10);
    char **strings = backtrace_symbols(array, size);

    for (size_t i = 0; i < size; i++) {
        printf("  %s\n", strings[i]);
    }

    free(strings);
    exit(1);
}

int main(void) {
    // Install signal handlers
    signal(SIGSEGV, signal_handler);   // Segmentation fault
    signal(SIGABRT, signal_handler);   // Abort
    signal(SIGFPE, signal_handler);    // Floating point exception

    // Trigger SIGSEGV for testing
    int *ptr = NULL;
    *ptr = 5;

    return 0;
}
```

## Debugging Deadlocks

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex2 = PTHREAD_MUTEX_INITIALIZER;

void *thread1_func(void *arg) {
    printf("Thread 1: Acquiring mutex 1\n");
    pthread_mutex_lock(&mutex1);
    sleep(1);

    printf("Thread 1: Trying to acquire mutex 2\n");
    pthread_mutex_lock(&mutex2);

    printf("Thread 1: Critical section\n");

    pthread_mutex_unlock(&mutex2);
    pthread_mutex_unlock(&mutex1);

    return NULL;
}

void *thread2_func(void *arg) {
    printf("Thread 2: Acquiring mutex 2\n");
    pthread_mutex_lock(&mutex2);
    sleep(1);

    printf("Thread 2: Trying to acquire mutex 1\n");
    pthread_mutex_lock(&mutex1);

    printf("Thread 2: Critical section\n");

    pthread_mutex_unlock(&mutex1);
    pthread_mutex_unlock(&mutex2);

    return NULL;
}

// Detecting deadlock with timeout
bool try_lock_with_timeout(pthread_mutex_t *mutex, int timeout_ms) {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    ts.tv_nsec += timeout_ms * 1000000;
    ts.tv_sec += ts.tv_nsec / 1000000000;
    ts.tv_nsec %= 1000000000;

    return pthread_mutex_timedlock(mutex, &ts) == 0;
}
```

## Memory Corruption Detection

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Canary value to detect stack corruption
#define STACK_CANARY 0xDEADBEEF

typedef struct {
    int canary;
    int data[10];
    int canary2;
} SafeArray;

void check_canaries(SafeArray *arr) {
    if (arr->canary != STACK_CANARY) {
        printf("ERROR: Front canary corrupted!\n");
    }
    if (arr->canary2 != STACK_CANARY) {
        printf("ERROR: Back canary corrupted!\n");
    }
}

int main(void) {
    SafeArray arr;
    arr.canary = STACK_CANARY;
    arr.canary2 = STACK_CANARY;

    // Access beyond array
    arr.data[15] = 100;

    check_canaries(&arr);

    return 0;
}
```

## Best Practices

### Reproduce Bugs First

```c
// Create minimal reproduction case
void reproduce_bug(void) {
    // Simplified version that shows the bug
    int x = 5;
    int y = 0;
    int result = x / y;  // Will crash
}

// Test the fix
void test_fix(void) {
    int x = 5;
    int y = 0;
    int result = (y != 0) ? x / y : 0;  // Fixed
    printf("Result: %d\n", result);
}
```

### Use Version Control Bisect

```bash
# Find which commit introduced the bug
git bisect start
git bisect bad   # Current version has bug
git bisect good <commit-id>  # Known good version
# Git will checkout commits, test each one
git bisect good  # or git bisect bad
# Continue until bug is found
git bisect reset
```

### Document Findings

```c
/*
 * Bug #123: Buffer overflow in process_string()
 *
 * Issue: strcpy() without size limit causes buffer overflow
 * when input string > 99 characters.
 *
 * Fix: Use strncpy() with explicit size limit
 *
 * Date: 2024-01-15
 * Author: Developer
 */
void process_string(char *dest, const char *src) {
    strncpy(dest, src, 99);
    dest[99] = '\0';
}
```

## Common Pitfalls

### 1. Heisenbugs

```c
// Bug that disappears when you try to observe it
void heisenbug(void) {
    int *ptr = malloc(sizeof(int));
    *ptr = 42;
    free(ptr);

    // Commenting out printf makes bug appear/disappear
    // printf("Value: %d\n", *ptr);  // Timing affects bug

    *ptr = 100;  // Use-after-free, might not crash
}
```

### 2. Overlooking Return Values

```c
// WRONG - Ignoring errors
FILE *file = fopen("data.txt", "r");
fgets(buffer, 100, file);  // Might crash if file is NULL

// CORRECT - Check return values
FILE *file = fopen("data.txt", "r");
if (file == NULL) {
    perror("Failed to open file");
    return;
}
if (fgets(buffer, 100, file) == NULL) {
    printf("Read failed\n");
    return;
}
```

### 3. Not Enabling Debug Symbols

```bash
# WRONG - No debug info
gcc -o program program.c
gdb ./program  # Can't see variables, line numbers

# CORRECT - With debug symbols
gcc -g -O0 -o program program.c
gdb ./program  # Full debugging information
```

> **Note**: Effective debugging requires a systematic approach: understand the problem, reproduce it, isolate the cause, fix it, and verify the fix. Use tools like GDB, Valgrind, and sanitizers to automate detection of common issues. Always compile with debugging symbols during development.
