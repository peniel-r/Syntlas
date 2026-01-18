---
id: "cpp.util.regex"
title: "std::regex"
category: util
difficulty: intermediate
tags: [cpp, std, regex, text]
keywords: [regex, regex_match, regex_search]
use_cases: [text validation, parsing]
prerequisites: ["cpp.stl.string"]
related: ["cpp.stl.string"]
next_topics: []
---

# std::regex

Regular expressions.

## Usage

```cpp
#include <regex>
#include <string>
#include <iostream>

int main() {
    std::string s = "subject";
    std::regex e("(sub)(.*)");
    
    if (std::regex_match(s, e)) {
        std::cout << "Match\n";
    }
    
    // Replace
    std::cout << std::regex_replace(s, e, "$2-$1"); // "ject-sub"
}
```

```
