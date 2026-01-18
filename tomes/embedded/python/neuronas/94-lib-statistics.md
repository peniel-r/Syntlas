---
id: "py.lib.statistics"
title: "Statistics (statistics)"
category: stdlib
difficulty: beginner
tags: [python, stdlib, statistics, mean]
keywords: [mean, median, mode, stdev]
use_cases: [data analysis]
prerequisites: ["python.datastructures.lists"]
related: ["py.lib.math"]
next_topics: []
---

# Statistics Module

Basic statistics functions.

## Usage

```python
import statistics

data = [1, 2, 3, 4, 4]

print(statistics.mean(data))   # 2.8
print(statistics.median(data)) # 3
print(statistics.mode(data))   # 4
print(statistics.stdev(data))  # Standard deviation
```
