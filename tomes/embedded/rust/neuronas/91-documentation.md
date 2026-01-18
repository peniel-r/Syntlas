---
id: "rust.documentation"
title: "Documentation"
category: tooling
difficulty: beginner
tags: [rust, docs, comments, rustdoc]
keywords: [///, rustdoc, cargo doc, markdown]
use_cases: [api documentation, examples]
prerequisites: ["rust.functions"]
related: ["rust.cargo"]
next_topics: ["rust.cargo"]
---

# Documentation

Rust has a built-in documentation tool called `rustdoc`.

## Doc Comments

Use `///` for item documentation (functions, structs). Supports Markdown.

```rust
/// Adds one to the number given.
///
/// # Examples
///
/// ```
/// let arg = 5;
/// let answer = my_crate::add_one(arg);
///
/// assert_eq!(6, answer);
/// ```
pub fn add_one(x: i32) -> i32 {
    x + 1
}
```

## Documentation Tests

Code blocks in documentation are automatically tested when you run `cargo test`. This ensures examples never go out of date.

## Generating Docs

```bash
$ cargo doc --open
```
