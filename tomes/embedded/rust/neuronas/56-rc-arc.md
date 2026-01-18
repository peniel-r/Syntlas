---
id: "rust.rc-arc"
title: "Rc and Arc"
category: memory
difficulty: advanced
tags: [rust, pointers, reference counting, concurrency]
keywords: [Rc, Arc, shared ownership]
use_cases: [shared state, graph data structures]
prerequisites: ["rust.smart-pointers"]
related: ["rust.refcell", "rust.threading"]
next_topics: ["rust.refcell"]
---

# Rc and Arc

These smart pointers enable multiple ownership of data.

## Rc<T> (Reference Counted)

Single-threaded reference counting.

```rust
use std::rc::Rc;

let a = Rc::new(5);
let b = Rc::clone(&a); // Increases count, doesn't copy data
println!("Count: {}", Rc::strong_count(&a)); // 2
```

## Arc<T> (Atomic Reference Counted)

Thread-safe reference counting. Use this when sharing data across threads.

```rust
use std::sync::Arc;
use std::thread;

let a = Arc::new(5);
let b = Arc::clone(&a);

thread::spawn(move || {
    println!("{}", b);
});
```
