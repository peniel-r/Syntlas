---
id: "rust.std.convert"
title: "Conversion (std::convert)"
category: stdlib
difficulty: intermediate
tags: [rust, std, convert, traits]
keywords: [From, Into, TryFrom, AsRef, AsMut]
use_cases: [casting, type coercion]
prerequisites: ["rust.traits.from-into"]
related: ["rust.traits.from-into"]
next_topics: []
---

# Conversion Traits

The `std::convert` module holds standard traits for type conversion.

## AsRef / AsMut

Cheap reference-to-reference conversion.

```rust
fn open_file<P: AsRef<Path>>(path: P) {
    let p = path.as_ref();
    // ...
}

open_file("string");
open_file(path_buf);
```

## TryFrom / TryInto

Fallible conversion.

```rust
use std::convert::TryFrom;

let u: u8 = u8::try_from(1000i32).unwrap_err(); // Overflow
```
