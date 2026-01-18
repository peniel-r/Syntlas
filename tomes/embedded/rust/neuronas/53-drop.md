---
id: "rust.traits.drop"
title: "Drop Trait"
category: traits
difficulty: intermediate
tags: [rust, traits, memory, cleanup]
keywords: [Drop, destructor, cleanup]
use_cases: [resource management, raii]
prerequisites: ["rust.ownership"]
related: ["rust.smart-pointers"]
next_topics: []
---

# Drop

The `Drop` trait lets you customize what happens when a value goes out of scope.

## Implementation

```rust
struct CustomSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping CustomSmartPointer with data `{}`!", self.data);
    }
}

fn main() {
    let c = CustomSmartPointer { data: String::from("stuff") };
    // "Dropping..." printed here
}
```

## Manual Drop

You cannot call `drop` directly. Use `std::mem::drop` to force early drop.

```rust
drop(c);
```
