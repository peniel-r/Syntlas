---
id: "rust.refcell"
title: "RefCell and Interior Mutability"
category: memory
difficulty: advanced
tags: [rust, interior mutability, borrow checking]
keywords: [RefCell, borrow_mut, interior mutability]
use_cases: [mock objects, graph mutation, lazy static]
prerequisites: ["rust.smart-pointers"]
related: ["rust.rc-arc"]
next_topics: ["rust.threading"]
---

# RefCell<T>

`RefCell<T>` enforces borrowing rules at *runtime* instead of compile time. This pattern is known as **interior mutability**.

## Usage

Allows mutating data even when there are immutable references to that data.

```rust
use std::cell::RefCell;

let x = RefCell::new(5);

{
    let mut y = x.borrow_mut();
    *y += 1;
} // y goes out of scope, borrow ends

println!("{}", x.borrow()); // 6
```

## Panics

If you violate borrow rules (e.g., two mutable borrows), `RefCell` will panic at runtime.
