---
id: "rust.std.thread.local"
title: "Thread Local Storage"
category: concurrency
difficulty: advanced
tags: [rust, std, thread, local]
keywords: [thread_local!, LocalKey]
use_cases: [per-thread state]
prerequisites: ["rust.threading"]
related: ["rust.std.cell"]
next_topics: []
---

# Thread Local Storage

Allows defining variables where each thread gets its own independent copy.

## Usage

```rust
use std::cell::RefCell;

thread_local!(static COUNTER: RefCell<u32> = RefCell::new(0));

fn main() {
    COUNTER.with(|c| {
        *c.borrow_mut() = 2;
    });
}
```
