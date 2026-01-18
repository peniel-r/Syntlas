---
id: "cpp.lang.extern-c"
title: "extern \"C\""
category: language
difficulty: intermediate
tags: [cpp, c, interoperability]
keywords: [extern C, name mangling]
use_cases: [linking with C libraries]
prerequisites: ["cpp.basics.functions"]
related: ["cpp.basics.functions"]
next_topics: []
---

# extern "C"

Prevents C++ name mangling, allowing functions to be called from C or to call C functions.

## Usage

```cpp
extern "C" {
    void my_c_function(int a);
}

extern "C" void single_func();
```

```
