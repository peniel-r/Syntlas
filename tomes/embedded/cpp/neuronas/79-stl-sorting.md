---
id: "cpp.stl.sorting"
title: "Sorting Algorithms"
category: stl
difficulty: intermediate
tags: [cpp, stl, sorting, algorithm]
keywords: [sort, stable_sort, partial_sort, nth_element]
use_cases: [ordering data]
prerequisites: ["cpp.stl.vector"]
related: ["cpp.stl.algorithm"]
next_topics: []
---

# Sorting

## std::sort

Sorts elements in range `[first, last)`. O(N log N).

```cpp
std::sort(v.begin(), v.end());
std::sort(v.begin(), v.end(), std::greater<int>());
```

## std::stable_sort

Preserves order of equal elements.

## std::partial_sort

Sorts the top N elements.
