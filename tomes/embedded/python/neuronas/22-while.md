---
id: "python.controlflow.while"
title: "While Loops"
category: language
difficulty: novice
tags: [python, loops, iteration, while]
keywords: [while, break, continue, infinite loop]
use_cases: [repeating until condition, waiting for events, polling]
prerequisites: ["python.controlflow.if"]
related: ["python.controlflow.for"]
next_topics: ["python.functions.def"]
---

# While Loops

While loops repeat as long as a condition is True.

## Basic While Loop

```python
count = 0

while count < 5:
    print(count)
    count += 1
# Output: 0, 1, 2, 3, 4
```

## While with User Input

```python
while True:
    response = input("Continue? (yes/no): ")
    if response.lower() == "no":
        break
    print("Continuing...")
```

## break and continue

```python
count = 0

while count < 10:
    count += 1

    if count == 5:
        continue  # Skip 5

    if count == 8:
        break     # Exit early

    print(count)
# Output: 1, 2, 3, 4, 6, 7
```

## While-else

```python
count = 0

while count < 5:
    print(count)
    count += 1
else:
    print("Loop completed")
# Output: 0, 1, 2, 3, 4, Loop completed
```

## Common Use Cases

### Reading until EOF
```python
lines = []
while True:
    try:
        line = input()
        lines.append(line)
    except EOFError:
        break
```

### Polling
```python
import time

while not task_complete:
    check_status()
    time.sleep(1)
```

### Menu system
```python
while True:
    print("1. Option 1")
    print("2. Option 2")
    print("3. Exit")

    choice = input("Enter choice: ")

    if choice == "1":
        handle_option1()
    elif choice == "2":
        handle_option2()
    elif choice == "3":
        break
```

### Validation loop
```python
while True:
    age = input("Enter age: ")
    if age.isdigit() and 0 < int(age) < 120:
        age = int(age)
        break
    print("Invalid age, try again")
```

## Common Patterns

### Countdown
```python
count = 10
while count > 0:
    print(count)
    count -= 1
print("Liftoff!")
```

### Summation
```python
total = 0
i = 1
while i <= 100:
    total += i
    i += 1
print(total)  # 5050
```

### Searching
```python
items = ["apple", "banana", "cherry"]
target = "banana"
index = 0

while index < len(items):
    if items[index] == target:
        print(f"Found at index {index}")
        break
    index += 1
```

> **Warning**: Always ensure while loops have an exit condition to avoid infinite loops.
