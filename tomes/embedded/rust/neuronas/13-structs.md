---
id: "rust.structs"
title: "Structs"
category: types
difficulty: beginner
tags: [rust, structs, types, data structures]
keywords: [struct, field, instance, tuple struct]
use_cases: [custom types, data grouping, object modeling]
prerequisites: ["rust.types"]
related: ["rust.methods", "rust.enums"]
next_topics: ["rust.methods"]
---

# Structs

A `struct`, or structure, is a custom data type that lets you name and package together multiple related values that make up a meaningful group.

## Defining and Instantiating Structs

```rust
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

fn main() {
    let user1 = User {
        email: String::from("someone@example.com"),
        username: String::from("someusername123"),
        active: true,
        sign_in_count: 1,
    };
    
    println!("User: {}", user1.email);
}
```

## Tuple Structs

Structs that look like tuples but have a name.

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32);

let black = Color(0, 0, 0);
let origin = Point(0, 0);
```

## Unit-Like Structs

Structs without any fields. Useful for traits.

```rust
struct AlwaysEqual;
let subject = AlwaysEqual;
```

## Update Syntax

Create a new instance from an existing one.

```rust
let user2 = User {
    email: String::from("another@example.com"),
    ..user1
};
```
