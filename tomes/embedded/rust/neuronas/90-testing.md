---
id: "rust.testing"
title: "Testing"
category: tooling
difficulty: beginner
tags: [rust, testing, test, assert]
keywords: [#[test], assert!, assert_eq!, integration tests]
use_cases: [quality assurance, tdd, regression testing]
prerequisites: ["rust.functions", "rust.panic"]
related: ["rust.documentation", "rust.cargo"]
next_topics: ["rust.documentation"]
---

# Testing

Rust has first-class support for testing.

## Unit Tests

Unit tests go in the same file as the code.

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(add(2, 2), 4);
    }
    
    #[test]
    #[should_panic]
    fn it_fails() {
        panic!("Make this test pass");
    }
}
```

## Running Tests

```bash
$ cargo test
```

## Integration Tests

Located in the `tests` directory next to `src`. Each file is compiled as a separate crate.

```rust
// tests/integration_test.rs
use my_crate;

#[test]
fn it_adds_two() {
    assert_eq!(my_crate::add_two(2), 4);
}
```
