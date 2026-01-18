---
id: "c.stdlib.scanf"
title: Stdio Scanf 
category: stdlib
difficulty: intermediate
tags:
  - scanf
  - fscanf
  - sscanf
  - input
keywords:
  - formatted input
  - scanf
  - fscanf
  - sscanf
  - format specifiers
use_cases:
  - User input
  - File parsing
  - String parsing
  - Data extraction
prerequisites:
  - c.stdlib.stdio
  - c.stdlib.string
  - c.functions
related:
  - 
  - 
next_topics:
  - 
---

# Stdio Scanf 

The scanf family of  provides formatted input from various sources.

## scanf() - Standard Input

```c
#include <stdio.h>

int main(void) {
    int age;
    char name[50];

    printf("Enter your name: ");
    scanf("%49s", name);  // Limit input size

    printf("Enter your age: ");
    scanf("%d", &age);

    printf("Hello %s, you are %d years old.\n", name, age);

    return 0;
}
```

## Format Specifiers

```c
#include <stdio.h>

int main(void) {
    int integer;
    float floating;
    char character;
    char string[50];
    unsigned int unsigned_int;
    long long_number;

    printf("Enter int: ");
    scanf("%d", &integer);

    printf("Enter float: ");
    scanf("%f", &floating);

    printf("Enter char: ");
    scanf(" %c", &character);  // Note the space before %c

    printf("Enter string: ");
    scanf("%49s", string);

    printf("Enter unsigned: ");
    scanf("%u", &unsigned_int);

    printf("Enter long: ");
    scanf("%ld", &long_number);

    printf("\nValues:\n");
    printf("  int: %d\n", integer);
    printf("  float: %f\n", floating);
    printf("  char: %c\n", character);
    printf("  string: %s\n", string);
    printf("  unsigned: %u\n", unsigned_int);
    printf("  long: %ld\n", long_number);

    return 0;
}
```

## Multiple Values in One Call

```c
#include <stdio.h>

int main(void) {
    int a, b, c;

    printf("Enter three c.stdlib.stdint (separated by spaces): ");
    int result = scanf("%d %d %d", &a, &b, &c);

    if (result == 3) {
        printf("Sum: %d\n", a + b + c);
        printf("Product: %d\n", a * b * c);
    } else {
        printf("Error: Expected 3 c.stdlib.stdint, got %d\n", result);
    }

    return 0;
}
```

## Field Width and Precision

```c
#include <stdio.h>

int main(void) {
    int id;
    char name[10];
    float salary;

    printf("Enter ID (3 digits), name (up to 9 chars), salary: ");
    // %3d = exactly 3 digits
    // %9s = max 9 characters
    scanf("%3d %9s %f", &id, name, &salary);

    printf("ID: %03d\n", id);
    printf("Name: %s\n", name);
    printf("Salary: %.2f\n", salary);

    return 0;
}
```

## Character Sets (Scansets)

```c
#include <stdio.h>

int main(void) {
    char word[50];

    // Read only alphabetic characters
    printf("Enter a word (letters only): ");
    scanf("%[a-zA-Z]", word);
    printf("Word: %s\n", word);

    // Read characters until newline
    printf("Enter a sentence: ");
    scanf("%[^\n]", word);  // ^\n means "not newline"
    printf("Sentence: %s\n", word);

    return 0;
}
```

## fscanf() - File Input

```c
#include <stdio.h>

int main(void) {
    FILE *file = fopen("data.txt", "r");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    int id;
    char name[50];
    float score;

    // Read formatted data from file
    while (fscanf(file, "%d %49s %f", &id, name, &score) == 3) {
        printf("ID: %d, Name: %s, Score: %.2f\n", id, name, score);
    }

    fclose(file);
    return 0;
}

/*
data.txt:
1 John 85.5
2 Jane 92.3
3 Bob 78.9
*/
```

## sscanf() - String Input

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    char data[] = "John Doe,30,50000.50";
    char first[20], last[20];
    int age;
    float salary;

    // Parse string
    int parsed = sscanf(data, "%19s %19s,%d,%f", first, last, &age, &salary);

    if (parsed == 4) {
        printf("Name: %s %s\n", first, last);
        printf("Age: %d\n", age);
        printf("Salary: %.2f\n", salary);
    }

    return 0;
}
```

## Parsing CSV Data

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    char name[50];
    int age;
    float salary;
} Employee;

void parse_employee(const char *line, Employee *emp) {
    // Parse "Name,Age,Salary" format
    sscanf(line, "%49[^,],%d,%f", emp->name, &emp->age, &emp->salary);
}

int main(void) {
    const char *csv_data[] = {
        "John Doe,30,50000.50",
        "Jane Smith,28,55000.75",
        "Bob Johnson,35,48000.00"
    };
    int count = 3;

    printf("Employees:\n");
    for (int i = 0; i < count; i++) {
        Employee emp;
        parse_employee(csv_data[i], &emp);
        printf("  %s: Age %d, Salary $%.2f\n", emp.name, emp.age, emp.salary);
    }

    return 0;
}
```

## Reading with Return Value Check

```c
#include <stdio.h>

int main(void) {
    int value;

    printf("Enter a number: ");
    int result = scanf("%d", &value);

    // Check if input was successful
    if (result == EOF) {
        printf("Error or EOF encountered\n");
    } else if (result == 0) {
        printf("Invalid input (not an integer)\n");
        // Clear input buffer
        while (getchar() != '\n');
    } else {
        printf("You entered: %d\n", value);
    }

    return 0;
}
```

## Clearing Input Buffer

```c
#include <stdio.h>

void clear_input_buffer(void) {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
}

int main(void) {
    int number;
    char name[50];

    printf("Enter a number: ");
    scanf("%d", &number);
    clear_input_buffer();  // Clear remaining characters

    printf("Enter your name: ");
    fgets(name, sizeof(name), stdin);
    // Remove newline if present
    name[strcspn(name, "\n")] = '\0';

    printf("Number: %d, Name: %s\n", number, name);

    return 0;
}
```

## Reading Hexadecimal and Octal

```c
#include <stdio.h>

int main(void) {
    int decimal, hex, octal;

    printf("Enter decimal: ");
    scanf("%d", &decimal);

    printf("Enter hex: ");
    scanf("%x", &hex);

    printf("Enter octal: ");
    scanf("%o", &octal);

    printf("\nAll in decimal:\n");
    printf("  Decimal: %d\n", decimal);
    printf("  Hex: %d\n", hex);
    printf("  Octal: %d\n", octal);

    return 0;
}
```

## Using Modifier Specifiers

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    // h modifier for short
    short short_num;
    printf("Enter short: ");
    scanf("%hd", &short_num);

    // l modifier for long
    long long_num;
    printf("Enter long: ");
    scanf("%ld", &long_num);

    // ll modifier for long long
    long long ll_num;
    printf("Enter long long: ");
    scanf("%lld", &ll_num);

    // L modifier for long double
    long double ld_num;
    printf("Enter long double: ");
    scanf("%Lf", &ld_num);

    // z modifier for size_t
    size_t size_num;
    printf("Enter size_t: ");
    scanf("%zu", &size_num);

    printf("\nValues:\n");
    printf("  Short: %hd\n", short_num);
    printf("  Long: %ld\n", long_num);
    printf("  Long long: %lld\n", ll_num);
    printf("  Long double: %Lf\n", ld_num);
    printf("  Size_t: %zu\n", size_num);

    return 0;
}
```

## Ignoring Input

```c
#include <stdio.h>

int main(void) {
    int day, year;
    char month[20];

    printf("Enter date (DD MMM YYYY): ");
    // Ignore whitespace between tokens
    scanf("%d %19s %d", &day, month, &year);

    printf("Day: %d, Month: %s, Year: %d\n", day, month, year);

    // Read and ignore specific format
    char buffer[100];
    printf("Enter anything (will be ignored): ");
    scanf("%*s");  // * modifier: read but don't assign

    printf("Ignored\n");
    return 0;
}
```

## Reading Multiple Lines

```c
#include <stdio.h>

int main(void) {
    char line1[100], line2[100], line3[100];

    printf("Enter 3 lines:\n");

    // Using fgets with scanf mix
    scanf(" %[^\n]", line1);  // Note leading space to skip whitespace
    scanf(" %[^\n]", line2);
    scanf(" %[^\n]", line3);

    printf("\nYou entered:\n");
    printf("%s\n%s\n%s\n", line1, line2, line3);

    return 0;
}
```

## Parsing Configuration File

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char name[50];
    int port;
    int max_connec.stdlib.stdions;
    bool debug;
} Config;

void load_config(const char *filename, Config *config) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        perror("Failed to open config");
        return;
    }

    char line[256];
    while (fgets(line, sizeof(line), file)) {
        char key[50], value[100];

        // Parse "key = value" format
        if (sscanf(line, "%49s = %99s", key, value) == 2) {
            if (strcmp(key, "name") == 0) {
                strncpy(config->name, value, sizeof(config->name) - 1);
            } else if (strcmp(key, "port") == 0) {
                config->port = atoi(value);
            } else if (strcmp(key, "max_connec.stdlib.stdions") == 0) {
                config->max_connec.stdlib.stdions = atoi(value);
            } else if (strcmp(key, "debug") == 0) {
                config->debug = (strcmp(value, "true") == 0);
            }
        }
    }

    fclose(file);
}

int main(void) {
    Config config = {0};
    load_config("config.txt", &config);

    printf("Configuration:\n");
    printf("  Name: %s\n", config.name);
    printf("  Port: %d\n", config.port);
    printf("  Max connec.stdlib.stdions: %d\n", config.max_connec.stdlib.stdions);
    printf("  Debug: %s\n", config.debug ? "true" : "false");

    return 0;
}

/*
config.txt:
name = MyServer
port = 8080
max_connec.stdlib.stdions = 100
debug = true
*/
```

## Best Practices

### Always Check Return Values

```c
// GOOD - Check return value
if (scanf("%d", &value) != 1) {
    fprintf(stderr, "Invalid input\n");
    return 1;
}

// BAD - Ignoring return value
scanf("%d", &value);  // Might fail silently
```

### Limit Input Sizes

```c
// GOOD - Limit buffer size
char name[50];
scanf("%49s", name);

// BAD - No size limit
char name[50];
scanf("%s", name);  // Buffer overflow possible
```

### Clear Buffer After Errors

```c
int value;
if (scanf("%d", &value) != 1) {
    fprintf(stderr, "Invalid input\n");
    // Clear the invalid input
    while (getchar() != '\n');
}
```

### Prefer fgets() for Strings

```c
// GOOD - Use fgets for strings
char name[50];
fgets(name, sizeof(name), stdin);
name[strcspn(name, "\n")] = '\0';  // Remove newline

// AVOID - scanf for strings (no spaces)
char name[50];
scanf("%49s", name);  // Can't read spaces
```

## Common Pitfalls

### 1. Forgetting & for Non-Array Types

```c
// WRONG - Missing & for c.stdlib.stdint
int value;
scanf("%d", value);  // Segmentation fault!

// CORRECT
int value;
scanf("%d", &value);
```

### 2. Space Before %c

```c
// WRONG - Reads previous newline
char c;
scanf("%c", &c);  // Might read newline from previous input

// CORRECT - Skip whitespace
char c;
scanf(" %c", &c);  // Leading space skips whitespace
```

### 3. Not Clearing Buffer

```c
// WRONG - Buffer issues
scanf("%d", &num1);
scanf("%d", &num2);  // Might read leftover data

// CORRECT - Clear between reads
scanf("%d", &num1);
while (getchar() != '\n');  // Clear buffer
scanf("%d", &num2);
```

> **Note**: scanf can be tricky and has security concerns. For production code, consider using fgets() combined with sscanf(), or dedicated parsing libraries. Always validate input and handle errors appropriately.
