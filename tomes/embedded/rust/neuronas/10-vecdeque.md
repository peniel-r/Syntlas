---
id: "rust.collections.vecdeque"
title: "VecDeque"
category: collections
difficulty: intermediate
tags: [rust, collections, queue, stack, deque]
keywords: [VecDeque, push_front, pop_front, ring buffer]
use_cases: [queues, double-ended queues, ring buffers]
prerequisites: ["rust.collections"]
related: ["rust.collections.vec"]
next_topics: []
---

# VecDeque

`VecDeque` is a double-ended queue implemented with a growable ring buffer.

## Usage

Efficiently add or remove elements from both the front and back.

```rust
use std::collections::VecDeque;

fn main() {
    let mut buf = VecDeque::new();

    // Push back
    buf.push_back(1);
    buf.push_back(2);

    // Push front
    buf.push_front(3);

    // Buffer is now [3, 1, 2]
    assert_eq!(buf.pop_front(), Some(3));
    assert_eq!(buf.pop_back(), Some(2));
}
```

## Performance

- `O(1)` amortized for `push_front`, `push_back`, `pop_front`, `pop_back`.
- `O(1)` for random access (indexing).
- `O(n)` for inserting/removing from the middle.
