---
id: "rust.types"
title: "Data Types"
category: basics
difficulty: beginner
tags: [rust, types, primitives, scalars]
keywords: [integer, float, boolean, char, tuple, array]
use_cases: [data definition, type safety]
prerequisites: ["rust.variables"]
related: ["rust.structs", "rust.patterns.enums"]
next_topics: ["rust.functions"]
---

# Data Types

Rust is a statically typed language. Every value in Rust is of a certain data type, which tells Rust what kind of data is being specified so it knows how to work with that data.

## Scalar Types

A scalar type represents a single value.

### Integers
- Signed: `i8`, `i16`, `i32` (default), `i64`, `i128`, `isize`
- Unsigned: `u8`, `u16`, `u32`, `u64`, `u128`, `usize`

### Floating-Point
- `f32`, `f64` (default)

### Boolean
- `bool`: `true` or `false`

### Character
- `char`: Unicode Scalar Value (4 bytes), e.g., 'a', 'ℤ', '😻'

## Compound Types

Compound types can group multiple values into one type.

### Tuples
Fixed length, can contain different types.

```rust
let tup: (i32, f64, u8) = (500, 6.4, 1);
let (x, y, z) = tup; // Destructuring
let five_hundred = tup.0; // Access by index
```

### Arrays
Fixed length, same type. Data allocated on the stack.

```rust
let a = [1, 2, 3, 4, 5];
let first = a[0];
let months = ["Jan", "Feb", "Mar"];
```
