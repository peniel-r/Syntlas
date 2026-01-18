---
id: "python.stdlib.itertools"
title: "Itertools - Iterator Functions"
category: stdlib
difficulty: intermediate
tags: [python, itertools, iterators, functional]
keywords: [chain, zip_longest, combinations, permutations]
use_cases: [data transformation, combinations, efficient iteration]
prerequisites: ["python.controlflow.for"]
related: ["python.stdlib.collections", "python.patterns.comprehensions"]
next_topics: ["python.stdlib.functools"]
---

# Itertools

`itertools` provides efficient functions for working with iterators.

## chain - Chain Iterables

```python
from itertools import chain

list1 = [1, 2, 3]
list2 = [4, 5, 6]
list3 = [7, 8, 9]

# Combine multiple iterables
combined = list(chain(list1, list2, list3))
# [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

## zip_longest - Zip Different Lengths

```python
from itertools import zip_longest

names = ["Alice", "Bob"]
ages = [30, 25, 28]

# Fill missing values
zipped = list(zip_longest(names, ages, fillvalue=None))
# [('Alice', 30), ('Bob', 25), (None, 28)]
```

## combinations - All Combinations

```python
from itertools import combinations

items = ['A', 'B', 'C']

# All pairs (order doesn't matter)
pairs = list(combinations(items, 2))
# [('A', 'B'), ('A', 'C'), ('B', 'C')]

# All triplets
triplets = list(combinations(items, 3))
# [('A', 'B', 'C')]
```

## permutations - All Permutations

```python
from itertools import permutations

items = ['A', 'B']

# All orderings (order matters)
perms = list(permutations(items))
# [('A', 'B'), ('B', 'A')]

# With repetition
perms_with_repetition = list(permutations(items, r=3))
```

## product - Cartesian Product

```python
from itertools import product

colors = ['red', 'blue']
sizes = ['S', 'M', 'L']

# All combinations
combinations = list(product(colors, sizes))
# [('red', 'S'), ('red', 'M'), ('red', 'L'),
#  ('blue', 'S'), ('blue', 'M'), ('blue', 'L')]
```

## islice - Slice Iterators

```python
from itertools import islice, count

# Infinite iterator
counter = count(10)  # 10, 11, 12, ...

# Take first 5
first_five = list(islice(counter, 5))
# [10, 11, 12, 13, 14]

# Slice from 10 to 20
middle_ten = list(islice(counter, 10, 20))
# [20, 21, ..., 29]
```

## takewhile, dropwhile

```python
from itertools import takewhile, dropwhile

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Take while condition is True
small = list(takewhile(lambda x: x < 5, numbers))
# [1, 2, 3, 4]

# Drop while condition is True
large = list(dropwhile(lambda x: x < 5, numbers))
# [5, 6, 7, 8, 9]
```

## groupby - Group by Key

```python
from itertools import groupby
from operator import itemgetter

data = [
    ("fruit", "apple"),
    ("fruit", "banana"),
    ("vegetable", "carrot"),
    ("fruit", "cherry"),
    ("vegetable", "broccoli")
]

# Sort by category first
data.sort(key=itemgetter(0))

# Group by category
for key, group in groupby(data, key=itemgetter(0)):
    print(f"{key}: {list(item[1] for item in group)}")
# fruit: ['apple', 'banana', 'cherry']
# vegetable: ['carrot', 'broccoli']
```

## combinations_with_replacement

```python
from itertools import combinations_with_replacement

items = ['A', 'B']

# Pairs with replacement
pairs = list(combinations_with_replacement(items, 2))
# [('A', 'A'), ('A', 'B'), ('B', 'A'), ('B', 'B')]
```

## accumulate - Cumulative Operations

```python
from itertools import accumulate

numbers = [1, 2, 3, 4, 5]

# Running sum
running_sum = list(accumulate(numbers))
# [1, 3, 6, 10, 15]

# Running product
running_product = list(accumulate(numbers, lambda x, y: x * y))
# [1, 2, 6, 24, 120]

# Running max
running_max = list(accumulate(numbers, max))
# [1, 2, 3, 4, 5]
```

## tee - Split Iterator

```python
from itertools import tee

# Split iterator into multiple independent iterators
it = iter([1, 2, 3, 4, 5])
it1, it2, it3 = tee(it, 3)

list(it1)  # [1, 2, 3, 4, 5]
list(it2)  # [1, 2, 3, 4, 5]
list(it3)  # [1, 2, 3, 4, 5]
```

## Common Use Cases

### Generate all subsets
```python
from itertools import combinations, chain

def all_subsets(items):
    """Generate all possible subsets."""
    result = []
    for r in range(len(items) + 1):
        result.extend(combinations(items, r))
    return result

subsets = all_subsets(['A', 'B', 'C'])
# [(), ('A',), ('B',), ('C',), ('A', 'B'), ...]
```

### Sliding window
```python
from itertools import islice

def sliding_window(iterable, size):
    """Yield sliding windows of given size."""
    it = iter(iterable)
    window = list(islice(it, size))
    yield list(window)
    for elem in it:
        window = window[1:] + [elem]
        yield window

data = [1, 2, 3, 4, 5, 6]
windows = list(sliding_window(data, 3))
# [[1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6]]
```

### Round-robin scheduling
```python
from itertools import cycle, islice

def round_robin(*iterables):
    """Cycle through iterables in round-robin."""
    nexts = cycle(iter(it).__next__ for it in iterables)
    return (next(it) for it in cycle(nexts))

for item in round_robin([1, 2, 3], ['a', 'b', 'c'], [True, False]):
    print(item)
# 1, 'a', True, 2, 'b', False, 3, 'c', ...
```

### Batch processing
```python
from itertools import islice

def batch(iterable, batch_size):
    """Yield batches of given size."""
    it = iter(iterable)
    while batch := list(islice(it, batch_size)):
        yield batch

items = list(range(100))
for batch in batch(items, 10):
    process_batch(batch)
```

> **Performance**: itertools functions return iterators (lazy evaluation) - use `list()` to force evaluation.
