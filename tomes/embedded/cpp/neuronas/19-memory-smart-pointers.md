---
# TIER 1: ESSENTIAL
id: "cpp.memory.smart-pointers"
title: "Smart Pointers"
tags: [cpp, memory, smart-pointers, intermediate]
links: ["cpp.basic.pointers", "cpp.oo.constructors"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: memory
difficulty: intermediate
keywords: [unique-ptr, shared-ptr, weak-ptr, memory-management]
prerequisites: ["cpp.basic.pointers", "cpp.oo.classes"]
next: ["cpp.memory.move-semantics", "cpp.modern.rule-of-five"]
related:
  - id: "cpp.memory.dynamic-allocation"
    type: alternative
    weight: 80
  - id: "cpp.modern.rule-of-zero"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Smart Pointers

Smart pointers automatically manage memory, preventing leaks and dangling pointers.

## unique_ptr

```cpp
#include <memory>

std::unique_ptr<int> ptr1(new int(42));
// Or C++14: auto ptr1 = std::make_unique<int>(42);

std::cout << *ptr1 << std::endl;  // 42

// Automatically deleted when out of scope
{
    std::unique_ptr<int> ptr2(new int(100));
    // ptr2 automatically deleted here
}

// Cannot copy, only move
std::unique_ptr<int> ptr3 = std::move(ptr1);
// ptr1 is now nullptr
```

## shared_ptr

```cpp
std::shared_ptr<int> ptr1 = std::make_shared<int>(42);
std::shared_ptr<int> ptr2 = ptr1;  // Share ownership

std::cout << ptr1.use_count() << std::endl;  // 2

// Automatically deleted when last shared_ptr goes out of scope
```

## weak_ptr

```cpp
std::shared_ptr<int> shared = std::make_shared<int>(42);
std::weak_ptr<int> weak = shared;

// Check if expired
if (!weak.expired()) {
    std::shared_ptr<int> locked = weak.lock();
    std::cout << *locked << std::endl;
}
```

## Custom Deleters

```cpp
void customDeleter(int* p) {
    std::cout << "Custom delete" << std::endl;
    delete p;
}

std::unique_ptr<int, decltype(&customDeleter)> ptr(new int(42), customDeleter);
```

## See Also

- [Move Semantics](cpp.modern.move-semantics) - Understanding move operations
- [Rule of Zero](cpp.modern.rule-of-zero) - Avoid manual resource management
