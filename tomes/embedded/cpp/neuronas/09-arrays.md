---
# TIER 1: ESSENTIAL
id: "cpp.basic.arrays"
title: "Arrays"
tags: [cpp, basics, arrays, beginner]
links: ["cpp.basic.variables", "cpp.basic.loops"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [array, c-array, initializer-list, bounds]
prerequisites: ["cpp.basic.variables"]
next: ["cpp.stl.vector", "cpp.oo.structs"]
related:
  - id: "cpp.stl.vector"
    type: alternative
    weight: 95
  - id: "cpp.stl.array"
    type: complement
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Arrays

Arrays store multiple values of the same type in contiguous memory.

## C-Style Arrays

```cpp
int arr[5];                    // Uninitialized array
int arr2[5] = {1, 2, 3, 4, 5};  // Explicit initialization
int arr3[] = {1, 2, 3, 4, 5};       // Size deduced
int arr4[5] = {1, 2, 3};            // Rest initialized to 0
int arr5[5] = {};                    // All elements to 0
```

## Array Access

```cpp
int arr[5] = {10, 20, 30, 40, 50};

std::cout << arr[0] << std::endl;  // 10 (first element)
std::cout << arr[4] << std::endl;  // 50 (last element)

// Out of bounds - undefined behavior!
// std::cout << arr[5];  // DON'T DO THIS
```

## Multidimensional Arrays

```cpp
int matrix[3][4] = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {9, 10, 11, 12}
};

std::cout << matrix[0][2] << std::endl;  // 3
```

## Arrays and Functions

```cpp
// Pass array with size
void printArray(int arr[], int size) {
    for (int i = 0; i < size; i++) {
        std::cout << arr[i] << " ";
    }
}

// Pass by reference (modern approach)
template<size_t N>
void printArrayRef(int (&arr)[N]) {
    for (int i = 0; i < N; i++) {
        std::cout << arr[i] << " ";
    }
}
```

## Array Decay

```cpp
int arr[10];
int* ptr = arr;  // Arrays decay to pointers

sizeof(arr);   // 40 (10 * 4 bytes)
sizeof(ptr);   // 8 (pointer size on 64-bit)
```

## Range-Based For Loop

```cpp
int arr[5] = {1, 2, 3, 4, 5};

// By value
for (int x : arr) {
    std::cout << x << " ";
}

// By reference
for (int& x : arr) {
    x *= 2;  // Modify original
}
```

## See Also

- [std::vector](cpp.stl.vector) - Dynamic array with automatic memory management
- [std::array](cpp.stl.array) - Fixed-size array with STL interface
