---
# TIER 1: ESSENTIAL
id: "cpp.stl.stack"
title: "std::stack"
tags: [cpp, stl, stack, containers, beginner]
links: ["cpp.stl.vector", "cpp.stl.deque"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [stack, lifo, adapter, container]
prerequisites: ["cpp.stl.vector"]
next: ["cpp.stl.queue", "cpp.stl.priority-queue"]
related:
  - id: "cpp.stl.queue"
    type: similar
    weight: 80
  - id: "cpp.stl.deque"
    type: complement
    weight: 70
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::stack

`std::stack` is a container adapter providing LIFO (Last-In-First-Out) operations.

## Basic Usage

```cpp
#include <stack>

std::stack<int> s;
s.push(10);  // [10]
s.push(20);  // [10, 20]
s.push(30);  // [10, 20, 30]
```

## Common Operations

```cpp
std::stack<int> s;

s.push(10);      // Add element
s.pop();          // Remove top element
s.top();          // Access top element
s.size();         // Number of elements
s.empty();        // Check if empty
```

## Example

```cpp
std::stack<int> s;

s.push(1);
s.push(2);
s.push(3);

while (!s.empty()) {
    std::cout << s.top() << " ";  // 3, 2, 1
    s.pop();
}
```

## Custom Container

```cpp
// Using deque as underlying container
std::stack<int, std::deque<int>> s;

// Using list as underlying container
std::stack<int, std::list<int>> s2;
```

## See Also

- [std::queue](cpp.stl.queue) - FIFO adapter
- [std::deque](cpp.stl.deque) - Underlying container
