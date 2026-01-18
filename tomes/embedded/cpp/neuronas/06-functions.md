---
# TIER 1: ESSENTIAL
id: "cpp.basic.functions"
title: "Functions"
tags: [cpp, basics, functions, beginner]
links: ["cpp.basic.variables", "cpp.basic.loops"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [function, return, parameter, argument, overload]
prerequisites: ["cpp.basic.variables"]
next: ["cpp.basic.pointers", "cpp.stl.vector"]
related:
  - id: "cpp.modern.lambdas"
    type: complement
    weight: 85
  - id: "cpp.modern.type-inference"
    type: complement
    weight: 80
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Functions

Functions are reusable blocks of code that perform specific tasks.

## Basic Function

```cpp
// Function declaration (prototype)
int add(int a, int b);

// Function definition
int add(int a, int b) {
    return a + b;
}

// Function call
int result = add(3, 5);  // result = 8
```

## Function with Default Parameters

```cpp
void greet(std::string name, int times = 1) {
    for (int i = 0; i < times; i++) {
        std::cout << "Hello, " << name << "!" << std::endl;
    }
}

greet("Alice");      // Once
greet("Bob", 3);    // Three times
```

## Function Overloading

```cpp
int add(int a, int b) {
    return a + b;
}

double add(double a, double b) {
    return a + b;
}

// Compiler chooses based on argument types
int x = add(1, 2);        // Calls int version
double y = add(1.5, 2.5); // Calls double version
```

## Pass by Value vs Reference

```cpp
// Pass by value (copy)
void square(int x) {
    x = x * x;  // Only affects local copy
}

// Pass by reference (no copy, can modify)
void square(int& x) {
    x = x * x;  // Modifies original
}

// Pass by const reference (no copy, read-only)
void print(const int& x) {
    std::cout << x << std::endl;
}
```

## Return Multiple Values (C++11 Structured Bindings)

```cpp
#include <tuple>

std::tuple<int, double, std::string> getData() {
    return {42, 3.14, "hello"};
}

// Unpack tuple
auto [num, pi, text] = getData();
// num = 42, pi = 3.14, text = "hello"
```

## Inline Functions

```cpp
// Suggests compiler to insert function code at call site
inline int max(int a, int b) {
    return (a > b) ? a : b;
}
```

## C++11 Lambda Functions

```cpp
auto add = [](int a, int b) {
    return a + b;
};

int result = add(3, 5);  // 8

// Lambda with capture
int multiplier = 2;
auto multiply = [multiplier](int x) {
    return x * multiplier;
};

int result2 = multiply(5);  // 10
```

## C++14 Return Type Deduction

```cpp
auto multiply(int a, int b) {  // Return type deduced as int
    return a * b;
}
```

## See Also

- [Pointers](cpp.basic.pointers) - Memory addresses and indirection
- [Lambdas](cpp.modern.lambdas) - Advanced lambda features
