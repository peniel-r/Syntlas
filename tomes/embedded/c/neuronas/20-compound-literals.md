---
id: "c.compound-literals"
title: "Compound Literals"
category: language
difficulty: intermediate
tags: [c, compound literals, anonymous structs, temporary objects]
keywords: [compound literal, cast syntax, temporary struct]
use_cases: [api calls, temporary data, struct initialization]
prerequisites: []
related: []
next_topics: []
---

# Compound Literals

Compound literals create temporary unnamed objects.

## Syntax

```c
// (type){ initializer-list }
struct Point { int x; int y; };

// Create temporary Point
struct Point p = (struct Point){ .x = 10, .y = 20 };

// As expression (C99)
struct Point make_point(int x, int y) {
    return (struct Point){ .x = x, .y = y };
}
```

## Basic Usage

```c
struct Point { int x; int y; };

// Pass temporary struct to function
void print_point(struct Point p) {
    printf("(%d, %d)\n", p.x, p.y);
}

// Call with compound literal
print_point((struct Point){ 10, 20 });
// No need for separate variable
```

## Arrays

```c
// Temporary array
int* arr = (int[]){1, 2, 3, 4, 5};

// Pass to function
void sum_array(int arr[], int n);
sum_array((int[]){1, 2, 3, 4, 5}, 5);

// Initialize with loop
for (int i = 0; i < 5; i++) {
    printf("%d ", ((int[]){1, 2, 3, 4, 5})[i]);
}
```

## With const

```c
// Read-only compound literal
const struct Point* p = &(const struct Point){ .x = 10, .y = 20 };
// p->x = 15;  // Error: cannot modify

// Const array
const char* str = (const char[]){"Hello, World!"};
// str[0] = 'J';  // Error
```

## Memory Lifetime

```c
// Compound literal has automatic storage duration
// Lifetime is limited to the enclosing block

struct Point* create_point(int x, int y) {
    // ERROR: Returns pointer to temporary!
    return &(struct Point){ .x = x, .y = y };
    // Compound literal is destroyed when function returns
}

// CORRECT: Allocate on heap
struct Point* create_point(int x, int y) {
    struct Point* p = malloc(sizeof(struct Point));
    *p = (struct Point){ .x = x, .y = y };
    return p;
}
```

## In Struct Initialization

```c
struct Rect {
    struct Point top_left;
    struct Point bottom_right;
};

// Use compound literals to initialize nested structs
struct Rect rect = {
    .top_left = (struct Point){ 0, 0 },
    .bottom_right = (struct Point){ 100, 100 }
};
```

## In Array Initialization

```c
struct Point points[] = {
    (struct Point){ 0, 0 },
    (struct Point){ 10, 10 },
    (struct Point){ 20, 20 }
};

// 2D array
int matrix[3][3] = {
    (int[]){1, 2, 3},
    (int[]){4, 5, 6},
    (int[]){7, 8, 9}
};
```

## API Function Calls

```c
// API function expecting struct pointer
void configure_device(struct Config* cfg);

// Pass temporary config
configure_device(&(struct Config){
    .timeout = 30,
    .retries = 3,
    .debug = 0
});

// Without compound literal
struct Config cfg;
cfg.timeout = 30;
cfg.retries = 3;
cfg.debug = 0;
configure_device(&cfg);
```

## Union Compound Literals

```c
union Data {
    int i;
    float f;
    char str[20];
};

void process_data(union Data* data);

// Pass different types
process_data(&(union Data){ .i = 42 });
process_data(&(union Data){ .f = 3.14f });
process_data(&(union Data){ .str = "Hello" });
```

## Return from Functions

```c
struct Complex {
    float real;
    float imag;
};

// Create and return complex number
struct Complex make_complex(float real, float imag) {
    return (struct Complex){ .real = real, .imag = imag };
}

// Usage
struct Complex z = make_complex(3.0f, 4.0f);
```

## Function Arguments

```c
struct BoundingBox {
    float min_x, min_y;
    float max_x, max_y;
};

bool point_in_box(struct Point p, struct BoundingBox box);

// Call with temporary box
struct Point p = {50, 50};
bool inside = point_in_box(
    p,
    (struct BoundingBox){
        .min_x = 0, .min_y = 0,
        .max_x = 100, .max_y = 100
    }
);
```

## Common Patterns

### Configuration Override

```c
struct Config get_default_config() {
    return (struct Config){
        .timeout = 30,
        .retries = 3,
        .debug = 0
    };
}

// Override specific settings
struct Config get_config_with_debug() {
    struct Config cfg = get_default_config();
    cfg.debug = 1;
    return cfg;
}
```

### Temporary Buffer

```c
void process_data(const char* data) {
    // Create temporary buffer
    char* buffer = (char[1024]){0};

    strcpy(buffer, data);
    // Process buffer
    transform(buffer);

    // buffer is automatically freed when scope ends
}
```

### Struct Constructor

```c
struct Color {
    unsigned char r, g, b, a;
};

// Factory function
struct Color make_color(unsigned char r, unsigned char g,
                     unsigned char b, unsigned char a) {
    return (struct Color){ .r = r, .g = g, .b = b, .a = a };
}

// Preset colors
struct Color red() { return make_color(255, 0, 0, 255); }
struct Color green() { return make_color(0, 255, 0, 255); }
struct Color blue() { return make_color(0, 0, 255, 255); }
```

### API Wrapper

```c
// Low-level API
void send_message(struct Message* msg);

// High-level wrapper
void send_text(const char* text) {
    send_message(&(struct Message){
        .type = MSG_TEXT,
        .data = (void*)text,
        .length = strlen(text)
    });
}

void send_command(int cmd, int param) {
    send_message(&(struct Message){
        .type = MSG_COMMAND,
        .data = (void*)(uintptr_t)param,
        .length = sizeof(param)
    });
}
```

### Data Transformation

```c
struct Vector {
    float x, y, z;
};

struct Vector add(struct Vector a, struct Vector b) {
    return (struct Vector){
        .x = a.x + b.x,
        .y = a.y + b.y,
        .z = a.z + b.z
    };
}

// Usage
struct Vector v1 = {1, 2, 3};
struct Vector v2 = {4, 5, 6};
struct Vector result = add(v1, v2);
```

## Common Mistakes

```c
// ❌ WRONG: Returning pointer to temporary
struct Point* get_origin() {
    return &(struct Point){ 0, 0 };  // DANGEROUS!
}

// ✅ CORRECT: Return by value
struct Point get_origin() {
    return (struct Point){ 0, 0 };
}

// ❌ WRONG: Storing pointer to temporary
struct Point* global_point;
void init_global() {
    global_point = &(struct Point){ 10, 20 };  // Undefined!
}

// ✅ CORRECT: Allocate or use static
struct Point* global_point;
void init_global() {
    global_point = malloc(sizeof(struct Point));
    *global_point = (struct Point){ 10, 20 };
}
```

## Advanced: Nested Compound Literals

```c
struct Matrix {
    float m[3][3];
};

// Initialize matrix with compound literals
struct Matrix identity = {
    .m = {
        (float[]){1, 0, 0},
        (float[]){0, 1, 0},
        (float[]){0, 0, 1}
    }
};

// Matrix multiplication
struct Matrix multiply(struct Matrix a, struct Matrix b) {
    struct Matrix result = { .m = (float[3][3]){0} };

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            for (int k = 0; k < 3; k++) {
                result.m[i][j] += a.m[i][k] * b.m[k][j];
            }
        }
    }
    return result;
}
```

## Comparison with Traditional Methods

```c
// Method 1: Traditional (verbose)
struct Point p1;
p1.x = 10;
p1.y = 20;

// Method 2: Initializer (order-dependent)
struct Point p2 = {10, 20};

// Method 3: Designated initializer
struct Point p3 = { .x = 10, .y = 20 };

// Method 4: Compound literal (C99)
struct Point p4 = (struct Point){ .x = 10, .y = 20 };

// Method 4 as expression
use_point((struct Point){ .x = 10, .y = 20 });
```

> **Note**: Compound literals are C99 feature. Ensure your compiler supports C99 or later.
