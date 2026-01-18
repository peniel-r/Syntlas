---
id: "python.stdlib.json"
title: "JSON Processing"
category: stdlib
difficulty: intermediate
tags: [python, json, serialization, data-format]
keywords: [json.load, json.dump, json.dumps, json.loads]
use_cases: [API responses, config files, data interchange]
prerequisites: ["python.datastructures.dicts"]
related: ["python.stdlib.io"]
next_topics: ["python.stdlib.pprint"]
---

# JSON Processing

Python's `json` module handles JSON encoding and decoding.

## Encoding to JSON

```python
import json

# Simple types
data = {"name": "Alice", "age": 30}
json_str = json.dumps(data)
# '{"name": "Alice", "age": 30}'

# Pretty print
pretty = json.dumps(data, indent=2)
# {
#   "name": "Alice",
#   "age": 30
# }

# Sort keys
sorted_json = json.dumps(data, indent=2, sort_keys=True)

# Non-ASCII characters
data = {"message": "Hello 世界"}
json_str = json.dumps(data, ensure_ascii=False)
# '{"message": "Hello 世界"}'
```

## Decoding JSON

```python
import json

# Parse JSON string
json_str = '{"name": "Alice", "age": 30}'
data = json.loads(json_str)
print(data["name"])  # Alice

# Handle lists
json_array = '[1, 2, 3]'
numbers = json.loads(json_array)
print(numbers)  # [1, 2, 3]
```

## File I/O

```python
import json

# Write JSON to file
data = {"name": "Alice", "age": 30}
with open("output.json", "w") as f:
    json.dump(data, f, indent=2)

# Read JSON from file
with open("input.json", "r") as f:
    data = json.load(f)
    print(data)
```

## Custom Serialization

```python
import json
from datetime import datetime

class User:
    def __init__(self, name, birth_date):
        self.name = name
        self.birth_date = birth_date

def default_serializer(obj):
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")

user = User("Alice", datetime(1990, 1, 1))
json_str = json.dumps(user.__dict__, default=default_serializer)
```

## Custom Deserialization

```python
import json
from datetime import datetime

def object_hook(dct):
    if "date" in dct:
        dct["date"] = datetime.fromisoformat(dct["date"])
    return dct

json_str = '{"name": "Alice", "date": "1990-01-01T00:00:00"}'
data = json.loads(json_str, object_hook=object_hook)
print(data["date"])  # datetime object
```

## Handling Common Cases

### Config files
```python
import json

# Load config
with open("config.json", "r") as f:
    config = json.load(f)

# Access with defaults
db_url = config.get("database", {}).get("url", "localhost:5432")

# Update and save
config["new_setting"] = "value"
with open("config.json", "w") as f:
    json.dump(config, f, indent=2)
```

### API responses
```python
import json
import urllib.request

# Fetch and parse API response
url = "https://api.example.com/users"
with urllib.request.urlopen(url) as response:
    data = json.loads(response.read())

for user in data["users"]:
    print(user["name"])
```

### Validating JSON
```python
import json

def validate_json(json_str):
    try:
        data = json.loads(json_str)
        return True, data
    except json.JSONDecodeError as e:
        return False, f"Invalid JSON: {e}"

is_valid, data = validate_json('{"name": "Alice"}')
```

### Merging JSON configs
```python
import json

def merge_configs(config1_path, config2_path):
    with open(config1_path, "r") as f:
        config1 = json.load(f)
    with open(config2_path, "r") as f:
        config2 = json.load(f)

    # Deep merge
    merged = {**config1, **config2}
    return merged

merged = merge_configs("default.json", "user.json")
```

## Performance Tips

```python
import json

# Use json.load() for files (faster)
with open("large.json", "r") as f:
    data = json.load(f)  # Efficient

# Not recommended for large files
with open("large.json", "r") as f:
    content = f.read()
    data = json.loads(content)  # Less efficient
```

## Common Errors

### Non-serializable types
```python
# Error
import json
data = {"date": datetime.now()}
json.dumps(data)  # TypeError

# Fix: Custom encoder
data = {"date": datetime.now().isoformat()}
json.dumps(data)
```

### Duplicate keys
```python
# Later key overwrites earlier (not an error, but confusing)
data = json.loads('{"name": "Alice", "name": "Bob"}')
print(data["name"])  # Bob
```

> **Note**: JSON only supports: strings, numbers, booleans, null, arrays, objects. Python's datetime, set, and complex must be converted.
