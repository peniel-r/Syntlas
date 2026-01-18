---
id: "zig.std.http.client"
title: "HTTP Client"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, http, client]
keywords: [http, client, request, fetch]
use_cases: [api requests]
prerequisites: ["zig.std.net"]
related: ["zig.std.http.server"]
next_topics: []
---

# HTTP Client

Zig has a built-in HTTP client in `std.http`.

```zig
var client = std.http.Client{ .allocator = allocator };
defer client.deinit();

var buf: [1024]u8 = undefined;
const uri = try std.Uri.parse("http://example.com");
const req = try client.fetch(allocator, .{
    .location = .{ .uri = uri },
    .response_storage = .{ .buffer = &buf },
});
```
