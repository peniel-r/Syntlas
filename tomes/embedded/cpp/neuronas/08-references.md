---
# TIER 1: ESSENTIAL
id: "cpp.basic.references"
title: "References"
tags: [cpp, basics, references, intermediate]
links: ["cpp.basic.pointers", "cpp.basic.functions"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [reference, alias, const-reference, rvalue]
prerequisites: ["cpp.basic.variables", "cpp.basic.pointers"]
next: ["cpp.oo.classes", "cpp.stl.vector"]
related:
  - id: "cpp.basic.pointers"
    type: similar
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# References

References provide an alias for an existing variable, offering a safer alternative to pointers.

## Basic References

```cpp
int x = 42;
int& ref = x;  // ref is an alias for x

ref = 10;      // Modifies x
std::cout << x << std::endl;  // 10
```

## References vs Pointers

```cpp
// Pointer
int x = 42;
int* ptr = &x;
*ptr = 10;       // Must dereference

// Reference
int& ref = x;
ref = 10;        // No dereference needed
```

**Key Differences:**
- References must be initialized when declared
- References cannot be nullptr
- References cannot be reassigned
- References have no address (they are aliases)

## References in Function Parameters

```cpp
// Pass by reference (no copy, can modify)
void increment(int& n) {
    n++;
}

int value = 5;
increment(value);
std::cout << value << std::endl;  // 6
```

## Const References

```cpp
// Pass by const reference (no copy, read-only)
void print(const std::string& s) {
    std::cout << s << std::endl;
    // s = "new";  // Error: can't modify
}

print("Hello");  // Efficient: no string copy
```

## Returning References

```cpp
int& getElement(int arr[], int index) {
    return arr[index];  // Returns reference to element
}

int arr[] = {1, 2, 3};
getElement(arr, 0) = 10;  // Modify array element
```

## Rvalue References (C++11)

```cpp
// Rvalue reference (binds to temporary)
int&& rref = 42;  // OK: 42 is rvalue
// int&& rref2 = x; // Error: x is lvalue

// Perfect forwarding
template<typename T>
void wrapper(T&& arg) {
    process(std::forward<T>(arg));
}
```

## See Also

- [Pointers](cpp.basic.pointers) - Memory addresses
- [Move Semantics](cpp.modern.move-semantics) - Rvalue references in action
