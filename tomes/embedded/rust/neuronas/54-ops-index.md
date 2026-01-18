---
id: "rust.ops.index"
title: "Operator Overloading: Index"
category: traits
difficulty: intermediate
tags: [rust, traits, ops, indexing]
keywords: [Index, IndexMut, [], operator overloading]
use_cases: [custom collections, accessing elements]
prerequisites: ["rust.traits"]
related: ["rust.ops.deref"]
next_topics: []
---

# Index and IndexMut

Allows using the `[]` operator.

## Implementation

```rust
use std::ops::Index;

struct Nucleus {
    protons: Vec<String>,
}

impl Index<usize> for Nucleus {
    type Output = String;

    fn index(&self, index: usize) -> &Self::Output {
        &self.protons[index]
    }
}

fn main() {
    let n = Nucleus { protons: vec!["p1".into(), "p2".into()] };
    println!("{}", n[0]);
}
```
