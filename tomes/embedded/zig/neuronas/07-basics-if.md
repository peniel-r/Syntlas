---
id: "zig.basics.if"
title: "If Expressions"
category: basics
difficulty: beginner
tags: [zig, basics, control-flow]
keywords: [if, else]
use_cases: [branching]
prerequisites: ["zig.basics.values"]
related: ["zig.basics.switch"]
next_topics: ["zig.basics.switch"]
---

# If Expressions

`if` is an expression in Zig.

## Usage

```zig
const x = 5;
if (x > 0) {
    // ...
} else {
    // ...
}
```

## As Expression

```zig
const y = if (x > 0) 1 else -1;
```
