---
id: "c.stdlib.stdio.advanced"
title: "Advanced File I/O"
category: io
difficulty: intermediate
tags: [c, io, file, advanced, seeking]
keywords: [fseek, ftell, rewind, fflush]
use_cases: [file processing, random access, binary files]
prerequisites: ["c.stdlib.stdio"]
related: ["c.stdlib.system"]
next_topics: ["c.stdlib.process"]
---

# Advanced File I/O

## File Positioning

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "w+");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fprintf(file, "Hello, World!");

    // Go to start of file
    rewind(file);

    // Read from start
    char buffer[100];
    fgets(buffer, sizeof(buffer), file);
    printf("Read: %s\n", buffer);

    fclose(file);

    return 0;
}
```

## fseek - File Seeking

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "w+");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    // Write data
    fprintf(file, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");

    // Seek to position 10 (from start)
    fseek(file, 10, SEEK_SET);

    char ch = fgetc(file);
    printf("Character at position 10: %c\n", ch);  // K

    fclose(file);

    return 0;
}
```

## ftell - Get Current Position

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "w+");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    fprintf(file, "Hello, World!");

    // Get current position
    long pos = ftell(file);
    printf("Current position: %ld\n", pos);

    fclose(file);

    return 0;
}
```

## Binary File Writing

```c
#include <stdio.h>

typedef struct {
    int id;
    float value;
    char name[50];
} Record;

int main() {
    FILE* file = fopen("data.bin", "wb");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    Record records[] = {
        {1, 3.14f, "Alice"},
        {2, 2.71f, "Bob"},
        {3, 1.41f, "Charlie"}
    };

    size_t count = sizeof(records) / sizeof(records[0]);
    size_t written = fwrite(records, sizeof(Record), count, file);

    printf("Wrote %zu records\n", written);

    fclose(file);

    return 0;
}
```

## Binary File Reading

```c
#include <stdio.h>

typedef struct {
    int id;
    float value;
    char name[50];
} Record;

int main() {
    FILE* file = fopen("data.bin", "rb");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    // Get file size
    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    fseek(file, 0, SEEK_SET);

    size_t count = file_size / sizeof(Record);
    Record* records = malloc(count * sizeof(Record));

    if (records == NULL) {
        fclose(file);
        return 1;
    }

    size_t read = fread(records, sizeof(Record), count, file);

    printf("Read %zu records:\n", read);
    for (size_t i = 0; i < read; i++) {
        printf("  ID: %d, Value: %.2f, Name: %s\n",
               records[i].id, records[i].value, records[i].name);
    }

    free(records);
    fclose(file);

    return 0;
}
```

## Random Access

```c
#include <stdio.h>

int main() {
    FILE* file = fopen("data.txt", "w+");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    // Write structured data
    for (int i = 0; i < 10; i++) {
        fprintf(file, "Record %d\n", i);
    }

    // Random access: read record 5
    fseek(file, 0, SEEK_SET);

    for (int i = 0; i < 5; i++) {
        char buffer[100];
        fgets(buffer, sizeof(buffer), file);
    }

    char buffer[100];
    fgets(buffer, sizeof(buffer), file);
    printf("Record 5: %s", buffer);

    fclose(file);

    return 0;
}
```

## fflush - Flush Buffer

```c
#include <stdio.h>

int main() {
    printf("Writing to stdout...");

    // Ensure data is written immediately
    fflush(stdout);

    // Continue working...

    printf("Done\n");
    fflush(stdout);

    return 0;
}
```

## File Locking

```c
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
    FILE* file = fopen("data.txt", "r+");

    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    int fd = fileno(file);

    // Exclusive lock
    struct flock lock;
    lock.l_type = F_WRLCK;  // Write lock
    lock.l_whence = SEEK_SET;
    lock.l_start = 0;
    lock.l_len = 0;  // Lock entire file
    lock.l_pid = getpid();

    if (fcntl(fd, F_SETLK, &lock) == -1) {
        perror("Failed to acquire lock");
        fclose(file);
        return 1;
    }

    printf("Lock acquired\n");

    // Work with file...

    // Release lock
    lock.l_type = F_UNLCK;
    fcntl(fd, F_SETLK, &lock);

    printf("Lock released\n");
    fclose(file);

    return 0;
}
```

## File Mapping

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

int main() {
    int fd = open("data.txt", O_RDWR);
    if (fd == -1) {
        perror("Failed to open file");
        return 1;
    }

    off_t size = lseek(fd, 0, SEEK_END);
    char* mapped = mmap(NULL, size, PROT_READ | PROT_WRITE,
                        MAP_SHARED, fd, 0);

    if (mapped == MAP_FAILED) {
        perror("Failed to map file");
        close(fd);
        return 1;
    }

    printf("Mapped %ld bytes\n", size);
    printf("Content: %.*s\n", (int)size, mapped);

    // Modify mapped memory
    mapped[0] = 'X';

    // Unmap
    munmap(mapped, size);
    close(fd);

    return 0;
}
```

## Directory Operations

```c
#include <stdio.h>
#include <dirent.h>
#include <sys/stat.h>

int main() {
    DIR* dir = opendir(".");
    if (dir == NULL) {
        perror("Failed to open directory");
        return 1;
    }

    struct dirent* entry;
    while ((entry = readdir(dir)) != NULL) {
        printf("%s\n", entry->d_name);
    }

    closedir(dir);

    return 0;
}
```

## File Permissions

```c
#include <stdio.h>
#include <sys/stat.h>

int main() {
    const char* filename = "data.txt";

    // Set read/write for owner only
    if (chmod(filename, S_IRUSR | S_IWUSR) == -1) {
        perror("Failed to change permissions");
        return 1;
    }

    // Check permissions
    struct stat st;
    if (stat(filename, &st) == -1) {
        perror("Failed to stat file");
        return 1;
    }

    printf("File permissions: %o\n", st.st_mode & 0777);

    return 0;
}
```

## File Metadata

```c
#include <stdio.h>
#include <sys/stat.h>

void print_file_info(const char* filename) {
    struct stat st;

    if (stat(filename, &st) == -1) {
        perror("Failed to stat file");
        return;
    }

    printf("File: %s\n", filename);
    printf("Size: %ld bytes\n", st.st_size);
    printf("Mode: %o\n", st.st_mode & 0777);
    printf("Inode: %ld\n", st.st_ino);
    printf("Last modified: %ld\n", st.st_mtime);
}

int main() {
    print_file_info("data.txt");

    return 0;
}
```

## Temporary Files

```c
#include <stdio.h>

int main() {
    // Create temporary file
    FILE* tmpfile = tmpfile();

    if (tmpfile == NULL) {
        perror("Failed to create temporary file");
        return 1;
    }

    fprintf(tmpfile, "Temporary data\n");

    // Read back
    rewind(tmpfile);

    char buffer[100];
    fgets(buffer, sizeof(buffer), tmpfile);
    printf("Read: %s", buffer);

    fclose(tmpfile);

    return 0;
}
```

## File Descriptor Manipulation

```c
#include <stdio.h>
#include <unistd.h>

int main() {
    // Redirect stdout to file
    FILE* file = fopen("output.txt", "w");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    int fd = fileno(file);

    if (dup2(fd, STDOUT_FILENO) == -1) {
        perror("Failed to redirect stdout");
        fclose(file);
        return 1;
    }

    printf("This goes to file, not console\n");

    fclose(file);

    return 0;
}
```

> **Note**: Binary files use "rb" and "wb" modes. Text files use "r" and "w". Always check file operations for errors.
