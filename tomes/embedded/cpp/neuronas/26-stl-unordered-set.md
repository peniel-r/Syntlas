---
# TIER 1: ESSENTIAL
id: "cpp.stl.unordered-set"
title: "std::unordered_set"
tags: [cpp, stl, unordered-set, containers, beginner]
links: ["cpp.stl.set", "cpp.stl.algorithm"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [unordered-set, hash-table, unique, associative]
prerequisites: ["cpp.stl.set"]
next: ["cpp.modern.concepts", "cpp.stl.algorithm"]
related:
  - id: "cpp.stl.set"
    type: alternative
    weight: 85
  - id: "cpp.stl.unordered-map"
    type: similar
    weight: 70
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::unordered_set

`std::unordered_set` stores unique elements in no particular order using a hash table.

## Basic Usage

```cpp
#include <unordered_set>

std::unordered_set<int> s;
s.insert(10);
s.insert(20);
s.insert(10);  // Duplicate, not inserted

std::cout << s.size() << std::endl;  // 2
```

## Initialization

```cpp
std::unordered_set<int> s = {10, 20, 30, 10};
// s contains {10, 20, 30} (duplicates removed)
```

## Checking Existence

```cpp
std::unordered_set<int> s = {10, 20, 30};

if (s.find(20) != s.end()) {
    std::cout << "20 exists" << std::endl;
}

if (s.count(40) > 0) {
    std::cout << "40 exists" << std::endl;
}
```

## Operations

```cpp
std::unordered_set<int> s = {10, 20, 30};

s.insert(40);          // Insert element
s.erase(20);           // Remove element
s.size();              // Number of elements
s.empty();             // Check if empty
s.clear();             // Remove all elements
s.bucket_count();      // Number of buckets
s.load_factor();       // Current load factor
```

## Custom Hash

```cpp
struct Person {
    std::string name;
    int age;
};

struct PersonHash {
    size_t operator()(const Person& p) const {
        return std::hash<std::string>()(p.name) ^ 
               std::hash<int>()(p.age);
    }
};

std::unordered_set<Person, PersonHash> s;
```

## See Also

- [std::set](cpp.stl.set) - Ordered set (tree-based)
- [std::unordered_map](cpp.stl.unordered-map) - Hash-based map
