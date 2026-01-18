---
id: "rust.functions"
title: "Functions"
category: basics
difficulty: beginner
tags: [rust, functions, syntax, parameters]
keywords: [fn, return, parameters, arguments]
use_cases: [code organization, reuse, abstraction]
prerequisites: ["rust.types"]
related: ["rust.control-flow", "rust.methods"]
next_topics: ["rust.control-flow"]
---

# Functions

Functions are the building blocks of Rust code. You've already seen the `main` function, which is the entry point of many programs.

## Syntax

```rust
fn main() {
    print_labeled_measurement(5, 'h');
}

fn print_labeled_measurement(value: i32, unit_label: char) {
    println!("The measurement is: {}{}", value, unit_label);
}
```

## Statements vs Expressions

- **Statements**: Instructions that perform some action and do not return a value.
- **Expressions**: Evaluate to a resulting value.

```rust
fn main() {
    let y = {
        let x = 3;
        x + 1 // Expression (no semicolon)
    };
    
    println!("The value of y is: {}", y); // 4
}
```

## Return Values

Functions can return values to the code that calls them. We don't name return values, but we declare their type after an arrow (`->`).

```rust
fn five() -> i32 {
    5 // Implicit return (last expression)
}

fn plus_one(x: i32) -> i32 {
    x + 1
}
```
