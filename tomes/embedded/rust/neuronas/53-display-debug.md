---
id: "rust.traits.display-debug"
title: "Display and Debug"
category: traits
difficulty: beginner
tags: [rust, traits, formatting, print]
keywords: [Display, Debug, fmt]
use_cases: [printing, logging, user output]
prerequisites: ["rust.traits"]
related: ["rust.derive"]
next_topics: []
---

# Display and Debug

Rust has two main traits for formatting output.

## Debug (`{:?}`)

For programmers. Automatically derivable.

```rust
#[derive(Debug)]
struct Point { x: i32, y: i32 }
println!("{:?}", Point { x: 1, y: 2 });
```

## Display (`{}`)

For user-facing output. Must be manually implemented.

```rust
use std::fmt;

struct Point { x: i32, y: i32 }

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

println!("{}", Point { x: 1, y: 2 });
```
