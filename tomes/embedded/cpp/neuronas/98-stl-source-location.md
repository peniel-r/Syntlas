---
id: "cpp.stl.source-location"
title: "std::source_location (C++20)"
category: util
difficulty: intermediate
tags: [cpp, stl, logging, debug]
keywords: [source_location, current, file_name, line]
use_cases: [logging, assertions]
prerequisites: ["cpp.lang.preprocessor"]
related: ["cpp.lang.preprocessor"]
next_topics: []
---

# std::source_location

Provides info about source code (file, line, function) without macros.

## Usage

```cpp
#include <source_location>
#include <iostream>

void log(const char* msg, 
         std::source_location loc = std::source_location::current()) {
    std::cout << loc.file_name() << ":" << loc.line() << " " << msg << '\n';
}

int main() {
    log("Hello"); // Prints file:line Hello
}
```

```
