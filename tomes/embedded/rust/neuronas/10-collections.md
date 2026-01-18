---
id: "rust.stdlib.collections"
title: "Standard Library Collections"
category: stdlib
difficulty: intermediate
tags: [rust, stdlib, vec, hashmap, btreemap]
keywords: [Vec, HashMap, BTreeMap, HashSet, BTreeSet]
use_cases: [dynamic arrays, key-value storage, ordered collections]
prerequisites: ["rust.ownership"]
related: ["rust.stdlib.iterators"]
next_topics: ["rust.stdlib.string"]
---

# Standard Library Collections

## Vec<T> - Dynamic Array

```rust
use std::vec::Vec;

fn main() {
    // Create empty vec
    let mut v: Vec<i32> = Vec::new();

    // Create with initial values
    let v = vec
![1, 2, 3];

    // With capacity (pre-allocate)
    let mut v: Vec<i32> = Vec::with_capacity(10);

    // Add elements
    v.push(4);
    v.push(5);

    // Remove and return last element
    let last = v.pop();

    // Access elements
    let first = v[0];
    let slice = &v[1..3];

    // Length and capacity
    println!("Length: {}, Capacity: {}", v.len(), v.capacity());
}
```

## HashMap<K, V> - Hash Map

```rust
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();

    // Insert values
    map.insert(String::from("apple"), 5);
    map.insert(String::from("banana"), 3);

    // Get value
    if let Some(count) = map.get(&String::from("apple")) {
        println!("Apple count: {}", count);
    }

    // Remove value
    map.remove(&String::from("banana"));

    // Iterate
    for (key, value) in &map {
        println!("{}: {}", key, value);
    }

    // Entry API
    map.entry(String::from("cherry")).or_insert(0);
}
```

## BTreeMap<K, V> - Ordered Map

```rust
use std::collections::BTreeMap;

fn main() {
    let mut map = BTreeMap::new();

    map.insert(1, String::from("first"));
    map.insert(2, String::from("second"));
    map.insert(3, String::from("third"));

    // Keys are ordered (sorted)
    for (key, value) in &map {
        println!("{}: {}", key, value);
    }

    // Range queries
    let range = map.range(2..=3);
    for (key, value) in range {
        println!("{}: {}", key, value);
    }
}
```

## HashSet<T> - Hash Set

```rust
use std::collections::HashSet;

fn main() {
    let mut set = HashSet::new();

    // Insert elements
    set.insert(1);
    set.insert(2);
    set.insert(3);

    // Check membership
    if set.contains(&2) {
        println!("2 is in set");
    }

    // Remove element
    set.remove(&1);

    // Union, intersection, difference
    let set1: HashSet<i32> = [1, 2, 3].iter().cloned().collect();
    let set2: HashSet<i32> = [3, 4, 5].iter().cloned().collect();

    let union: HashSet<_> = set1.union(&set2).cloned().collect();
    let intersection: HashSet<_> = set1.intersection(&set2).cloned().collect();
    let difference: HashSet<_> = set1.difference(&set2).cloned().collect();
}
```

## BTreeSet<T> - Ordered Set

```rust
use std::collections::BTreeSet;

fn main() {
    let mut set = BTreeSet::new();

    set.insert(3);
    set.insert(1);
    set.insert(4);
    set.insert(2);

    // Elements are ordered
    for item in &set {
        println!("{}", item);  // 1, 2, 3, 4
    }

    // Range queries
    let range = set.range(&2..=&4);
    for item in range {
        println!("{}", item);  // 2, 3, 4
    }
}
```

## VecDeque<T> - Double-Ended Queue

```rust
use std::collections::VecDeque;

fn main() {
    let mut deque: VecDeque<i32> = VecDeque::new();

    // Push to front
    deque.push_front(1);
    deque.push_front(2);

    // Push to back
    deque.push_back(3);
    deque.push_back(4);

    // Pop from front
    let front = deque.pop_front();

    // Pop from back
    let back = deque.pop_back();

    // Access by index
    let first = deque[0];
    let last = deque[deque.len() - 1];
}
```

## LinkedList<T> - Doubly Linked List

```rust
use std::collections::LinkedList;

fn main() {
    let mut list = LinkedList::new();

    // Push front
    list.push_front(1);
    list.push_front(2);

    // Push back
    list.push_back(3);
    list.push_back(4);

    // Pop front
    let front = list.pop_front();

    // Pop back
    let back = list.pop_back();

    // Iterate
    for item in &list {
        println!("{}", item);
    }
}
```

## BinaryHeap<T> - Priority Queue

```rust
use std::collections::BinaryHeap;

fn main() {
    let mut heap = BinaryHeap::new();

    // Push elements (min-heap default)
    heap.push(5);
    heap.push(3);
    heap.push(10);
    heap.push(1);

    // Pop smallest
    let smallest = heap.pop();

    // Convert to max-heap with Reverse
    use std::cmp::Reverse;
    let mut max_heap = BinaryHeap::new();
    max_heap.push(Reverse(5));
    let largest = heap.pop();
}
```

## Common Patterns

### Count occurrences
```rust
use std::collections::HashMap;

fn count_occurrences(items: &[i32]) -> HashMap<i32, usize> {
    let mut counts = HashMap::new();
    for &item in items {
        *counts.entry(item).or_insert(0) += 1;
    }
    counts
}

fn main() {
    let items = vec
![1, 2, 2, 3, 1];
    let counts = count_occurrences(&items);
    println!("{:?}", counts);  // {1: 2, 2: 2, 3: 1}
}
```

### LRU Cache
```rust
use std::collections::{HashMap, VecDeque};

struct LRUCache<K, V> {
    capacity: usize,
    map: HashMap<K, V>,
    order: VecDeque<K>,
}

impl<K: Eq + std::hash::Hash, V> LRUCache<K, V> {
    fn new(capacity: usize) -> Self {
        LRUCache {
            capacity,
            map: HashMap::new(),
            order: VecDeque::new(),
        }
    }

    fn get(&mut self, key: &K) -> Option<&V> {
        if let Some(value) = self.map.get(key) {
            // Move to most recently used
            self.order.retain(|k| k != key);
            self.order.push_back(*key);
            Some(value)
        } else {
            None
        }
    }

    fn put(&mut self, key: K, value: V) {
        if self.order.len() >= self.capacity {
            if let Some(oldest) = self.order.pop_front() {
                self.map.remove(&oldest);
            }
        }
        self.order.push_back(key);
        self.map.insert(key, value);
    }
}
```

### Group by key
```rust
use std::collections::HashMap;

fn group_by_key<T: Eq + std::hash::Hash, K, F>(
    items: &[T],
    key_func: F,
) -> HashMap<K, Vec<T>>
where
    F: Fn(&T) -> K,
{
    let mut groups = HashMap::new();
    for item in items {
        let key = key_func(item);
        groups.entry(key).or_insert_with(Vec::new).push(item);
    }
    groups
}
```

> **Performance**: Use HashMap for O(1) lookups, BTreeMap for O(log n) lookups but ordered iteration.
