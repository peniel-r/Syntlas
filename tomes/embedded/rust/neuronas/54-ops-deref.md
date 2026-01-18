---
id: "rust.ops.deref"
title: "Deref Coercion"
category: traits
difficulty: advanced
tags: [rust, traits, ops, deref, pointers]
keywords: [Deref, DerefMut, *, coercion]
use_cases: [smart pointers, transparency]
prerequisites: ["rust.traits", "rust.smart-pointers"]
related: ["rust.ops.index"]
next_topics: []
---

# Deref

The `Deref` trait allows you to customize the behavior of the dereference operator `*`.

## Deref Coercion

Rust automatically coerces types that implement `Deref`.

```rust
use std::ops::Deref;

struct MyBox<T>(T);

impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

fn hello(name: &str) {
    println!("Hello, {}!", name);
}

fn main() {
    let m = MyBox(String::from("Rust"));
    // &MyBox<String> -> &String -> &str
    hello(&m); 
}
```
