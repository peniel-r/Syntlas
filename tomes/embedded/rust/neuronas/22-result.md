---
id: "rust.result"
title: "Recoverable Errors with Result"
category: error-handling
difficulty: beginner
tags: [rust, error, result, handling]
keywords: [Result, Ok, Err, ? operator]
use_cases: [file io, parsing, fallible operations]
prerequisites: ["rust.patterns.enums", "rust.generics"]
related: ["rust.panic", "rust.option"]
next_topics: ["rust.option"]
---

# Recoverable Errors with Result

Most errors aren't serious enough to stop the program entirely. Rust uses the `Result` enum for this.

## The Result Enum

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

## Handling Result

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => panic!("Problem opening the file: {:?}", error),
    };
}
```

## The ? Operator

A shortcut for propagating errors.

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();
    File::open("hello.txt")?.read_to_string(&mut s)?;
    Ok(s)
}
```
