---
id: "rust.async.barrier"
title: "Barrier"
category: async
difficulty: advanced
tags: [rust, async, barrier, synchronization]
keywords: [tokio::sync::Barrier, wait]
use_cases: [synchronizing multiple tasks]
prerequisites: ["rust.async"]
related: ["rust.async"]
next_topics: []
---

# Barrier

A barrier allows multiple tasks to wait until all of them have reached a certain point.

## Usage

```rust
use tokio::sync::Barrier;
use std::sync::Arc;

let barrier = Arc::new(Barrier::new(3)); // Wait for 3 tasks

for _ in 0..3 {
    let c = barrier.clone();
    tokio::spawn(async move {
        println!("Waiting");
        c.wait().await;
        println!("Passed");
    });
}
```
