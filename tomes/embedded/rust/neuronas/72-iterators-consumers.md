---
id: "rust.iterators.consumers"
title: "Iterator Consumers"
category: functions
difficulty: intermediate
tags: [rust, iterators, functional, sum, collect]
keywords: [sum, product, collect, fold, any, all]
use_cases: [aggregation, reduction]
prerequisites: ["rust.iterators"]
related: ["rust.iterators.adapters"]
next_topics: []
---

# Iterator Consumers

Consumers drive the iterator and produce a final value.

## Common Consumers

```rust
let v = vec![1, 2, 3];

// sum / product
let sum: i32 = v.iter().sum();
let product: i32 = v.iter().product();

// collect: transform into a collection
let v2: Vec<_> = v.iter().cloned().collect();

// any / all
let has_even = v.iter().any(|x| x % 2 == 0);
let all_positive = v.iter().all(|x| *x > 0);

// fold: general purpose reduction
let sum2 = v.iter().fold(0, |acc, x| acc + x);
```
