---
id: "python.stdlib.collections"
title: "Collections Module"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, collections, datastructures]
keywords: [defaultdict, counter, deque, namedtuple]
use_cases: [advanced data structures, counting, grouping]
prerequisites: ["python.datastructures.lists", "python.datastructures.dicts"]
related: ["python.stdlib.itertools"]
next_topics: ["python.stdlib.itertools"]
---

# Collections Module

The `collections` module provides specialized container datatypes.

## defaultdict

Dictionary with default values for missing keys.

```python
from collections import defaultdict

# Count occurrences
words = ["apple", "banana", "apple", "cherry"]
counts = defaultdict(int)

for word in words:
    counts[word] += 1

# counts = {'apple': 2, 'banana': 1, 'cherry': 1}
# No KeyError for missing keys
print(counts["durian"])  # 0 (default int value)

# Group data
groups = defaultdict(list)
items = [("fruit", "apple"), ("fruit", "banana"),
           ("vegetable", "carrot"), ("fruit", "cherry")]

for category, item in items:
    groups[category].append(item)

# groups = {
#   'fruit': ['apple', 'banana', 'cherry'],
#   'vegetable': ['carrot']
# }
```

## Counter

Counts hashable objects.

```python
from collections import Counter

# Count list elements
words = ["apple", "banana", "apple", "cherry", "banana", "apple"]
counts = Counter(words)
# Counter({'apple': 3, 'banana': 2, 'cherry': 1})

# Count characters
text = "hello world"
char_counts = Counter(text)
# Counter({'l': 3, 'o': 2, ' ': 1, 'h': 1, 'e': 1, 'w': 1, 'r': 1, 'd': 1})

# Most common elements
print(counts.most_common(2))
# [('apple', 3), ('banana', 2)]

# Operations
c1 = Counter([1, 2, 3])
c2 = Counter([3, 4, 5])

print(c1 + c2)      # Counter({1: 1, 2: 1, 3: 2, 4: 1, 5: 1})
print(c1 - c2)      # Counter({1: 1, 2: 1}) - only positive counts
print(c1 & c2)      # Counter({3: 1}) - intersection (minimums)
print(c1 | c2)      # Counter({1: 1, 2: 1, 3: 1, 4: 1, 5: 1}) - union (maximums)
```

## deque

Double-ended queue - optimized for appends/pops from both ends.

```python
from collections import deque

# Create deque
d = deque([1, 2, 3])

# Operations from both ends
d.append(4)       # Add to right: [1, 2, 3, 4]
d.appendleft(0)    # Add to left: [0, 1, 2, 3, 4]
d.pop()           # Remove from right: returns 4
d.popleft()        # Remove from left: returns 0

# Rotate
d.rotate(1)        # Shift right: [3, 4, 0, 1, 2]
d.rotate(-1)       # Shift left: [4, 0, 1, 2, 3]

# Extend
d.extend([5, 6])     # Add multiple to right
d.extendleft([9, 8])  # Add multiple to left
```

Use cases: queues, stacks, sliding windows.

```python
# Queue (FIFO)
from collections import deque
queue = deque()

queue.append("task1")
queue.append("task2")
task = queue.popleft()  # task1

# Stack (LIFO) - using list is more common
stack = deque()
stack.append("item1")
stack.append("item2")
item = stack.pop()  # item2

# Sliding window max
from collections import deque

def max_sliding_window(nums, k):
    result = []
    window = deque()

    for i, num in enumerate(nums):
        while window and window[-1] < num:
            window.pop()
        window.append(num)

        if i >= k - 1:
            result.append(window[0])
            if window[0] == nums[i - k + 1]:
                window.popleft()

    return result
```

## namedtuple

Factory function for creating tuple subclasses with named fields.

```python
from collections import namedtuple

# Define named tuple type
Point = namedtuple('Point', ['x', 'y', 'z'])

# Create instances
p1 = Point(10, 20, 30)
p2 = Point(x=5, y=10, z=15)

# Access by name
print(p1.x)  # 10
print(p1.y)  # 20

# Access by index (like regular tuple)
print(p1[0])  # 10

# Unpacking
x, y, z = p1

# Helper methods
p3 = p1._replace(x=100)
d = p1._asdict()  # {'x': 10, 'y': 20, 'z': 30}
```

## OrderedDict (Legacy)

From Python 3.7+, regular dicts preserve insertion order.

```python
from collections import OrderedDict

# Create ordered dict (use regular dict in Python 3.7+)
od = OrderedDict()
od["first"] = 1
od["second"] = 2
od["third"] = 3

# Move to end
od.move_to_end("first")

# Pop last item
item = od.popitem(last=True)
```

## ChainMap

Group multiple dicts together.

```python
from collections import ChainMap

defaults = {"theme": "dark", "language": "en"}
user_config = {"theme": "light"}
system_config = {"timeout": 30}

config = ChainMap(user_config, system_config, defaults)

# Lookup searches from first to last
print(config["theme"])  # light (from user_config)
print(config["timeout"])  # 30 (from system_config)
print(config["language"])  # en (from defaults)
```

## Common Use Cases

### Frequency analysis
```python
from collections import Counter

text = "hello world hello"
counts = Counter(text.split())
print(counts.most_common())
```

### Group by key
```python
from collections import defaultdict

students = [
    ("Alice", 90),
    ("Bob", 85),
    ("Alice", 88),
    ("Bob", 92)
]

by_student = defaultdict(list)
for name, score in students:
    by_student[name].append(score)

# {'Alice': [90, 88], 'Bob': [85, 92]}
```

### LRU Cache implementation
```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.capacity = capacity
        self.cache = OrderedDict()

    def get(self, key):
        if key in self.cache:
            self.cache.move_to_end(key)
            return self.cache[key]
        return None

    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        else:
            if len(self.cache) >= self.capacity:
                self.cache.popitem(last=False)
            self.cache[key] = value
```

> **Performance**: `deque` provides O(1) operations for both ends, unlike lists which are O(n) for insertions at the front.
