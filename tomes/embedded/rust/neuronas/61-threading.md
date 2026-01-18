---
id: "rust.threading"
title: "Threads"
category: concurrency
difficulty: intermediate
tags: [rust, threads, concurrency, spawn]
keywords: [std::thread, spawn, join, move]
use_cases: [parallel execution, background tasks]
prerequisites: ["rust.closures", "rust.ownership"]
related: ["rust.sync", "rust.async"]
next_topics: ["rust.sync"]
---

# Threads

Rust provides a 1:1 threading model (OS threads).

## Spawning a Thread

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    handle.join().unwrap(); // Wait for thread to finish
}
```

## Move Closures

Using `move` transfers ownership of values into the thread.

```rust
let v = vec![1, 2, 3];

let handle = thread::spawn(move || {
    println!("Here's a vector: {:?}", v);
});
```
