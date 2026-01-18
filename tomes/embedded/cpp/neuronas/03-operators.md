---
# TIER 1: ESSENTIAL
id: "cpp.basic.operators"
title: "Operators"
tags: [cpp, basics, operators, beginner]
links: ["cpp.basic.variables", "cpp.basic.controlflow"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [arithmetic, logical, comparison, bitwise]
prerequisites: ["cpp.basic.variables"]
next: ["cpp.basic.controlflow", "cpp.modern.lambdas"]
related:
  - id: "cpp.basic.overloading"
    type: complement
    weight: 75
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Operators

C++ provides a rich set of operators for performing arithmetic, logical, and bitwise operations.

## Arithmetic Operators

```cpp
int a = 10, b = 3;

a + b;   // Addition: 13
a - b;   // Subtraction: 7
a * b;   // Multiplication: 30
a / b;   // Division: 3 (integer division)
a % b;   // Modulus: 1 (remainder)
++a;     // Prefix increment: 11
a++;     // Postfix increment: 11
--a;     // Prefix decrement
a--;     // Postfix decrement
```

## Comparison Operators

```cpp
int x = 5, y = 10;

x == y;  // Equal to: false
x != y;  // Not equal to: true
x < y;   // Less than: true
x > y;   // Greater than: false
x <= y;  // Less than or equal: true
x >= y;  // Greater than or equal: false
```

## Logical Operators

```cpp
bool a = true, b = false;

a && b;  // Logical AND: false
a || b;  // Logical OR: true
!a;      // Logical NOT: false
```

## Bitwise Operators

```cpp
unsigned int x = 5;  // Binary: 0101

x << 1;   // Left shift: 10 (1010)
x >> 1;   // Right shift: 2 (0010)
x & 3;    // Bitwise AND: 1 (0001)
x | 2;    // Bitwise OR: 7 (0111)
x ^ 3;    // Bitwise XOR: 6 (0110)
~x;       // Bitwise NOT: -6 (1010)
```

## Assignment Operators

```cpp
int x = 10;

x += 5;   // x = x + 5;  (15)
x -= 3;   // x = x - 3;  (12)
x *= 2;   // x = x * 2;  (24)
x /= 4;   // x = x / 4;  (6)
x %= 4;   // x = x % 4;  (2)
x <<= 1;  // x = x << 1;
x >>= 1;  // x = x >> 1;
x &= 3;   // x = x & 3;
x |= 2;   // x = x | 2;
x ^= 3;   // x = x ^ 3;
```

## Ternary Operator

```cpp
int age = 20;
std::string status = (age >= 18) ? "adult" : "minor";

// Equivalent to:
std::string status;
if (age >= 18) {
    status = "adult";
} else {
    status = "minor";
}
```

## Operator Precedence

```cpp
// Parentheses override precedence
int result = (2 + 3) * 4;  // 20

// Without parentheses, * has higher precedence
int result = 2 + 3 * 4;    // 14
```

## See Also

- [Control Flow](cpp.basic.controlflow) - Using operators in conditionals
- [Operator Overloading](cpp.basic.overloading) - Custom operators for types
