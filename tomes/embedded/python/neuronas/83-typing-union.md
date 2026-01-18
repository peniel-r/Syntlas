---
id: "py.typing.union-optional"
title: "Union and Optional"
category: typing
difficulty: intermediate
tags: [python, typing, union, optional]
keywords: [Union, Optional, None]
use_cases: [nullable values, multiple types]
prerequisites: ["python.basics.types"]
related: ["py.typing.generics"]
next_topics: []
---

# Union and Optional

## Union

Value can be one of several types.

```python
from typing import Union

def process(value: Union[int, str]):
    if isinstance(value, int):
        print(value * 2)
    else:
        print(value.upper())

# Python 3.10+ syntax
def process_modern(value: int | str):
    pass
```

## Optional

Shorthand for `Union[T, None]`.

```python
from typing import Optional

def find_user(id: int) -> Optional[str]:
    return "Alice" if id == 1 else None
```
