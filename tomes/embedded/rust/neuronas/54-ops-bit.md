---
id: "rust.ops.bit"
title: "Bitwise Operators"
category: traits
difficulty: intermediate
tags: [rust, traits, ops, bitwise]
keywords: [BitAnd, BitOr, BitXor, Shl, Shr]
use_cases: [flags, low-level manipulation]
prerequisites: ["rust.ops.add"]
related: ["rust.ops.add"]
next_topics: []
---

# Bitwise Operators

Rust allows overloading `&`, `|`, `^`, `<<`, `>>`.

## Traits

- `BitAnd`: `&`
- `BitOr`: `|`
- `BitXor`: `^`
- `Shl`: `<<`
- `Shr`: `>>`

Useful for custom bitset or flag types.
