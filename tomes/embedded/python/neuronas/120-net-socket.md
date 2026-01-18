---
id: "py.net.socket"
title: "Sockets"
category: networking
difficulty: advanced
tags: [python, net, socket, tcp, udp]
keywords: [socket, bind, listen, connect]
use_cases: [low-level networking, servers]
prerequisites: ["py.io.bytes"]
related: ["py.net.http"]
next_topics: []
---

# Sockets

Low-level networking interface.

## TCP Server

```python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('localhost', 12345))
s.listen(1)
conn, addr = s.accept()
with conn:
    print('Connected by', addr)
    while True:
        data = conn.recv(1024)
        if not data: break
        conn.sendall(data)
```

## TCP Client

```python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('localhost', 12345))
s.sendall(b'Hello, world')
data = s.recv(1024)
s.close()
```
