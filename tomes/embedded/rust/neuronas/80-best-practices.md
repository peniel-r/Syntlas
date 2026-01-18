---
id: "rust.best-practices"
title: "Rust Best Practices"
category: pattern
difficulty: advanced
tags: [rust, best-practices, idioms, conventions]
keywords: [error handling, ownership, cargo, testing]
use_cases: [writing idiomatic code, memory safety, maintainability]
prerequisites: ["rust.ownership"]
related: ["rust.error", "rust.traits"]
next_topics: []
---

# Rust Best Practices

## Idiomatic Rust

### Prefer match over if-else chains

```rust
// GOOD
match value {
    1 => println!("One"),
    2 => println!("Two"),
    _ => println!("Other"),
}

// AVOID
if value == 1 {
    println!("One");
} else if value == 2 {
    println!("Two");
} else {
    println!("Other");
}
```

### Use Option and Result

```rust
// GOOD
fn divide(a: i32, b: i32) -> Option<i32> {
    if b == 0 {
        None
    } else {
        Some(a / b)
    }
}

// AVOID
fn divide(a: i32, b: i32) -> i32 {
    a / b  // May panic on divide by zero
}
```

### Leverage standard library

```rust
// GOOD - use stdlib functions
use std::cmp::Ordering;

fn compare(a: &str, b: &str) -> Ordering {
    a.cmp(b)
}

// AVOID - reimplement
fn compare(a: &str, b: &str) -> i32 {
    if a < b { -1 } else if a > b { 1 } else { 0 }
}
```

### Use iterators for transformations

```rust
// GOOD
let doubled: Vec<_> = numbers.iter().map(|x| x * 2).collect();

// AVOID
let mut doubled = Vec::new();
for num in &numbers {
    doubled.push(num * 2);
}
```

## Error Handling

### Prefer Result over panic

```rust
// GOOD - recoverable error
fn read_file(path: &str) -> Result<String, std::io::Error> {
    std::fs::read_to_string(path)
}

// AVOID - panic in production code
fn read_file_bad(path: &str) -> String {
    std::fs::read_to_string(path).unwrap()
}
```

### Handle Results properly

```rust
// GOOD
match read_file("config.txt") {
    Ok(content) => println!("{}", content),
    Err(e) => eprintln!("Error: {}", e),
}

// AVOID - ignore errors
let _ = read_file("config.txt").ok();
```

### Use expect() for truly impossible cases

```rust
// GOOD - documented invariant
let idx = index.get(0).expect("Index should exist");

// AVOID - expect() for recoverable errors
let _ = index.get(0).expect("Should work");
```

## Ownership Patterns

### Prefer borrowing when possible

```rust
// GOOD - borrow
fn print_string(s: &str) {
    println!("{}", s)
}

// AVOID - take ownership unnecessarily
fn print_string(s: String) {
    println!("{}", s)
}
```

### Use Cow<str> for flexible string handling

```rust
use std::borrow::Cow;

fn process(input: &str) -> Cow<str> {
    if input.contains("special") {
        // Need owned string
        input.to_uppercase().into()
    } else {
        // Can borrow
        input.into()
    }
}
```

### Clone strategically

```rust
// GOOD - clone only when needed
fn process(data: Vec<i32>) {
    for &item in &data {
        // Work with reference
        process_item(item);
    }
}

// AVOID - unnecessary clones
fn process_bad(data: Vec<i32>) {
    for item in data.clone() {
        process_item(item);
    }
}
```

## Memory Management

### Use Vec with_capacity for known sizes

```rust
// GOOD - pre-allocate
let mut vec = Vec::with_capacity(100);
for i in 0..100 {
    vec.push(i);
}

// AVOID - reallocations
let mut vec = Vec::new();
for i in 0..100 {
    vec.push(i);
}
```

### Use String::with_capacity

```rust
// GOOD
let mut s = String::with_capacity(100);
for _ in 0..100 {
    s.push_str("hello");
}

// AVOID - multiple reallocations
let mut s = String::new();
for _ in 0..100 {
    s.push_str("hello");
}
```

### Use small string optimization (SSO) when beneficial

```rust
// GOOD - Small strings inline
let s = "hello";

// AVOID - allocation for small strings
let s = String::from("hello");
```

## Naming Conventions

### snake_case for variables and functions

```rust
let user_name = "Alice";
fn calculate_total() -> i32 {
    0
}
```

### PascalCase for types

```rust
struct UserProfile {
    name: String,
    age: i32,
}

enum HttpStatus {
    Ok,
    NotFound,
}
```

### SCREAMING_SNAKE_CASE for constants

```rust
const MAX_RETRIES: i32 = 3;
const DEFAULT_TIMEOUT: u64 = 30000;
```

## Code Organization

### Module structure

```rust
// GOOD - logical modules
mod config {
    pub fn load() -> Config {
        // ...
    }
}

mod database {
    pub fn connect() -> Connection {
        // ...
    }
}
```

### Use visibility modifiers appropriately

```rust
// GOOD - pub only for public API
pub mod api {
    pub fn handle_request() -> Response {
        // ...
    }

    mod internal {
        fn parse() -> Data {
            // ...
        }
    }
}
```

## Cargo Best Practices

### Use workspaces for multi-package projects

```toml
[workspace]
members = ["core", "cli", "server"]
```

### Specify dependencies precisely

```toml
[dependencies]
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }
```

### Use dev-dependencies for dev tools

```toml
[dev-dependencies]
criterion = "0.3"
```

## Testing

### Write unit tests in module

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_addition() {
        assert_eq!(add(2, 3), 5);
    }
}
```

### Use proptest for property-based testing

```toml
[dev-dependencies]
proptest = "1.0"
```

## Documentation

### Document public APIs

```rust
/// Adds two numbers together.
///
/// # Arguments
///
/// * `a` - First addend
/// * `b` - Second addend
///
/// # Returns
///
/// Sum of `a` and `b`
///
/// # Examples
///
/// ```
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// ```
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

### Document error variants

```rust
/// Error that can occur during file operations
#[derive(Debug)]
pub enum FileError {
    /// File not found at given path
    NotFound(String),

    /// Insufficient permissions
    PermissionDenied(String),

    /// Generic I/O error
    IoError(std::io::Error),
}
```

> **Reference**: [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
