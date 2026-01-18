---
id: "zig.interop.cimport"
title: "C Import"
category: interop
difficulty: intermediate
tags: [zig, interop, c, header]
keywords: [@cImport, @cInclude]
use_cases: [using c libraries]
prerequisites: ["zig.basics.values"]
related: ["zig.interop.ctypes"]
next_topics: ["zig.interop.ctypes"]
---

# C Import

Zig can directly parse C headers.

```zig
const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
});

pub fn main() void {
    _ = c.printf("Hello from C\n");
}
```

