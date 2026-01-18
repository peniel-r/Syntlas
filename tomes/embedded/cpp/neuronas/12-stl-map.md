---
# TIER 1: ESSENTIAL
id: "cpp.stl.map"
title: "std::map"
tags: [cpp, stl, map, containers, beginner]
links: ["cpp.stl.vector", "cpp.stl.algorithm"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [map, key-value, associative, ordered]
prerequisites: ["cpp.stl.vector"]
next: ["cpp.stl.unordered-map", "cpp.stl.algorithm"]
related:
  - id: "cpp.stl.unordered-map"
    type: alternative
    weight: 85
  - id: "cpp.stl.set"
    type: similar
    weight: 70
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::map

`std::map` is an associative container that stores key-value pairs in sorted order.

## Basic Usage

```cpp
#include <map>

std::map<std::string, int> ages;
ages["Alice"] = 25;
ages["Bob"] = 30;
ages["Charlie"] = 35;

// Access by key
std::cout << ages["Alice"] << std::endl;  // 25
```

## Initialization

```cpp
std::map<std::string, int> scores = {
    {"Alice", 95},
    {"Bob", 87},
    {"Charlie", 92}
};
```

## Checking Existence

```cpp
std::map<std::string, int> ages;

if (ages.find("Alice") != ages.end()) {
    std::cout << "Alice exists" << std::endl;
}

// Using count()
if (ages.count("Bob") > 0) {
    std::cout << "Bob exists" << std::endl;
}
```

## Iterating

```cpp
std::map<std::string, int> ages = {{"Alice", 25}, {"Bob", 30}};

// Range-based for
for (const auto& [name, age] : ages) {
    std::cout << name << ": " << age << std::endl;
}

// Using iterators
for (auto it = ages.begin(); it != ages.end(); ++it) {
    std::cout << it->first << ": " << it->second << std::endl;
}
```

## Operations

```cpp
std::map<std::string, int> m = {{"a", 1}, {"b", 2}};

m.insert({"c", 3});        // Insert element
m.erase("b");              // Remove by key
m.size();                  // Number of elements
m.empty();                 // Check if empty
m.clear();                 // Remove all elements
```

## Custom Comparator

```cpp
// Case-insensitive string map
struct CaseInsensitive {
    bool operator()(const std::string& a, const std::string& b) const {
        return std::lexicographical_compare(
            a.begin(), a.end(),
            b.begin(), b.end(),
            [](char c1, char c2) { return tolower(c1) < tolower(c2); }
        );
    }
};

std::map<std::string, int, CaseInsensitive> m;
```

## See Also

- [std::unordered_map](cpp.stl.unordered-map) - Hash-based map (faster, unordered)
- [std::set](cpp.stl.set) - Unique values only
