---
id: "rust.modules.paths"
title: "Module Paths"
category: modules
difficulty: beginner
tags: [rust, modules, paths]
keywords: [crate, super, self]
use_cases: [importing items]
prerequisites: ["rust.modules.mod"]
related: ["rust.modules.use"]
next_topics: []
---

# Module Paths

## Keywords

- `crate`: The root of the current crate.
- `super`: The parent module (like `..` in filesystem).
- `self`: The current module.

```rust
mod outer {
    fn call_me() {}

    mod inner {
        fn function() {
            crate::outer::call_me(); // Absolute
            super::call_me();        // Relative
        }
    }
}
```
