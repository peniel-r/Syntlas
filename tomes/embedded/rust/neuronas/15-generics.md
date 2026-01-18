---
id: "rust.generics"
title: "Generics"
category: language
difficulty: intermediate
tags: [rust, generics, polymorphism, types]
keywords: [generic, type parameter, <T>]
use_cases: [code reuse, type safety, collections]
prerequisites: ["rust.structs", "rust.patterns.enums"]
related: ["rust.traits", "rust.lifetime"]
next_topics: ["rust.traits"]
---

# Generics

Generics allow you to write code that works with multiple types, reducing code duplication.

## In Functions

```rust
fn largest<T: PartialOrd>(list: &[T]) -> &T {
    let mut largest = &list[0];
    for item in list {
        if item > largest {
            largest = item;
        }
    }
    largest
}
```

## In Structs

```rust
struct Point<T> {
    x: T,
    y: T,
}

let integer = Point { x: 5, y: 10 };
let float = Point { x: 1.0, y: 4.0 };
```

## In Enums

```rust
enum Option<T> {
    Some(T),
    None,
}

enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

## Performance

Rust implements generics using *monomorphization*, meaning it generates specific code for each concrete type used at compile time. There is no runtime cost for using generics.
