---
id: "cpp.memory.raii"
title: "RAII"
category: memory
difficulty: intermediate
tags: [cpp, memory, raii, patterns]
keywords: [Resource Acquisition Is Initialization, destructor]
use_cases: [resource management, exception safety]
prerequisites: ["cpp.oo.constructors", "cpp.oo.classes"]
related: ["cpp.memory.smart-pointers"]
next_topics: []
---

# RAII

**R**esource **A**cquisition **I**s **I**nitialization.

## Principle

Bind the life cycle of a resource (memory, file handle, mutex) to the lifetime of an object.
1. Acquire resource in constructor.
2. Release resource in destructor.

Since local objects are automatically destroyed when they go out of scope, resources are guaranteed to be released.

```cpp
class FileHandle {
    FILE* file;
public:
    FileHandle(const char* name) { file = fopen(name, "r"); }
    ~FileHandle() { if(file) fclose(file); }
};
```
