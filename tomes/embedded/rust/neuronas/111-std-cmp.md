---
id: "rust.std.cmp"
title: "Comparison (std::cmp)"
category: stdlib
difficulty: intermediate
tags: [rust, std, cmp, sorting]
keywords: [PartialEq, Eq, PartialOrd, Ord, Ordering]
use_cases: [sorting, comparison, map keys]
prerequisites: ["rust.traits"]
related: ["rust.derive"]
next_topics: []
---

# Comparison Traits

Rust separates equality and ordering into traits.

## Equality

- `PartialEq`: `a == b`.
- `Eq`: `a == a` is always true (Reflexivity). `f32` implements `PartialEq` but NOT `Eq` (because `NaN != NaN`).

## Ordering

- `PartialOrd`: Can compare (returns `Option<Ordering>`).
- `Ord`: Total ordering (returns `Ordering`). Required for `BTreeMap` keys.

## Ordering Enum

```rust
enum Ordering {
    Less,
    Equal,
    Greater,
}
```
