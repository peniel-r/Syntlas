---
id: "rust.std.num"
title: "Numeric Types (std::num)"
category: stdlib
difficulty: intermediate
tags: [rust, std, num, math]
keywords: [Saturating, Wrapping, NonZeroU32]
use_cases: [safe math, optimization]
prerequisites: ["rust.types"]
related: ["rust.ops.add"]
next_topics: []
---

# Numeric Types

The `std::num` module (and primitives) provides advanced numeric operations.

## Wrapping Arithmetic

Wraps around at the boundary instead of panicking in debug mode.

```rust
let x: u8 = 255;
let y = x.wrapping_add(1); // 0
```

## Saturating Arithmetic

Stops at the boundary.

```rust
let x: u8 = 255;
let y = x.saturating_add(1); // 255
```

## Checked Arithmetic

Returns `Option`.

```rust
match 255u8.checked_add(1) {
    Some(v) => println!("{}", v),
    None => println!("Overflow!"),
}
```

## NonZero Types

Types like `NonZeroU32` enable memory optimization (e.g., `Option<NonZeroU32>` is same size as `u32`).
