---
id: "py.web.json-api"
title: "Consuming JSON APIs"
category: web
difficulty: intermediate
tags: [python, web, json, api]
keywords: [json, urllib, requests]
use_cases: [integrations, data fetching]
prerequisites: ["py.lib.json", "py.net.urllib"]
related: ["py.net.urllib"]
next_topics: []
---

# Consuming JSON APIs

Combining `urllib` (or `requests`) with `json`.

```python
import urllib.request
import json

url = "https://api.github.com/users/octocat"
with urllib.request.urlopen(url) as f:
    data = json.load(f)

print(f"User: {data['name']}")
print(f"Bio: {data['bio']}")
```
