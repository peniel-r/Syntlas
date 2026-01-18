---
id: "rust.ffi.cstring"
title: "CString and CStr"
category: advanced
difficulty: expert
tags: [rust, ffi, strings]
keywords: [CString, CStr, null-terminated]
use_cases: [ffi string passing]
prerequisites: ["rust.ffi.basics"]
related: ["rust.ffi.basics"]
next_topics: []
---

# CString and CStr

Rust strings are not null-terminated. C strings are.

## CString (Owned)

Used to pass data *to* C.

```rust
use std::ffi::CString;

let c_string = CString::new("Hello").expect("CString::new failed");
let ptr = c_string.as_ptr(); // Pass to C
```

## CStr (Borrowed)

Used to read data *from* C.

```rust
use std::ffi::CStr;

unsafe {
    let slice = CStr::from_ptr(ptr); // from C pointer
    println!("String from C: {:?}", slice);
}
```
