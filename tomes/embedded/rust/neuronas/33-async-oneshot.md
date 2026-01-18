---
id: "rust.async.oneshot"
title: "Oneshot Channel"
category: async
difficulty: intermediate
tags: [rust, async, channel, oneshot]
keywords: [tokio::sync::oneshot, send, recv]
use_cases: [returning a single value, signals]
prerequisites: ["rust.async"]
related: ["rust.async.channels"]
next_topics: []
---

# Oneshot Channel

A channel for sending a single value from one task to another.

## Usage

```rust
use tokio::sync::oneshot;

#[tokio::main]
async fn main() {
    let (tx, rx) = oneshot::channel();

    tokio::spawn(async move {
        if let Err(_) = tx.send("Hello from task") {
            println!("Receiver dropped");
        }
    });

    match rx.await {
        Ok(v) => println!("Got: {}", v),
        Err(_) => println!("Sender dropped"),
    }
}
```
