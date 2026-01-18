---
id: "zig.std.io"
title: "Reader and Writer"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, io, stream]
keywords: [Reader, Writer, print]
use_cases: [streaming data]
prerequisites: ["zig.std.fs"]
related: ["zig.std.formatting"]
next_topics: ["zig.std.formatting"]
---

# Reader and Writer

Interfaces for I/O.

## Writer

```zig
const writer = file.writer();
try writer.print("Hello {}\n", .{123});
try writer.writeAll("Bytes");
```

## Reader

```zig
const reader = file.reader();
var buf: [100]u8 = undefined;
const bytes_read = try reader.read(&buf);
```

```
