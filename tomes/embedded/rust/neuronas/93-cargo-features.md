---
id: "rust.cargo.features"
title: "Cargo Features"
category: tooling
difficulty: intermediate
tags: [rust, cargo, features, conditional compilation]
keywords: [features, default-features, optional dependencies]
use_cases: [optional functionality, reducing bloat]
prerequisites: ["rust.cargo"]
related: ["rust.modules.mod"]
next_topics: []
---

# Cargo Features

Features allow you to express conditional compilation and optional dependencies.

## Definition

In `Cargo.toml`:

```toml
[features]
default = ["std"]
std = []
extra-stuff = ["dep:serde", "dep:rand"]

[dependencies]
serde = { version = "1.0", optional = true }
rand = { version = "0.8", optional = true }
```

## Usage in Code

```rust
#[cfg(feature = "extra-stuff")]
fn do_extra() {
    println!("Doing extra stuff");
}
```

## Enabling Features

```bash
cargo run --features "extra-stuff"
```
