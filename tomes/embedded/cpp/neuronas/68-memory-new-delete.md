---
id: "cpp.memory.new-delete"
title: "new and delete"
category: memory
difficulty: beginner
tags: [cpp, memory, heap, allocation]
keywords: [new, delete, new[], delete[]]
use_cases: [manual memory management (legacy)]
prerequisites: ["cpp.basics.pointers"]
related: ["cpp.memory.smart-pointers"]
next_topics: ["cpp.memory.smart-pointers"]
---

# new and delete

Manual dynamic memory allocation.

## Usage

```cpp
int* p = new int(10); // Allocate int
delete p;             // Free memory

int* arr = new int[5]; // Allocate array
delete[] arr;          // Free array (Note the [])
```

> **Warning**: Prefer smart pointers (`std::unique_ptr`, `std::shared_ptr`) or containers (`std::vector`) in modern C++.
