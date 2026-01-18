---
# TIER 1: ESSENTIAL
id: "cpp.stl.queue"
title: "std::queue"
tags: [cpp, stl, queue, containers, beginner]
links: ["cpp.stl.deque", "cpp.stl.stack"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [queue, fifo, adapter, container]
prerequisites: ["cpp.stl.deque"]
next: ["cpp.stl.priority-queue", "cpp.stl.stack"]
related:
  - id: "cpp.stl.stack"
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

# std::queue

`std::queue` is a container adapter providing FIFO (First-In-First-Out) operations.

## Basic Usage

```cpp
#include <queue>

std::queue<int> q;
q.push(10);  // [10]
q.push(20);  // [10, 20]
q.push(30);  // [10, 20, 30]
```

## Common Operations

```cpp
std::queue<int> q;

q.push(10);      // Add element to back
q.pop();          // Remove front element
q.front();        // Access front element
q.back();         // Access back element
q.size();         // Number of elements
q.empty();        // Check if empty
```

## Example

```cpp
std::queue<int> q;

q.push(1);
q.push(2);
q.push(3);

while (!q.empty()) {
    std::cout << q.front() << " ";  // 1, 2, 3
    q.pop();
}
```

## Custom Container

```cpp
// Using list as underlying container
std::queue<int, std::list<int>> q;

// Using deque as underlying container (default)
std::queue<int, std::deque<int>> q2;
```

## See Also

- [std::stack](cpp.stl.stack) - LIFO adapter
- [std::priority_queue](cpp.stl.priority-queue) - Priority-based queue
