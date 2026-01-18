---
id: "zig.std.tcp"
title: "TCP Sockets"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, net, tcp]
keywords: [listen, accept, connect, stream]
use_cases: [servers, clients]
prerequisites: ["zig.std.net"]
related: ["zig.std.net"]
next_topics: []
---

# TCP Sockets

## Server

```zig
var server = try std.net.listen(.{}, addr);
defer server.deinit();

while (true) {
    const conn = try server.accept();
    defer conn.stream.close();
    // Use conn.stream.reader()/writer()
}
```

## Client

```zig
const stream = try std.net.tcpConnectToAddress(addr);
defer stream.close();
```
