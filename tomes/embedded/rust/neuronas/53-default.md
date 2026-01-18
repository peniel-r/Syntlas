---
id: "rust.traits.default"
title: "Default Trait"
category: traits
difficulty: beginner
tags: [rust, traits, default]
keywords: [Default, default value]
use_cases: [initialization, configuration]
prerequisites: ["rust.traits"]
related: ["rust.derive"]
next_topics: []
---

# Default

The `Default` trait provides a common way to initialize a type with a default value.

## Deriving Default

```rust
#[derive(Default)]
struct Config {
    port: u32, // Defaults to 0
    host: String, // Defaults to ""
}
```

## Implementing Default

```rust
impl Default for Config {
    fn default() -> Self {
        Self {
            port: 8080,
            host: String::from("localhost"),
        }
    }
}
```

## Usage

```rust
let conf = Config::default();
// Or with update syntax
let conf = Config { port: 9000, ..Default::default() };
```
