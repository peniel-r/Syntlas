---
id: "c.patterns.structs"
title: "Structures and Unions"
category: patterns
difficulty: beginner
tags: [c, struct, union, bitfield, packing]
keywords: [struct, union, bitfield, attribute, packed]
use_cases: [data modeling, hardware access, protocol parsing]
prerequisites: []
related: ["c.pointers"]
next_topics: ["c.patterns.enums"]
---

# Structures and Unions

## Basic Struct

```c
#include <stdio.h>

typedef struct {
    int x;
    int y;
} Point;

int main() {
    Point p = {10, 20};

    printf("Point: (%d, %d)\n", p.x, p.y);

    return 0;
}
```

## Struct with Pointers

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    char* name;
    int age;
} Person;

Person* create_person(const char* name, int age) {
    Person* p = malloc(sizeof(Person));
    if (p == NULL) {
        return NULL;
    }

    p->name = malloc(strlen(name) + 1);
    if (p->name == NULL) {
        free(p);
        return NULL;
    }

    strcpy(p->name, name);
    p->age = age;

    return p;
}

void free_person(Person* p) {
    if (p != NULL) {
        free(p->name);
        free(p);
    }
}

int main() {
    Person* person = create_person("Alice", 30);

    if (person != NULL) {
        printf("Name: %s, Age: %d\n", person->name, person->age);
        free_person(person);
    }

    return 0;
}
```

## Nested Structs

```c
#include <stdio.h>

typedef struct {
    int day;
    int month;
    int year;
} Date;

typedef struct {
    char* name;
    Date birthdate;
} Person;

int main() {
    Person p = {
        .name = "John",
        .birthdate = {15, 6, 1990}
    };

    printf("%s was born on %d/%d/%d\n",
           p.name,
           p.birthdate.day,
           p.birthdate.month,
           p.birthdate.year);

    return 0;
}
```

## Struct Arrays

```c
#include <stdio.h>

typedef struct {
    const char* name;
    int score;
} Student;

int main() {
    Student students[] = {
        {"Alice", 90},
        {"Bob", 85},
        {"Charlie", 95}
    };

    size_t count = sizeof(students) / sizeof(students[0]);

    for (size_t i = 0; i < count; i++) {
        printf("%s: %d\n", students[i].name, students[i].score);
    }

    return 0;
}
```

## Struct Alignment

```c
#include <stdio.h>
#include <stddef.h>

typedef struct {
    char c;    // 1 byte
    int i;     // 4 bytes (aligned)
    char d;    // 1 byte
} AlignedStruct;

int main() {
    printf("sizeof(AlignedStruct): %zu\n", sizeof(AlignedStruct));
    printf("Offset of c: %zu\n", offsetof(AlignedStruct, c));
    printf("Offset of i: %zu\n", offsetof(AlignedStruct, i));
    printf("Offset of d: %zu\n", offsetof(AlignedStruct, d));

    return 0;
}
```

## Packed Struct

```c
#include <stdio.h>
#include <stddef.h>

typedef struct __attribute__((packed)) {
    char c;    // 1 byte
    int i;     // 4 bytes (no padding)
    char d;    // 1 byte
} PackedStruct;

int main() {
    printf("sizeof(PackedStruct): %zu\n", sizeof(PackedStruct));

    return 0;
}
```

## Bitfields

```c
#include <stdio.h>

typedef struct {
    unsigned int day : 5;      // 1-31 (5 bits)
    unsigned int month : 4;    // 1-12 (4 bits)
    unsigned int year : 12;    // 0-4095 (12 bits)
} CompactDate;

int main() {
    CompactDate date = {18, 1, 2026};

    printf("Date: %d/%d/%d\n", date.day, date.month, date.year);
    printf("Size: %zu bytes\n", sizeof(CompactDate));

    return 0;
}
```

## Union

```c
#include <stdio.h>

typedef union {
    int i;
    float f;
    char bytes[4];
} DataUnion;

int main() {
    DataUnion data;

    data.i = 0x12345678;

    printf("As int: 0x%x\n", data.i);
    printf("As float: %f\n", data.f);

    for (int i = 0; i < 4; i++) {
        printf("Byte %d: 0x%02x\n", i, (unsigned char)data.bytes[i]);
    }

    return 0;
}
```

## Anonymous Union

```c
#include <stdio.h>

typedef struct {
    int type;
    union {
        int i;
        float f;
        const char* s;
    } value;
} Variant;

int main() {
    Variant v;

    v.type = 1;  // int
    v.value.i = 42;
    printf("Int: %d\n", v.value.i);

    v.type = 2;  // float
    v.value.f = 3.14;
    printf("Float: %f\n", v.value.f);

    v.type = 3;  // string
    v.value.s = "Hello";
    printf("String: %s\n", v.value.s);

    return 0;
}
```

## Struct with Function Pointer

```c
#include <stdio.h>

typedef struct {
    int a;
    int b;
    int (*operation)(int, int);
} Calculator;

int add(int a, int b) { return a + b; }
int multiply(int a, int b) { return a * b; }

int main() {
    Calculator calc;

    calc.a = 5;
    calc.b = 3;

    calc.operation = add;
    printf("Add: %d\n", calc.operation(calc.a, calc.b));

    calc.operation = multiply;
    printf("Multiply: %d\n", calc.operation(calc.a, calc.b));

    return 0;
}
```

## Linked List

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node* next;
} Node;

Node* create_node(int data) {
    Node* node = malloc(sizeof(Node));
    if (node != NULL) {
        node->data = data;
        node->next = NULL;
    }
    return node;
}

void free_list(Node* head) {
    Node* current = head;
    while (current != NULL) {
        Node* next = current->next;
        free(current);
        current = next;
    }
}

int main() {
    Node* head = create_node(1);
    head->next = create_node(2);
    head->next->next = create_node(3);

    Node* current = head;
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");

    free_list(head);

    return 0;
}
```

## Struct Copy

```c
#include <stdio.h>
#include <string.h>

typedef struct {
    char name[50];
    int age;
} Person;

int main() {
    Person p1 = {"Alice", 30};
    Person p2;

    // Shallow copy
    p2 = p1;

    printf("p1: %s, %d\n", p1.name, p1.age);
    printf("p2: %s, %d\n", p2.name, p2.age);

    // Using memcpy
    Person p3;
    memcpy(&p3, &p1, sizeof(Person));

    printf("p3: %s, %d\n", p3.name, p3.age);

    return 0;
}
```

## Struct Comparison

```c
#include <stdio.h>
#include <string.h>

typedef struct {
    int x;
    int y;
} Point;

int points_equal(const Point* a, const Point* b) {
    return memcmp(a, b, sizeof(Point)) == 0;
}

int main() {
    Point p1 = {10, 20};
    Point p2 = {10, 20};
    Point p3 = {5, 15};

    printf("p1 == p2: %d\n", points_equal(&p1, &p2));
    printf("p1 == p3: %d\n", points_equal(&p1, &p3));

    return 0;
}
```

## Struct as Return Value

```c
#include <stdio.h>

typedef struct {
    int quotient;
    int remainder;
} DivisionResult;

DivisionResult divide(int a, int b) {
    DivisionResult result;
    result.quotient = a / b;
    result.remainder = a % b;
    return result;
}

int main() {
    DivisionResult res = divide(10, 3);

    printf("10 / 3 = %d remainder %d\n",
           res.quotient, res.remainder);

    return 0;
}
```

## Struct Initializers

```c
#include <stdio.h>

typedef struct {
    int x;
    int y;
    int z;
} Point3D;

int main() {
    // All members
    Point3D p1 = {1, 2, 3};

    // Designated initializers
    Point3D p2 = {.x = 10, .y = 20};

    // Partial initialization (rest zero)
    Point3D p3 = {.z = 30};

    printf("p1: %d, %d, %d\n", p1.x, p1.y, p1.z);
    printf("p2: %d, %d, %d\n", p2.x, p2.y, p2.z);
    printf("p3: %d, %d, %d\n", p3.x, p3.y, p3.z);

    return 0;
}
```

## Transparent Union

```c
#include <stdio.h>

typedef union {
    int* int_ptr;
    float* float_ptr;
} PointerUnion;

void print_value(PointerUnion pu, int type) {
    if (type == 0) {
        printf("Int: %d\n", *pu.int_ptr);
    } else {
        printf("Float: %f\n", *pu.float_ptr);
    }
}

int main() {
    int i = 42;
    float f = 3.14f;

    print_value((PointerUnion){.int_ptr = &i}, 0);
    print_value((PointerUnion){.float_ptr = &f}, 1);

    return 0;
}
```

> **Note**: Bitfield layout is implementation-defined. Use `__attribute__((packed))` for specific memory layouts.
