---
id: "rust.std.fs"
title: "File System (std::fs)"
category: stdlib
difficulty: intermediate
tags: [rust, std, fs, file, io]
keywords: [File, read_to_string, write_all, metadata]
use_cases: [file manipulation, data persistence]
prerequisites: ["rust.result", "rust.io"]
related: ["rust.std.path", "rust.io"]
next_topics: ["rust.std.path"]
---

# File System

The `std::fs` module provides functionality for manipulating the file system.

## Reading a File

```rust
use std::fs;

fn main() -> std::io::Result<()> {
    let content = fs::read_to_string("hello.txt")?;
    println!("{}", content);
    Ok(())
}
```

## Writing to a File

```rust
use std::fs::File;
use std::io::Write;

fn main() -> std::io::Result<()> {
    let mut file = File::create("foo.txt")?;
    file.write_all(b"Hello, world!")?;
    Ok(())
}
```

## Directory Operations

```rust
use std::fs;

fn main() -> std::io::Result<()> {
    // Create directory
    fs::create_dir_all("a/b/c")?;

    // Iterate entries
    for entry in fs::read_dir(".")? {
        let entry = entry?;
        println!("{:?}", entry.path());
    }
    
    // Remove file
    fs::remove_file("foo.txt")?;
    
    Ok(())
}
```
