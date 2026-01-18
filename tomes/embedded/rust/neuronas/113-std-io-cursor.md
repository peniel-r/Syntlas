---
id: "rust.stdlib.io.cursor"
title: "Cursor (std::io::Cursor)"
category: stdlib
difficulty: intermediate
tags: [rust, std, io, testing]
keywords: [Cursor, Read, Write, Seek]
use_cases: [in-memory io, testing io code]
prerequisites: ["rust.stdlib.io"]
related: ["rust.stdlib.io"]
next_topics: []
---

# Cursor

`Cursor<T>` wraps an in-memory buffer (like `Vec<u8>` or `&[u8]`) and implements `Read`, `Write`, and `Seek`.

## Usage

Great for testing I/O code without touching the filesystem.

```rust
use std::io::{Cursor, Read, Write};

fn main() {
    let mut buff = Cursor::new(vec![1, 2, 3]);
    let mut out = vec![];
    
    buff.read_to_end(&mut out).unwrap();
    assert_eq!(out, vec![1, 2, 3]);
}
```
