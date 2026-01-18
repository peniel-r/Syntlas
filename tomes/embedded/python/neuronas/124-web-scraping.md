---
id: "py.web.scraping"
title: "Web Scraping Concepts"
category: web
difficulty: intermediate
tags: [python, web, scraping, html]
keywords: [html, parser, scraping]
use_cases: [data extraction]
prerequisites: ["py.net.urllib"]
related: ["py.net.urllib"]
next_topics: []
---

# Web Scraping

Extracting data from HTML.

## HTMLParser (Built-in)

For simple tasks. For complex scraping, use `BeautifulSoup` (external).

```python
from html.parser import HTMLParser

class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print("Start tag:", tag)
    def handle_data(self, data):
        print("Data:", data)

parser = MyHTMLParser()
parser.feed('<html><head><title>Test</title></head><body><h1>Parse me!</h1></body></html>')
```
