---
id: "rust.sync"
title: "Shared State Concurrency"
category: concurrency
difficulty: advanced
tags: [rust, mutex, rwlock, atomics]
keywords: [Mutex, Lock, Arc, Sync, Send]
use_cases: [shared memory, thread safety]
prerequisites: ["rust.threading", "rust.rc-arc"]
related: ["rust.async"]
next_topics: ["rust.best-practices"]
---

# Shared State Concurrency

Rust's type system (Send/Sync traits) ensures thread safety at compile time.

## Mutex<T>

Mutual exclusion. Only one thread can access the data at a time.

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

## Send and Sync Traits

- **Send**: Ownership can be transferred to another thread.
- **Sync**: Safe to reference from multiple threads (i.e., `&T` is `Send`).
