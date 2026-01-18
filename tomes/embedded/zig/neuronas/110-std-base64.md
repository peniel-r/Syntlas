---
id: "zig.std.base64"
title: "Base64"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, encoding, base64]
keywords: [Base64, encode, decode]
use_cases: [encoding binary data]
prerequisites: ["zig.basics.slices"]
related: ["zig.std.crypto"]
next_topics: []
---

# Base64

## Encode

```zig
const Base64 = std.base64.standard;
var buf: [100]u8 = undefined;
const slice = Base64.Encoder.encode(&buf, "hello");
```

## Decode

```zig
try Base64.Decoder.decode(&buf, slice);
```
