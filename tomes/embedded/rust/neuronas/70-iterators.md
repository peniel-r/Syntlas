---
id: "rust.iterators"
title: "Iterators"
category: functions
difficulty: intermediate
tags: [rust, iterators, functional]
keywords: [iter, into_iter, map, filter, collect]
use_cases: [processing collections, lazy evaluation]
prerequisites: ["rust.closures"]
related: ["rust.collections"]
next_topics: ["rust.collections"]
---

# Iterators

The `Iterator` trait is central to Rust's functional programming features. Iterators are lazy—they do nothing until you consume them.

## Creating Iterators

- `iter()`: Yields references (`&T`).
- `iter_mut()`: Yields mutable references (`&mut T`).
- `into_iter()`: Yields owned values (`T`).

## Adapters

Methods that transform an iterator into another iterator.

```rust
let v1: Vec<i32> = vec![1, 2, 3];
let v2: Vec<_> = v1.iter().map(|x| x + 1).collect();
```

## Consumers

Methods that call `next()` and consume the iterator.

```rust
let total: i32 = v1.iter().sum();
```