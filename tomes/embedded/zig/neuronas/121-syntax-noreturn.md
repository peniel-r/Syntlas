---
id: "zig.syntax.noreturn"
title: "NoReturn"
category: syntax
difficulty: intermediate
tags: [zig, syntax, types]
keywords: [noreturn, panic, exit]
use_cases: [functions that never return]
prerequisites: ["zig.basics.functions"]
related: ["zig.debug.panic"]
next_topics: []
---

# NoReturn

The type `noreturn` means the function will not return control to the caller (e.g., `exit`, `panic`, infinite loop).

```zig
fn abort() noreturn {
    std.process.exit(1);
}
```
