---
# TIER 1: ESSENTIAL
id: "cpp.io.files"
title: "File I/O"
tags: [cpp, io, files, intermediate]
links: ["cpp.basic.strings", "cpp.exceptions"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [fstream, ifstream, ofstream, file-operations]
prerequisites: ["cpp.basic.strings"]
next: ["cpp.io.streams", "cpp.best-practices"]
related:
  - id: "cpp.io.streams"
    type: complement
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# File I/O

C++ provides file streams for reading and writing files.

## Writing Files

```cpp
#include <fstream>

std::ofstream outFile("output.txt");
if (outFile.is_open()) {
    outFile << "Hello, World!" << std::endl;
    outFile << 42 << std::endl;
    outFile.close();
}
```

## Reading Files

```cpp
std::ifstream inFile("input.txt");
if (inFile.is_open()) {
    std::string line;
    while (std::getline(inFile, line)) {
        std::cout << line << std::endl;
    }
    inFile.close();
}
```

## Reading Word by Word

```cpp
std::ifstream inFile("input.txt");
if (inFile.is_open()) {
    std::string word;
    while (inFile >> word) {
        std::cout << word << std::endl;
    }
}
```

## Binary Files

```cpp
// Write binary
std::ofstream outFile("data.bin", std::ios::binary);
int numbers[] = {1, 2, 3, 4, 5};
outFile.write(reinterpret_cast<char*>(numbers), sizeof(numbers));
outFile.close();

// Read binary
std::ifstream inFile("data.bin", std::ios::binary);
int readNumbers[5];
inFile.read(reinterpret_cast<char*>(readNumbers), sizeof(readNumbers));
inFile.close();
```

## File Modes

```cpp
// Open modes
std::ofstream out("file.txt", std::ios::out);  // Write (default)
std::ifstream in("file.txt", std::ios::in);   // Read (default)
std::fstream file("file.txt", std::ios::in | std::ios::out);  // Read/write

// Additional modes
std::ios::app    // Append
std::ios::ate    // Seek to end
std::ios::trunc  // Truncate
std::ios::binary // Binary mode
```

## File Positioning

```cpp
std::ifstream file("data.txt");
file.seekg(0, std::ios::end);  // Seek to end
size_t size = file.tellg();       // Get position
file.seekg(0, std::ios::beg);  // Seek to beginning
```

## See Also

- [Streams](cpp.io.streams) - Console I/O
- [String Streams](cpp.basic.strings) - In-memory formatting
