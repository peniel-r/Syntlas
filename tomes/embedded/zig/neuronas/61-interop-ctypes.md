---
id: "zig.interop.ctypes"
title: "C Types"
category: interop
difficulty: intermediate
tags: [zig, interop, types, abi]
keywords: [c_int, c_char, null]
use_cases: [abi compatibility]
prerequisites: ["zig.interop.cimport"]
related: ["zig.interop.extern"]
next_topics: ["zig.interop.extern"]
---

# C Types

Zig provides types that match C ABI.

- `c_int`, `c_long`, `c_ulong`
- `[*c]T`: C pointer (can be null, supports arithmetic).
- `?[*]T`: Optional pointer (safer).

```zig
const ptr: [*c]const u8 = "string";
```
