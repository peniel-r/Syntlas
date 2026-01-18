---
id: "zig.std.formatting"
title: "Formatting"
category: stdlib
difficulty: beginner
tags: [zig, stdlib, fmt, print]
keywords: [fmt, print, debug]
use_cases: [text output]
prerequisites: ["zig.std.io"]
related: ["zig.std.io"]
next_topics: []
---

# Formatting

Zig uses a format string similar to C/Python but strictly typed.

## Specifiers

- `{}`: Default formatting.
- `{s}`: String (for `[]u8`).
- `{d}`: Decimal.
- `{x}`: Hex (lower).
- `{X}`: Hex (upper).
- `{b}`: Binary.
- `{c}`: Character.
- `{any}`: Any type (verbose struct dump).

## Example

```zig
std.debug.print("{s}: {d}\n", .{ "Value", 42 });
```

```
