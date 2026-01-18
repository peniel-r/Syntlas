---
id: "rust.closures"
title: "Closures"
category: functions
difficulty: intermediate
tags: [rust, closures, functional]
keywords: [closure, lambda, move, Fn, FnMut, FnOnce]
use_cases: [callbacks, iterators, threading]
prerequisites: ["rust.functions"]
related: ["rust.iterators", "rust.threading"]
next_topics: ["rust.iterators"]
---

# Closures

Closures are anonymous functions that can capture values from their environment.

## Syntax

```rust
let plus_one = |x: i32| x + 1;
assert_eq!(plus_one(5), 6);
```

## Capturing Environment

```rust
let x = 10;
let print_x = || println!("x is {}", x); // Captures &x
print_x();
```

## Moving Ownership

Use `move` to take ownership of captured values. Essential for threads.

```rust
let list = vec![1, 2, 3];
let owns_list = move || println!("{:?}", list);
// println!("{:?}", list); // Error: list moved
```

## Traits

- `FnOnce`: Called at least once (consumes self).
- `FnMut`: Called mutably (mutates self).
- `Fn`: Called immutably (reads self).
