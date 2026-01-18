---
id: "rust.iterators.adapters"
title: "Iterator Adapters"
category: functions
difficulty: intermediate
tags: [rust, iterators, functional, map, filter]
keywords: [map, filter, zip, chain, enumerate]
use_cases: [data transformation, lazy processing]
prerequisites: ["rust.iterators"]
related: ["rust.iterators.consumers"]
next_topics: ["rust.iterators.consumers"]
---

# Iterator Adapters

Adapters take an iterator and produce a new iterator. They are lazy.

## Common Adapters

```rust
let v = vec![1, 2, 3];

// map: transform each element
let v2: Vec<_> = v.iter().map(|x| x * 2).collect();

// filter: keep elements matching predicate
let v3: Vec<_> = v.iter().filter(|x| **x > 1).collect();

// zip: combine two iterators
let v4: Vec<_> = v.iter().zip(v2.iter()).collect();

// enumerate: yield (index, value)
for (i, x) in v.iter().enumerate() {
    println!("{}: {}", i, x);
}

// chain: append one iterator to another
let v5: Vec<_> = v.iter().chain(v2.iter()).collect();
```
