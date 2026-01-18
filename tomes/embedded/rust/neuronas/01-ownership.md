---
id: "rust.ownership"
title: "Ownership and Borrowing"
category: language
difficulty: intermediate
tags: [rust, ownership, borrowing, lifetime]
keywords: [ownership, borrow, mutable borrow, lifetime, move]
use_cases: [memory safety, reference management, preventing data races]
prerequisites: []
related: ["rust.lifetime", "rust.intro"]
next_topics: ["rust.types"]
---

# Ownership and Borrowing

Rust's ownership system ensures memory safety without a garbage collector.

## Ownership Rules

1. Each value has an owner
2. There can only be one owner at a time
3. When the owner goes out of scope, the value is dropped

```rust
let s1 = String::from("hello");
let s2 = s1;  // s1 is moved to s2
// println!("{}", s1);  // Error: s1 was moved

let s3 = s2.clone();  // Explicit clone
println!("{}", s2);  // OK: s2 still valid
println!("{}", s3);  // OK: s3 is a copy
```

## Move Semantics

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1;  // s1 moved, no longer valid

    // s2 moves to the function
    takes_ownership(s2);

    // s1 and s2 are now invalid
}
```

## Primitive vs Non-Primitive Types

```rust
// Copy types - cheap to clone
let x: i32 = 5;
let y = x;  // x is still valid (Copy trait)

// Non-copy types - move semantics
let s1 = String::from("hello");
let s2 = s1;  // s1 moved
```

## Borrowing

```rust
fn main() {
    let s1 = String::from("hello");

    // Immutable borrow - &str
    let len = calculate_length(&s1);

    // s1 still valid (not moved)
    println!("{}", s1);  // OK
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

## Mutable Borrow

```rust
fn main() {
    let mut s = String::from("hello");

    append_world(&mut s);

    println!("{}", s);  // "helloworld"
}

fn append_world(s: &mut String) {
    s.push_str("world");
}
```

## Multiple Borrows

```rust
fn main() {
    let mut s = String::from("hello");

    // ERROR: Cannot borrow s mutably more than once
    let first = &s[0..1];
    let second = &s[1..2];
    s.push_str("world");  // Error

    // OK: Non-mutable borrows
    let first = &s[0..1];
    let second = &s[1..2];
    println!("{} {}", first, second);
}
```

## Borrow Checker Rules

1. Any number of immutable borrows (&T) is OK
2. One mutable borrow (&mut T) is OK
3. Cannot have mutable and immutable borrows simultaneously

```rust
fn main() {
    let mut x = 5;

    // ERROR: Mutable borrow prevents immutable borrows
    let r1 = &x;
    x += 1;
    let r2 = &x;  // Error

    // OK: Immutable borrows only
    let r1 = &x;
    let r2 = &x;
}
```

## Common Patterns

### Returning references
```rust
// GOOD: Return &str (borrow from argument)
fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    &s[..]
}

fn main() {
    let s = String::from("hello world");
    println!("{}", first_word(&s));  // "hello"
}
```

### Copy vs Clone

```rust
#[derive(Clone)]
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p1 = Point { x: 10, y: 20 };
    let p2 = p1.clone();  // Explicit clone
    let p3 = p1;  // Copy trait
}
```

### Avoiding moves with references

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = String::from("world");

    // Compare without moving
    if s1 == s2 {
        println!("Strings are equal");
    }

    // Both s1 and s2 still valid
}
```

> **Key Concept**: Ownership prevents data races, eliminates entire classes of memory errors at compile time.
