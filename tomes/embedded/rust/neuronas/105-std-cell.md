---
id: "rust.std.cell"
title: "Cell (std::cell)"
category: stdlib
difficulty: advanced
tags: [rust, std, cell, interior mutability]
keywords: [Cell, set, get, Copy]
use_cases: [small copy types, flags, interior mutability]
prerequisites: ["rust.refcell"]
related: ["rust.refcell"]
next_topics: []
---

# Cell<T>

`Cell<T>` provides interior mutability by moving values in and out of the cell.

- **Zero overhead**: No runtime borrow checking (unlike `RefCell`).
- **Copy types**: Best used with `Copy` types (integers, bools).
- **Single-threaded**: Not `Sync`.

## Usage

```rust
use std::cell::Cell;

struct Sensor {
    value: Cell<u32>,
}

impl Sensor {
    fn update(&self, new_val: u32) {
        // Can mutate even via &self
        self.value.set(new_val);
    }
}
```
