---
id: "rust.trait-bounds"
title: "Trait Bounds"
category: types
difficulty: intermediate
tags: [rust, traits, generics, bounds]
keywords: [where, impl Trait, bounds]
use_cases: [generic constraints, api design]
prerequisites: ["rust.traits", "rust.generics"]
related: ["rust.generics"]
next_topics: ["rust.smart-pointers"]
---

# Trait Bounds

Trait bounds allow you to restrict generic types to those that implement specific behaviors.

## Syntax

```rust
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

## Multiple Bounds

```rust
pub fn notify(item: &(impl Summary + Display)) { ... }
// or
pub fn notify<T: Summary + Display>(item: &T) { ... }
```

## where Clauses

For cleaner syntax with complex bounds.

```rust
fn some_function<T, U>(t: &T, u: &U) -> i32
where
    T: Display + Clone,
    U: Clone + Debug,
{ ... }
```
