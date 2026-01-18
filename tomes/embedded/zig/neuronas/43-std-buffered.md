---
id: "zig.std.buffered"
title: "Buffered IO"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, buffer, performance]
keywords: [BufferedWriter, BufferedReader]
use_cases: [performance]
prerequisites: ["zig.std.io"]
related: ["zig.std.io"]
next_topics: []
---

# Buffered IO

Wraps a reader/writer to minimize syscalls.

## Usage

```zig
var bw = std.io.bufferedWriter(file.writer());
const writer = bw.writer();

try writer.writeAll("Fast");
try bw.flush(); // Don't forget to flush!
```
