---
id: "rust.collections.hashset"
title: "HashSet"
category: collections
difficulty: intermediate
tags: [rust, collections, set, hash]
keywords: [HashSet, unique, fast lookup]
use_cases: [deduplication, membership check]
prerequisites: ["rust.collections"]
related: ["rust.collections.hashmap"]
next_topics: []
---

# HashSet

A set implemented as a `HashMap` where the value is `()`.

## Usage

```rust
use std::collections::HashSet;

let mut set = HashSet::new();
set.insert("a");
set.insert("b");

assert!(set.contains("a"));
assert!(!set.contains("c"));
```

## Operations

Union, intersection, difference, and symmetric difference.

```rust
let union: HashSet<_> = set1.union(&set2).collect();
```
