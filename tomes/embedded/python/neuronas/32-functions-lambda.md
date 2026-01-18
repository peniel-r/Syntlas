---
id: "py.functions.lambda"
title: "Lambda Functions"
category: functions
difficulty: intermediate
tags: [python, functions, lambda, anonymous]
keywords: [lambda, anonymous function]
use_cases: [short callbacks, functional programming]
prerequisites: ["py.functions.basics"]
related: ["py.functional.map-filter"]
next_topics: []
---

# Lambda Functions

Small, anonymous functions defined with the `lambda` keyword.

## Syntax

`lambda arguments: expression`

```python
add = lambda x, y: x + y
print(add(2, 3))  # 5
```

## Usage

Often used as arguments to higher-order functions like `map`, `filter`, or `sort`.

```python
points = [(1, 2), (3, 1), (5, 0)]
points.sort(key=lambda p: p[1])  # Sort by y-coordinate
```
