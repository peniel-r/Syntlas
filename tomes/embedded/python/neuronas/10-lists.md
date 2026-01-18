---
id: "python.datastructures.lists"
title: "Lists and List Operations"
category: datastructure
difficulty: novice
tags: [python, lists, sequences, collections]
keywords: [append, extend, insert, remove, sorting, comprehensions]
use_cases: [storing ordered data, managing sequences, list manipulation]
prerequisites: ["python.basics.types"]
related: ["python.datastructures.tuples", "python.datastructures.dicts", "python.patterns.comprehensions"]
next_topics: ["python.datastructures.dicts"]
---

# Lists and List Operations

Lists are ordered, mutable collections that can hold any type.

## Creating Lists

```python
# Empty list
empty = []

# With elements
numbers = [1, 2, 3, 4, 5]
mixed = [1, "hello", 3.14, True]

# From other iterables
from_string = list("hello")  # ['h', 'e', 'l', 'l', 'o']
from_range = list(range(5))   # [0, 1, 2, 3, 4]
```

## Accessing Elements

```python
fruits = ["apple", "banana", "cherry"]

fruits[0]      # 'apple' (first element)
fruits[-1]     # 'cherry' (last element)
fruits[1:3]    # ['banana', 'cherry'] (slice)
fruits[::2]    # ['apple', 'cherry'] (every 2nd)

fruits[1] = "blueberry"  # ['apple', 'blueberry', 'cherry']
```

## Adding Elements

```python
numbers = [1, 2, 3]

numbers.append(4)          # [1, 2, 3, 4] (add to end)
numbers.extend([5, 6])     # [1, 2, 3, 4, 5, 6] (add multiple)
numbers.insert(0, 0)       # [0, 1, 2, 3, 4, 5, 6] (insert at index)
```

## Removing Elements

```python
numbers = [1, 2, 3, 4, 5]

numbers.remove(3)           # [1, 2, 4, 5] (remove by value)
numbers.pop()               # [1, 2, 4] (remove and return last)
numbers.pop(0)             # [2, 4] (remove and return at index)
del numbers[0]              # [4] (delete by index)

numbers.clear()             # [] (remove all elements)
```

## List Methods

```python
nums = [3, 1, 4, 1, 5, 9, 2, 6]

nums.count(1)          # 2 (count occurrences)
nums.index(4)         # 2 (first index of value)
nums.sort()            # [1, 1, 2, 3, 4, 5, 6, 9] (in-place sort)
nums.reverse()         # [9, 6, 5, 4, 3, 2, 1, 1] (in-place reverse)

nums_copy = nums.copy()  # [1, 2, 3, 4] (shallow copy)

letters = ['a', 'b', 'c']
letters * 3            # ['a', 'b', 'c', 'a', 'b', 'c', 'a', 'b', 'c']
```

## Sorting Lists

```python
# sort() - in-place
nums = [3, 1, 4, 1, 5]
nums.sort()          # [1, 1, 3, 4, 5]
nums.sort(reverse=True) # [5, 4, 3, 1, 1]

# sorted() - returns new list
nums = [3, 1, 4, 1, 5]
new_nums = sorted(nums)  # [1, 1, 3, 4, 5]
# nums remains [3, 1, 4, 1, 5]

# Sorting with key
words = ["banana", "Apple", "cherry"]
words.sort(key=str.lower)  # ['Apple', 'banana', 'cherry']
words.sort(key=len)       # ['Apple', 'banana', 'cherry'] (by length)
```

## Checking Lists

```python
nums = [1, 2, 3, 4, 5]

len(nums)        # 5 (length)
1 in nums        # True (membership)
10 in nums       # False

nums1 = [1, 2, 3]
nums2 = [1, 2, 3]
nums1 == nums2    # True (element-wise comparison)
```

## List Comprehensions

```python
# Basic comprehension
squares = [x**2 for x in range(5)]  # [0, 1, 4, 9, 16]

# With condition
evens = [x for x in range(10) if x % 2 == 0]  # [0, 2, 4, 6, 8]

# Nested comprehension
matrix = [[i*j for j in range(3)] for i in range(3)]
# [[0, 0, 0], [0, 1, 2], [0, 2, 4]]
```

> **Note**: Lists are mutable - they can be modified after creation. Use tuples for immutable sequences.
