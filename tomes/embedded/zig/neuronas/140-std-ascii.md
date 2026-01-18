---
id: "zig.std.ascii"
title: "ASCII"
category: stdlib
difficulty: beginner
tags: [zig, stdlib, ascii, text]
keywords: [ascii, toUpper, isDigit]
use_cases: [text processing]
prerequisites: ["zig.basics.values"]
related: ["zig.std.unicode"]
next_topics: ["zig.std.unicode"]
---

# ASCII

`std.ascii` utilities.

```zig
const upper = std.ascii.toUpper('a'); // 'A'
const is_digit = std.ascii.isDigit('9'); // true
```
