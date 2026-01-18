---
# TIER 1: ESSENTIAL
id: "cpp.stl.algorithm"
title: "STL Algorithms"
tags: [cpp, stl, algorithm, intermediate]
links: ["cpp.stl.vector", "cpp.stl.map"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [algorithm, sort, find, transform, for-each]
prerequisites: ["cpp.stl.vector", "cpp.stl.iterator"]
next: ["cpp.stl.lambda", "cpp.modern.ranges"]
related:
  - id: "cpp.stl.lambda"
    type: complement
    weight: 90
  - id: "cpp.modern.ranges"
    type: alternative
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# STL Algorithms

The STL provides over 60 algorithms that operate on containers.

## Sorting

```cpp
#include <algorithm>
#include <vector>

std::vector<int> v = {4, 2, 5, 1, 3};

// Ascending sort
std::sort(v.begin(), v.end());
// v = {1, 2, 3, 4, 5}

// Descending sort
std::sort(v.begin(), v.end(), std::greater<int>());
// v = {5, 4, 3, 2, 1}

// Custom comparator
std::sort(v.begin(), v.end(), [](int a, int b) {
    return a % 2 < b % 2;  // Even numbers first
});
```

## Finding

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

auto it = std::find(v.begin(), v.end(), 3);
if (it != v.end()) {
    std::cout << "Found: " << *it << std::endl;
}

// Find if with condition
auto it2 = std::find_if(v.begin(), v.end(), [](int x) {
    return x > 3;
});
// Points to 4

// Check if all satisfy condition
bool allPositive = std::all_of(v.begin(), v.end(), [](int x) {
    return x > 0;
});
```

## Counting

```cpp
std::vector<int> v = {1, 2, 3, 1, 1};

// Count occurrences
int count = std::count(v.begin(), v.end(), 1);
// count = 3

// Count with condition
int count2 = std::count_if(v.begin(), v.end(), [](int x) {
    return x % 2 == 0;
});
// count2 = 1 (only 2)
```

## Transform

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
std::vector<int> result(5);

std::transform(v.begin(), v.end(), result.begin(), [](int x) {
    return x * 2;
});
// result = {2, 4, 6, 8, 10}

// In-place transform
std::transform(v.begin(), v.end(), v.begin(), [](int x) {
    return x + 1;
});
// v = {2, 3, 4, 5, 6}
```

## For Each

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

std::for_each(v.begin(), v.end(), [](int x) {
    std::cout << x << " ";
});
// Output: 1 2 3 4 5

// With side effect
int sum = 0;
std::for_each(v.begin(), v.end(), [&sum](int x) {
    sum += x;
});
// sum = 15
```

## Accumulate

```cpp
#include <numeric>

std::vector<int> v = {1, 2, 3, 4, 5};

int sum = std::accumulate(v.begin(), v.end(), 0);
// sum = 15

int product = std::accumulate(v.begin(), v.end(), 1,
    [](int a, int b) { return a * b; });
// product = 120
```

## Copy and Remove

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
std::vector<int> v2(5);

std::copy(v.begin(), v.end(), v2.begin());
// v2 = {1, 2, 3, 4, 5}

// Remove even numbers (doesn't actually remove)
auto newEnd = std::remove_if(v.begin(), v.end(), [](int x) {
    return x % 2 == 0;
});
v.erase(newEnd, v.end());
// v = {1, 3, 5}
```

## See Also

- [Lambdas](cpp.stl.lambda) - Function objects for algorithms
- [Ranges](cpp.modern.ranges) - Modern algorithm interface (C++20)
