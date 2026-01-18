---
id: "rust.option"
title: "The Option Enum"
category: error-handling
difficulty: beginner
tags: [rust, option, null, safety]
keywords: [Option, Some, None]
use_cases: [optional values, null safety, default arguments]
prerequisites: ["rust.patterns.enums", "rust.generics"]
related: ["rust.result", "rust.patterns.match"]
next_topics: ["rust.stdlib.collections"]
---

# The Option Enum

Rust doesn't have the null feature. Instead, it has an enum that can encode the concept of a value being present or absent.

## Definition

```rust
enum Option<T> {
    None,
    Some(T),
}
```

## Usage

```rust
let some_number = Some(5);
let some_string = Some("a string");
let absent_number: Option<i32> = None;
```

## Handling Option

You must convert `Option<T>` to `T` before you can perform `T` operations with it.

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}
```

This prevents the common "Null Pointer Exception" found in other languages.
