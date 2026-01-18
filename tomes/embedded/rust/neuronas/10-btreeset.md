---
id: "rust.collections.btreeset"
title: "BTreeSet"
category: collections
difficulty: intermediate
tags: [rust, collections, set, sorted]
keywords: [BTreeSet, sorted set, unique]
use_cases: [sorted unique items, set operations]
prerequisites: ["rust.collections.btreemap"]
related: ["rust.collections.hashset"]
next_topics: []
---

# BTreeSet

A set based on a B-Tree. Stores unique elements in sorted order.

## Usage

```rust
use std::collections::BTreeSet;

fn main() {
    let mut books = BTreeSet::new();

    books.insert("A Song of Ice and Fire");
    books.insert("The Hobbit");
    
    if !books.contains("Harry Potter") {
        println!("We have {} books, but not Harry Potter.", books.len());
    }
}
```

## Set Operations

```rust
let set1: BTreeSet<_> = [1, 2, 3].iter().cloned().collect();
let set2: BTreeSet<_> = [3, 4, 5].iter().cloned().collect();

// Intersection: [3]
let intersection: Vec<_> = set1.intersection(&set2).collect();
```
