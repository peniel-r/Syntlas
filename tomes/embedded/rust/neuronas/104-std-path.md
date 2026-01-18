---
id: "rust.std.path"
title: "Path Handling (std::path)"
category: stdlib
difficulty: beginner
tags: [rust, std, path, filesystem]
keywords: [Path, PathBuf, join, extension]
use_cases: [cross-platform paths, file manipulation]
prerequisites: ["rust.std.fs", "rust.types"]
related: ["rust.std.fs"]
next_topics: []
---

# Path Handling

The `std::path` module provides cross-platform path manipulation.

## Path vs PathBuf

- `Path`: Immutable slice (like `&str`).
- `PathBuf`: Mutable, owned (like `String`).

## Usage

```rust
use std::path::PathBuf;

fn main() {
    let mut path = PathBuf::from("/tmp");
    path.push("foo");
    path.set_extension("txt");

    println!("{:?}", path); // "/tmp/foo.txt" (on Unix)
    
    // Checking components
    if path.exists() {
        println!("File exists");
    }
}
```
