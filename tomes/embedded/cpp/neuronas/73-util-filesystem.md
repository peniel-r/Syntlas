---
id: "cpp.util.filesystem"
title: "std::filesystem (C++17)"
category: util
difficulty: intermediate
tags: [cpp, std, filesystem, io]
keywords: [filesystem, path, directory_iterator, exists]
use_cases: [file manipulation, path handling]
prerequisites: ["cpp.io.streams"]
related: ["cpp.io.files"]
next_topics: []
---

# std::filesystem

Cross-platform filesystem operations.

## Usage

```cpp
#include <filesystem>
namespace fs = std::filesystem;

int main() {
    fs::path p = "path/to/file.txt";
    
    if (fs::exists(p)) {
        auto size = fs::file_size(p);
    }
    
    // Iterate directory
    for (const auto& entry : fs::directory_iterator(".")) {
        std::cout << entry.path() << '\n';
    }
}
```

```
