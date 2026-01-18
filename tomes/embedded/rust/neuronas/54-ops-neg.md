---
id: "rust.ops.neg"
title: "Operator Overloading: Neg"
category: traits
difficulty: intermediate
tags: [rust, traits, ops, math]
keywords: [Neg, -]
use_cases: [math types]
prerequisites: ["rust.ops.add"]
related: ["rust.ops.add"]
next_topics: []
---

# Neg

Overload the unary negation operator `-`.

```rust
use std::ops::Neg;

#[derive(Debug, PartialEq)]
struct Point { x: i32, y: i32 }

impl Neg for Point {
    type Output = Point;

    fn neg(self) -> Point {
        Point { x: -self.x, y: -self.y }
    }
}
```
