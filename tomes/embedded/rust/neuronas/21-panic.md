---
id: "rust.panic"
title: "Unrecoverable Errors"
category: error-handling
difficulty: beginner
tags: [rust, panic, error, crash]
keywords: [panic!, unwrap, expect]
use_cases: [fatal errors, assertions, prototyping]
prerequisites: ["rust.control-flow"]
related: ["rust.result", "rust.option"]
next_topics: ["rust.result"]
---

# Unrecoverable Errors with panic!

Sometimes bad things happen, and there's nothing you can do about it. For these cases, Rust has the `panic!` macro.

## The panic! Macro

When `panic!` executes, your program prints a failure message, unwinds and cleans up the stack, and then quits.

```rust
fn main() {
    panic!("crash and burn");
}
```

## Backtraces

You can run your program with `RUST_BACKTRACE=1` to see a backtrace of what happened.

```bash
$ RUST_BACKTRACE=1 cargo run
```

## When to Panic?

- Examples, prototype code, and tests.
- When you have more information than the compiler (e.g., `unwrap`).
- When some assumption is violated that makes continuing impossible.
