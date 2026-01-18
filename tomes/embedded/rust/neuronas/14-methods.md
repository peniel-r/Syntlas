---
id: "rust.methods"
title: "Methods"
category: types
difficulty: beginner
tags: [rust, methods, impl, self]
keywords: [impl, self, associated functions]
use_cases: [encapsulation, behavior, object-oriented patterns]
prerequisites: ["rust.structs"]
related: ["rust.traits"]
next_topics: ["rust.enums"]
---

# Methods

Methods are similar to functions, but they are defined within the context of a struct (or enum/trait object) and their first parameter is always `self`.

## Defining Methods

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
    
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}
```

## Associated Functions

Functions defined in an `impl` block that don't take `self`. Often used as constructors.

```rust
impl Rectangle {
    fn square(size: u32) -> Self {
        Self {
            width: size,
            height: size,
        }
    }
}

let sq = Rectangle::square(3);
```
