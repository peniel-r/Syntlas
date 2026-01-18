---
id: "rust.derive"
title: "Derive Macros"
category: metaprogramming
difficulty: intermediate
tags: [rust, macros, derive, traits]
keywords: [derive, Debug, Clone, Copy]
use_cases: [boilerplate reduction, default implementations]
prerequisites: ["rust.traits"]
related: ["rust.macros.declarative"]
next_topics: []
---

# Derive Macros

Rust provides the `derive` attribute to automatically generate code that implements a trait for your struct or enum.

## Common Derivable Traits

- `Debug`: Format output with `{:?}`
- `Clone`: Explicitly create a deep copy
- `Copy`: Implicitly copy values (stack-only)
- `PartialEq`, `Eq`: Equality comparisons
- `PartialOrd`, `Ord`: Ordering comparisons
- `Hash`: Hashable (for HashMap keys)
- `Default`: Default value

## Usage

```rust
#[derive(Debug, Clone, PartialEq)]
struct User {
    username: String,
    id: u32,
}

fn main() {
    let user = User { username: "demo".into(), id: 1 };
    println!("{:?}", user); // Uses Debug
}
```
