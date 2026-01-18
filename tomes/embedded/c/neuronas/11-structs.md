---
id: "c.patterns.structs"
title: "Structs and Unions"
category: pattern
difficulty: intermediate
tags: [c, structs, unions, bitfields, padding, packed]
keywords: [struct, union, bit-field, padding, packed, offsetof]
use_cases: [data modeling, memory layout, type safety]
prerequisites: ["c.arrays"]
related: ["c.functions"]
next_topics: ["c.best-practices"]
---

# Structs and Unions

C structs allow defining custom data types with optional type safety.

## Basic Structs

```c
#include <stdio.h>

struct Point {
    int x;
    int y;
};

struct Rectangle {
    float width;
    float height;
};

int main() {
    struct Point p = {10, 20};
    struct Rectangle r = {5.0, 3.0};
    
    printf("Point: (%d, %d)\n", p.x, p.y);
    printf("Rectangle: %.1fx%.1f\n", r.width, r.height);
    return 0;
}
```

## Pointers to Structs

```c
#include <stdio.h>

void access_with_pointer() {
    struct Point p = {10, 20};
    struct Point* ptr = &p;
    
    // Access via pointer
    ptr->x = 15;  // Same as p.x
    printf("Point via pointer: (%d, %d)\n", ptr->x, ptr->y);
}
```

## Array in Structs

```c
#include <stdio.h>

struct Data {
    int values[10];
    int count;
};

void init_data(struct Data* data) {
    for (int i = 0; i < 10; i++) {
        data->values[i] = i;
    }
    data->count = 10;
}
```

## Nested Structs

```c
#include <stdio.h>

struct Address {
    char street[50];
    char city[20];
    char state[3];
    int zip;
};

struct Person {
    char name[50];
    int age;
    struct Address address;
};

struct Employee {
    char name[50];
    struct Person person;
    int employee_id;
    float salary;
};
```

## Union Types

```c
#include <stdio.h>

// Simple union
union Data {
    int as_int;
    float as_float;
    char as_char;
};

void print_union(union Data* data) {
    printf("As int: %d\n", data->as_int);
    printf("As float: %.2f\n", data->as_float);
    printf("As char: %c\n", data->as_char);
}

// Tagged union
enum DataType {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_STRING,
};

union TaggedData {
    DataType type;
    union Data value;
};

int main() {
    union TaggedData data;
    data.type = TYPE_FLOAT;
    data.value.as_float = 3.14;
    
    switch (data.type) {
        case TYPE_INT:
            printf("Integer value: %d\n", data.value.as_int);
            break;
        case TYPE_FLOAT:
            printf("Float value: %.2f\n", data.value.as_float);
            break;
        case TYPE_STRING:
            printf("String value: %s\n", data.value.as_char);
            break;
    }
    
    return 0;
}
```

## Bit Fields

```c
#include <stdio.h>

// Bit flags in struct
struct Flags {
    unsigned int flag1 : 1;
    unsigned int flag2 : 2;
    unsigned int flag3 : 3;
};

void test_bitfields(struct Flags f) {
    f.flag1 = 1;
    f.flag2 = 0;
    f.flag3 = 1;
    
    printf("Flags: %d %d %d\n", f.flag1, f.flag2, f.flag3);
}

// Bit manipulation
unsigned int toggle_bit(unsigned int flags, int bit) {
    if (bit >= 0 && bit < 32) {
        return flags ^ (1 << bit);
    }
    return flags;
}
```

## Structure Padding

```c
#include <stdio.h>

// Natural padding (compiler-dependent)
struct Padded {
    char a;
    // Compiler may add padding here
    int b;
};

// Explicit padding
#pragma pack(push, 1)
struct ExplicitlyPadded {
    char a;
    int b;
};
#pragma pack(pop)

// Force no padding
#pragma pack(1)
struct NoPadding {
    char a;
    int b;
};
```

## Alignment

```c
#include <stdio.h>

// Aligned structure (compiler-specific)
struct AlignedStruct {
    char a;
    int b;
} __attribute__ ((aligned(8)));

void check_alignment() {
    printf("Size of AlignedStruct: %zu\n", sizeof(AlignedStruct));
}
```

## Flexible Array Member

```c
#include <stdio.h>

struct FlexibleArray {
    int count;
    char data[1];  // Flexible array member
};

int main() {
    struct FlexibleArray fa = {0, "Initial string"};
    
    printf("Flexible array: %s, length: %zu\n", fa.data, strlen(fa.data));
}
```

## Opaque Pointer Type

```c
#include <stdio.h>

// Opaque type hides implementation details
typedef struct Handle Handle_;
typedef void (*Operation)(Handle_);

struct Handle {
    Handle_* opaque;
    Operation* ops;
};

void use_handle(Handle* handle) {
    // Can access only through provided functions
    handle->ops->init(handle);
    handle->ops->process(handle);
}
```

## Function Pointers

```c
#include <stdio.h>

// Function pointers can point to functions
int add(int a, int b) { return a + b; }
int (*operation)(int, int) = &add;

// Array of function pointers
int (*ops[3])(int, int) = {add, add, add};
int (*chosen_op)(int, int) = ops[1];

void call_function_pointers() {
    chosen_op(5, 10);  // Call first addition
}
```

## offsetof Macro

```c
#include <stddef.h>

struct Point {
    int x;
    int y;
};

int main() {
    // Get offset of member
    size_t x_offset = offsetof(struct Point, x);
    size_t y_offset = offsetof(struct Point, y);
    
    printf("Offset of x: %zu\n", x_offset);
    printf("Offset of y: %zu\n", y_offset);
    
    return 0;
}
```

## Sizeof and Alignof

```c
#include <stdio.h>

struct Aligned64 {
    long long x;
    char padding[8];
};

void check_sizes() {
    printf("sizeof(long long): %zu\n", sizeof(long long));
    printf("sizeof(char[8]): %zu\n", sizeof(char[8]));
    printf("Alignof(long long): %zu\n", alignof(long long));
    
    struct Aligned64 a64;
    printf("sizeof(Aligned64): %zu\n", sizeof(a64));
    printf("Offset of x: %zu\n", offsetof(struct Aligned64, x));
}
```

## Common Patterns

### Self-referential Structs

```c
#include <stdio.h>

struct Node {
    int data;
    struct Node* next;
};

void create_linked_list() {
    struct Node* head = NULL;
    struct Node* current = NULL;
    
    // Create first node
    head = malloc(sizeof(struct Node));
    head->data = 1;
    head->next = NULL;
    current = head;
    
    // Create remaining nodes
    for (int i = 1; i < 5; i++) {
        struct Node* node = malloc(sizeof(struct Node));
        node->data = i + 1;
        node->next = NULL;
        
        if (current != NULL) {
            current->next = node;
            current = node;
        }
    }
}
```

### Binary Tree Struct

```c
#include <stdio.h>

struct TreeNode {
    int data;
    struct TreeNode* left;
    struct TreeNode* right;
};

void insert_node(struct TreeNode** root, int value) {
    struct TreeNode* node = malloc(sizeof(struct TreeNode));
    node->data = value;
    node->left = NULL;
    node->right = NULL;
    
    // Insert into BST
    if (*root == NULL) {
        *root = node;
    } else {
        struct TreeNode* current = *root;
        while (true) {
            if (value < current->data) {
                if (current->left == NULL) {
                    struct TreeNode* node = malloc(sizeof(struct TreeNode));
                    node->data = value;
                    node->left = node;
                    current->left->left = node;
                    current = node;
                } else {
                    current = current->left;
                }
            } else if (value > current->data) {
                if (current->right == NULL) {
                    struct TreeNode* node = malloc(sizeof(struct TreeNode));
                    node->data = value;
                    node->right = node;
                    current->right->right = node;
                    current = node;
                } else {
                    current = current->right;
                }
                
                if (current->data == value) {
                    break;  // Found duplicate
                }
            }
            
            current = current;
        }
    }
}
```

### Hash Table Entry Struct

```c
#include <stdio.h>

struct HashEntry {
    int key;
    void* value;
    struct HashEntry* next;
};

int hash_function(int key) {
    return key % 100;
}

void create_hash_table() {
    struct HashEntry* table[100] = {NULL};
    
    // Initialize hash table with empty entries
    for (int i = 0; i < 100; i++) {
        table[i].key = i;
        table[i].value = NULL;
        table[i].next = NULL;
    }
}
```

> **Note**: Be aware of structure padding and alignment issues. Use `pragma pack` carefully when memory layout matters. Consider using flexible array members when appropriate.
