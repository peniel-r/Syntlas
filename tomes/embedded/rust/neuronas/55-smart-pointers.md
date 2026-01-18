---
id: "rust.smart-pointers"
title: "Smart Pointers"
category: memory
difficulty: intermediate
tags: [rust, pointers, memory, heap]
keywords: [Box, Deref, Drop, heap]
use_cases: [recursive types, heap allocation, trait objects]
prerequisites: ["rust.ownership"]
related: ["rust.rc-arc", "rust.refcell"]
next_topics: ["rust.rc-arc"]
---

# Smart Pointers

Smart pointers are data structures that act like a pointer but also have additional metadata and capabilities.

## Box<T>

The most common smart pointer. It allows you to store data on the heap rather than the stack.

```rust
fn main() {
    let b = Box::new(5);
    println!("b = {}", b);
}
```

### Recursive Types

Boxes enable recursive types by providing a known size.

```rust
enum List {
    Cons(i32, Box<List>),
    Nil,
}
```

## Deref Trait

Allows customizing the behavior of the dereference operator `*`.

## Drop Trait

Allows customizing what happens when a value goes out of scope.
