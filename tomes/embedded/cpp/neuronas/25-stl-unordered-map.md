---
# TIER 1: ESSENTIAL
id: "cpp.stl.unordered-map"
title: "std::unordered_map"
tags: [cpp, stl, unordered-map, containers, beginner]
links: ["cpp.stl.map", "cpp.stl.algorithm"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [unordered-map, hash-table, key-value, associative]
prerequisites: ["cpp.stl.map"]
next: ["cpp.stl.unordered-set", "cpp.modern.concepts"]
related:
  - id: "cpp.stl.map"
    type: alternative
    weight: 85
  - id: "cpp.stl.unordered-set"
    type: similar
    weight: 70
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::unordered_map

`std::unordered_map` is a hash table storing key-value pairs in no particular order.

## Basic Usage

```cpp
#include <unordered_map>

std::unordered_map<std::string, int> ages;
ages["Alice"] = 25;
ages["Bob"] = 30;
ages["Charlie"] = 35;

// Access by key
std::cout << ages["Alice"] << std::endl;  // 25
```

## Initialization

```cpp
std::unordered_map<std::string, int> scores = {
    {"Alice", 95},
    {"Bob", 87},
    {"Charlie", 92}
};
```

## Checking Existence

```cpp
std::unordered_map<std::string, int> ages;

if (ages.find("Alice") != ages.end()) {
    std::cout << "Alice exists" << std::endl;
}

// Using count()
if (ages.count("Bob") > 0) {
    std::cout << "Bob exists" << std::endl;
}
```

## Operations

```cpp
std::unordered_map<std::string, int> m = {{"a", 1}, {"b", 2}};

m.insert({"c", 3});        // Insert element
m.erase("b");              // Remove by key
m.size();                  // Number of elements
m.empty();                 // Check if empty
m.clear();                 // Remove all elements
m.bucket_count();          // Number of buckets
m.max_load_factor();       // Current load factor
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

std::unordered_map<Person, int, PersonHash> m;
```

## See Also

- [std::map](cpp.stl.map) - Ordered map (tree-based)
- [std::unordered_set](cpp.stl.unordered-set) - Hash-based set
