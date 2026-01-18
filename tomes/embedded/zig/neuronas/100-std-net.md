---
id: "zig.std.net"
title: "Networking"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, net, ip]
keywords: [Address, parseIp4, localhost]
use_cases: [network communication]
prerequisites: ["zig.std.io"]
related: ["zig.std.tcp"]
next_topics: ["zig.std.tcp"]
---

# Networking

`std.net` provides networking primitives.

## Address

```zig
const addr = try std.net.Address.parseIp4("127.0.0.1", 8080);
```
