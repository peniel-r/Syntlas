---
id: "rust.std.any"
title: "Any (std::any)"
category: stdlib
difficulty: expert
tags: [rust, std, any, reflection]
keywords: [Any, type_id, downcast]
use_cases: [dynamic typing, heterogenous collections]
prerequisites: ["rust.traits"]
related: ["rust.generics"]
next_topics: []
---

# Any

The `Any` trait enables dynamic typing (runtime type reflection) within Rust.

## Usage

```rust
use std::any::Any;

fn print_if_string(s: &dyn Any) {
    if let Some(string) = s.downcast_ref::<String>() {
        println!("It's a string: {}", string);
    } else {
        println!("Not a string");
    }
}

fn main() {
    print_if_string(&String::from("Hello"));
    print_if_string(&5);
}
```
