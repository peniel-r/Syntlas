---
# TIER 1: ESSENTIAL
id: "cpp.basic.pointers"
title: "Pointers"
tags: [cpp, basics, pointers, intermediate]
links: ["cpp.basic.variables", "cpp.basic.references"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [pointer, address, dereference, nullptr]
prerequisites: ["cpp.basic.variables", "cpp.basic.functions"]
next: ["cpp.basic.references", "cpp.memory.smart-pointers"]
related:
  - id: "cpp.basic.references"
    type: similar
    weight: 90
  - id: "cpp.memory.dynamic-allocation"
    type: complement
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Pointers

Pointers store memory addresses and enable direct memory manipulation and dynamic allocation.

## Pointer Basics

```cpp
int x = 42;
int* ptr = &x;  // ptr stores address of x

std::cout << "Value: " << x << std::endl;           // 42
std::cout << "Address: " << &x << std::endl;         // 0x7fff...
std::cout << "Pointer: " << ptr << std::endl;         // 0x7fff...
std::cout << "Dereferenced: " << *ptr << std::endl; // 42
```

## Null Pointers

```cpp
int* ptr1 = nullptr;  // C++11 preferred
int* ptr2 = NULL;    // C style (avoid)
int* ptr3 = 0;       // Old style (avoid)

// Check before dereferencing
if (ptr1 != nullptr) {
    *ptr1 = 10;
}
```

## Pointer Arithmetic

```cpp
int arr[] = {10, 20, 30, 40, 50};
int* ptr = arr;  // Points to arr[0]

std::cout << *ptr << std::endl;    // 10 (arr[0])
std::cout << *(ptr + 1) << std::endl; // 20 (arr[1])
std::cout << *(ptr + 2) << std::endl; // 30 (arr[2])

ptr++;  // Now points to arr[1]
std::cout << *ptr << std::endl;    // 20
```

## Pointers and Arrays

```cpp
int arr[] = {1, 2, 3, 4, 5};
int* ptr = arr;

// Arrays decay to pointers
for (int i = 0; i < 5; i++) {
    std::cout << *(ptr + i) << " ";  // Same as arr[i]
}

// Pointer iteration
for (int* p = arr; p < arr + 5; p++) {
    std::cout << *p << " ";
}
```

## Pointers to Pointers

```cpp
int x = 10;
int* ptr = &x;
int** ptrptr = &ptr;

std::cout << x << std::endl;       // 10
std::cout << *ptr << std::endl;    // 10
std::cout << **ptrptr << std::endl; // 10
```

## Function Pointers

```cpp
int add(int a, int b) {
    return a + b;
}

int (*funcPtr)(int, int) = &add;
// Or: auto funcPtr = &add;

int result = funcPtr(3, 5);  // 8
```

## Const Pointers

```cpp
int x = 10, y = 20;

// Pointer to const data (can't modify through pointer)
const int* ptr1 = &x;
// *ptr1 = 15;  // Error: can't modify
ptr1 = &y;      // OK: can change pointer

// Const pointer (can't change pointer address)
int* const ptr2 = &x;
*ptr2 = 15;    // OK: can modify data
// ptr2 = &y;   // Error: can't change pointer

// Const pointer to const data
const int* const ptr3 = &x;
// *ptr3 = 15;  // Error
// ptr3 = &y;    // Error
```

## Dynamic Allocation

```cpp
int* ptr = new int;      // Allocate single int
*ptr = 42;
delete ptr;              // Free memory

int* arr = new int[5];   // Allocate array
arr[0] = 1;
arr[1] = 2;
delete[] arr;             // Free array memory
```

## See Also

- [References](cpp.basic.references) - Safer alternative to pointers
- [Smart Pointers](cpp.memory.smart-pointers) - Automatic memory management
