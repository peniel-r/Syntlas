---
id: "c.functions"
title: "Functions and Control Flow"
category: language
difficulty: intermediate
tags: [c, , return, parameters, , control-flow]
keywords: [function, return, void, , , typedef]
use_cases: [code organization, parameter passing, recursion, callbacks]
prerequisites: []
related: ["c.pointers"]
next_topics: ["c.stdlib.io"]
---

#  and Control Flow

C provides  for code organization and control flow.

## Function Declaration

```c
#include <stdio.h>

// Function returning int
int add(int a, int b) {
    return a + b;
}

// Function returning pointer
int* create_int(int value) {
    int* ptr = malloc(sizeof(int));
    if (ptr != NULL) {
        *ptr = value;
    }
    return ptr;
}

// Function returning void (no return value)
void print_message(const char* msg) {
    printf("%s\n", msg);
}
```

## Parameters

```c
#include <stdio.h>

// Pass by value
void modify_value(int x) {
    x = 100;  // Changes local copy only
}

// Pass by pointer (can modify original)
void modify_pointer(int* ptr) {
    if (ptr != NULL) {
        *ptr = 100;  // Modifies original
    }
}

// Pass array (decays to pointer)
void process_array(int arr[], size_t size) {
    for (size_t i = 0; i < size; i++) {
        arr[i] *= 2;  // Modifies original array
    }
}
```

## 

```c
#include <stdio.h>

// Define struct
struct Point {
    int x;
    int y;
};

// Function taking struct by value
struct Point translate(struct Point p, int dx, int dy) {
    return (struct Point){p.x + dx, p.y + dy};
}

// Function taking struct by pointer
void translate_in_place(struct Point* p, int dx, int dy) {
    if (p != NULL) {
        p->x += dx;
        p->y += dy;
    }
}
```

## Typedef

```c
#include <stdio.h>

// Create type alias
typedef unsigned int uint;
typedef struct Point Point;

// Use typedef in function
uint add_numbers(uint a, uint b) {
    return a + b;
}

Point create_point(int x, int y) {
    Point p = {x, y};
    return p;
}
```

## Recursion

```c
#include <stdio.h>

// Factorial - recursive
int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

// Fibonacci - recursive
int fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int main() {
    printf("5! = %d\n", factorial(5));
    printf("fib(10) = %d\n", fibonacci(10));
    return 0;
}
```

## Static 

```c
#include <stdio.h>

// Static function (internal linkage)
static int internal_counter = 0;

void increment_counter(void) {
    internal_counter++;
    printf("Counter: %d\n", internal_counter);
}
```

## Function 

```c
#include <stdio.h>

// Function pointer type
typedef int (*BinaryOp)(int, int);

int apply(BinaryOp op, int a, int b) {
    return op(a, b);
}

int main() {
    // Array of function 
    BinaryOp ops[] = {
        // Define add function
        // Define multiply function
    };
    
    // In C99+, compound literals for 
    // Note: In older C, need separate 
    
    int result = apply(ops[0], 5, 3);  // Assuming ops[0] is add
    
    printf("Result: %d\n", result);
    return 0;
}
```

## Control Flow

```c
#include <stdio.h>

int main() {
    int x = 5;
    
    // if-else
    if (x > 10) {
        printf("Large\n");
    } else if (x > 0) {
        printf("Small\n");
    } else {
        printf("Zero or negative\n");
    }
    
    // switch statement
    switch (x) {
        case 1:
        printf("One\n");
            break;
        case 2:
            printf("Two\n");
            break;
        case 3:
            printf("Three\n");
            break;
        default:
            printf("Other\n");
    }
    
    // ternary operator
    const char* msg = (x > 0) ? "Positive" : "Non-positive";
    printf("%s\n", msg);
    
    return 0;
}
```

## c.controlflow

```c
#include <stdio.h>

int main() {
    int sum = 0;
    
    // for loop
    for (int i = 0; i < 10; i++) {
        sum += i;
    }
    printf("For loop sum: %d\n", sum);
    
    // while loop
    sum = 0;
    int j = 0;
    while (j < 10) {
        sum += j;
        j++;
    }
    printf("While loop sum: %d\n", sum);
    
    // do-while loop
    sum = 0;
    int k = 0;
    do {
        sum += k;
        k++;
    } while (k < 10);
    printf("Do-while loop sum: %d\n", sum);
    
    // Nested c.controlflow
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("i=%d, j=%d\n", i, j);
        }
    }
    
    return 0;
}
```

## Return Values

```c
#include <stdio.h>

int divide_with_error(int a, int b) {
    if (b == 0) {
        // Return error indicator
        // In real code, would use error codes or error return types
        return 0;
    }
    return a / b;
}

int main() {
    int result = divide_with_error(10, 0);
    if (result == 0) {
        printf("Error: Division by zero\n");
    } else {
        printf("Result: %d\n", result);
    }
    return 0;
}
```

## Common Patterns

### Validate parameters

```c
#include <stdio.h>

int process_data(const char* data) {
    if (data == NULL) {
        printf("Error: NULL data\n");
        return -1;
    }
    
    printf("Processing: %s\n", data);
    return 0;
}
```

### Initialize struct

```c
#include <stdio.h>

struct Person {
    const char* name;
    int age;
};

struct Person create_person(const char* name, int age) {
    // Designated initializer
    return (struct Person){.name = name, .age = age};
}
```

### Array as parameter

```c
#include <stdio.h>

int sum_array(int arr[], size_t size) {
    int sum = 0;
    for (size_t i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum;
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    int total = sum_array(numbers, 5);
    printf("Sum: %d\n", total);
    return 0;
}
```

### Function pointer as callback

```c
#include <stdio.h>

typedef void (*Callback)(int);

void process_numbers(int arr[], size_t size, Callback callback) {
    for (size_t i = 0; i < size; i++) {
        callback(arr[i]);
    }
}

void print_value(int value) {
    printf("Value: %d\n", value);
}

int main() {
    int numbers[] = {1, 2, 3};
    process_numbers(numbers, 3, print_value);
    return 0;
}
```

### Variadic 

```c
#include <stdarg.h>
#include <stdio.h>

int sum_all(int count, ...) {
    va_list args;
    va_start(args, count);
    
    int sum = 0;
    for (int i = 0; i < count; i++) {
        sum += va_arg(args, int);
    }
    
    va_end(args);
    return sum;
}

int main() {
    int total = sum_all(5, 1, 2, 3, 4, 5);
    printf("Sum: %d\n", total);
    return 0;
}
```

> **Note**: Prefer const correctness, explicit function prototypes, and parameter passing by const reference when possible.
