---
id: "rust.std.time"
title: "Time (std::time)"
category: stdlib
difficulty: beginner
tags: [rust, std, time, duration, instant]
keywords: [Duration, Instant, SystemTime, sleep]
use_cases: [benchmarking, timeouts, scheduling]
prerequisites: ["rust.types"]
related: ["rust.threading"]
next_topics: []
---

# Time

The `std::time` module provides time-related functionality.

## Duration

Represents a span of time.

```rust
use std::time::Duration;

let five_seconds = Duration::new(5, 0);
let two_seconds = Duration::from_secs(2);
```

## Measuring Execution Time

Use `Instant` for monotonic clocks (benchmarking).

```rust
use std::time::Instant;

fn main() {
    let start = Instant::now();
    
    // Expensive operation
    let _x: Vec<i32> = (0..1_000_000).collect();

    let duration = start.elapsed();
    println!("Time elapsed: {:?}", duration);
}
```

## System Time

Use `SystemTime` for wall-clock time.

```rust
use std::time::SystemTime;

let now = SystemTime::now();
```
