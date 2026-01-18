---
id: "rust.patterns.raii"
title: "RAII (Resource Acquisition Is Initialization)"
category: patterns
difficulty: intermediate
tags: [rust, patterns, memory, cleanup]
keywords: [RAII, Drop, resource management]
use_cases: [file handles, mutex locks, sockets]
prerequisites: ["rust.ownership", "rust.traits.drop"]
related: ["rust.traits.drop"]
next_topics: []
---

# RAII

Rust enforces RAII via the ownership system. Resources are acquired in a constructor and released in the `Drop` implementation.

## Example: MutexGuard

When you lock a `Mutex`, you get a `MutexGuard`. When that guard goes out of scope (dropped), the lock is automatically released.

```rust
{
    let mut guard = mutex.lock().unwrap();
    *guard += 1;
} // guard dropped, lock released
```

You rarely need `finally` blocks in Rust because destructors run automatically on all paths (return, panic, etc.).
