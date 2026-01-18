---
id: "rust.traits.from-into"
title: "From and Into"
category: traits
difficulty: intermediate
tags: [rust, traits, conversion]
keywords: [From, Into, type conversion]
use_cases: [type conversion, constructors]
prerequisites: ["rust.traits"]
related: ["rust.traits.from-into"]
next_topics: ["rust.traits.from-into"]
---

# From and Into

The `From` and `Into` traits are used for infallible type conversions.

## From

`From<T> for U` allows you to create a `U` from a `T`.

```rust
struct Number {
    value: i32,
}

impl From<i32> for Number {
    fn from(item: i32) -> Self {
        Number { value: item }
    }
}

let num = Number::from(30);
```

## Into

If you implement `From`, you get `Into` for free.

```rust
let num: Number = 30.into();
```

## Usage in Functions

```rust
fn do_stuff<T: Into<Number>>(n: T) {
    let num = n.into();
    // ...
}
```
