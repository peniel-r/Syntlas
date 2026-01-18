---
id: "py.net.http"
title: "HTTP Servers"
category: networking
difficulty: intermediate
tags: [python, net, http, server]
keywords: [http.server, SimpleHTTPRequestHandler]
use_cases: [serving files, simple apis]
prerequisites: ["py.net.socket"]
related: ["py.net.urllib"]
next_topics: []
---

# HTTP Servers

Python includes a basic HTTP server.

## Serving Files CLI

```bash
python -m http.server 8000
```

## Code

```python
from http.server import HTTPServer, BaseHTTPRequestHandler

class Simple(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Hello World')

httpd = HTTPServer(('localhost', 8000), Simple)
httpd.serve_forever()
```
