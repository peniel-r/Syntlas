---
id: "cpp.stl.numeric"
title: "Numeric Algorithms"
category: stl
difficulty: intermediate
tags: [cpp, stl, numeric, math]
keywords: [accumulate, iota, reduce, inner_product]
use_cases: [summation, generating sequences]
prerequisites: ["cpp.stl.vector"]
related: ["cpp.stl.algorithm"]
next_topics: []
---

# Numeric Algorithms

Header `<numeric>` contains algorithms for numeric processing.

## Examples

```cpp
#include <numeric>
#include <vector>

std::vector<int> v(10);

// iota: Fill with 0, 1, 2...
std::iota(v.begin(), v.end(), 0);

// accumulate: Sum
int sum = std::accumulate(v.begin(), v.end(), 0);
```
