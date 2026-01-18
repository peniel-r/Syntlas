---
id: "rust.async"
title: "Async with Tokio"
category: async
difficulty: advanced
tags: [rust, async, tokio, futures]
keywords: [async, await, tokio::main, tokio::spawn]
use_cases: [concurrent I/O, web servers, network requests]
prerequisites: ["rust.ownership"]
related: []
next_topics: []
---

# Async with Tokio

Tokio is Rust's most popular async runtime.

## Basic Async Function

```rust
use tokio::time::{sleep, Duration};

async fn hello() {
    println!("Before sleep");
    sleep(Duration::from_secs(1)).await;
    println!("After sleep");
}

#[tokio::main]
async fn main() {
    hello().await;
}
```

## Spawning Tasks

```rust
use tokio::task;

async fn worker(name: &str) {
    println!("{} started", name);
    tokio::time::sleep(Duration::from_secs(1)).await;
    println!("{} finished", name);
}

#[tokio::main]
async fn main() {
    // Spawn independent tasks
    task::spawn(worker("Task 1"));
    task::spawn(worker("Task 2"));
    task::spawn(worker("Task 3"));

    // Give tasks time to run
    tokio::time::sleep(Duration::from_secs(2)).await;
}
```

## Joining Tasks

```rust
use tokio::task;

async fn worker(id: i32) -> i32 {
    println!("Worker {} running", id);
    tokio::time::sleep(Duration::from_millis(100)).await;
    id * 2
}

#[tokio::main]
async fn main() {
    let task1 = task::spawn(worker(1));
    let task2 = task::spawn(worker(2));
    let task3 = task::spawn(worker(3));

    // Wait for all tasks
    let results = tokio::try_join!(task1, task2, task3)
        .expect("Tasks failed");

    println!("Results: {:?}", results);
}
```

## Select! - Wait for First Completion

```rust
use tokio::time::{sleep, timeout, Duration};

async fn task1() -> &'static str {
    sleep(Duration::from_secs(2)).await;
    "Task 1"
}

async fn task2() -> &'static str {
    sleep(Duration::from_secs(1)).await;
    "Task 2"
}

#[tokio::main]
async fn main() {
    // Wait for whichever completes first
    tokio::select! {
        _ = task1() => {
            println!("Task 1 won");
        }
        _ = task2() => {
            println!("Task 2 won");
        }
    }
}
```

## Channels

```rust
use tokio::sync::mpsc;

async fn producer(tx: mpsc::Sender<i32>) {
    for i in 0..10 {
        tx.send(i).await.unwrap();
        println!("Sent: {}", i);
    }
}

async fn consumer(mut rx: mpsc::Receiver<i32>) {
    while let Some(value) = rx.recv().await {
        println!("Received: {}", value);
    }
}

#[tokio::main]
async fn main() {
    let (tx, mut rx) = mpsc::channel(100);

    let producer = task::spawn(producer(tx));
    let consumer = task::spawn(consumer(rx));

    tokio::try_join!(producer, consumer).unwrap();
}
```

## Timeout Operations

```rust
use tokio::time::{timeout, Duration};

async fn slow_operation() -> Result<String, tokio::time::error::Elapsed> {
    tokio::time::sleep(Duration::from_secs(5)).await;
    Ok(String::from("Done"))
}

#[tokio::main]
async fn main() {
    match timeout(Duration::from_secs(2), slow_operation()).await {
        Ok(result) => println!("Success: {}", result),
        Err(_) => println!("Operation timed out"),
    }
}
```

## Interval Ticker

```rust
use tokio::time::{interval, Duration};

#[tokio::main]
async fn main() {
    let mut ticker = interval(Duration::from_secs(1));

    for count in 0..5 {
        ticker.tick().await;
        println!("Tick {}", count);
    }
}
```

## Async Iterators

```rust
use futures::stream::{self, StreamExt};

async fn process_items() {
    let items = vec
![1, 2, 3, 4, 5];
    let mut stream = futures::stream::iter(items);

    while let Some(item) = stream.next().await {
        println!("Processing: {}", item);
    }
}

#[tokio::main]
async fn main() {
    process_items().await;
}
```

## Common Patterns

### Semaphore - Limit Concurrency

```rust
use tokio::sync::Semaphore;
use std::sync::Arc;

#[tokio::main]
async fn main() {
    let semaphore = Arc::new(Semaphore::new(3)); // Max 3 concurrent

    for i in 0..10 {
        let permit = semaphore.clone().acquire_owned().await.unwrap();
        let task = task::spawn(async move {
            // Work with permit
            tokio::time::sleep(Duration::from_secs(1)).await;
        });

        task.await.unwrap();
    }
}
```

### Mutex - Shared State

```rust
use tokio::sync::Mutex;
use std::sync::Arc;

#[tokio::main]
async fn main() {
    let counter = Arc::new(Mutex::new(0i32));
    let mut tasks = Vec::new();

    for _ in 0..5 {
        let counter = counter.clone();
        tasks.push(task::spawn(async move {
            let mut c = counter.lock().await;
            *c += 1;
        }));
    }

    for task in tasks {
        task.await.unwrap();
    }

    let final_count = *counter.lock().await;
    println!("Final count: {}", final_count);
}
```

### Broadcast Channel - Fan Out

```rust
use tokio::sync::broadcast;

#[tokio::main]
async fn main() {
    let (tx, _rx) = broadcast::channel(16);

    // Multiple receivers
    let mut tasks = Vec::new();
    for i in 0..3 {
        let mut rx = tx.subscribe();
        tasks.push(task::spawn(async move {
            while let Ok(msg) = rx.recv().await {
                println!("Receiver {} got: {}", i, msg);
            }
        }));
    }

    for _ in 0..5 {
        tx.send("message").unwrap();
        tokio::time::sleep(Duration::from_millis(100)).await;
    }
}
```

> **Note**: Tokio provides both multi-threaded (current-thread) and async I/O runtimes.
