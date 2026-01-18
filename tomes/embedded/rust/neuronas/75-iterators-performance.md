---
id: "rust.iterators.performance"
title: "Iterator Performance"
category: functions
difficulty: advanced
tags: [rust, iterators, performance, zero-cost]
keywords: [zero-cost abstraction, loop unrolling, vectorization]
use_cases: [optimization, high performance]
prerequisites: ["rust.iterators"]
related: ["rust.intro"]
next_topics: []
---

# Iterator Performance

Iterators in Rust are **zero-cost abstractions**. They compile down to the same (or better) machine code as manual loops.

## Why?

1. **No Bounds Checks**: Iterators don't need to check bounds on every access like `v[i]` does.
2. **Inlining**: The compiler aggressively inlines iterator methods.
3. **Unrolling**: LLVM can unroll iterator loops and vectorize them (SIMD).

> **Guideline**: Prefer iterators over C-style `for` loops or `while` loops for performance-critical code involving slices or vectors.
