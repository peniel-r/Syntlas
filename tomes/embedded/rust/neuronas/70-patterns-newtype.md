---
id: "rust.patterns.newtype"
title: "Newtype Pattern"
category: patterns
difficulty: intermediate
tags: [rust, patterns, types, safety]
keywords: [newtype, struct wrapper, type safety]
use_cases: [type safety, implementing traits on external types]
prerequisites: ["rust.structs"]
related: ["rust.traits.from-into"]
next_topics: []
---

# Newtype Pattern

The newtype pattern involves creating a tuple struct with one field to wrap an existing type.

## Benefits

1. **Type Safety**: Distinguish between same underlying types (e.g., `Miles` vs `Kilometers`).
2. **Trait Implementation**: Implement local traits on external types (bypassing Orphan Rule).

## Example

```rust
struct Millimeters(u32);
struct Meters(u32);

impl Add<Meters> for Millimeters {
    type Output = Millimeters;

    fn add(self, other: Meters) -> Millimeters {
        Millimeters(self.0 + (other.0 * 1000))
    }
}
```
