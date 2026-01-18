---
id: "rust.stdlib.string"
title: "String and Text Processing"
category: stdlib
difficulty: intermediate
tags: [rust, string, &str, String, text]
keywords: [String::from, &str slicing, format, as_str]
use_cases: [text manipulation, string building, formatting]
prerequisites: ["rust.ownership"]
related: ["rust.stdlib.collections"]
next_topics: ["rust.stdlib.io"]
---

# String and Text Processing

Rust has two main string types: `String` (owned) and `&str` (borrowed).

## Creating Strings

```rust
// From &str
let s1 = String::from("hello");
let s2: String = "world".to_string();

// From parts
let s3 = String::new();
s3.push_str("hello");
s3.push_str(" world");

// From characters
let s4: String = ['h', 'e', 'l', 'l', 'o'].iter().collect();
```

## String vs &str

```rust
// String: owned heap-allocated, can grow
let owned: String = String::from("hello");

// &str: borrowed string slice, no allocation
let borrowed: &str = &owned;

fn takes_str(s: &str) {
    // Prefer &str when ownership not needed
    println!("{}", s);
}
```

## String Slicing and Indexing

```rust
let s = String::from("hello");

// Slice by bytes (danger with UTF-8)
let slice = &s[0..5];  // "hello"

// Get characters (UTF-8 aware)
let chars: Vec<char> = s.chars().collect();
let first_char = chars[0];  // 'h'

// Safe byte slicing
if let Some(slice) = s.get(0..5) {
    println!("{}", slice);
}
```

## String Manipulation

```rust
let mut s = String::from("hello world");

// Replace
let replaced = s.replace("hello", "hi");

// Split
let parts: Vec<&str> = s.split_whitespace().collect();
// ["hello", "world"]

// Trim
let trimmed = s.trim();
let trimmed_start = s.trim_start_matches(|c| c == ' ');
```

## String Formatting

```rust
let name = "Alice";
let age = 30;

// format! macro
let message = format!("Hello, {}! You are {}.", name, age);

// Named parameters
let message = format!("Name: {}, Age: {}", name, age);

// Debug format
let debug = format!("{:?}", s);
```

## String Concatenation

```rust
// BAD: Inefficient (creates new String each time)
let mut s = String::new();
s.push_str("hello");
s.push_str(" ");
s.push_str("world");

// GOOD: Use format! or collect
let words = vec!["hello", "world"];
let s = words.join(" ");
```

## String Length

```rust
let s = String::from("hello");

// Bytes (not character count)
let byte_len = s.len();

// Characters
let char_count = s.chars().count();

// UTF-8 aware
let graphemes: Vec<&str> = s.split("").collect();
```

## String Iteration

```rust
let s = String::from("hello");

// Characters
for c in s.chars() {
    println!("{}", c);
}

// Bytes
for b in s.bytes() {
    println!("{}", b);
}

// Lines
for line in s.lines() {
    println!("{}", line);
}
```

## String Comparison

```rust
let s1 = String::from("hello");
let s2 = String::from("hello");

// Equality
if s1 == s2 {
    println!("Strings are equal");
}

// Case-insensitive
if s1.to_lowercase() == s2.to_lowercase() {
    println!("Strings equal ignoring case");
}
```

## Common Patterns

### Build string from parts
```rust
let parts = vec!["hello", " ", "world", "!"];
let s = parts.join("");
```

### Check if string contains substring
```rust
let s = String::from("hello world");
if s.contains("world") {
    println!("Found 'world'");
}
```

### Remove prefix/suffix
```rust
let s = String::from("prefix-value-suffix");

// Remove prefix
let without_prefix = s.strip_prefix("prefix-").unwrap_or(&s);

// Remove suffix
let without_suffix = s.strip_suffix("-suffix").unwrap_or(&s);
```

### Parse delimited string
```rust
let s = String::from("a,b,c");

let parts: Vec<&str> = s.split(",").collect();
// ["a", "b", "c"]

// Split with max parts
let parts: Vec<&str> = s.splitn(2, ",").collect();
// ["a", "b,c"]
```

### String to number conversion
```rust
let s = String::from("42");
let num: i32 = s.parse().unwrap_or(0);
```

> **Note**: String slicing with `&s[0..n]` operates on bytes. Use `s.chars()` for character-level operations.
