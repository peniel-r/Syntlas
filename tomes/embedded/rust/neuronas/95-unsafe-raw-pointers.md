---
id: "rust.unsafe.raw-pointers"
title: "Raw Pointers"
category: advanced
difficulty: expert
tags: [rust, unsafe, pointers]
keywords: [*const, *mut, null]
use_cases: [ffi, optimization, unchecked access]
prerequisites: ["rust.unsafe"]
related: ["rust.smart-pointers"]
next_topics: []
---

# Raw Pointers

Rust has two types of raw pointers: `*const T` and `*mut T`.

## Differences from References

- Are not guaranteed to point to valid memory.
- Are allowed to be null.
- Do not implement automatic cleanup (drop).
- Can ignore borrowing rules (multiple mutable pointers to same data).

## Creating

```rust
let mut num = 5;
let r1 = &num as *const i32;
let r2 = &mut num as *mut i32;
```

## Dereferencing (Unsafe)

```rust
unsafe {
    println!("{}", *r1);
    *r2 = 10;
}
```
