---
id: "rust.ffi.basics"
title: "FFI Basics"
category: advanced
difficulty: expert
tags: [rust, ffi, c, extern]
keywords: [extern "C", no_mangle, libc]
use_cases: [interfacing with C, system libraries]
prerequisites: ["rust.unsafe"]
related: ["rust.unsafe"]
next_topics: []
---

# Foreign Function Interface (FFI)

Calling foreign code from Rust, and allowing foreign code to call Rust.

## Calling C from Rust

```rust
extern "C" {
    fn abs(input: i32) -> i32;
}

fn main() {
    unsafe {
        println!("Absolute value of -3: {}", abs(-3));
    }
}
```

## Calling Rust from C

```rust
#[no_mangle]
pub extern "C" fn call_from_c() {
    println!("Just called a Rust function from C!");
}
```
