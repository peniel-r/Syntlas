---
id: "python.pickle"
title: "Object Serialization with Pickle"
category: stdlib
difficulty: intermediate
tags: [python, pickle, serialization, persistence]
keywords: [pickle.dump, pickle.load, dumps, loads]
use_cases: [object persistence, data caching, inter-process]
prerequisites: ["python.classes"]
related: ["python.stdlib.json"]
next_topics: []
---

# Pickle

Pickle serializes Python objects to bytes for storage/transmission.

## Basic Serialization

```python
import pickle

# Serialize object
data = {"name": "Alice", "age": 30}
serialized = pickle.dumps(data)

# Deserialize object
deserialized = pickle.loads(serialized)
print(deserialized)  # {'name': 'Alice', 'age': 30}
```

## File I/O

```python
import pickle

# Save to file
data = {"users": [...], "config": {...}}

with open("data.pkl", "wb") as f:
    pickle.dump(data, f)

# Load from file
with open("data.pkl", "rb") as f:
    loaded = pickle.load(f)
    print(loaded)
```

## Custom Objects

```python
import pickle

class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age

user = User("Alice", 30)

# Serialize
serialized = pickle.dumps(user)

# Deserialize
loaded_user = pickle.loads(serialized)
print(loaded_user.name)  # Alice
```

## Protocol Version

```python
import pickle

# Specify protocol for compatibility
# Protocol 4: Python 3.8+ (default)
# Higher protocol = newer features, but less compatible

data = {"key": "value"}
serialized = pickle.dumps(data, protocol=4)

# Load works with compatible protocol
loaded = pickle.loads(serialized)
```

## Handling Classes

```python
import pickle

class Account:
    def __init__(self, balance):
        self.balance = balance

account = Account(100.0)

# Serialize
with open("account.pkl", "wb") as f:
    pickle.dump(account, f)

# Deserialize
with open("account.pkl", "rb") as f:
    loaded = pickle.load(f)
    print(loaded.balance)  # 100.0
```

## Security Warning

```python
import pickle

# DANGER: Never unpickle untrusted data!
# Pickle can execute arbitrary code during deserialization

# BAD - loading from untrusted source
with open("untrusted.pkl", "rb") as f:
    data = pickle.load(f)  # POTENTIALLY DANGEROUS

# SAFE alternatives:
# 1. Use JSON for data-only serialization
import json
json_data = json.loads(trusted_json)

# 2. Use HMAC signatures if pickle required
import hmac
with open("data.pkl", "rb") as f:
    serialized = f.read()
    # Verify signature before unpickling
    if verify_hmac(serialized):
        data = pickle.loads(serialized)
```

## Common Use Cases

### Caching expensive objects
```python
import pickle
import os

def cache_result(key, obj):
    """Cache object to disk."""
    with open(f"cache/{key}.pkl", "wb") as f:
        pickle.dump(obj, f)

def load_cached(key):
    """Load object from cache."""
    cache_file = f"cache/{key}.pkl"
    if os.path.exists(cache_file):
        with open(cache_file, "rb") as f:
            return pickle.load(f)
    return None
```

### Machine learning model persistence
```python
import pickle

class Model:
    def __init__(self, weights):
        self.weights = weights

    def train(self, data):
        # Training logic...
        pass

# Save trained model
model = Model([...])
model.train([...])

with open("model.pkl", "wb") as f:
    pickle.dump(model, f)

# Load model later
with open("model.pkl", "rb") as f:
    loaded_model = pickle.load(f)
```

### Session storage
```python
import pickle
import uuid

def save_session(session_data):
    """Save session to file."""
    session_id = str(uuid.uuid4())
    filename = f"sessions/{session_id}.pkl"
    with open(filename, "wb") as f:
        pickle.dump(session_data, f)
    return session_id

def load_session(session_id):
    """Load session from file."""
    filename = f"sessions/{session_id}.pkl"
    with open(filename, "rb") as f:
        return pickle.load(f)
```

### Inter-process communication
```python
import pickle
import socket

def send_object(conn, obj):
    """Send pickled object over socket."""
    serialized = pickle.dumps(obj)
    conn.sendall(serialized)

def receive_object(conn):
    """Receive and unpickle object from socket."""
    serialized = conn.recv(4096)
    return pickle.loads(serialized)
```

## Pickle vs JSON

| Feature | Pickle | JSON |
|----------|---------|-------|
| Python objects | Yes | No |
| Readable | No | Yes |
| Cross-language | No | Yes |
| Security | Risky | Safe |
| Size | Smaller | Larger |
| Speed | Faster | Slower |

> **Best Practice**: Use JSON for data interchange. Use pickle only for Python-specific object persistence in trusted environments.
