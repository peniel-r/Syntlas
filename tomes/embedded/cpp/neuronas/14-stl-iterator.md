---
# TIER 1: ESSENTIAL
id: "cpp.stl.iterator"
title: "Iterators"
tags: [cpp, stl, iterator, intermediate]
links: ["cpp.stl.vector", "cpp.stl.algorithm"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [iterator, begin, end, const-iterator]
prerequisites: ["cpp.stl.vector"]
next: ["cpp.stl.algorithm", "cpp.stl.lambda"]
related:
  - id: "cpp.stl.algorithm"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Iterators

Iterators provide a uniform interface for traversing STL containers.

## Iterator Basics

```cpp
#include <vector>
#include <iostream>

std::vector<int> v = {10, 20, 30, 40, 50};

// Get iterators
auto it = v.begin();   // Points to first element
auto end = v.end();    // Points one past last element

// Dereference
std::cout << *it << std::endl;  // 10

// Advance
++it;  // Now points to 20
std::cout << *it << std::endl;  // 20
```

## Iterator Categories

```cpp
// Input iterator (read-only, forward)
std::istream_iterator<int> it(std::cin);

// Output iterator (write-only, forward)
std::ostream_iterator<int> out(std::cout, " ");

// Forward iterator (read/write, forward)
std::forward_list<int>::iterator fwd;

// Bidirectional iterator (forward and backward)
std::list<int>::iterator bidir;
--bidir;  // Can move backward

// Random access iterator (jump to any position)
std::vector<int>::iterator rand;
rand += 5;  // Jump 5 positions
```

## Iterator Operations

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// Dereference
auto it = v.begin();
*it = 10;  // Modify element

// Arrow operator
std::vector<std::pair<int, int>> v2 = {{1, 2}};
auto it2 = v2.begin();
std::cout << it2->first << std::endl;  // 1

// Advancing
++it;    // Pre-increment
it++;    // Post-increment
--it;    // Decrement (bidirectional+)
it += 3;  // Jump (random access)

// Comparison
if (it != v.end()) { /* ... */ }
if (it < v.end()) { /* ... */ }  // Random access only
```

## Const Iterators

```cpp
std::vector<int> v = {1, 2, 3};

// Const iterator (read-only)
std::vector<int>::const_iterator cit = v.cbegin();
// *cit = 10;  // Error: cannot modify

// Using auto
for (auto it = v.cbegin(); it != v.cend(); ++it) {
    std::cout << *it << " ";  // Read-only
}
```

## Reverse Iterators

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// Reverse iteration
for (auto it = v.rbegin(); it != v.rend(); ++it) {
    std::cout << *it << " ";
}
// Output: 5 4 3 2 1
```

## Iterator Adapters

```cpp
#include <iterator>

std::vector<int> v = {1, 2, 3};

// Reverse iterator
std::reverse_iterator<std::vector<int>::iterator> rit(v.end());
std::cout << *rit << std::endl;  // 3

// Insert iterator
std::back_insert_iterator<std::vector<int>> back_it(v);
*back_it = 4;  // Inserts at end

// Move iterator
std::move_iterator<std::vector<int>::iterator> move_it(v.begin());
```

## See Also

- [STL Algorithms](cpp.stl.algorithm) - Algorithms that use iterators
- [Range-based For](cpp.basic.loops) - Simpler iteration syntax
