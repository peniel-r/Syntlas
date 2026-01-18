---
id: "rust.unsafe"
title: "Unsafe Rust"
category: advanced
difficulty: expert
tags: [rust, unsafe, pointers, ffi]
keywords: [unsafe, raw pointers, ffi, extern]
use_cases: [ffi, hardware access, performance optimization]
prerequisites: ["rust.ownership", "rust.smart-pointers"]
related: ["rust.threading"]
next_topics: []
---

# Unsafe Rust

Rust hides a second language inside it called "Unsafe Rust". It gives you five superpowers:

1. Dereference raw pointers
2. Call unsafe functions or methods
3. Access or modify mutable static variables
4. Implement an unsafe trait
5. Access fields of `union`s

## The unsafe block

```rust
let mut num = 5;

let r1 = &num as *const i32;
let r2 = &mut num as *mut i32;

unsafe {
    println!("r1 is: {}", *r1);
    println!("r2 is: {}", *r2);
}
```

## When to use it?

Only when strictly necessary. Most Rust code should be safe. It's often used when interfacing with C libraries (FFI) or building low-level abstractions (like `Vec` or standard library internals).
