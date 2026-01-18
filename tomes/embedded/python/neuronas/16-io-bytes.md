---
id: "py.io.bytes"
title: "Bytes and Bytearray"
category: io
difficulty: intermediate
tags: [python, io, bytes, binary]
keywords: [bytes, bytearray, encode, decode]
use_cases: [binary data, network packets, image processing]
prerequisites: ["py.io.files", "py.basics.strings"]
related: ["py.io.files"]
next_topics: []
---

# Bytes and Bytearray

Python distinguishes between text (`str`) and binary data (`bytes`).

## Bytes (Immutable)

```python
b = b'hello'
print(b[0])  # 104 (ASCII for 'h')

# Encoding/Decoding
s = "café"
b = s.encode('utf-8')  # b'caf\xc3\xa9'
s2 = b.decode('utf-8') # "café"
```

## Bytearray (Mutable)

```python
ba = bytearray(b'hello')
ba[0] = 87  # 'W'
print(ba)   # bytearray(b'Wello')
```

## Binary File I/O

```python
with open('image.png', 'rb') as f:
    data = f.read()
```
