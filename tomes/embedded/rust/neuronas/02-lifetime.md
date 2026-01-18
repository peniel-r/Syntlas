---
id: "rust.lifetime"
title: "Lifetimes"
category: language
difficulty: advanced
tags: [rust, lifetime, borrow-checker, annotations]
keywords: [lifetime, 'a, 'static, struct, fn]
use_cases: [reference validity, preventing use-after-free]
prerequisites: ["rust.ownership"]
related: ["rust.intro"]
next_topics: ["rust.stdlib.collections"]
---

# Lifetimes

Lifetimes ensure references remain valid for their entire duration.

## Basic Lifetime Syntax

```rust
// Explicit lifetime annotation
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

fn main() {
    let s1 = String::from("long string");
    let s2 = String::from("short");
    let result = longest(&s1, &s2);
    println!("{}", result);  // "long string"
}
```

## Lifetime Elision

```rust
// These don't need explicit lifetimes (compiler infers)
fn first_word(s: &str) -> &str {
    // Single input, return &str -> elided
    s.split_whitespace().next().unwrap_or("")
}

fn main() {
    let s = String::from("hello world");
    println!("{}", first_word(&s));  // "hello"
}
```

## Struct Lifetimes

```rust
struct Ref<'a> {
    value: &'a str,
}

fn main() {
    let s = String::from("hello");
    let r = Ref { value: &s };
    println!("{}", r.value);  // "hello"
}
```

## Multiple Lifetimes

```rust
// Different lifetimes for different parameters
fn compare<'a, 'b>(s1: &'a str, s2: &'b str) -> bool {
    s1 == s2
}

fn main() {
    let s1 = String::from("hello");
    let s2 = String::from("world");
    println!("{}", compare(&s1, &s2));
}
```

## Lifetime Bounds

```rust
// T must live at least as long as 'a
fn print_ref<'a, T: 'a>(t: &'a T) {
    println!("{}", t);
}

fn main() {
    let x = 42;
    print_ref(&x);
}
```

## 'static Lifetime

```rust
// Lives for entire program duration
static LANGUAGE: &str = "Rust";
const MAX: i32 = 100;

fn main() {
    println!("{}", LANGUAGE);  // OK: 'static
}
```

## Methods with Lifetimes

```rust
struct Holder<'a> {
    value: &'a str,
}

impl<'a> Holder<'a> {
    fn new(value: &'a str) -> Self {
        Holder { value }
    }

    fn get(&self) -> &'a str {
        self.value
    }
}

fn main() {
    let s = String::from("hello");
    let holder = Holder::new(&s);
    println!("{}", holder.get());  // "hello"
}
```

## Common Patterns

### Returning owned vs borrowed

```rust
// Return String (owned)
fn to_uppercase(s: &str) -> String {
    s.to_uppercase()
}

// Return &str (borrowed)
fn as_uppercase(s: &str) -> &str {
    // Returns slice of input - no allocation
    if s.len() == s.to_uppercase().len() {
        s
    } else {
        // Would need owned value - can't return reference
        panic!("Not uppercase");
    }
}
```

### Struct with self-referential data

```rust
struct Node<'a> {
    value: i32,
    next: Option<&'a Node<'a>>,
}

impl<'a> Node<'a> {
    fn new(value: i32) -> Self {
        Node {
            value,
            next: None,
        }
    }

    fn set_next(&mut self, node: &'a Node<'a>) {
        self.next = Some(node);
    }
}
```

### Avoiding lifetime annotations

```rust
// Prefer owned values when possible
fn process_string(s: String) -> usize {
    // No lifetime annotations needed
    s.len()
}

// vs.

fn process_string_ref(s: &str) -> usize {
    // Requires lifetime annotation in some cases
    s.len()
}
```

> **Tip**: The compiler will suggest lifetime annotations when needed. Start with explicit ones, then learn elision rules.
