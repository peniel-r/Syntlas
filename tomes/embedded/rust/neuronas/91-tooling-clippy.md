---
id: "rust.tooling.clippy"
title: "Clippy"
category: tooling
difficulty: beginner
tags: [rust, tooling, linter]
keywords: [clippy, lint, static analysis]
use_cases: [code quality, learning]
prerequisites: ["rust.cargo"]
related: ["rust.best-practices"]
next_topics: []
---

# Clippy

Clippy is a collection of lints to catch common mistakes and improve your Rust code.

## Usage

```bash
cargo clippy
```

## Configuring Lints

In your code:

```rust
#[allow(clippy::too_many_arguments)]
fn complex_function(...) {}
```

Or deny warnings in CI:
`cargo clippy -- -D warnings`
