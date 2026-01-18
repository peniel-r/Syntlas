---
id: "rust.collections.linkedlist"
title: "LinkedList"
category: collections
difficulty: intermediate
tags: [rust, collections, linked list]
keywords: [LinkedList, double linked list]
use_cases: [splitting/merging lists, unknown size]
prerequisites: ["rust.collections"]
related: ["rust.collections.vecdeque"]
next_topics: []
---

# LinkedList

A doubly-linked list.

## Warning

It is almost always better to use `Vec` or `VecDeque` due to CPU cache locality. Use `LinkedList` only when you need efficient splitting and merging of lists.

## Usage

```rust
use std::collections::LinkedList;

fn main() {
    let mut list = LinkedList::new();

    list.push_back('a');
    list.push_front('b');
    
    let mut split_list = list.split_off(1);
}
```
