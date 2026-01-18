---
id: "rust.unsafe.transmute"
title: "Transmute"
category: advanced
difficulty: expert
tags: [rust, unsafe, memory, transmute]
keywords: [std::mem::transmute, bits, casting]
use_cases: [bit casting, bypassing type system]
prerequisites: ["rust.unsafe"]
related: ["rust.unsafe"]
next_topics: []
---

# Transmute

`std::mem::transmute` reinterprets the bits of a value of one type as another type.

## Danger

This is **incredibly unsafe**. The types must have the same size.

```rust
unsafe {
    let a: f64 = 42.0;
    let b: u64 = std::mem::transmute(a); // Bit-wise cast
}
```

Prefer `pointer::cast` or `bytemuck` crate where possible.
