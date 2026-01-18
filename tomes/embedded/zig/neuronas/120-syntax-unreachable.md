---
id: "zig.syntax.unreachable"
title: "Unreachable"
category: syntax
difficulty: intermediate
tags: [zig, syntax, control-flow]
keywords: [unreachable, optimization]
use_cases: [impossible states]
prerequisites: ["zig.basics.if"]
related: ["zig.debug.panic"]
next_topics: []
---

# Unreachable

A control flow path that cannot happen.

- **Debug**: Panics if reached.
- **ReleaseFast**: Undefined behavior (optimizer assumes it never happens).

```zig
const x: u8 = 10;
if (x > 255) unreachable;
```
