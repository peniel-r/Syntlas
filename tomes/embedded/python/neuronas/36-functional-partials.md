---
id: "py.functional.partials"
title: "Partials"
category: functional
difficulty: intermediate
tags: [python, functional, partial]
keywords: [functools, partial, currying]
use_cases: [freezing arguments, callbacks]
prerequisites: ["py.functions.basics"]
related: ["py.lib.functools"]
next_topics: []
---

# Partials

`functools.partial` allows you to fix a certain number of arguments of a function and generate a new function.

## Usage

```python
from functools import partial

def power(base, exponent):
    return base ** exponent

square = partial(power, exponent=2)
cube = partial(power, exponent=3)

print(square(5))  # 25
print(cube(5))    # 125
```
