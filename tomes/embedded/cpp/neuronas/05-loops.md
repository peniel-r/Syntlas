---
# TIER 1: ESSENTIAL
id: "cpp.basic.loops"
title: "Loops"
tags: [cpp, basics, loops, beginner]
links: ["cpp.basic.controlflow", "cpp.basic.functions"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [for, while, do-while, range-for]
prerequisites: ["cpp.basic.controlflow"]
next: ["cpp.basic.functions", "cpp.stl.vector"]
related:
  - id: "cpp.modern.ranges"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Loops

Loops allow you to execute code repeatedly based on conditions.

## For Loop

```cpp
// Traditional for loop
for (int i = 0; i < 5; i++) {
    std::cout << i << " ";
}
// Output: 0 1 2 3 4

// Multiple initializers and conditions
for (int i = 0, j = 10; i < j; i++, j--) {
    std::cout << i << " " << j << std::endl;
}
```

## While Loop

```cpp
int i = 0;
while (i < 5) {
    std::cout << i << " ";
    i++;
}
// Output: 0 1 2 3 4
```

## Do-While Loop

```cpp
int i = 0;
do {
    std::cout << i << " ";
    i++;
} while (i < 5);
// Output: 0 1 2 3 4
```

## Range-Based For Loop (C++11)

```cpp
std::vector<int> numbers = {1, 2, 3, 4, 5};

// By value
for (int n : numbers) {
    std::cout << n << " ";
}

// By reference (allows modification)
for (int& n : numbers) {
    n *= 2;  // Modify original
}

// Const reference (read-only)
for (const int& n : numbers) {
    std::cout << n << " ";
}
```

## C++20 Ranges with For Loop

```cpp
#include <ranges>
#include <vector>

std::vector<int> numbers = {1, 2, 3, 4, 5};

// Filter even numbers
for (int n : numbers | std::views::filter([](int x) { return x % 2 == 0; })) {
    std::cout << n << " ";
}
// Output: 2 4

// Transform and filter
for (int n : numbers | std::views::transform([](int x) { return x * 2; })
                       | std::views::take(3)) {
    std::cout << n << " ";
}
// Output: 2 4 6
```

## Infinite Loops

```cpp
// Common pattern: while(true) with break
while (true) {
    std::string input;
    std::cin >> input;
    if (input == "quit") break;
    // Process input
}

// Alternative: for(;;)
for (;;) {
    // Infinite loop
}
```

## See Also

- [Control Flow](cpp.basic.controlflow) - Conditional statements
- [Range Algorithms](cpp.modern.ranges) - Advanced range operations
