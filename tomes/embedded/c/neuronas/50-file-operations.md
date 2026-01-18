---
id: "c.stdlib.stdio.file-operations"
title: "File Operations Basics"
category: io
difficulty: beginner
tags: [c, io, file, fopen, fclose]
keywords: [fopen, fclose, fread, fwrite, fprintf]
use_cases: [file processing, data storage, configuration]
prerequisites: []
related: ["c.stdlib.stdio.advanced"]
next_topics: ["c.stdlib.string"]
---

# File Operations

## fopen and fclose

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "w");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fprintf(file, "Hello, World!");

    fclose(file);

    return 0;
}
```

## Read Text File

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "r");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    char buffer[256];
    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("%s", buffer);
    }

    fclose(file);

    return 0;
}
```

## Write Text File

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "w");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fprintf(file, "Line 1\n");
    fprintf(file, "Line 2\n");
    fprintf(file, "Line 3\n");

    fclose(file);

    return 0;
}
```

## Append to File

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "a");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fprintf(file, "Appended line\n");

    fclose(file);

    return 0;
}
```

## Check File Existence

```c
#include <stdio.h>

int file_exists(const char* filename) {
    FILE* file = fopen(filename, "r");

    if (file == NULL) {
        return 0;
    }

    fclose(file);
    return 1;
}

int main() {
    if (file_exists("data.txt")) {
        printf("File exists\n");
    } else {
        printf("File does not exist\n");
    }

    return 0;
}
```

## File Error Handling

```c
#include <stdio.h>
#include <errno.h>

int main() {
    FILE* file = fopen("nonexistent.txt", "r");

    if (file == NULL) {
        switch (errno) {
            case ENOENT:
                printf("File does not exist\n");
                break;
            case EACCES:
                printf("Permission denied\n");
                break;
            default:
                printf("Error: %d\n", errno);
        }
        return 1;
    }

    fclose(file);
    return 0;
}
```

## Binary Write

```c
#include <stdio.h>

int main() {
    int data[] = {1, 2, 3, 4, 5};

    FILE* file = fopen("data.bin", "wb");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fwrite(data, sizeof(int), 5, file);

    fclose(file);

    return 0;
}
```

## Binary Read

```c
#include <stdio.h>

int main() {
    int data[5];

    FILE* file = fopen("data.bin", "rb");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    size_t read = fread(data, sizeof(int), 5, file);

    printf("Read %zu integers\n", read);

    fclose(file);

    return 0;
}
```

## File Size

```c
#include <stdio.h>

long get_file_size(FILE* file) {
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);
    return size;
}

int main() {
    FILE* file = fopen("data.txt", "r");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    long size = get_file_size(file);
    printf("File size: %ld bytes\n", size);

    fclose(file);

    return 0;
}
```

## Read Character by Character

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "r");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    int ch;
    while ((ch = fgetc(file)) != EOF) {
        putchar(ch);
    }

    fclose(file);

    return 0;
}
```

## Write Character by Character

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "w");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    const char* text = "Hello, World!";
    while (*text != '\0') {
        fputc(*text, file);
        text++;
    }

    fclose(file);

    return 0;
}
```

## Read Line by Line

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "r");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    char buffer[256];
    int line_number = 1;

    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("Line %d: %s", line_number, buffer);
        line_number++;
    }

    fclose(file);

    return 0;
}
```

## Copy File

```c
#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 4096

int copy_file(const char* src, const char* dst) {
    FILE* src_file = fopen(src, "rb");
    if (src_file == NULL) {
        return 1;
    }

    FILE* dst_file = fopen(dst, "wb");
    if (dst_file == NULL) {
        fclose(src_file);
        return 1;
    }

    char buffer[BUFFER_SIZE];
    size_t bytes_read;

    while ((bytes_read = fread(buffer, 1, BUFFER_SIZE, src_file)) > 0) {
        fwrite(buffer, 1, bytes_read, dst_file);
    }

    fclose(src_file);
    fclose(dst_file);

    return 0;
}

int main() {
    if (copy_file("data.txt", "copy.txt") == 0) {
        printf("File copied successfully\n");
    } else {
        printf("Failed to copy file\n");
    }

    return 0;
}
```

## Read File into Buffer

```c
#include <stdio.h>
#include <stdlib.h>

char* read_file(const char* filename, long* size) {
    FILE* file = fopen(filename, "rb");

    if (file == NULL) {
        return NULL;
    }

    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    fseek(file, 0, SEEK_SET);

    char* buffer = malloc(file_size + 1);
    if (buffer == NULL) {
        fclose(file);
        return NULL;
    }

    fread(buffer, 1, file_size, file);
    buffer[file_size] = '\0';

    fclose(file);

    if (size != NULL) {
        *size = file_size;
    }

    return buffer;
}

int main() {
    long size;
    char* content = read_file("data.txt", &size);

    if (content != NULL) {
        printf("File size: %ld bytes\n", size);
        printf("Content: %s\n", content);
        free(content);
    } else {
        printf("Failed to read file\n");
    }

    return 0;
}
```

## File Modes

```c
#include <stdio.h>

int main() {
    // Read mode
    FILE* read_file = fopen("data.txt", "r");

    // Write mode (truncate)
    FILE* write_file = fopen("data.txt", "w");

    // Append mode
    FILE* append_file = fopen("data.txt", "a");

    // Read and write mode
    FILE* rw_file = fopen("data.txt", "r+");

    // Binary read
    FILE* rb_file = fopen("data.bin", "rb");

    // Binary write
    FILE* wb_file = fopen("data.bin", "wb");

    if (read_file != NULL) fclose(read_file);
    if (write_file != NULL) fclose(write_file);
    if (append_file != NULL) fclose(append_file);
    if (rw_file != NULL) fclose(rw_file);
    if (rb_file != NULL) fclose(rb_file);
    if (wb_file != NULL) fclose(wb_file);

    return 0;
}
```

> **Note**: Always check `fopen` return value. Use "rb" and "wb" for binary files. Close files when done.
