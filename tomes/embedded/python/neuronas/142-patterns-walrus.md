---
id: "py.patterns.walrus"
title: "Walrus Operator (:=)"
category: patterns
difficulty: intermediate
tags: [python, patterns, walrus, assignment]
keywords: [:=, assignment expression]
use_cases: [assignment in expression, while loops]
prerequisites: ["py.basics.variables"]
related: ["py.control.while"]
next_topics: []
---

# Walrus Operator (:=)

Assignment expressions (Python 3.8+). Assigns a value to a variable as part of a larger expression.

## While Loops

```python
# Before
line = f.readline()
while line:
    print(line)
    line = f.readline()

# After
while (line := f.readline()):
    print(line)
```

## List Comprehensions

```python
# Calculate expensive result once
results = [y for x in data if (y := expensive(x)) > 0]
```
