---
id: "cpp.util.chrono"
title: "std::chrono"
category: util
difficulty: intermediate
tags: [cpp, std, time, chrono]
keywords: [chrono, duration, time_point, steady_clock]
use_cases: [timing, delays, timestamps]
prerequisites: ["cpp.basic.variables"]
related: ["cpp.util.ratio"]
next_topics: []
---

# std::chrono

Time utilities.

## Duration

```cpp
#include <chrono>
using namespace std::chrono;

milliseconds ms(250);
seconds s(1);
auto total = s + ms; // 1250ms
```

## Clocks

- `system_clock`: Wall time.
- `steady_clock`: Monotonic time (stopwatch).

```cpp
auto start = steady_clock::now();
// ...
auto end = steady_clock::now();
auto diff = end - start;
```
