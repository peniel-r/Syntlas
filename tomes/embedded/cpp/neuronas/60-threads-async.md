---
id: "cpp.threads.async"
title: "std::async"
category: concurrency
difficulty: intermediate
tags: [cpp, threads, async, task]
keywords: [async, launch::async, launch::deferred]
use_cases: [simple parallel tasks]
prerequisites: ["cpp.threads.future"]
related: ["cpp.threads.future"]
next_topics: []
---

# std::async

Runs a function asynchronously (potentially in a new thread) and returns a `std::future` that will eventually hold the result.

## Policies

- `std::launch::async`: Run in new thread immediately.
- `std::launch::deferred`: Run lazily when `get()` is called.

```cpp
auto f1 = std::async(std::launch::async, []{ return 1; });
auto f2 = std::async(std::launch::async, []{ return 2; });

int res = f1.get() + f2.get();
```
