---
id: "cpp.stl.execution"
title: "Parallel Algorithms (C++17)"
category: stl
difficulty: advanced
tags: [cpp, stl, execution, parallel]
keywords: [execution, par, seq, par_unseq]
use_cases: [multi-core processing]
prerequisites: ["cpp.stl.algorithm"]
related: ["cpp.stl.algorithm"]
next_topics: []
---

# Parallel Algorithms

Standard algorithms can accept an execution policy.

## Usage

```cpp
#include <algorithm>
#include <execution>

std::sort(std::execution::par, v.begin(), v.end());
```

## Policies

- `seq`: Sequential (default).
- `par`: Parallel.
- `par_unseq`: Parallel and vectorized.
