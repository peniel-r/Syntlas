---
id: "c.stdlib.stdio"
title: "Standard I/O (stdio.h)"
category: stdlib
difficulty: beginner
tags: [c, stdio, printf, scanf, fprintf, fscanf]
keywords: [printf, scanf, fprintf, fscanf, puts, gets]
use_cases: [input output, user interaction, logging]
prerequisites: []
related: [c.io]
next_topics: [c.stdlib.string]
---

# Standard I/O

## printf - Formatted Output

```c
#include <stdio.h>

int main() {
    // Integer
    printf("Integer: %d\n", 42);

    // Float
    printf("Float: %.2f\n", 3.14159);

    // String
    printf("String: %s\n", "Hello");

    // Character
    printf("Character: %c\n", 'A');

    // Hexadecimal
    printf("Hex: %x\n", 255);

    // Pointer
    int value = 42;
    printf("Pointer: %p\n", &value);

    return 0;
}
```

## scanf - Formatted Input

```c
#include <stdio.h>

int main() {
    int integer;
    float floating;

    // Read integer
    printf("Enter an integer: ");
    scanf("%d", &integer);
    printf("You entered: %d\n", integer);

    // Read float
    printf("Enter a float: ");
    scanf("%f", &floating);
    printf("You entered: %.2f\n", floating);

    return 0;
}
```

## puts - Print String

```c
#include <stdio.h>

int main() {
    // Print string with newline
    puts("Hello, World!");

    // Empty string with newline
    puts("");

    return 0;
}
```

## gets - Read String

```c
#include <stdio.h>

int main() {
    char buffer[100];

    printf("Enter a string: ");
    gets(buffer);

    printf("You entered: %s\n", buffer);

    return 0;
}
```

## fgets - Safe String Input

```c
#include <stdio.h>

int main() {
    char buffer[100];

    printf("Enter a string: ");
    fgets(buffer, sizeof(buffer), stdin);

    // Remove newline if present
    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n') {
        buffer[len - 1] = '\0';
    }

    printf("You entered: %s\n", buffer);

    return 0;
}
```

## fprintf - File I/O

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("output.txt", "w");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fprintf(file, "Hello, File!\n");
    fprintf(file, "Integer: %d\n", 42);
    fprintf(file, "Float: %.2f\n", 3.14);

    fclose(file);

    printf("Data written to file\n");

    return 0;
}
```

## fscanf - File Input

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "r");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    int value;
    float number;
    char text[100];

    fscanf(file, "%d %f %99s", &value, &number, text);

    printf("Read: %d %.2f %s\n", value, number, text);

    fclose(file);

    return 0;
}
```

## sprintf - String Formatting

```c
#include <stdio.h>
#include <string.h>

int main() {
    char buffer[100];

    // Format into string
    sprintf(buffer, "Value: %d, Float: %.2f", 42, 3.14);

    printf("Formatted: %s\n", buffer);

    return 0;
}
```

## sscanf - String Parsing

```c
#include <stdio.h>

int main() {
    const char* data = "42 3.14 Hello";
    int value;
    float number;
    char text[100];

    sscanf(data, "%d %f %99s", &value, &number, text);

    printf("Parsed: %d %.2f %s\n", value, number, text);

    return 0;
}
```

## perror - Error Output

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE* file = fopen("nonexistent.txt", "r");

    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    fclose(file);

    return 0;
}
```

## getchar/putchar - Character I/O

```c
#include <stdio.h>

int main() {
    printf("Enter text (Ctrl+D to end):\n");

    int ch;
    while ((ch = getchar()) != EOF && ch != 4) {
        putchar(toupper(ch));
    }

    printf("\nText processed\n");

    return 0;
}
```

## sprintf with Formatting

```c
#include <stdio.h>

int main() {
    char buffer[200];

    sprintf(buffer, "Name: %s, Age: %d, Score: %.1f",
            "Alice", 30, 95.5);

    printf("%s\n", buffer);

    return 0;
}
```

## Formatted Output

```c
#include <stdio.h>
int main() {
    int value = 42;
    float pi = 3.14159;

    // Width and precision
    printf("| %10d |\n", value);
    printf("| %10.2f |\n", pi);
    printf("| %-10s |\n", "text");

    // Left/Right alignment
    printf("| %-10d |\n", value);
    printf("| %10d |\n", value);

    return 0;
}
```

## Formatted Input with Width

```c
#include <stdio.h>

int main() {
    int value;

    // Input with width
    printf("Enter value (max 5 digits): ");
    scanf("%5d", &value);

    printf("You entered: %d\n", value);

    return 0;
}
```

## Reading Strings Safely

```c
#include <stdio.h>
#include <string.h>

int main() {
    char buffer[256];

    printf("Enter a string: ");
    if (fgets(buffer, sizeof(buffer), stdin) == NULL) {
        printf("Error reading input\n");
        return 1;
    }

    // Remove newline
    buffer[strcspn(buffer, "\n")] = '\0';

    printf("You entered: %s\n", buffer);

    return 0;
}
```

## Writing Strings to File

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("lines.txt", "w");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fprintf(file, "Line 1\n");
    fprintf(file, "Line 2\n");
    fprintf(file, "Line 3\n");

    fclose(file);

    printf("Lines written to file\n");

    return 0;
}
```

## Reading Lines from File

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("lines.txt", "r");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    char line[256];
    int line_num = 1;

    while (fgets(line, sizeof(line), file) != NULL) {
        printf("Line %d: %s", line_num++, line);
    }

    fclose(file);

    return 0;
}
```

## Binary I/O Basics

```c
#include <stdio.h>

int main() {
    int value = 42;

    // Write binary
    FILE* file = fopen("binary.bin", "wb");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fwrite(&value, sizeof(int), 1, file);

    fclose(file);

    // Read binary
    file = fopen("binary.bin", "rb");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    int read_value;
    if (fread(&read_value, sizeof(int), 1, file) == 1) {
        printf("Read value: %d\n", read_value);
    }

    fclose(file);

    return 0;
}
```

## Standard Streams

```c
#include <stdio.h>

int main() {
    // Standard streams
    fprintf(stdout, "Output to stdout\n");
    fprintf(stderr, "Error to stderr\n");
    fprintf(stdin, "This goes to stdin\n");

    // Redirect streams
    freopen("output.log", "w", stdout);
    fprintf(stdout, "This goes to file\n");

    return 0;
}
```

## Console Input with Validation

```c
#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>

bool read_int(int* result) {
    char buffer[100];
    if (fgets(buffer, sizeof(buffer), stdin) == NULL) {
        return false;
    }

    for (char* p = buffer; *p != '\0' && isspace((unsigned char)*p); p++);

    return sscanf(buffer, "%d", result) == 1;
}

int main() {
    int value;

    printf("Enter a number: ");

    if (read_int(&value)) {
        printf("Valid number: %d\n", value);
    } else {
        printf("Invalid input\n");
    }

    return 0;
}
```

> **Note**: `gets` is unsafe. Use `fgets` instead. Always check return values for errors.
