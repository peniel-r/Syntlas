---
id: "rust.traits.clone-copy"
title: "Clone and Copy"
category: traits
difficulty: intermediate
tags: [rust, traits, memory, copy]
keywords: [Clone, Copy, deep copy, shallow copy]
use_cases: [duplication, move semantics]
prerequisites: ["rust.ownership"]
related: ["rust.derive"]
next_topics: []
---

# Clone and Copy

## Clone

The `Clone` trait allows you to explicitly create a deep copy of a value.

```rust
let s1 = String::from("hello");
let s2 = s1.clone(); // Heap data copied
```

## Copy

The `Copy` trait modifies ownership rules. Types with `Copy` are duplicated via `memcpy` instead of moved.

- Only allowed if all components are `Copy`.
- Types needing allocation (String, Vec) cannot be `Copy`.
- `i32`, `bool`, `char`, `f64` are `Copy`.

```rust
#[derive(Copy, Clone)]
struct Point { x: i32, y: i32 }

let p1 = Point { x: 1, y: 2 };
let p2 = p1; // p1 still valid
```
