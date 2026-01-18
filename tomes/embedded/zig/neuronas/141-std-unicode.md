---
id: "zig.std.unicode"
title: "Unicode"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, unicode, utf8]
keywords: [utf8, decode, codepoint]
use_cases: [text processing]
prerequisites: ["zig.std.ascii"]
related: ["zig.std.ascii"]
next_topics: []
---

# Unicode

`std.unicode` handles UTF-8.

```zig
const s = "Hello 🌍";
const len = try std.unicode.utf8CountCodepoints(s);
```
