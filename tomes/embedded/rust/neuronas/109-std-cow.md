---
id: "rust.std.borrow"
title: "Cow (Copy-on-Write)"
category: stdlib
difficulty: intermediate
tags: [rust, std, borrow, cow, optimization]
keywords: [Cow, Borrow, ToOwned]
use_cases: [string processing, optimization, lazy cloning]
prerequisites: ["rust.ownership", "rust.traits.clone-copy"]
related: ["rust.traits.from-into"]
next_topics: []
---

# Cow (Copy-on-Write)

`std::borrow::Cow` is an enum that holds either borrowed data or owned data.

## Usage

It allows you to work with borrowed data (cheap) and only clone it (expensive) when you need to mutate it.

```rust
use std::borrow::Cow;

fn remove_spaces(input: &str) -> Cow<str> {
    if input.contains(' ') {
        // Must allocate new string
        Cow::Owned(input.replace(' ', ""))
    } else {
        // Can return original slice
        Cow::Borrowed(input)
    }
}

fn main() {
    let s1 = remove_spaces("hello"); // Borrowed
    let s2 = remove_spaces("hello world"); // Owned
}
```
