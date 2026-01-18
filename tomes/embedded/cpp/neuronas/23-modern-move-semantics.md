---
# TIER 1: ESSENTIAL
id: "cpp.modern.move-semantics"
title: "Move Semantics"
tags: [cpp, modern, move-semantics, intermediate]
links: ["cpp.basic.references", "cpp.oo.constructors"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [move, rvalue, lvalue, noexcept]
prerequisites: ["cpp.basic.references", "cpp.oo.constructors"]
next: ["cpp.modern.rule-of-five", "cpp.memory.smart-pointers"]
related:
  - id: "cpp.oo.copy"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Move Semantics

Move semantics allow efficient transfer of resources instead of copying.

## Lvalues vs Rvalues

```cpp
int x = 42;    // x is lvalue (has address)
int& lref = x;  // OK: bind lvalue reference
// int& rref = 10;  // Error: 10 is rvalue

int&& rref = 10; // OK: bind rvalue reference
int&& rref2 = std::move(x);  // OK: cast to rvalue
```

## std::move

```cpp
#include <utility>

std::string s1 = "Hello";
std::string s2 = std::move(s1);  // Move s1 to s2

std::cout << s1 << std::endl;  // Empty (moved from)
std::cout << s2 << std::endl;  // "Hello"
```

## Move Constructor

```cpp
class String {
private:
    char* data;
    size_t size;

public:
    // Move constructor
    String(String&& other) noexcept
        : data(other.data), size(other.size) {
        other.data = nullptr;
        other.size = 0;
    }
};
```

## Move Assignment

```cpp
class String {
public:
    // Move assignment
    String& operator=(String&& other) noexcept {
        if (this != &other) {
            delete[] data;
            data = other.data;
            size = other.size;
            other.data = nullptr;
            other.size = 0;
        }
        return *this;
    }
};
```

## Return Value Optimization

```cpp
std::string createString() {
    std::string s = "Hello";
    return s;  // Move semantics applied automatically
}

std::string result = createString();  // Moved, not copied
```

## See Also

- [Rule of Five](cpp.modern.rule-of-five) - Complete move semantics
- [Smart Pointers](cpp.memory.smart-pointers) - Automatic resource management
