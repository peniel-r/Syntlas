---
id: "rust.async.mutex"
title: "Async Mutex"
category: async
difficulty: advanced
tags: [rust, async, mutex, tokio]
keywords: [tokio::sync::Mutex, lock, await]
use_cases: [shared state in async]
prerequisites: ["rust.async", "rust.sync"]
related: ["rust.async.rwlock"]
next_topics: []
---

# Async Mutex

`tokio::sync::Mutex` is an async-aware mutex.

## vs std::sync::Mutex

- **Tokio**: `lock().await` yields the task, allowing other tasks to run.
- **Std**: `lock()` blocks the entire thread.

**Rule**: Use `tokio::sync::Mutex` if the lock is held across an `.await` point. Otherwise, `std::sync::Mutex` is often faster (even in async code).

## Usage

```rust
use tokio::sync::Mutex;
use std::sync::Arc;

let data = Arc::new(Mutex::new(0));
let mut lock = data.lock().await;
*lock += 1;
```
