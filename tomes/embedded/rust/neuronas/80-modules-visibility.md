---
id: "rust.modules.visibility"
title: "Visibility (pub)"
category: modules
difficulty: beginner
tags: [rust, visibility, privacy, pub]
keywords: [pub, pub(crate), privacy]
use_cases: [api design, encapsulation]
prerequisites: ["rust.modules.mod"]
related: ["rust.modules.use"]
next_topics: []
---

# Visibility

By default, everything in Rust is private. The `pub` keyword makes items public.

## Levels

- `pub`: Accessible from anywhere.
- `pub(crate)`: Accessible within the current crate.
- `pub(super)`: Accessible in the parent module.
- Private (default): Accessible only in current module and its children.

```rust
mod back_of_house {
    pub struct Breakfast {
        pub toast: String,      // Public field
        seasonal_fruit: String, // Private field
    }

    impl Breakfast {
        pub fn summer(toast: &str) -> Breakfast {
            Breakfast {
                toast: String::from(toast),
                seasonal_fruit: String::from("peaches"),
            }
        }
    }
}
```
