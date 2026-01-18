---
id: "rust.std.fmt"
title: "Formatting Syntax"
category: stdlib
difficulty: beginner
tags: [rust, std, fmt, print]
keywords: [println!, format!, {:?}, {:x}]
use_cases: [string formatting]
prerequisites: ["rust.traits.display-debug"]
related: ["rust.traits.display-debug"]
next_topics: []
---

# Formatting Syntax

Rust's formatting macros (`println!`, `format!`) use a powerful syntax.

## Positional Arguments

```rust
format!("{1} {} {0}", 1, 2); // "2 1 1"
```

## Named Arguments

```rust
format!("{argument}", argument = "test");
```

## Formatting Traits

- `{:?}`: Debug
- `{:o}`: Octal
- `{:x}`: LowerHex
- `{:X}`: UpperHex
- `{:p}`: Pointer
- `{:b}`: Binary
- `{:e}`: LowerExp

## Padding and Alignment

```rust
format!("{:>5}", 1);  // "    1" (Right align)
format!("{:05}", 1);  // "00001" (Zero pad)
```
