---
id: "c.stdlib.stdio"
title: "Standard Input/Output"
category: stdlib
difficulty: novice
tags: [c, stdio, stdlib, input, output, printf, scanf]
keywords: [printf, fprintf, scanf, getchar, putchar, fgetc, fputc, puts, gets]
use_cases: [console I/O, file I/O, formatted output, user input]
prerequisites: []
related: ["c.stdlib.string"]
next_topics: []
---

# Standard Input/Output

C's <stdio.h> provides functions for formatted input and output operations.

## printf - Formatted Output

```c
#include <stdio.h>

int main() {
    // Print string literal
    printf("Hello, World!\n");
    
    // Print with format specifier
    printf("Integer: %d\n", 42);
    printf("Float: %.2f\n", 3.14);
    printf("String: %s\n", "Hello");
    printf("Pointer: %p\n", (void*)0x1234);
    printf("Hex: %x\n", 0x1234);
    
    // Print multiple arguments
    printf("Values: %d, %s\n", 42, "hello");
    
    return 0;
}
```

## fprintf - Formatted File Output

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("output.txt", "w");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }
    
    // Write formatted output
    fprintf(file, "Name: %s, Age: %d\n", "Alice", 25);
    fprintf(file, "Score: %.2f\n", 95.5);
    
    fclose(file);
    printf("Data written to output.txt\n");
    return 0;
}
```

## scanf - Formatted Input

```c
#include <stdio.h>

int main() {
    int age;
    float percentage;
    char name[50];
    
    printf("Enter name: ");
    scanf("%49s", name);
    
    printf("Enter age: ");
    scanf("%d", &age);
    
    printf("Enter percentage: ");
    scanf("%f", &percentage);
    
    printf("Entered: %s, %d, %.2f\n", name, age, percentage);
    
    return 0;
}
```

## getchar - Character Input

```c
#include <stdio.h>

int main() {
    printf("Press any key to exit...\n");
    
    // Read characters
    int ch;
    while ((ch = getchar()) != '\n' && ch != EOF) {
        if (ch == '\t') break;
        putchar(ch);
    }
    }
    
    printf("Goodbye\n");
    return 0;
}
```

## puts - String Output

```c
#include <stdio.h>

int main() {
    // Print with automatic newline
    puts("Hello, World!");
    puts("Multiple lines");
    
    // puts returns non-negative on success
    return 0;
}
```

## puts vs fputs

```c
int main() {
    FILE* file = fopen("output.txt", "w");
    if (file == NULL) return 1;
    
    // puts writes to stdout
    puts("This goes to stdout");
    
    // fprintf writes to specified stream
    fprintf(file, "This goes to file\n");
    
    fclose(file);
    
    return 0;
}
```

## fgets - Line Input

```c
#include <stdio.h>

int main() {
    char buffer[100];
    
    printf("Enter a line: ");
    
    // Read line (removes newline)
    if (fgets(buffer, sizeof(buffer), stdin) != NULL) {
        // Remove newline
        char* newline = strchr(buffer, '\n');
        if (newline != NULL) *newline = '\0';
            *newline = '\0';
        }
        
        printf("You entered: %s\n", buffer);
    }
    
    return 0;
}
```

## gets - String Input

```c
#include <stdio.h>

int main() {
    char buffer[100];
    
    printf("Enter your name: ");
    
    // Read entire line (removes newline)
    if (gets(buffer) != NULL) {
        printf("You entered: %s\n", buffer);
    }
    
    return 0;
}
```

## Character I/O Functions

```c
#include <stdio.h>

int main() {
    // fgetc() - get character from stream
    FILE* file = fopen("data.txt", "r");
    if (file == NULL) return 1;
    
    int ch = fgetc(file);
    while (ch != EOF) {
        putchar(ch);
    ch = fgetc(file);
    }
    
    fclose(file);
    return 0;
}

int main() {
    // fputc() - write character to stream
    FILE* file = fopen("output.txt", "w");
    if (file == NULL) return 1;
    
    fputc('H', file);
    fputc('e', file);
    fputc('l', file);
    fputc('l', file);
    fputc('o', file);
    
    fclose(file);
    return 0;
}
```

## Formatted Output Specifiers

```c
#include <stdio.h>

int main() {
    int value = 42;
    double pi = 3.141592653589793;
    char* name = "Alice";
    
    // Integer format
    printf("Decimal: %d\n", value);           // %d
    printf("Octal: %o\n", 04);          // %o
    printf("Hexadecimal: %x\n", 0xA);      // %x
    printf("Pointer: %p\n", &value);      // p
    printf("Scientific: %e\n", value);   // %e
    
    // Floating point format
    printf("Fixed-point: %.2f\n", pi);
    printf("Exponential: %.2e\n", pi);
    
    // Width and precision specifiers
    printf("Default: %.2f\n", pi);       // 6 decimal places
    printf("Precision 6: %.2f\n", pi);   // 6 decimal places
    printf("Width 10: %.2f\n", pi);    // Minimum 10 chars, 2 decimal places
    
    // String format
    printf("String: %-20s\n", name);  // Left-aligned in 20-char field
    
    printf("Percent: %%%\n", 25.0);      // Percentage with 2 decimals
    
    // Signed integers
    printf("Signed decimal: %d\n", -5);
    printf("Signed decimal: %+d\n", 5);
    
    return 0;
}
```

## Error Handling in I/O

```c
#include <stdio.h>
#include <errno.h>

int main() {
    FILE* file = fopen("data.txt", "r");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }
    
    // Check if file opened successfully
    int file_error = ferror(file);
    if (file_error != 0) {
        perror("File error occurred");
        fclose(file);
        return 1;
    }
    
    // Write and check for errors
    fprintf(file, "Test data\n");
    if (ferror(file) != 0) {
        perror("Write failed");
        fclose(file);
        return 1;
    }
    
    fclose(file);
    printf("I/O operations completed\n");
    return 0;
}
```

> **Note**: Always check return values from file operations. Use formatted output specifiers for portable code. Handle I/O errors gracefully with perror and ferror.
