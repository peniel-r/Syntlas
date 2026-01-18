---
id: "rust.async.streams"
title: "Streams"
category: async
difficulty: advanced
tags: [rust, async, streams, iterators]
keywords: [Stream, StreamExt, next]
use_cases: [async iteration, websockets, data feeds]
prerequisites: ["rust.async", "rust.iterators"]
related: ["rust.async"]
next_topics: []
---

# Streams

Streams are the asynchronous equivalent of Iterators. They yield a sequence of values over time.

## Usage

Using the `futures` crate or `tokio-stream`.

```rust
use futures::stream::{self, StreamExt};

#[tokio::main]
async fn main() {
    let mut stream = stream::iter(1..=3);

    while let Some(x) = stream.next().await {
        println!("Got: {}", x);
    }
}
```
