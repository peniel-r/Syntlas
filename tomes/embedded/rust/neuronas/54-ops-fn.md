---
id: "rust.ops.fn"
title: "Fn Traits"
category: traits
difficulty: expert
tags: [rust, traits, ops, closures]
keywords: [Fn, FnMut, FnOnce, function pointers]
use_cases: [custom closures, function overloading]
prerequisites: ["rust.closures"]
related: ["rust.ops.add"]
next_topics: []
---

# Fn, FnMut, FnOnce

These traits allow instances of a type to be called like functions. This is how closures works, but you can also implement them for your own types (though rare).

- `FnOnce`: Takes `self`.
- `FnMut`: Takes `&mut self`.
- `Fn`: Takes `&self`.

Most users consume these traits (as bounds) rather than implementing them.
