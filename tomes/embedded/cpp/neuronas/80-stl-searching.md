---
id: "cpp.stl.searching"
title: "Searching Algorithms"
category: stl
difficulty: intermediate
tags: [cpp, stl, searching, algorithm]
keywords: [find, binary_search, lower_bound, upper_bound]
use_cases: [finding data]
prerequisites: ["cpp.stl.vector"]
related: ["cpp.stl.sorting"]
next_topics: []
---

# Searching

## Linear Search

```cpp
auto it = std::find(v.begin(), v.end(), 5);
if (it != v.end()) { /* found */ }
```

## Binary Search

Requires sorted range. O(log N).

```cpp
bool exists = std::binary_search(v.begin(), v.end(), 5);
auto it = std::lower_bound(v.begin(), v.end(), 5);
```
