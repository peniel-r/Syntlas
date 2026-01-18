---
id: "c.stdlib.filemodes"
title: File Modes and Permissions
category: system
difficulty: intermediate
tags:
  - file-permissions
  - chmod
  - umask
  - stat
keywords:
  - file permissions
  - chmod
  - umask
  - stat
  - file modes
use_cases:
  - File security
  - Permission management
  - File access control
  - Security settings
prerequisites:
  - 
  - 
related:
  - 
  - system-popen
next_topics:
  - c.stdlib.fd
---

# File Modes and Permissions

File modes control access permissions and file types in Unix-like systems.

## Reading File Permissions

```c
#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>

void print_permissions(const char *filename) {
    struct stat file_stat;

    if (stat(filename, &file_stat) == -1) {
        perror("stat failed");
        return;
    }

    mode_t mode = file_stat.st_mode;

    // File type
    char type;
    if (S_ISREG(mode)) type = '-';
    else if (S_ISDIR(mode)) type = 'd';
    else if (S_ISLNK(mode)) type = 'l';
    else if (S_ISFIFO(mode)) type = 'p';
    else if (S_ISSOCK(mode)) type = 's';
    else if (S_ISCHR(mode)) type = 'c';
    else if (S_ISBLK(mode)) type = 'b';
    else type = '?';

    printf("File type: %c\n", type);

    // Permissions
    printf("Owner: %c%c%c\n",
           mode & S_IRUSR ? 'r' : '-',
           mode & S_IWUSR ? 'w' : '-',
           mode & S_IXUSR ? 'x' : '-');

    printf("Group: %c%c%c\n",
           mode & S_IRGRP ? 'r' : '-',
           mode & S_IWGRP ? 'w' : '-',
           mode & S_IXGRP ? 'x' : '-');

    printf("Other: %c%c%c\n",
           mode & S_IROTH ? 'r' : '-',
           mode & S_IWOTH ? 'w' : '-',
           mode & S_IXOTH ? 'x' : '-');

    // Special bits
    if (mode & S_ISUID) printf("Set-UID bit set\n");
    if (mode & S_ISGID) printf("Set-GID bit set\n");
    if (mode & S_ISVTX) printf("Sticky bit set\n");

    // Numeric representation
    printf("Numeric mode: %04o\n", mode & 0777);
}

int main(void) {
    print_permissions("test.txt");
    return 0;
}
```

## Changing File Permissions

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

int main(void) {
    const char *filename = "test.txt";

    // Create file with specific permissions
    FILE *file = fopen(filename, "w");
    if (file != NULL) {
        fclose(file);
    }

    // Set permissions using numeric mode
    if (chmod(filename, 0644) == -1) {
        perror("chmod failed");
        return 1;
    }

    printf("Set permissions to 0644 (rw-r--r--)\n");

    // Add execute permission for owner
    if (chmod(filename, 0755) == -1) {
        perror("chmod failed");
        return 1;
    }

    printf("Set permissions to 0755 (rwxr-xr-x)\n");

    // Use symbolic permissions
    // Note: This is simplified, normally done with chmod command
    // or using system() which is not recommended

    return 0;
}
```

## Checking File Permissions

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>

int main(void) {
    const char *filename = "test.txt";

    // Check if file exists
    if (access(filename, F_OK) == 0) {
        printf("File exists\n");
    } else {
        printf("File does not exist\n");
    }

    // Check read permission
    if (access(filename, R_OK) == 0) {
        printf("Readable\n");
    } else {
        printf("Not readable\n");
    }

    // Check write permission
    if (access(filename, W_OK) == 0) {
        printf("Writable\n");
    } else {
        printf("Not writable\n");
    }

    // Check execute permission
    if (access(filename, X_OK) == 0) {
        printf("Executable\n");
    } else {
        printf("Not executable\n");
    }

    // Using stat for detailed info
    struct stat file_stat;
    if (stat(filename, &file_stat) == 0) {
        if (file_stat.st_mode & S_IRUSR) printf("Owner can read\n");
        if (file_stat.st_mode & S_IWUSR) printf("Owner can write\n");
        if (file_stat.st_mode & S_IXUSR) printf("Owner can execute\n");
    }

    return 0;
}
```

## Umask

```c
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void) {
    // Get current umask
    mode_t old_umask = umask(0);
    umask(old_umask);  // Restore

    printf("Current umask: %04o\n", old_umask);

    // Create file with default permissions
    int fd = open("default.txt", O_WRONLY | O_CREAT, 0666);
    if (fd != -1) {
        close(fd);

        struct stat stat_buf;
        stat("default.txt", &stat_buf);
        printf("Created file permissions: %04o\n", stat_buf.st_mode & 0777);
    }

    // Change umask
    mode_t new_umask = 0022;  // Don't allow write for group/other
    umask(new_umask);
    printf("New umask: %04o\n", new_umask);

    // Create file with new umask
    fd = open("new_umask.txt", O_WRONLY | O_CREAT, 0666);
    if (fd != -1) {
        close(fd);

        struct stat stat_buf;
        stat("new_umask.txt", &stat_buf);
        printf("Created file permissions: %04o\n", stat_buf.st_mode & 0777);
    }

    return 0;
}
```

## Creating Directories with Permissions

```c
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(void) {
    // Create directory with specific permissions
    if (mkdir("mydir", 0755) == -1) {
        perror("mkdir failed");
        return 1;
    }

    printf("Created directory with permissions 0755\n");

    // Create directory with full permissions for owner
    if (mkdir("privatedir", 0700) == -1) {
        perror("mkdir failed");
        return 1;
    }

    printf("Created directory with permissions 0700\n");

    return 0;
}
```

## Special Permission Bits

```c
#include <stdio.h>
#include <sys/stat.h>

void set_special_bits(const char *filename) {
    struct stat file_stat;
    stat(filename, &file_stat);

    mode_t mode = file_stat.st_mode;

    // Set UID bit (set-user-ID)
    if (chmod(filename, mode | S_ISUID) == -1) {
        perror("chmod S_ISUID failed");
    } else {
        printf("Set UID bit\n");
    }

    // Set GID bit (set-group-ID)
    if (chmod(filename, mode | S_ISGID) == -1) {
        perror("chmod S_ISGID failed");
    } else {
        printf("Set GID bit\n");
    }

    // Set sticky bit (directory only)
    if (chmod(filename, mode | S_ISVTX) == -1) {
        perror("chmod S_ISVTX failed");
    } else {
        printf("Set sticky bit\n");
    }
}

int main(void) {
    // Create test file
    FILE *file = fopen("test.txt", "w");
    if (file) fclose(file);

    set_special_bits("test.txt");

    return 0;
}
```

## Permission Helper 

```c
#include <stdio.h>
#include <sys/stat.h>
#include <stdbool.h>

bool is_readable(const char *filename) {
    return access(filename, R_OK) == 0;
}

bool is_writable(const char *filename) {
    return access(filename, W_OK) == 0;
}

bool is_executable(const char *filename) {
    return access(filename, X_OK) == 0;
}

bool is_directory(const char *filename) {
    struct stat file_stat;
    return stat(filename, &file_stat) == 0 && S_ISDIR(file_stat.st_mode);
}

bool is_regular_file(const char *filename) {
    struct stat file_stat;
    return stat(filename, &file_stat) == 0 && S_ISREG(file_stat.st_mode);
}

mode_t get_permissions(const char *filename) {
    struct stat file_stat;
    if (stat(filename, &file_stat) == -1) {
        return 0;
    }
    return file_stat.st_mode & 0777;
}

int main(void) {
    const char *filename = "test.txt";

    printf("File: %s\n", filename);
    printf("  Readable: %s\n", is_readable(filename) ? "yes" : "no");
    printf("  Writable: %s\n", is_writable(filename) ? "yes" : "no");
    printf("  Executable: %s\n", is_executable(filename) ? "yes" : "no");
    printf("  Is directory: %s\n", is_directory(filename) ? "yes" : "no");
    printf("  Is regular file: %s\n", is_regular_file(filename) ? "yes" : "no");
    printf("  Permissions: %04o\n", get_permissions(filename));

    return 0;
}
```

## Permission String to Mode

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

typedef struct {
    char type;
    char perms[10];
} PermissionString;

PermissionString permission_string(mode_t mode) {
    PermissionString ps;

    // File type
    if (S_ISREG(mode)) ps.type = '-';
    else if (S_ISDIR(mode)) ps.type = 'd';
    else if (S_ISLNK(mode)) ps.type = 'l';
    else ps.type = '?';

    // Permissions
    ps.perms[0] = (mode & S_IRUSR) ? 'r' : '-';
    ps.perms[1] = (mode & S_IWUSR) ? 'w' : '-';
    ps.perms[2] = (mode & S_IXUSR) ? 'x' : '-';
    ps.perms[3] = (mode & S_IRGRP) ? 'r' : '-';
    ps.perms[4] = (mode & S_IWGRP) ? 'w' : '-';
    ps.perms[5] = (mode & S_IXGRP) ? 'x' : '-';
    ps.perms[6] = (mode & S_IROTH) ? 'r' : '-';
    ps.perms[7] = (mode & S_IWOTH) ? 'w' : '-';
    ps.perms[8] = (mode & S_IXOTH) ? 'x' : '-';
    ps.perms[9] = '\0';

    // Special bits
    if (mode & S_ISUID) ps.perms[2] = 's';
    if (mode & S_ISGID) ps.perms[5] = 's';
    if (mode & S_ISVTX) ps.perms[8] = 't';

    return ps;
}

int main(void) {
    struct stat file_stat;
    const char *filename = "test.txt";

    if (stat(filename, &file_stat) == -1) {
        perror("stat failed");
        return 1;
    }

    PermissionString ps = permission_string(file_stat.st_mode);
    printf("%c%s\n", ps.type, ps.perms);

    return 0;
}
```

## Best Practices

### Use Least Privilege

```c
// GOOD - Minimal permissions
if (mkdir("secret", 0700) == -1) {
    perror("mkdir failed");
}

// BAD - Too permissive
if (mkdir("secret", 0777) == -1) {
    perror("mkdir failed");
}
```

### Check Before Operations

```c
// GOOD - Check permissions
if (access(filename, W_OK) == 0) {
    // File is writable
    FILE *file = fopen(filename, "w");
    // ...
}

// BAD - Assume permissions
FILE *file = fopen(filename, "w");
if (file == NULL) {
    perror("Failed to open");
}
```

### Use Octal Literals

```c
// GOOD - Use octal notation
chmod(filename, 0644);

// BAD - Confusing decimal
chmod(filename, 420);  // 420 decimal = 0644 octal, but confusing
```

## Common Pitfalls

### 1. Not Checking Return Values

```c
// WRONG - Not checking chmod
chmod(filename, 0644);
// Might have failed!

// CORRECT - Check return value
if (chmod(filename, 0644) == -1) {
    perror("chmod failed");
    return 1;
}
```

### 2. Using Incorrect Permission Values

```c
// WRONG - Using decimal instead of octal
chmod(filename, 644);  // 644 decimal != 0644 octal

// CORRECT - Use octal (leading 0)
chmod(filename, 0644);
```

### 3. Ignoring Umask

```c
// WRONG - Not considering umask
int fd = open("file", O_CREAT, 0666);
// Actual permissions will be 0666 & ~umask

// CORRECT - Consider umask
mode_t umask_val = umask(0);
umask(umask_val);
int fd = open("file", O_CREAT, 0666);
// Or set umask explicitly first
```

> **Note: File permissions are crucial for security. Always use the principle of least privilege. Check permissions before operations. Be aware of umask when creating files. Use octal notation for mode values (leading 0).
