---
id: "c.stdlib.string"
title: "String Library Functions"
category: stdlib
difficulty: intermediate
tags: [c, string, strlen, strcpy, strcmp, sprintf]
keywords: [strlen, strcpy, strcat, strcmp, strncmp, strstr, sprintf]
use_cases: [string manipulation, text processing, c-style strings]
prerequisites: []
related: ["c.arrays", "c.pointers"]
next_topics: ["c.stdlib.io"]
---

# String Library 

C provides <string.h> for null-terminated string operations.

## String Length

```c
#include <string.h>
#include <stdio.h>

int main() {
    const char* text = "Hello, World!";
    
    // strlen() - returns length excluding null terminator
    size_t len = strlen(text);
    printf("Length: %zu\n", len);  // 13
    
    return 0;
}
```

## String Copying

```c
#include <string.h>
#include <stdio.h>

int main() {
    const char* src = "Hello";
    char dest[100];
    
    // strcpy() - copies entire string (dangerous - no bounds check)
    strcpy(dest, src);
    printf("Copied: %s\n", dest);
    
    // strncpy() - safer with max length
    char dest2[6];
    strncpy(dest2, src, 5);
    dest2[5] = '\0';  // Ensure null termination
    printf("Safe copy: %s\n", dest2);
    
    return 0;
}
```

## String Concatenation

```c
#include <string.h>
#include <stdio.h>

int main() {
    const char* part1 = "Hello";
    const char* part2 = " World";
    char dest[100];
    
    // strcat() - appends (dangerous - no bounds check)
    strcpy(dest, part1);
    strcat(dest, part2);
    printf("Concatenated: %s\n", dest);
    
    // strncat() - safer with max length
    char dest2[50];
    strcpy(dest2, part1);
    strncat(dest2, part2, 10);
    printf("Safe concat: %s\n", dest2);
    
    return 0;
}
```

## String Comparison

```c
#include <string.h>
#include <stdio.h>

int main() {
    const char* s1 = "hello";
    const char* s2 = "HELLO";
    
    // strcmp() - lexicographic comparison
    int cmp = strcmp(s1, s2);
    if (cmp < 0) printf("s1 < s2\n");
    else if (cmp > 0) printf("s1 > s2\n");
    else printf("s1 == s2\n");
    
    // strncmp() - comparison up to n characters
    int cmp_n = strncmp(s1, s2, 3);
    printf("First 3 chars: %d\n", cmp_n);
    
    return 0;
}
```

## String Searching

```c
#include <string.h>
#include <stdio.h>

int main() {
    const char* text = "Hello, World!";
    const char* search = "World";
    
    // strstr() - find substring
    char* found = strstr(text, search);
    if (found != NULL) {
        printf("Found at position: %td\n", found - text);
    } else {
        printf("Not found\n");
    }
    
    // strchr() - find character
    char* char_found = strchr(text, 'W');
    if (char_found != NULL) {
        printf("First 'W' at: %td\n", char_found - text);
    }
    
    return 0;
}
```

## String Formatting

```c
#include <string.h>
#include <stdio.h>

int main() {
    char buffer[100];
    int age = 30;
    const char* name = "Alice";
    
    // sprintf() - formatted output (dangerous - no bounds check)
    sprintf(buffer, "Name: %s, Age: %d", name, age);
    printf("Formatted: %s\n", buffer);
    
    // snprintf() - safer with max length
    snprintf(buffer, sizeof(buffer), "Name: %s, Age: %d", name, age);
    printf("Safe formatted: %s\n", buffer);
    
    return 0;
}
```

## String Tokenization

```c
#include <string.h>
#include <stdio.h>

int main() {
    const char* text = "apple,banana,cherry";
    char buffer[100];
    
    // strtok() - tokenize (modifies string, not thread-safe)
    strcpy(buffer, text);
    
    char* token = strtok(buffer, ",");
    while (token != NULL) {
        printf("Token: %s\n", token);
        token = strtok(NULL, ",");  // Continue
    }
    
    return 0;
}
```

## Safe String 

```c
#include <string.h>
#include <stdio.h>

// strlcpy() - copies up to n characters
void safe_copy(char* dest, const char* src, size_t max_len) {
    strlcpy(dest, src, max_len);
    dest[max_len] = '\0';  // Ensure null termination
}

// strlcat() - appends up to n characters
void safe_append(char* dest, const char* src, size_t max_len) {
    size_t len = strlen(dest);
    if (len < max_len) {
        strlcat(dest, src, max_len - len - 1);
    }
}

int main() {
    char buffer[100] = "Hello";
    
    safe_append(buffer, " World", 98);
    printf("Safe append: %s\n", buffer);
    
    return 0;
}
```

## Character Classification

```c
#include <ctype.h>
#include <stdio.h>

int main() {
    char c = 'A';
    
    // isalpha() - alphabetic
    if (isalpha(c)) printf("Alphabetic\n");
    
    // isdigit() - digit
    if (isdigit(c)) printf("Digit\n");
    
    // isxdigit() - hexadecimal digit
    if (isxdigit(c)) printf("Hex digit\n");
    
    // tolower() - convert to lowercase
    printf("Lower: %c\n", tolower(c));
    
    // toupper() - convert to uppercase
    printf("Upper: %c\n", toupper(c));
    
    return 0;
}
```

## Memory and Size

```c
#include <string.h>

int main() {
    const char* text = "Hello";
    
    // strlen() - length
    size_t len = strlen(text);
    
    // sizeof() - size of type
    printf("sizeof(char): %zu\n", sizeof(char));
    printf("strlen: %zu\n", len);
    printf("Ratio: %.2f\n", (float)len / sizeof(char));
    
    return 0;
}
```

## Common Patterns

### String builder pattern

```c
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

char* build_string(const char* parts[], size_t count) {
    // Calculate total length
    size_t total_len = 0;
    for (size_t i = 0; i < count; i++) {
        total_len += strlen(parts[i]);
    }
    
    // Allocate (+1 for null terminator)
    char* result = malloc(total_len + 1);
    if (result == NULL) return NULL;
    
    // Build string
    size_t pos = 0;
    for (size_t i = 0; i < count; i++) {
        size_t len = strlen(parts[i]);
        if (i > 0) {
            result[pos++] = ' ';  // Separator
        }
        strcpy(result + pos, parts[i]);
        pos += len;
    }
    
    result[total_len] = '\0';  // Null terminate
    return result;
}

int main() {
    const char* words[] = {"Hello", "beautiful", "world"};
    char* sentence = build_string(words, 3);
    if (sentence != NULL) {
        printf("Built: %s\n", sentence);
        free(sentence);
    }
    
    return 0;
}
```

### Safe string copy with bounds

```c
#include <stdlib.h>
#include <string.h>

char* safe_strdup(const char* src) {
    if (src == NULL) return NULL;
    
    size_t len = strlen(src) + 1;  // +1 for null terminator
    char* dest = malloc(len);
    if (dest == NULL) return NULL;
    
    memcpy(dest, src, len);
    return dest;
}
```

### String prefix/suffix check

```c
#include <string.h>
#include <stdio.h>

int starts_with(const char* str, const char* prefix) {
    size_t prefix_len = strlen(prefix);
    return strncmp(str, prefix, prefix_len) == 0;
}

int ends_with(const char* str, const char* suffix) {
    size_t str_len = strlen(str);
    size_t suffix_len = strlen(suffix);
    
    if (str_len < suffix_len) return 0;
    
    return strcmp(str + str_len - suffix_len, suffix) == 0;
}
```

> **Note**: Modern C should prefer strnlen(), strncat(), and strncpy_s() with explicit length parameters for safety. Consider using C++ std::string for safer string handling.
