---
id: "zig.basics.values"
title: "Values and Types"
category: basics
difficulty: beginner
tags: [zig, basics, types, primitives]
keywords: [i32, u8, f64, bool, primitives]
use_cases: [data storage]
prerequisites: []
related: ["zig.basics.assignment"]
next_topics: ["zig.basics.assignment"]
---

# Values and Primitive Types

Zig provides standard primitive types.

## Integers

- `i8`, `u8`
- `i16`, `u16`
- `i32`, `u32`
- `i64`, `u64`
- `i128`, `u128`
- `isize`, `usize` (pointer sized)

## Floats

- `f16`, `f32`, `f64`, `f80`, `f128`

## Boolean

- `bool` (`true` or `false`)

## Usage

```zig
const x: i32 = 42;
const y: f64 = 123.45;
const z: bool = true;
```
