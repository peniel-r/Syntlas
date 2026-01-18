---
# TIER 1: ESSENTIAL
id: "cpp.stl.priority-queue"
title: "std::priority_queue"
tags: [cpp, stl, priority-queue, containers, intermediate]
links: ["cpp.stl.queue", "cpp.stl.vector"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [priority-queue, heap, adapter, container]
prerequisites: ["cpp.stl.vector"]
next: ["cpp.stl.priority-queue", "cpp.stl.queue"]
related:
  - id: "cpp.stl.queue"
    type: similar
    weight: 70
  - id: "cpp.stl.priority-queue"
    type: complement
    weight: 80
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::priority_queue

`std::priority_queue` provides priority-based element access (max-heap by default).

## Basic Usage

```cpp
#include <queue>

std::priority_queue<int> pq;
pq.push(10);
pq.push(30);
pq.push(20);

std::cout << pq.top() << std::endl;  // 30 (highest priority)
```

## Common Operations

```cpp
std::priority_queue<int> pq;

pq.push(10);    // Add element
pq.pop();         // Remove top element
pq.top();         // Access top element
pq.size();        // Number of elements
pq.empty();       // Check if empty
```

## Example

```cpp
std::priority_queue<int> pq;
pq.push(10);
pq.push(30);
pq.push(20);

while (!pq.empty()) {
    std::cout << pq.top() << " ";  // 30, 20, 10
    pq.pop();
}
```

## Min-Heap (Custom Comparator)

```cpp
// Min-heap using greater
std::priority_queue<int, std::vector<int>, std::greater<int>> minPq;

minPq.push(10);
minPq.push(30);
minPq.push(20);

std::cout << minPq.top() << std::endl;  // 10 (lowest priority)
```

## Custom Comparator

```cpp
struct Person {
    std::string name;
    int priority;
};

struct PersonCompare {
    bool operator()(const Person& a, const Person& b) {
        return a.priority < b.priority;
    }
};

std::priority_queue<Person, std::vector<Person>, PersonCompare> pq;
```

## See Also

- [std::queue](cpp.stl.queue) - FIFO adapter
- [std::make_heap](cpp.stl.priority-queue) - Heap algorithms
