---
id: "c.stdlib.atoi"
title: "String to Number Conversion (atoi, atof, strtol)"
category: stdlib
difficulty: beginner
tags: [c, stdlib, atoi, atof, strtol, strtod, conversion]
keywords: [atoi, atof, strtol, strtod, strtoul, string, conversion, number]
use_cases: [parsing command line args, reading config files, input validation]
prerequisites: ["c.strings", "c.arrays"]
related: ["c.stdlib.scanf", "c.io"]
next_topics: ["c.error.errno"]
---

# String to Number Conversion

## atoi - Simple Integer Conversion

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Convert string to integer
    const char* str1 = "42";
    int num1 = atoi(str1);
    printf("atoi(\"42\") = %d\n", num1);  // 42

    // Handles leading whitespace
    const char* str2 = "  -123  ";
    int num2 = atoi(str2);
    printf("atoi(\"  -123  \") = %d\n", num2);  // -123

    // Stops at first non-digit
    const char* str3 = "42abc";
    int num3 = atoi(str3);
    printf("atoi(\"42abc\") = %d\n", num3);  // 42

    // Invalid input returns 0
    const char* str4 = "hello";
    int num4 = atoi(str4);
    printf("atoi(\"hello\") = %d\n", num4);  // 0

    return 0;
}
```

## atof - Float Conversion

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Convert string to double
    const char* str1 = "3.14159";
    double pi = atof(str1);
    printf("atof(\"3.14159\") = %f\n", pi);  // 3.141590

    // Scientific notation
    const char* str2 = "1.23e-4";
    double sci = atof(str2);
    printf("atof(\"1.23e-4\") = %f\n", sci);  // 0.000123

    return 0;
}
```

## strtol - Robust Integer Conversion

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main() {
    const char* str = "12345";
    char* endptr;

    // Convert with error checking
    errno = 0;
    long num = strtol(str, &endptr, 10);

    if (errno == ERANGE) {
        printf("Number out of range\n");
    } else if (endptr == str) {
        printf("No digits found\n");
    } else {
        printf("strtol(\"%s\") = %ld\n", str, num);
    }

    // Different bases
    const char* hex = "1aF";
    long hex_num = strtol(hex, &endptr, 16);
    printf("strtol(\"%s\", 16) = %ld\n", hex, hex_num);  // 431

    const char* octal = "755";
    long oct_num = strtol(octal, &endptr, 8);
    printf("strtol(\"%s\", 8) = %ld\n", octal, oct_num);  // 493

    return 0;
}
```

## strtod - Robust Float Conversion

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main() {
    const char* str = "3.1415926535";
    char* endptr;

    errno = 0;
    double num = strtod(str, &endptr);

    if (errno == ERANGE) {
        printf("Number out of range\n");
    } else if (endptr == str) {
        printf("No digits found\n");
    } else {
        printf("strtod(\"%s\") = %.10f\n", str, num);
    }

    // Scientific notation
    const char* sci = "1.234e5";
    double sci_num = strtod(sci, &endptr);
    printf("strtod(\"%s\") = %f\n", sci, sci_num);  // 123400.000000

    return 0;
}
```

## strtoul - Unsigned Long Conversion

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    const char* str = "4294967295";  // Max 32-bit unsigned
    char* endptr;

    unsigned long num = strtoul(str, &endptr, 10);
    printf("strtoul(\"%s\") = %lu\n", str, num);

    // Hex to unsigned
    const char* hex = "FFFFFFFF";
    unsigned long hex_num = strtoul(hex, &endptr, 16);
    printf("strtoul(\"%s\", 16) = %lu\n", hex, hex_num);

    return 0;
}
```

## Safe Conversion Function

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

bool safe_strtol(const char* str, long* result) {
    if (str == NULL || result == NULL) return false;

    char* endptr;
    errno = 0;

    *result = strtol(str, &endptr, 10);

    // Check for conversion errors
    if (errno == ERANGE) return false;  // Overflow
    if (endptr == str) return false;   // No digits

    // Check for trailing non-whitespace
    while (*endptr != '\0') {
        if (!isspace((unsigned char)*endptr)) {
            return false;
        }
        endptr++;
    }

    return true;
}

int main() {
    const char* input = "  12345  ";
    long value;

    if (safe_strtol(input, &value)) {
        printf("Valid: %ld\n", value);
    } else {
        printf("Invalid input\n");
    }

    return 0;
}
```

## Parsing Multiple Numbers

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    const char* input = "10,20,30,40,50";
    char buffer[256];
    strncpy(buffer, input, sizeof(buffer));

    char* token = strtok(buffer, ",");
    int sum = 0;
    int count = 0;

    while (token != NULL) {
        int num = atoi(token);
        sum += num;
        count++;

        printf("Number %d: %d\n", count, num);
        token = strtok(NULL, ",");
    }

    printf("Sum: %d\n", sum);
    return 0;
}
```

## Command Line Argument Parsing

```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printf("Usage: %s <num1> <num2>\n", argv[0]);
        return 1;
    }

    int a = atoi(argv[1]);
    int b = atoi(argv[2]);

    printf("%d + %d = %d\n", a, b, a + b);
    printf("%d * %d = %d\n", a, b, a * b);

    return 0;
}
```

> **Warning**: `atoi` and `atof` don't detect errors. Use `strtol`/`strtod` with error checking in production code.
