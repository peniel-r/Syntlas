---
id: "rust.patterns.builder"
title: "Builder Pattern"
category: patterns
difficulty: intermediate
tags: [rust, patterns, builder, construction]
keywords: [builder, method chaining, build()]
use_cases: [complex object construction, optional parameters]
prerequisites: ["rust.structs", "rust.methods"]
related: ["rust.patterns.newtype"]
next_topics: []
---

# Builder Pattern

Used to construct complex objects, often with many optional configuration settings.

## Implementation

```rust
#[derive(Default)]
struct Server {
    host: String,
    port: u16,
    tls: bool,
}

struct ServerBuilder {
    server: Server,
}

impl ServerBuilder {
    fn new() -> Self {
        ServerBuilder { server: Server::default() }
    }

    fn host(mut self, host: &str) -> Self {
        self.server.host = host.to_string();
        self
    }

    fn port(mut self, port: u16) -> Self {
        self.server.port = port;
        self
    }

    fn build(self) -> Server {
        self.server
    }
}

fn main() {
    let server = ServerBuilder::new()
        .host("127.0.0.1")
        .port(8080)
        .build();
}
```
