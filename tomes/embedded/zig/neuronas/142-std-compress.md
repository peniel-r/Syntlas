---
id: "zig.std.compress"
title: "Compression"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, compress, zlib]
keywords: [compress, zlib, gzip, deflate]
use_cases: [data reduction]
prerequisites: ["zig.std.io"]
related: ["zig.std.io"]
next_topics: []
---

# Compression

Zig supports compression algorithms.

```zig
var stream = std.compress.zlib.compressor(writer, .{});
try stream.writeAll("data");
try stream.finish();
```
