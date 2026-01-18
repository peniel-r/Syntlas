---
id: "rust.variables"
title: "Variables and Mutability"
category: basics
difficulty: beginner
tags: [rust, variables, mutability, bindings]
keywords: [let, mut, const, shadowing]
use_cases: [storing data, managing state]
prerequisites: ["rust.intro"]
related: ["rust.types", "rust.ownership"]
next_topics: ["rust.types"]
---

# Variables and Mutability

In Rust, variables are immutable by default. This is one of many nudges Rust gives you to write code in a way that takes advantage of the safety and easy concurrency that Rust offers.

## Immutable Variables

```rust
fn main() {
    let x = 5;
    println!("The value of x is: {}", x);
    // x = 6; // Error: cannot assign twice to immutable variable
}
```

## Mutable Variables

You can make them mutable by adding `mut` in front of the variable name.

```rust
fn main() {
    let mut x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);
}
```

## Constants

Constants are always immutable and must have a type annotation.

```rust
const MAX_POINTS: u32 = 100_000;
```

## Shadowing

You can declare a new variable with the same name as a previous variable.

```rust
fn main() {
    let x = 5;
    let x = x + 1;
    let x = x * 2;
    println!("The value of x is: {}", x); // 12
}
```

Shadowing allows you to change the type of the value but reuse the same name.

```rust
let spaces = "   ";
let spaces = spaces.len(); // spaces is now usize
```
