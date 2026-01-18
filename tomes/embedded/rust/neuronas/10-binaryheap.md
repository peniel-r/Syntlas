---
id: "rust.collections.binaryheap"
title: "BinaryHeap"
category: collections
difficulty: intermediate
tags: [rust, collections, heap, priority queue]
keywords: [BinaryHeap, priority queue, max heap]
use_cases: [priority queues, scheduling, dijkstra]
prerequisites: ["rust.collections"]
related: ["rust.collections.vec"]
next_topics: []
---

# BinaryHeap

A priority queue implemented with a binary heap. Pop always returns the maximum element.

## Usage

```rust
use std::collections::BinaryHeap;

fn main() {
    let mut heap = BinaryHeap::new();

    heap.push(1);
    heap.push(5);
    heap.push(2);

    // Returns Some(5)
    println!("Max is: {:?}", heap.peek());

    // Pops in descending order: 5, 2, 1
    while let Some(val) = heap.pop() {
        println!("{}", val);
    }
}
```

## Min Heap

Wrap elements in `std::cmp::Reverse` to create a min-heap.

```rust
use std::cmp::Reverse;
let mut min_heap = BinaryHeap::new();
min_heap.push(Reverse(5));
```
