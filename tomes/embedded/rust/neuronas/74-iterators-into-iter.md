---
id: "rust.iterators.into-iter"
title: "IntoIterator Trait"
category: functions
difficulty: intermediate
tags: [rust, iterators, traits, ownership]
keywords: [IntoIterator, into_iter, for loop]
use_cases: [converting types to iterators, for loops]
prerequisites: ["rust.iterators"]
related: ["rust.iterators"]
next_topics: []
---

# IntoIterator

The `IntoIterator` trait allows a type to be converted into an iterator. This is what makes `for` loops work.

## For Loop Desugaring

```rust
let values = vec![1, 2, 3];

// This loop...
for x in values {
    println!("{}", x);
}

// ...desugars to this:
{
    let mut iter = values.into_iter();
    while let Some(x) = iter.next() {
        println!("{}", x);
    }
}
```

## Implementations

- `Vec<T>` -> `IntoIter<T>` (Moves items)
- `&Vec<T>` -> `Iter<T>` (Yields references)
- `&mut Vec<T>` -> `IterMut<T>` (Yields mutable references)
