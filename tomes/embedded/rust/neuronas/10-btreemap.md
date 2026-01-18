---
id: "rust.collections.btreemap"
title: "BTreeMap"
category: collections
difficulty: intermediate
tags: [rust, collections, map, sorted]
keywords: [BTreeMap, sorted map, key-value]
use_cases: [sorted data, range queries]
prerequisites: ["rust.stdlib.collections"]
related: ["rust.stdlib.collections"]
next_topics: ["rust.collections.btreeset"]
---

# BTreeMap

A map based on a B-Tree. Keys are stored in sorted order.

## Usage

Requires keys to implement `Ord`.

```rust
use std::collections::BTreeMap;

fn main() {
    let mut movie_reviews = BTreeMap::new();

    movie_reviews.insert("Office Space", "Deals with real issues in the workplace.");
    movie_reviews.insert("Pulp Fiction", "Masterpiece.");
    movie_reviews.insert("The Godfather", "Very enjoyable.");
    
    // Iterates in sorted order of keys
    for (movie, review) in &movie_reviews {
        println!("{}: \"{}\"", movie, review);
    }
}
```

## Performance

- `O(log n)` for insertion, lookup, and removal.
- Slower than `HashMap` for random access, but allows range queries.

```
