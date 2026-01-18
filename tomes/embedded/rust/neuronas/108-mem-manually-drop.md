---
id: "rust.mem.manually-drop"
title: "ManuallyDrop"
category: memory
difficulty: expert
tags: [rust, memory, drop]
keywords: [ManuallyDrop, drop]
use_cases: [custom memory management, unions]
prerequisites: ["rust.traits.drop"]
related: ["rust.mem.swap"]
next_topics: []
---

# ManuallyDrop

`ManuallyDrop<T>` inhibits the compiler from automatically calling the destructor of `T`.

## Usage

Often used in `union`s or when taking ownership of data from FFI without freeing it.

```rust
use std::mem::ManuallyDrop;

let s = ManuallyDrop::new(String::from("Hello"));
// s will NOT be dropped here
```

## Safety

You must eventually drop it manually (via `ManuallyDrop::drop`) or leak memory.
