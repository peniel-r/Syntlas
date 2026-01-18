---
id: "zig.std.hex"
title: "Hex"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, encoding, hex]
keywords: [hex, encode, decode]
use_cases: [binary representation]
prerequisites: ["zig.basics.slices"]
related: ["zig.std.fmt"]
next_topics: []
---

# Hex

## Encode

```zig
const hex = std.fmt.fmtSliceHexLower("hello");
```

## Decode

```zig
var buf: [5]u8 = undefined;
_ = try std.fmt.hexToBytes(&buf, "68656c6c6f");
```
