---
id: "c.stdlib.misc"
title: "Miscellaneous Library Functions"
category: stdlib
difficulty: intermediate
tags: [c, stdlib, stdio, stdlib, misc, utility]
keywords: [exit, abort, atexit, qsort, bsearch, system, getenv, setenv]
use_cases: [program termination, environment variables, sorting, searching, command execution]
prerequisites: []
related: ["c.stdlib.math"]
next_topics: []
---

# Miscellaneous Library 

C's <stdlib.h> provides various utility  beyond memory, math, and I/O.

## Program Termination

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int status = 0;
    
    // exit() - normal termination
    if (status == 0) {
        printf("Exiting with status %d\n", status);
        exit(status);
    }
    
    // _Exit() - normal termination
    // _Exit(status);
    
    // abort() - abnormal termination
    if (status == 1) {
        printf("Aborting with status %d\n", status);
        abort();
    }
    
    // Quick_exit - normal with cleanup
    // quick_exit(status);
    
    // atexit() - on exit handler
    // void on_exit_handler(void);
    // atexit(on_exit_handler);
    
    printf("Registered exit handler\n");
    return 0;
}
```

## Environment Variables

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Get environment variable
    char* path = getenv("PATH");
    if (path != NULL) {
        printf("PATH: %s\n", path);
    }
    
    // Set environment variable
    setenv("MY_VAR", "42");
    char* my_var = getenv("MY_VAR");
    printf("MY_VAR: %s\n", my_var);
    
    // Unset environment variable
    #ifdef _WIN32
    putenv("MY_VAR");
    #else
    unsetenv("MY_VAR");
    #endif
    
    return 0;
}
```

## System Commands

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Execute system command
    int result = system("dir /b");
    
    // system() returns implementation-dependent value
    if (result == 0) {
        printf("Command executed successfully\n");
    } else {
        printf("Command failed with code: %d\n", result);
    }
    
    return 0;
}
```

## Sorting

```c
#include <stdio.h>
#include <stdlib.h>

int compare_ints(const void* a, const void* b) {
    int ia = *(const int*)a;
    int ib = *(const int*)b);
    return (ia < ib) ? -1 : (ia > ib ? 1 : 0);
}

int main() {
    int values[] = {5, 3, 1, 9, 7};
    
    // Sort array using qsort
    qsort(values, sizeof(values) / sizeof(values[0]), compare_ints);
    
    printf("Sorted: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", values[i]);
    }
    printf("\n");
    
    return 0;
}
```

## Searching

```c
#include <stdio.h>
#include <stdlib.h>

int compare_string(const void* a, const void* b) {
    return strcmp((const char*)a, (const char*)b);
}

int main() {
    const char* strings[] = {"banana", "apple", "cherry", "date"};
    const char* target = "apple";
    
    // Search using bsearch
    const char* result = (char*)bsearch(&target, strings, sizeof(strings) / sizeof(strings[0]), sizeof(strings[0]), compare_string);
    
    if (result != NULL) {
        printf("Found at index: %td\n", result - strings);
    } else {
        printf("Not found\n");
    }
    
    return 0;
}
```

## Random Numbers

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    // Seed random number generator
    srand((unsigned int)time(NULL));
    
    // Generate random numbers
    for (int i = 0; i < 10; i++) {
        printf("Random: %d\n", rand());
    }
    
    return 0;
}
```

## Random Shuffling

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void shuffle(int* array, size_t size) {
    for (size_t i = size - 1; i > 0; i--) {
        // Fisher-Yates shuffle
        size_t j = rand() % (i + 1);
        
        // Swap elements
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    }
```

## Process ID

```c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
    // Get process ID
    pid_t pid = getpid();
    printf("Process ID: %d\n", pid);
    
    // Get parent process ID
    pid_t ppid = getppid();
    printf("Parent PID: %d\n", ppid);
    
    return 0;
}
```

## Absolute Path

```c
#include <stdio.h>
#include <limits.h>
#include <stdlib.h>

int main() {
    char path[PATH_MAX];
    
    // Get current working directory
    if (getcwd(path, sizeof(path)) == NULL) {
        perror("Failed to get cwd");
        return 1;
    }
    
    printf("Current directory: %s\n", path);
    return 0;
}
```

## Temporary File

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Create temporary file
    int fd = mkstemp();  // Creates unique filename
    if (fd == -1) {
        perror("Failed to create temp file");
        return 1;
    }
    
    // Write data
    const char* data = "Temporary data\n";
    write(fd, data, strlen(data));
    close(fd);
    
    // Print temp file path
    char temp_path[L_tmpnam];
    tmpnam(temp_path);
    printf("Temp file: %s\n", temp_path);
    
    // Remove temp file
    unlink(temp_path);
    
    return 0;
}
```

## Conversions

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdlib.h>

int main() {
    // String to integer
    const char* number_str = "42";
    char* endptr;
    long number = strtol(number_str, &endptr, 10);
    
    printf("String to long: %ld\n", number);
    
    // Integer to string
    int value = 42;
    char buffer[20];
    sprintf(buffer, "%d", value);
    printf("Integer to string: %s\n", buffer);
    
    // Double to string
    double dvalue = 3.14;
    sprintf(buffer, "%.2f", dvalue);
    printf("Double to string: %s\n", buffer);
    
    return 0;
}
```

> **Note**: Many stdlib  have security considerations. Validate inputs, check return values, and handle errors appropriately. Use safer alternatives where available (e.g., fopen_s instead of fopen).
