---
id: "rust.macros.derive-impl"
title: "Implementing Derive Macros"
category: metaprogramming
difficulty: expert
tags: [rust, macros, derive, syn]
keywords: [syn, quote, proc_macro_derive]
use_cases: [code generation]
prerequisites: ["rust.macros.procedural"]
related: ["rust.macros.procedural"]
next_topics: []
---

# Implementing Derive

To implement `#[derive(Hello)]`:

1.  Parse input `TokenStream` with `syn`.
2.  Generate impl code with `quote`.
3.  Return `TokenStream`.

```rust
#[proc_macro_derive(Hello)]
pub fn hello_macro_derive(input: TokenStream) -> TokenStream {
    let ast = syn::parse(input).unwrap();
    impl_hello_macro(&ast)
}
```
