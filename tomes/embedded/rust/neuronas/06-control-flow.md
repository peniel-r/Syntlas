---
id: "rust.control-flow"
title: "Control Flow"
category: basics
difficulty: beginner
tags: [rust, control flow, if, loops]
keywords: [if, else, loop, while, for]
use_cases: [logic, iteration, branching]
prerequisites: ["rust.functions"]
related: ["rust.patterns.match", "rust.iterators"]
next_topics: ["rust.ownership"]
---

# Control Flow

The ability to run some code depending on whether a condition is true and to run some code repeatedly while a condition is true are basic building blocks in most programming languages.

## if Expressions

```rust
let number = 3;

if number < 5 {
    println!("condition was true");
} else {
    println!("condition was false");
}
```

Using `if` in a `let` statement:

```rust
let condition = true;
let number = if condition { 5 } else { 6 };
```

## Loops

Rust has three kinds of loops: `loop`, `while`, and `for`.

### loop

Repeats forever until explicitly stopped with `break`.

```rust
let mut counter = 0;
let result = loop {
    counter += 1;
    if counter == 10 {
        break counter * 2;
    }
};
```

### while

Runs while a condition is true.

```rust
let mut number = 3;

while number != 0 {
    println!("{}!", number);
    number -= 1;
}
```

### for

Iterates over a collection.

```rust
let a = [10, 20, 30, 40, 50];

for element in a {
    println!("the value is: {}", element);
}

// Range
for number in (1..4).rev() {
    println!("{}!", number);
}
```
