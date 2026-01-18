---
id: "cpp.util.ratio"
title: "std::ratio"
category: util
difficulty: advanced
tags: [cpp, std, math, templates]
keywords: [ratio, compile-time fractions]
use_cases: [units, chrono]
prerequisites: ["cpp.modern.templates"]
related: ["cpp.util.chrono"]
next_topics: []
---

# std::ratio

Compile-time rational arithmetic.

## Usage

```cpp
#include <ratio>

using one_third = std::ratio<1, 3>;
using two_fourths = std::ratio<2, 4>;

using sum = std::ratio_add<one_third, two_fourths>;
// sum::num == 5, sum::den == 6
```
