---
id: "rust.std.net"
title: "Networking (std::net)"
category: stdlib
difficulty: intermediate
tags: [rust, std, net, tcp, udp]
keywords: [TcpListener, TcpStream, UdpSocket, IpAddr]
use_cases: [network services, clients, servers]
prerequisites: ["rust.io", "rust.threading"]
related: ["rust.async"]
next_topics: []
---

# Networking

The `std::net` module provides TCP and UDP networking primitives.

## TCP Server

```rust
use std::net::{TcpListener, TcpStream};
use std::io::{Read, Write};
use std::thread;

fn handle_client(mut stream: TcpStream) {
    let mut buffer = [0; 512];
    stream.read(&mut buffer).unwrap();
    stream.write(&buffer).unwrap(); // Echo back
}

fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:7878")?;

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                thread::spawn(|| handle_client(stream));
            }
            Err(e) => { /* connection failed */ }
        }
    }
    Ok(())
}
```

## TCP Client

```rust
use std::net::TcpStream;
use std::io::{Read, Write};

fn main() -> std::io::Result<()> {
    let mut stream = TcpStream::connect("127.0.0.1:7878")?;

    stream.write(&[1])?;
    let mut buffer = [0; 10];
    stream.read(&mut buffer)?;

    Ok(())
}
```
