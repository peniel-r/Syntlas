---
id: "rust.traits"
title: "Traits and Trait Bounds"
category: language
difficulty: advanced
tags: [rust, traits, generics, bounds]
keywords: [trait, impl, where, dyn, generic]
use_cases: [polymorphism, shared behavior, code reuse]
prerequisites: ["rust.patterns.enums"]
related: ["rust.generics"]
next_topics: []
---

# Traits and Trait Bounds

Traits define shared behavior that types can implement.

## Basic Trait Definition

```rust
trait Summary {
    fn summarize(&self) -> String;
}

struct Article {
    title: String,
    content: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{} - {}", self.title, self.content)
    }
}

fn main() {
    let article = Article {
        title: String::from("Hello"),
        content: String::from("World"),
    };
    println!("{}", article.summarize());
}
```

## Trait Bounds

```rust
use std::fmt::Display;

fn print_summary<T: Display>(item: &T) {
    println!("{}", item);
}

fn main() {
    print_summary(&String::from("Hello"));
    print_summary(&42);
}
```

## Multiple Trait Bounds

```rust
use std::fmt::{Display, Debug};

fn print_both<T: Display + Debug>(item: &T) {
    println!("Debug: {:?}, Display: {}", item, item);
}
```

## impl Trait Syntax

```rust
trait Summary {
    fn summarize(&self) -> String;
}

fn notify(item: &impl Summary) {
    println!("{}", item.summarize());
}
```

## Trait Objects (dyn)

```rust
trait Summary {
    fn summarize(&self) -> String;
}

fn process(items: &[Box<dyn Summary>]) {
    for item in items {
        println!("{}", item.summarize());
    }
}
```

## Default Implementations

```rust
#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

impl Default for Point {
    fn default() -> Self {
        Point { x: 0, y: 0 }
    }
}

fn main() {
    let p = Point::default();
    println!("{:?}", p);
}
```

## Common Traits

### Clone

```rust
#[derive(Clone)]
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p1 = Point { x: 10, y: 20 };
    let p2 = p1.clone();  // Copy
}
```

### Copy

```rust
#[derive(Clone, Copy)]
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p1 = Point { x: 10, y: 20 };
    let p2 = p1;  // Implicit copy (no clone needed)
}
```

### Display and Debug

```rust
use std::fmt::{Display, Debug};

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

impl Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

fn main() {
    let p = Point { x: 10, y: 20 };
    println!("Debug: {:?}", p);
    println!("Display: {}", p);
}
```

### Iterator

```rust
struct Counter {
    current: i32,
    max: i32,
}

impl Iterator for Counter {
    type Item = i32;

    fn next(&mut self) -> Option<Self::Item> {
        if self.current < self.max {
            let val = self.current;
            self.current += 1;
            Some(val)
        } else {
            None
        }
    }
}
```

### From and Into

```rust
struct Point {
    x: i32,
    y: i32,
}

impl From<(i32, i32)> for Point {
    fn from((x, y): (i32, i32)) -> Self {
        Point { x, y }
    }
}

impl Into<(i32, i32)> for Point {
    fn into(self) -> (i32, i32) {
        (self.x, self.y)
    }
}

fn main() {
    let p: Point = (10, 20).into();
    let tuple: (i32, i32) = p.into();
}
```

## Common Patterns

### Generic functions with trait bounds
```rust
use std::fmt::Display;

fn print_all<T: Display>(items: &[T]) {
    for item in items {
        println!("{}", item);
    }
}
```

### Blanket implementations
```rust
trait Summary {
    fn summarize(&self) -> String;
}

// Implement for all types that implement Display
impl<T: Display> Summary for T {
    fn summarize(&self) -> String {
        format!("{} (via Display)", self)
    }
}
```

### Trait objects for flexibility
```rust
trait Drawable {
    fn draw(&self);
}

struct Circle { radius: f64 }
struct Square { size: f64 }

impl Drawable for Circle {
    fn draw(&self) {
        println!("Drawing circle");
    }
}

impl Drawable for Square {
    fn draw(&self) {
        println!("Drawing square");
    }
}

fn draw_all(items: &[Box<dyn Drawable>]) {
    for item in items {
        item.draw();
    }
}
```

### Associated types
```rust
trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}

struct Counter {
    current: i32,
}

impl Iterator for Counter {
    type Item = i32;

    fn next(&mut self) -> Option<Self::Item> {
        let val = self.current;
        self.current += 1;
        Some(val)
    }
}
```

### Generic trait with where clause
```rust
trait Add<RHS> {
    fn add(&self, rhs: RHS) -> Self;
}

impl<T: std::ops::Add<Output = T>> Add<T> for T {
    fn add(&self, rhs: T) -> Self {
        *self + rhs
    }
}
```

> **Tip**: Use trait bounds to specify required behavior for generic types.
