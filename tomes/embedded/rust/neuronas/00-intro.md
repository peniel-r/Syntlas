---
id: "rust.intro"
title: "Introduction to Rust"
category: basics
difficulty: beginner
tags: [rust, intro, systems, safety]
keywords: [rust, introduction, systems programming, memory safety]
use_cases: [systems programming, web assembly, embedded systems, cli tools]
prerequisites: []
related: ["rust.variables", "rust.types"]
next_topics: ["rust.variables"]
---

# Introduction to Rust

Rust is a systems programming language that empowers everyone to build reliable and efficient software. It focuses on three main goals: safety, speed, and concurrency.

## Key Features

- **Memory Safety**: Guaranteed at compile time without a garbage collector.
- **Zero-Cost Abstractions**: High-level concepts compile down to efficient machine code.
- **Concurrency**: Type system prevents data races.
- **Modern Tooling**: Cargo (package manager), rustfmt (formatter), and clippy (linter) are built-in.

## Hello World

```rust
fn main() {
    println!("Hello, world!");
}
```

## Compilation

Rust is a compiled language. You use `rustc` to compile a single file, or `cargo` to manage projects.

```bash
$ rustc main.rs
$ ./main
Hello, world!
```

## Why Rust?

> "Rust blurs the line between systems programming and high-level scripting."

It offers the performance of C++ with the safety of Java or C#, and the modern syntax of Python or Ruby.
