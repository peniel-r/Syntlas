---
id: "py.net.urllib"
title: "Urllib"
category: networking
difficulty: intermediate
tags: [python, net, http, client]
keywords: [urllib, request, urlopen]
use_cases: [http requests, downloading files]
prerequisites: ["py.io.bytes"]
related: ["py.lib.json"]
next_topics: []
---

# Urllib

URL handling module.

## GET Request

```python
import urllib.request

with urllib.request.urlopen('http://python.org/') as response:
    html = response.read()
    print(html[:100])
```

## POST Request

```python
import urllib.parse
import urllib.request

data = urllib.parse.urlencode({'key': 'value'}).encode()
req = urllib.request.Request('http://httpbin.org/post', data=data)

with urllib.request.urlopen(req) as response:
    print(response.read())
```
