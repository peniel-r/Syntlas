---
id: "c.file.operations"
title: "File Operations"
category: stdlib
difficulty: intermediate
tags: [c, stdio, file, fopen, fclose, fread, fwrite, fprintf]
keywords: [fopen, fclose, fread, fwrite, fprintf, remove, rename, stat]
use_cases: [file I/O, text files, binary files, file management, error handling]
prerequisites: []
related: ["c.stdlib.string"]
next_topics: ["c.stdlib.math"]
---

# File Operations

C's <stdio.h> provides comprehensive file I/O operations.

## Opening Files

```c
#include <stdio.h>

int main() {
    // Open file for reading
    FILE* file = fopen("data.txt", "r");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }
    
    // Open file for writing
    FILE* write_file = fopen("output.txt", "w");
    if (write_file == NULL) {
        perror("Failed to create file");
        fclose(file);
        return 1;
    }
    
    // Open file for appending
    FILE* append_file = fopen("log.txt", "a");
    if (append_file == NULL) {
        perror("Failed to open log file");
        fclose(file);
        return 1;
    }
    
    // Open file for read/write
    FILE* rw_file = fopen("config.txt", "w+");
    if (rw_file == NULL) {
        perror("Failed to open config file");
        return 1;
    }
    
    fclose(file);
    return 0;
}
```

## Reading Files

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "r");
    if (file == NULL) return 1;
    
    // Read entire file into buffer
    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    
    char* buffer = (char*)malloc(file_size + 1);
    if (buffer == NULL) {
        fclose(file);
        return 1;
    }
    
    size_t bytes_read = fread(buffer, 1, file_size, file);
    buffer[bytes_read] = '\0';  // Null-terminate
    
    printf("Read %zu bytes\n", bytes_read);
    printf("First 10 chars: %.*s\n", 10, buffer);
    
    free(buffer);
    fclose(file);
    return 0;
}
```

## Writing Files

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("output.txt", "w");
    if (file == NULL) return 1;
    
    // Write string
    const char* message = "Hello, World!\n";
    fprintf(file, "%s", message);
    
    // Write formatted output
    int value = 42;
    fprintf(file, "The answer is: %d\n", value);
    
    // Write multiple values
    for (int i = 0; i < 5; i++) {
        fprintf(file, "Value %d: %d\n", i, i * 10);
    }
    
    // Flush output
    fflush(file);
    
    fclose(file);
    return 0;
}
```

## File Positioning

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "r+");
    if (file == NULL) return 1;
    
    // Get current position
    long pos = ftell(file);
    printf("Current position: %ld\n", pos);
    
    // Seek to beginning
    fseek(file, 0, SEEK_SET);
    
    // Seek to end
    fseek(file, 0, SEEK_END);
    long end_pos = ftell(file);
    printf("End position: %ld\n", end_pos);
    
    // Seek to specific position
    fseek(file, 100, SEEK_SET);
    printf("Seeked to position 100\n");
    
    fclose(file);
    return 0;
}
```

## File Closing

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "r");
    if (file == NULL) return 1;
    
    // Close file
    fclose(file);
    
    // Attempt to use closed file (undefined behavior)
    // fprintf(file, "This will crash\n");
    
    return 0;
}
```

## File Deletion

```c
#include <stdio.h>

int main() {
    // Remove file
    if (remove("old_file.txt") == 0) {
        printf("File deleted successfully\n");
    } else {
        perror("Failed to delete file");
        return 1;
    }
    
    return 0;
}
```

## File Metadata

```c
#include <stdio.h>

int main() {
    // Get file information using stat
    struct stat file_stat;
    if (stat("data.txt", &file_stat) != 0) {
        perror("Failed to get file stats");
        return 1;
    }
    
    printf("File size: %ld bytes\n", file_stat.st_size);
    
    // Check if it's a directory
    if (S_ISDIR(file_stat.st_mode)) {
        printf("Path is a directory\n");
    } else {
        printf("Path is a regular file\n");
    }
    
    return 0;
}
```

## File Errors

```c
#include <stdio.h>

int main() {
    // Attempt to open non-existent file
    FILE* file = fopen("nonexistent.txt", "r");
    if (file == NULL) {
        // Error: File not found
        perror("Cannot open non-existent.txt");
        return 1;
    }
    
    // Attempt to open file with invalid path
    file = fopen("/invalid/path/that/does/not/exist", "r");
    if (file == NULL) {
        perror("Cannot open /invalid/path");
        return 1;
    }
    
    return 0;
}
```

## Temporary Files

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Create temporary file using tmpnam
    char temp_path[L_tmpnam] = {0};
    tmpnam(temp_path);
    if (temp_path[0] == '\0') {
        perror("Failed to create temp file name");
        return 1;
    }
    
    FILE* temp_file = fopen(temp_path, "w");
    if (temp_file == NULL) {
        perror("Failed to create temp file");
        return 1;
    }
    
    fprintf(temp_file, "Temporary data\n");
    fclose(temp_file);
    
    // Use temp file
    // ...
    
    // Delete temp file
    remove(temp_path);
    
    printf("Temporary operations complete\n");
    return 0;
}
```

## Binary Files

```c
#include <stdio.h>

int main() {
    // Binary read/write
    FILE* file = fopen("data.bin", "wb+");
    if (file == NULL) return 1;
    
    // Write binary data
    int values[] = {1, 2, 3, 4, 5};
    size_t written = fwrite(values, sizeof(values), file);
    
    fclose(file);
    printf("Wrote %zu integers\n", written);
    return 0;
}
```

## File Copy Operations

```c
#include <stdio.h>

int main() {
    // Copy file using system() function
    int result = system("copy source.txt destination.txt");
    if (result != 0) {
        perror("Copy command failed");
        return 1;
    }
    
    printf("File copied\n");
    return 0;
}
```

> **Note**: Always check return values from file operations. Use fclose() to properly close files. Check for NULL before using FILE pointers. Handle errors gracefully.
