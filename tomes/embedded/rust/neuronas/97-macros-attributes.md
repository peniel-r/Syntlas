---
id: "rust.macros.attributes"
title: "Attribute Macros"
category: metaprogramming
difficulty: expert
tags: [rust, macros, attributes]
keywords: [attribute, derive]
use_cases: [frameworks, annotations]
prerequisites: ["rust.macros.procedural"]
related: ["rust.derive"]
next_topics: []
---

# Attribute Macros

Attribute macros define new outer attributes.

## Usage

```rust
#[route(GET, "/")]
fn index() {}
```

## Implementation

```rust
#[proc_macro_attribute]
pub fn route(attr: TokenStream, item: TokenStream) -> TokenStream {
    // ...
}
```
