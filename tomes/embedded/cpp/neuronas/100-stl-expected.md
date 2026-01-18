---
id: "cpp.stl.expected"
title: "std::expected (C++23)"
category: stl
difficulty: intermediate
tags: [cpp, stl, expected, error-handling]
keywords: [expected, value_or, error]
use_cases: [error handling without exceptions]
prerequisites: ["cpp.stl.optional", "cpp.stl.variant"]
related: ["cpp.stl.optional"]
next_topics: []
---

# std::expected

Holds either a value `T` (success) or an error `E` (failure).

## Usage

```cpp
#include <expected>
#include <string>

std::expected<int, std::string> parse(const std::string& input) {
    if (input == "42") return 42;
    return std::unexpected("Parse error");
}

int main() {
    auto res = parse("42");
    if (res) {
        int val = *res;
    } else {
        std::string err = res.error();
    }
}
```
