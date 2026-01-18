---
id: "rust.async.rwlock"
title: "Async RwLock"
category: async
difficulty: advanced
tags: [rust, async, rwlock, tokio]
keywords: [tokio::sync::RwLock, read, write]
use_cases: [many readers, single writer]
prerequisites: ["rust.async.mutex"]
related: ["rust.async.mutex"]
next_topics: []
---

# Async RwLock

`tokio::sync::RwLock` allows multiple concurrent readers or a single exclusive writer.

## Usage

```rust
use tokio::sync::RwLock;
use std::sync::Arc;

let lock = Arc::new(RwLock::new(5));

// Many readers
{
    let r1 = lock.read().await;
    let r2 = lock.read().await;
    println!("Read: {}", *r1);
}

// One writer
{
    let mut w = lock.write().await;
    *w += 1;
}
```
