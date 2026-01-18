---
id: "rust.std.io.bufreader"
title: "BufReader (std::io::BufReader)"
category: stdlib
difficulty: intermediate
tags: [rust, std, io, buffer]
keywords: [BufReader, BufWriter, read_line]
use_cases: [efficient io, reading lines]
prerequisites: ["rust.io"]
related: ["rust.std.fs"]
next_topics: []
---

# BufReader

Wraps a reader and buffers input. This is significantly faster when making many small read calls (like reading byte-by-byte or line-by-line).

## Usage

```rust
use std::io::{BufReader, BufRead};
use std::fs::File;

fn main() -> std::io::Result<()> {
    let f = File::open("log.txt")?;
    let reader = BufReader::new(f);

    for line in reader.lines() {
        println!("{}", line?);
    }
    Ok(())
}
```
