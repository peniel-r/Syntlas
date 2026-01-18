---
id: "cpp.stl.transform"
title: "Transform and Modifying"
category: stl
difficulty: intermediate
tags: [cpp, stl, algorithm, transform]
keywords: [transform, copy, replace, remove_if]
use_cases: [mapping values, filtering]
prerequisites: ["cpp.stl.vector"]
related: ["cpp.modern.lambdas"]
next_topics: []
---

# Modifying Algorithms

## std::transform

Applies function to range.

```cpp
std::transform(v.begin(), v.end(), v.begin(), 
               [](int i) { return i * 2; });
```

## Erase-Remove Idiom

To remove elements from vector:

```cpp
v.erase(std::remove(v.begin(), v.end(), 99), v.end());
```
