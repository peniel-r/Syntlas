---
id: "rust.macros.procedural"
title: "Procedural Macros"
category: metaprogramming
difficulty: expert
tags: [rust, macros, proc-macro]
keywords: [proc_macro, TokenStream, syn, quote]
use_cases: [custom derive, attribute macros, dsl]
prerequisites: ["rust.macros.declarative"]
related: ["rust.derive"]
next_topics: []
---

# Procedural Macros

Procedural macros act like functions that take code (TokenStream) as input and produce code as output.

## Types

1. **Custom Derive**: `#[derive(MyTrait)]`
2. **Attribute-like**: `#[route(GET, "/")]`
3. **Function-like**: `sql!("SELECT * FROM posts")`

## Implementation

Requires a separate crate with `proc-macro = true`.

```rust
use proc_macro::TokenStream;

#[proc_macro]
pub fn make_answer(_item: TokenStream) -> TokenStream {
    "fn answer() -> u32 { 42 }".parse().unwrap()
}
```
