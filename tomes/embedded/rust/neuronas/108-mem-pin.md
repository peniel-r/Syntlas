---
id: "rust.mem.pin"
title: "Pin (std::pin)"
category: memory
difficulty: expert
tags: [rust, memory, pin]
keywords: [Pin, Unpin]
use_cases: [async, self-referential structs]
prerequisites: ["rust.async.pin"]
related: ["rust.async.pin"]
next_topics: []
---

# Pin Details

`Pin<P>` ensures that the pointee of pointer `P` has a stable location in memory.

## Pin on Stack

```rust
use std::pin::Pin;
use std::marker::PhantomPinned;

struct Test {
    _marker: PhantomPinned,
}

let test = Test { _marker: PhantomPinned };
let mut test = Box::pin(test); // Pin on heap
```

Stack pinning is harder and requires `unsafe` or `pin_utils`.
