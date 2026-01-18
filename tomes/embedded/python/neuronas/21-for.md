---
id: "python.controlflow.for"
title: "For Loops and Iteration"
category: language
difficulty: novice
tags: [python, loops, iteration, for]
keywords: [for, in, range, enumerate, break, continue]
use_cases: [iterating sequences, repeating operations, processing collections]
prerequisites: ["python.datastructures.lists"]
related: ["python.controlflow.while", "python.patterns.comprehensions"]
next_topics: ["python.controlflow.while"]
---

# For Loops

For loops iterate over sequences (lists, tuples, strings, etc.).

## Basic For Loop

```python
fruits = ["apple", "banana", "cherry"]

for fruit in fruits:
    print(fruit)
# Output: apple, banana, cherry
```

## range() Function

```python
# range(stop) - 0 to stop-1
for i in range(5):
    print(i)
# Output: 0, 1, 2, 3, 4

# range(start, stop)
for i in range(2, 6):
    print(i)
# Output: 2, 3, 4, 5

# range(start, stop, step)
for i in range(0, 10, 2):
    print(i)
# Output: 0, 2, 4, 6, 8

# Negative step
for i in range(5, 0, -1):
    print(i)
# Output: 5, 4, 3, 2, 1
```

## Enumerate - Get Index and Value

```python
fruits = ["apple", "banana", "cherry"]

for index, fruit in enumerate(fruits):
    print(f"{index}: {fruit}")
# Output:
# 0: apple
# 1: banana
# 2: cherry

# Custom start index
for index, fruit in enumerate(fruits, start=1):
    print(f"{index}: {fruit}")
# Output: 1: apple, 2: banana, 3: cherry
```

## Iterating Dictionaries

```python
person = {"name": "Alice", "age": 30, "city": "NYC"}

# Keys
for key in person:
    print(key)
# name, age, city

# Values
for value in person.values():
    print(value)
# Alice, 30, NYC

# Key-value pairs
for key, value in person.items():
    print(f"{key}: {value}")
# name: Alice, age: 30, city: NYC
```

## Nested Loops

```python
for i in range(3):
    for j in range(3):
        print(f"({i}, {j})")
# Output: (0,0), (0,1), (0,2), (1,0), (1,1), ...
```

## break and continue

```python
# break - exit loop completely
for i in range(10):
    if i == 5:
        break
    print(i)
# Output: 0, 1, 2, 3, 4

# continue - skip to next iteration
for i in range(5):
    if i == 2:
        continue
    print(i)
# Output: 0, 1, 3, 4
```

## Loop Control with else

```python
# else executes if loop completes without break
for i in range(5):
    if i == 10:
        break
else:
    print("Completed without break")
# Output: Completed without break
```

## Iterating Strings

```python
text = "Hello"

for char in text:
    print(char)
# Output: H, e, l, l, o
```

## Iterating Files

```python
with open("file.txt", "r") as f:
    for line in f:
        line = line.strip()
        print(line)
```

## Common Patterns

### Sum list elements
```python
total = 0
for num in [1, 2, 3, 4, 5]:
    total += num
print(total)  # 15
```

### Find element
```python
def find_index(lst, target):
    for index, value in enumerate(lst):
        if value == target:
            return index
    return -1  # Not found
```

### Flatten nested lists
```python
nested = [[1, 2], [3, 4], [5, 6]]
flat = []
for sublist in nested:
    for item in sublist:
        flat.append(item)
# flat = [1, 2, 3, 4, 5, 6]
```

### Building dictionary
```python
names = ["alice", "bob", "charlie"]
ages = [30, 25, 35]

user_data = {}
for name, age in zip(names, ages):
    user_data[name] = age
# {'alice': 30, 'bob': 25, 'charlie': 35}
```

> **Tip**: Use list/dict comprehensions instead of loops when building collections.
