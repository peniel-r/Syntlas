---
id: "rust.ffi.c-types"
title: "FFI Types"
category: advanced
difficulty: expert
tags: [rust, ffi, types, libc]
keywords: [c_int, c_void, c_char]
use_cases: [ffi compatibility]
prerequisites: ["rust.ffi.basics"]
related: ["rust.ffi.basics"]
next_topics: []
---

# FFI Types

When writing FFI, use types from `std::ffi` (or `libc` crate) to match C types.

## Common Types

- `c_void` -> `void`
- `c_char` -> `char`
- `c_int` -> `int`
- `c_long` -> `long`

## Opaque Structs

```rust
#[repr(C)]
pub struct FILE {
    _private: [u8; 0],
}

extern "C" {
    fn fopen(filename: *const c_char, mode: *const c_char) -> *mut FILE;
}
```
