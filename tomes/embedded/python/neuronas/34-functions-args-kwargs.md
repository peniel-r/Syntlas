---
id: "py.functions.args-kwargs"
title: "*args and **kwargs"
category: functions
difficulty: intermediate
tags: [python, functions, arguments, unpacking]
keywords: [*args, **kwargs, unpacking]
use_cases: [flexible arguments, wrappers, inheritance]
prerequisites: ["python.functions.def"]
related: ["py.patterns.unpacking"]
next_topics: []
---

# *args and **kwargs

Allow functions to accept an arbitrary number of arguments.

## *args (Positional)

Collects extra positional arguments into a tuple.

```python
def sum_all(*args):
    return sum(args)

sum_all(1, 2, 3)  # 6
```

## **kwargs (Keyword)

Collects extra keyword arguments into a dictionary.

```python
def print_info(**kwargs):
    for k, v in kwargs.items():
        print(f"{k}: {v}")

print_info(name="Alice", age=30)
```
