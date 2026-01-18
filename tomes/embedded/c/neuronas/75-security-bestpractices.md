---
id: 75-security-bestpractices
title: Security Best Practices
category: bestpractices
difficulty: advanced
tags:
  - security
  - buffer-overflow
  - input-validation
  - memory-safety
keywords:
  - buffer overflow
  - input validation
  - security
  - memory safety
  - safe coding
use_cases:
  - Secure applications
  - Security-sensitive code
  - Preventing vulnerabilities
  - Secure programming
prerequisites:
  - memory-management
  - string-functions
  - pointers
related:
  - memory-bestpractices
  - safety-bestpractices
  - error-handling
next_topics:
  - testing-practices
---

# Security Best Practices

Writing secure C code requires constant vigilance and following specific patterns to prevent common vulnerabilities.

## Buffer Overflow Prevention

```c
#include <stdio.h>
#include <string.h>

// BAD - Unsafe, no size checking
void unsafe_copy(char *dest, const char *src) {
    strcpy(dest, src);  // Buffer overflow possible!
}

// GOOD - Safe copy with size limit
void safe_copy(char *dest, const char *src, size_t dest_size) {
    strncpy(dest, src, dest_size - 1);
    dest[dest_size - 1] = '\0';  // Ensure null termination
}

int main(void) {
    char buffer[10];

    safe_copy(buffer, "Hello", sizeof(buffer));
    printf("Buffer: %s\n", buffer);

    return 0;
}
```

## Safe String Functions

```c
#include <stdio.h>
#include <string.h>

// Safer alternatives to standard string functions

// Safe string concatenation
void safe_strcat(char *dest, const char *src, size_t dest_size) {
    size_t dest_len = strlen(dest);
    if (dest_len < dest_size - 1) {
        strncat(dest, src, dest_size - dest_len - 1);
    }
}

// Safe string copy
void safe_strcpy(char *dest, const char *src, size_t dest_size) {
    if (dest_size > 0) {
        strncpy(dest, src, dest_size - 1);
        dest[dest_size - 1] = '\0';
    }
}

// Safe formatted output
void safe_sprintf(char *buffer, size_t buffer_size, const char *format, ...) {
    if (buffer == NULL || buffer_size == 0) return;

    va_list args;
    va_start(args, format);
    vsnprintf(buffer, buffer_size, format, args);
    va_end(args);
    buffer[buffer_size - 1] = '\0';
}

int main(void) {
    char buffer[20];

    safe_strcpy(buffer, "Hello", sizeof(buffer));
    safe_strcat(buffer, " World", sizeof(buffer));
    printf("Buffer: %s\n", buffer);

    safe_sprintf(buffer, sizeof(buffer), "Number: %d", 42);
    printf("Buffer: %s\n", buffer);

    return 0;
}
```

## Input Validation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Validate numeric input
bool is_valid_number(const char *str) {
    if (str == NULL || *str == '\0') return false;

    // Skip leading whitespace
    while (isspace((unsigned char)*str)) str++;

    // Check for optional sign
    if (*str == '+' || *str == '-') str++;

    // Check for at least one digit
    if (!isdigit((unsigned char)*str)) return false;

    // Check remaining characters are digits
    while (*str != '\0') {
        if (!isdigit((unsigned char)*str)) {
            // Allow trailing whitespace
            while (isspace((unsigned char)*str)) str++;
            return (*str == '\0');
        }
        str++;
    }

    return true;
}

// Safe string to integer conversion
bool safe_strtoi(const char *str, int *result) {
    if (!is_valid_number(str)) return false;

    char *endptr;
    long val = strtol(str, &endptr, 10);

    // Check for overflow
    if (val > INT_MAX || val < INT_MIN) return false;

    *result = (int)val;
    return true;
}

// Validate filename
bool is_safe_filename(const char *filename) {
    if (filename == NULL || *filename == '\0') return false;

    // Check for path traversal attempts
    if (strstr(filename, "..") != NULL) return false;

    // Check for absolute path
    if (filename[0] == '/' || filename[0] == '\\') return false;

    // Check length
    if (strlen(filename) > 255) return false;

    // Check for invalid characters
    const char *invalid = "<>:\"/\\|?*";
    for (int i = 0; filename[i] != '\0'; i++) {
        if (strchr(invalid, filename[i]) != NULL) {
            return false;
        }
    }

    return true;
}

int main(void) {
    int value;
    const char *input = "42";

    if (safe_strtoi(input, &value)) {
        printf("Valid number: %d\n", value);
    } else {
        printf("Invalid number\n");
    }

    const char *filename = "test.txt";
    if (is_safe_filename(filename)) {
        printf("Safe filename: %s\n", filename);
    } else {
        printf("Unsafe filename\n");
    }

    return 0;
}
```

## Memory Safety

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Safe memory allocation with initialization
void *safe_malloc(size_t size) {
    void *ptr = malloc(size);
    if (ptr != NULL) {
        memset(ptr, 0, size);  // Initialize to zero
    }
    return ptr;
}

// Safe reallocation
void *safe_realloc(void *ptr, size_t new_size) {
    if (new_size == 0) {
        free(ptr);
        return NULL;
    }

    void *new_ptr = realloc(ptr, new_size);
    if (new_ptr == NULL && ptr != NULL) {
        // Realloc failed, original pointer still valid
        return NULL;
    }

    return new_ptr;
}

// Double-free protection
typedef struct {
    void *ptr;
    bool freed;
} ProtectedPtr;

ProtectedPtr protect_ptr(void *ptr) {
    ProtectedPtr p = {ptr, false};
    return p;
}

void safe_free(ProtectedPtr *p) {
    if (p != NULL && !p->freed && p->ptr != NULL) {
        free(p->ptr);
        p->ptr = NULL;
        p->freed = true;
    }
}

int main(void) {
    // Safe malloc
    char *buffer = safe_malloc(100);
    if (buffer != NULL) {
        printf("Allocated and zeroed buffer\n");
    }

    // Safe free with protection
    ProtectedPtr protected = protect_ptr(buffer);
    safe_free(&protected);
    safe_free(&protected);  // Won't double-free

    return 0;
}
```

## Preventing Integer Overflow

```c
#include <stdio.h>
#include <stdint.h>
#include <limits.h>

// Safe addition
bool safe_add(int a, int b, int *result) {
    if (b > 0 && a > INT_MAX - b) return false;  // Overflow
    if (b < 0 && a < INT_MIN - b) return false;  // Underflow
    *result = a + b;
    return true;
}

// Safe multiplication
bool safe_mul(int a, int b, int *result) {
    if (a > 0) {
        if (b > 0 && a > INT_MAX / b) return false;
        if (b < 0 && b < INT_MIN / a) return false;
    } else if (a < 0) {
        if (b > 0 && a < INT_MIN / b) return false;
        if (b < 0 && a < INT_MAX / b) return false;
    }
    *result = a * b;
    return true;
}

// Safe array indexing
bool safe_index_access(int *array, size_t size, int index, int *value) {
    if (array == NULL || value == NULL) return false;
    if (index < 0 || (size_t)index >= size) return false;
    *value = array[index];
    return true;
}

int main(void) {
    int result;

    if (safe_add(INT_MAX, 1, &result)) {
        printf("Sum: %d\n", result);
    } else {
        printf("Addition overflow\n");
    }

    if (safe_mul(1000, 1000, &result)) {
        printf("Product: %d\n", result);
    } else {
        printf("Multiplication overflow\n");
    }

    int array[] = {10, 20, 30};
    int value;
    if (safe_index_access(array, 3, 1, &value)) {
        printf("Value: %d\n", value);
    }

    return 0;
}
```

## Format String Vulnerability Prevention

```c
#include <stdio.h>
#include <string.h>

// BAD - Format string vulnerability
void unsafe_print(const char *user_input) {
    printf(user_input);  // If user_input contains %s, %n, etc. - vulnerable!
}

// GOOD - Use format string
void safe_print(const char *user_input) {
    printf("%s", user_input);  // Safe
}

// Safe formatted output
void safe_fprintf(FILE *file, const char *format, ...) {
    va_list args;
    va_start(args, format);
    vfprintf(file, format, args);
    va_end(args);
}

int main(void) {
    char user_input[] = "Hello World";

    safe_print(user_input);

    return 0;
}
```

## Safe File Operations

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Safe file opening with validation
FILE *safe_fopen(const char *filename, const char *mode) {
    // Validate mode string
    if (mode == NULL || strlen(mode) > 3) return NULL;

    // Validate filename
    if (filename == NULL || strlen(filename) == 0) return NULL;
    if (strstr(filename, "..") != NULL) return NULL;

    return fopen(filename, mode);
}

// Safe file reading
bool safe_read_file(const char *filename, char *buffer, size_t buffer_size) {
    if (buffer == NULL || buffer_size == 0) return false;

    FILE *file = safe_fopen(filename, "r");
    if (file == NULL) return false;

    size_t bytes_read = fread(buffer, 1, buffer_size - 1, file);
    buffer[bytes_read] = '\0';

    fclose(file);
    return true;
}

// Safe file writing
bool safe_write_file(const char *filename, const char *data, size_t data_size) {
    if (data == NULL) return false;

    FILE *file = safe_fopen(filename, "w");
    if (file == NULL) return false;

    size_t bytes_written = fwrite(data, 1, data_size, file);
    fclose(file);

    return bytes_written == data_size;
}

int main(void) {
    char buffer[1024];

    if (safe_read_file("test.txt", buffer, sizeof(buffer))) {
        printf("Read: %s\n", buffer);
    }

    return 0;
}
```

## Random Number Security

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// BAD - Predictable random
void insecure_random(void) {
    srand(time(NULL));
    int random_value = rand();
    printf("Insecure random: %d\n", random_value);
}

// BETTER - More randomness (but not cryptographically secure)
void better_random(void) {
    // Use better entropy sources
    unsigned int seed;
    FILE *urandom = fopen("/dev/urandom", "r");
    if (urandom) {
        fread(&seed, sizeof(seed), 1, urandom);
        fclose(urandom);
        srand(seed);
    } else {
        srand(time(NULL));
    }

    int random_value = rand();
    printf("Better random: %d\n", random_value);
}

// NOTE: For cryptographic security, use specialized libraries
// like OpenSSL, libsodium, or system-specific secure random APIs

int main(void) {
    insecure_random();
    better_random();

    return 0;
}
```

## Password Security

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Secure password reading (POSIX)
char *read_password_secure(void) {
    char *password = NULL;
    size_t len = 0;
    ssize_t read;

    // Use getpass() or termios to hide input
    // Note: getpass() is deprecated, use termios instead

    printf("Enter password: ");
    fflush(stdout);

    read = getline(&password, &len, stdin);
    if (read > 0 && password[read - 1] == '\n') {
        password[read - 1] = '\0';
    }

    // Clear password from memory as soon as possible
    // (this is not perfect but better than nothing)
    if (password != NULL) {
        memset(password, 0, strlen(password));
    }

    return password;
}

// Password storage should use hashing (not plain text)
// Use libraries like libsodium or bcrypt for password hashing

int main(void) {
    char *password = read_password_secure();
    if (password != NULL) {
        // Process password (hash it, don't store plain text)
        free(password);
    }

    return 0;
}
```

## Safe Process Spawning

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// BAD - system() is dangerous
void unsafe_execute(const char *user_input) {
    // If user_input contains "; rm -rf /", it will execute!
    system(user_input);
}

// GOOD - Use execve() with explicit environment
void safe_execute(const char *command, char *const argv[]) {
    pid_t pid = fork();
    if (pid == 0) {
        // Child process
        execve(command, argv, NULL);  // NULL environment for security
        perror("execve failed");
        exit(1);
    } else if (pid > 0) {
        // Parent process
        int status;
        waitpid(pid, &status, 0);
    } else {
        perror("fork failed");
    }
}

int main(void) {
    char *args[] = {"/bin/ls", "-l", NULL};
    safe_execute("/bin/ls", args);

    return 0;
}
```

## Best Practices

### Use Secure Alternatives

```c
// BAD - Unsafe functions
strcpy(dest, src);
strcat(dest, src);
sprintf(buffer, "%s", input);
gets(buffer);  // Never use gets!

// GOOD - Safe alternatives
strncpy(dest, src, sizeof(dest) - 1);
dest[sizeof(dest) - 1] = '\0';
strncat(dest, src, sizeof(dest) - strlen(dest) - 1);
snprintf(buffer, sizeof(buffer), "%s", input);
fgets(buffer, sizeof(buffer), stdin);
```

### Always Validate Input

```c
// Validate all user input
if (!is_valid_input(user_data)) {
    fprintf(stderr, "Invalid input\n");
    return 1;
}

// Validate array bounds
if (index < 0 || index >= array_size) {
    fprintf(stderr, "Index out of bounds\n");
    return 1;
}
```

### Check Return Values

```c
// Always check return values
FILE *file = fopen("file.txt", "r");
if (file == NULL) {
    perror("Failed to open file");
    return 1;
}

int *ptr = malloc(sizeof(int) * n);
if (ptr == NULL) {
    fprintf(stderr, "Memory allocation failed\n");
    return 1;
}
```

## Common Pitfalls

### 1. Buffer Overflow

```c
// WRONG - No size checking
char buffer[10];
scanf("%s", buffer);  // Overflow if input > 9 chars

// CORRECT - Limit input
char buffer[10];
scanf("%9s", buffer);
```

### 2. Format String Vulnerability

```c
// WRONG - User controls format string
printf(user_input);

// CORRECT - Use format specifier
printf("%s", user_input);
```

### 3. Integer Overflow

```c
// WRONG - Can overflow
int result = a * b;

// CORRECT - Check before operation
if (b != 0 && a > INT_MAX / b) {
    // Handle overflow
}
result = a * b;
```

> **Note**: Security in C is challenging due to manual memory management. Always follow the principle of least privilege, validate all inputs, use secure coding practices, and consider using security-focused libraries for critical applications. Regular code reviews and security audits are essential.
