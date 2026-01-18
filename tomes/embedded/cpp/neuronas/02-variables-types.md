---
# TIER 1: ESSENTIAL
id: "cpp.basic.variables"
title: "Variables and Types"
tags: [cpp, basics, variables, types, beginner]
links: ["cpp.basic.syntax", "cpp.basic.operators"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [int, double, char, bool, string, auto]
prerequisites: ["cpp.basic.syntax"]
next: ["cpp.basic.operators", "cpp.basic.controlflow"]
related:
  - id: "cpp.modern.type-inference"
    type: complement
    weight: 85
  - id: "cpp.basic.variables"
    type: complement
    weight: 80
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Variables and Types

C++ provides several built-in data types for storing different kinds of values.

## Fundamental Types

### Integer Types
```cpp
int age = 25;           // Typically 4 bytes
short s = 10;           // At least 2 bytes
long l = 100000L;       // At least 4 bytes
long long ll = 1e18LL;  // At least 8 bytes (C++11)
unsigned int x = 42;    // Non-negative
```

### Floating-Point Types
```cpp
float price = 19.99f;   // Single precision (4 bytes)
double pi = 3.14159;    // Double precision (8 bytes)
long double ld = 1.0L;  // Extended precision
```

### Character and Boolean
```cpp
char grade = 'A';       // Single character (1 byte)
bool isActive = true;   // Boolean value
```

### String (C++11)
```cpp
#include <string>

std::string name = "Alice";
std::string empty;      // Empty string
```

## Type Deduction (auto)

```cpp
auto x = 42;            // int
auto y = 3.14;          // double
auto z = "hello";       // const char*

auto& ref = x;          // int&
const auto cx = x;      // const int
```

## Initialization

```cpp
int a = 10;             // Copy initialization
int b(20);              // Direct initialization
int c{30};              // List initialization (C++11) - preferred

// Avoid narrowing conversions
int d{3.14};            // Error: narrowing from double to int
```

## Constants

```cpp
const int MAX_AGE = 150;  // Compile-time constant
constexpr double PI = 3.14159;  // Must be compile-time evaluatable

// Enum for related constants
enum Color { RED, GREEN, BLUE };
Color c = RED;
```

## See Also

- [Operators](cpp.basic.operators) - Arithmetic and comparison operators
- [Control Flow](cpp.basic.controlflow) - Loops and conditionals
- [Type Inference](cpp.modern.type-inference) - Advanced auto usage
