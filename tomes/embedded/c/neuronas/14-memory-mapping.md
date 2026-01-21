---
id: "c.memory-mapping"
title: "Memory Mapping with mmap"
category: library
difficulty: advanced
tags: [c, memory, files, mmap, system-calls]
keywords: [mmap, munmap, mmap_prot, mmap_map, shared memory]
use_cases: [file i/o, shared memory, zero-copy]
prerequisites: []
related: []
next_topics: []
---

# Memory Mapping with mmap

Memory mapping maps files or devices into process memory.

## mmap Basics

```c
#include <sys/mman.h>

void* mmap(
    void* addr,          // Preferred address (NULL for system choice)
    size_t length,       // Number of bytes to map
    int prot,            // Memory protection flags
    int flags,           // Mapping type flags
    int fd,             // File descriptor
    off_t offset         // Offset in file
);
```

## Memory Protection Flags

```c
// PROT_READ: Read access
// PROT_WRITE: Write access
// PROT_EXEC: Execute access
// PROT_NONE: No access

// Read + Write
int prot = PROT_READ | PROT_WRITE;

// Read-only executable (for code)
int prot = PROT_READ | PROT_EXEC;
```

## Mapping Flags

```c
// MAP_SHARED: Changes visible to other processes
// MAP_PRIVATE: Private copy-on-write
// MAP_FIXED: Use exact address
// MAP_ANONYMOUS: No file backing
// MAP_NORESERVE: Don't reserve swap space

// Shared mapping (for file I/O or shared memory)
int flags = MAP_SHARED;

// Private mapping (copy-on-write)
int flags = MAP_PRIVATE;

// Anonymous mapping (no file)
int fd = -1;
int flags = MAP_PRIVATE | MAP_ANONYMOUS;
```

## Mapping a File

```c
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

const char* filename = "data.bin";

// Open file
int fd = open(filename, O_RDWR, 0666);
if (fd == -1) {
    perror("open");
    return -1;
}

// Get file size
struct stat st;
if (fstat(fd, &st) == -1) {
    perror("fstat");
    close(fd);
    return -1;
}

// Map file into memory
void* mapped = mmap(
    NULL,               // Let system choose address
    st.st_size,         // Size of mapping
    PROT_READ | PROT_WRITE,
    MAP_SHARED,         // Shared mapping
    fd,                 // File descriptor
    0                   // Offset
);

if (mapped == MAP_FAILED) {
    perror("mmap");
    close(fd);
    return -1;
}

// Access mapped memory
char* data = (char*)mapped;
data[0] = 'H';
data[1] = 'e';
data[2] = 'l';
data[3] = 'l';
data[4] = 'o';

// Unmap when done
munmap(mapped, st.st_size);

// Close file
close(fd);
```

## Anonymous Mapping

```c
#include <sys/mman.h>

// Allocate memory without file backing
size_t size = 1024 * 1024;  // 1MB

void* memory = mmap(
    NULL,
    size,
    PROT_READ | PROT_WRITE,
    MAP_PRIVATE | MAP_ANONYMOUS,
    -1,  // No file descriptor
    0
);

if (memory == MAP_FAILED) {
    perror("mmap");
    return -1;
}

// Use memory
int* array = (int*)memory;
array[0] = 42;

// Unmap
munmap(memory, size);
```

## Shared Memory

```c
#include <sys/mman.h>
#include <fcntl.h>

// Create shared memory object
int fd = shm_open("/my_shared_mem", O_CREAT | O_RDWR, 0666);
if (fd == -1) {
    perror("shm_open");
    return -1;
}

// Set size
ftruncate(fd, 4096);

// Map into memory
void* shared = mmap(
    NULL,
    4096,
    PROT_READ | PROT_WRITE,
    MAP_SHARED,
    fd,
    0
);

// Access from multiple processes
int* counter = (int*)shared;
(*counter)++;  // Atomic increment may be needed

// Clean up
munmap(shared, 4096);
close(fd);
shm_unlink("/my_shared_mem");
```

## Memory Protection (mprotect)

```c
#include <sys/mman.h>

void* memory = mmap(NULL, 4096, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

// Make memory read-only (protect from writes)
if (mprotect(memory, 4096, PROT_READ) == -1) {
    perror("mprotect");
}

// Attempting to write will cause SIGSEGV
// *(int*)memory = 42;  // Signal!

// Make executable (for JIT compilation)
mprotect(memory, 4096, PROT_READ | PROT_EXEC);
```

## Advantages of mmap

```c
// 1. Zero-copy I/O
void* mapped = mmap(..., fd, 0);
// No read/write syscalls needed, access memory directly

// 2. Lazy loading
// Pages loaded on demand (demand paging)

// 3. Shared memory between processes
mmap(..., MAP_SHARED, fd, 0);

// 4. Large file access
// Don't load entire file, map only needed parts
```

## File Copy with mmap

```c
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>

int copy_file(const char* src, const char* dst) {
    int src_fd = open(src, O_RDONLY);
    int dst_fd = open(dst, O_RDWR | O_CREAT | O_TRUNC, 0666);

    struct stat st;
    fstat(src_fd, &st);

    // Resize destination
    ftruncate(dst_fd, st.st_size);

    // Map both files
    void* src_map = mmap(NULL, st.st_size, PROT_READ,
                         MAP_PRIVATE, src_fd, 0);
    void* dst_map = mmap(NULL, st.st_size, PROT_WRITE,
                         MAP_SHARED, dst_fd, 0);

    // Copy with memcpy (very fast)
    memcpy(dst_map, src_map, st.st_size);

    // Cleanup
    munmap(src_map, st.st_size);
    munmap(dst_map, st.st_size);
    close(src_fd);
    close(dst_fd);

    return 0;
}
```

## Error Handling

```c
void* mapped = mmap(...);

if (mapped == MAP_FAILED) {
    // Check errno
    switch (errno) {
        case EACCES:
            fprintf(stderr, "Permission denied\n");
            break;
        case ENOMEM:
            fprintf(stderr, "Out of memory\n");
            break;
        case EINVAL:
            fprintf(stderr, "Invalid arguments\n");
            break;
        default:
            perror("mmap");
    }
}
```

## Common Patterns

### Read-Only Mapping

```c
// For config files or shared libraries
int fd = open("config.ini", O_RDONLY);
void* mapped = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);

// Read access
char* config = (char*)mapped;
printf("%s\n", config);
```

### Copy-on-Write

```c
// Private mapping creates copy when written
void* mapped = mmap(NULL, size,
                   PROT_READ | PROT_WRITE,
                   MAP_PRIVATE,  // Copy-on-write
                   fd, 0);

// Initial writes don't affect original file
// Pages are copied on first write
```

### Remapping (mremap)

```c
#include <sys/mman.h>

void* old_map = mmap(NULL, 4096, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

// Resize mapping (Linux specific)
void* new_map = mremap(old_map, 4096, 8192, MREMAP_MAYMOVE);

if (new_map == MAP_FAILED) {
    perror("mremap");
}
```

> **Note**: Memory mappings are page-aligned (typically 4KB). Always align sizes and offsets accordingly.
