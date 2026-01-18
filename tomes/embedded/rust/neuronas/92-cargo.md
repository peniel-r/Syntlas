---
id: "rust.cargo"
title: "Cargo and Crates"
category: tooling
difficulty: beginner
tags: [rust, cargo, crates, dependencies]
keywords: [Cargo.toml, crates.io, workspace, build]
use_cases: [project management, dependency resolution]
prerequisites: ["rust.intro"]
related: ["rust.testing", "rust.documentation"]
next_topics: []
---

# Cargo and Crates

Cargo is Rust's package manager and build system.

## Cargo.toml

The manifest file defines your project and dependencies.

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
rand = "0.8"
```

## Commands

- `cargo new`: Create a new project
- `cargo build`: Compile the project
- `cargo run`: Build and run
- `cargo check`: Check for errors without generating binaries (fast)
- `cargo update`: Update dependencies in `Cargo.lock`
- `cargo publish`: Upload to crates.io

## Workspaces

Manage multiple related packages in a single repo.

```toml
[workspace]
members = [
    "adder",
    "add_one",
]
```
