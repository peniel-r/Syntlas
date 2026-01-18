---
id: "rust.macros.declarative"
title: "Declarative Macros"
category: metaprogramming
difficulty: advanced
tags: [rust, macros, metaprogramming]
keywords: [macro_rules!, pattern matching]
use_cases: [dsl, boilerplate reduction, variadic functions]
prerequisites: ["rust.functions"]
related: ["rust.macros.procedural"]
next_topics: []
---

# Declarative Macros

Macros allow you to write code that writes other code.

## macro_rules!

```rust
#[macro_export]
macro_rules! vec {
    ( $( $x:expr ),* ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```

- `$()`: Repetition
- `$x:expr`: Match an expression and bind to `$x`
- `*`: Repeat zero or more times
