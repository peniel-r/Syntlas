---
id: "rust.async.notify"
title: "Notify"
category: async
difficulty: advanced
tags: [rust, async, notify, signal]
keywords: [tokio::sync::Notify, notify_one, notified]
use_cases: [basic signaling, event notification]
prerequisites: ["rust.async"]
related: ["rust.async.oneshot"]
next_topics: []
---

# Notify

`Notify` provides a basic mechanism to notify tasks of an event. It's like a semaphore but without counting (permits).

## Usage

```rust
use tokio::sync::Notify;
use std::sync::Arc;

let notify = Arc::new(Notify::new());
let notify2 = notify.clone();

tokio::spawn(async move {
    notify2.notified().await;
    println!("Received notification");
});

notify.notify_one();
```
