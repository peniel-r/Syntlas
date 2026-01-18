---
id: "py.functions.closures"
title: "Closures"
category: functions
difficulty: advanced
tags: [python, functions, closure, scope]
keywords: [closure, nonlocal, nested function]
use_cases: [data hiding, decorators, callbacks]
prerequisites: ["python.functions.def"]
related: ["python.patterns.decorators"]
next_topics: ["python.patterns.decorators"]
---

# Closures

A closure is a function object that remembers values in enclosing scopes even if they are not present in memory.

## Example

```python
def make_multiplier(n):
    def multiplier(x):
        return x * n
    return multiplier

times3 = make_multiplier(3)
times5 = make_multiplier(5)

print(times3(9))  # 27
print(times5(3))  # 15
```

The inner function `multiplier` "closes over" the variable `n`.
