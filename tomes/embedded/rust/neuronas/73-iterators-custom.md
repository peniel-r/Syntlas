---
id: "rust.iterators.custom"
title: "Implementing Iterator"
category: functions
difficulty: advanced
tags: [rust, iterators, traits, impl]
keywords: [Iterator, next, associated type]
use_cases: [custom collections, generators]
prerequisites: ["rust.iterators", "rust.traits"]
related: ["rust.structs"]
next_topics: []
---

# Implementing Iterator

To create a custom iterator, you only need to implement the `next` method.

## Example: Counter

```rust
struct Counter {
    count: u32,
}

impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        if self.count < 5 {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}

fn main() {
    let mut counter = Counter::new();
    assert_eq!(counter.next(), Some(1));
}
```
