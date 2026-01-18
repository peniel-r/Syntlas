---
id: "rust.mem.layout"
title: "Memory Layout"
category: memory
difficulty: expert
tags: [rust, memory, layout, repr]
keywords: [repr(C), repr(packed), align_of, size_of]
use_cases: [ffi, hardware interfacing, optimization]
prerequisites: ["rust.unsafe"]
related: ["rust.ffi.basics"]
next_topics: []
---

# Memory Layout

By default, Rust does **not** guarantee the layout of structs (fields may be reordered for padding).

## repr(C)

Forces C-compatible layout. Essential for FFI.

```rust
#[repr(C)]
struct MyStruct {
    a: u8,
    b: u32,
}
```

## repr(packed)

Removes padding.

```rust
#[repr(packed)]
struct Packed {
    a: u8,
    b: u32,
}
```
