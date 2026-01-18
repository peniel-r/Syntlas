---
id: "py.lib.copy"
title: "Copying (copy)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, copy, deepcopy]
keywords: [copy, deepcopy, shallow copy]
use_cases: [duplicating objects]
prerequisites: ["python.datastructures.lists"]
related: ["python.datastructures.lists"]
next_topics: []
---

# Copy Module

## Shallow Copy

Copies structure, but elements share references.

```python
import copy
list1 = [[1], [2]]
list2 = copy.copy(list1)
list2[0][0] = 9
print(list1)  # [[9], [2]] (Modified!)
```

## Deep Copy

Recursive copy. Independent objects.

```python
list3 = copy.deepcopy(list1)
list3[0][0] = 5
print(list1)  # [[9], [2]] (Unchanged)
```
