---
id: "c.stdlib.string.h"
title: "String  (strlen, strcpy, strcmp, strcat)"
category: stdlib
difficulty: beginner
tags: [c, string, strlen, strcpy, strcmp, strcat]
keywords: [strlen, strcpy, strcmp, strcat, strcpy_s, strcat_s]
use_cases: [string manipulation, text processing, comparisons]
prerequisites: []
related: ["c.stdlib.string.advanced"]
next_topics: ["c.stdlib.stdio"]
---

# String 

## strlen - String Length

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "Hello, World!";

    size_t len = strlen(str);
    printf("Length of '%s': %zu\n", str, len);

    return 0;
}
```

## strcpy - String Copy

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* src = "Hello";
    char dest[10];

    strcpy(dest, src);

    printf("Copied: %s\n", dest);

    return 0;
}
```

## strncpy - Safe String Copy

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* src = "Hello, World!";
    char dest[10];

    strncpy(dest, src, sizeof(dest) - 1);
    dest[sizeof(dest) - 1] = '\0';

    printf("Copied: %s\n", dest);

    return 0;
}
```

## strcmp - String Comparison

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str1 = "apple";
    const char* str2 = "banana";
    const char* str3 = "apple";

    int result1 = strcmp(str1, str2);
    int result2 = strcmp(str1, str3);

    printf("'%s' vs '%s': %d\n", str1, str2, result1);
    printf("'%s' vs '%s': %d\n", str1, str3, result2);

    if (result1 < 0) {
        printf("'%s' comes before '%s'\n", str1, str2);
    }

    if (result2 == 0) {
        printf("'%s' equals '%s'\n", str1, str3);
    }

    return 0;
}
```

## strncmp - Partial String Comparison

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str1 = "Hello, World!";
    const char* str2 = "Hello, Everyone!";

    int result = strncmp(str1, str2, 7);

    printf("First 7 chars: %d\n", result);

    if (result == 0) {
        printf("First 7 characters match\n");
    }

    return 0;
}
```

## strcat - String Concatenation

```c
#include <stdio.h>
#include <string.h>

int main() {
    char dest[50] = "Hello, ";
    const char* src = "World!";

    strcat(dest, src);

    printf("Concatenated: %s\n", dest);

    return 0;
}
```

## strncat - Safe Concatenation

```c
#include <stdio.h>
#include <string.h>

int main() {
    char dest[20] = "Hello";
    const char* src = ", World!";

    size_t space_left = sizeof(dest) - strlen(dest) - 1;
    strncat(dest, src, space_left);

    printf("Concatenated: %s\n", dest);

    return 0;
}
```

## String Concatenation Helper

```c
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool safe_strcat(char* dest, size_t dest_size, const char* src) {
    size_t dest_len = strlen(dest);
    size_t src_len = strlen(src);

    if (dest_len + src_len >= dest_size) {
        return false;
    }

    strcat(dest, src);
    return true;
}

int main() {
    char buffer[20] = "Hello";

    if (safe_strcat(buffer, sizeof(buffer), ", World!")) {
        printf("Success: %s\n", buffer);
    } else {
        printf("Buffer too small\n");
    }

    return 0;
}
```

## String Search

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* haystack = "Hello, World!";
    const char* needle = "World";

    char* result = strstr(haystack, needle);

    if (result != NULL) {
        printf("Found at position: %ld\n", result - haystack);
        printf("From match: %s\n", result);
    } else {
        printf("Not found\n");
    }

    return 0;
}
```

## Character Search

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "Hello, World!";

    char* result = strchr(str, 'o');

    if (result != NULL) {
        printf("First 'o' at position: %ld\n", result - str);
    }

    result = strrchr(str, 'o');

    if (result != NULL) {
        printf("Last 'o' at position: %ld\n", result - str);
    }

    return 0;
}
```

## String Copy with Length

```c
#include <stdio.h>
#include <string.h>

char* string_copy(const char* src, size_t max_len) {
    size_t len = strlen(src);
    if (len > max_len) {
        len = max_len;
    }

    char* dest = malloc(len + 1);
    if (dest == NULL) {
        return NULL;
    }

    strncpy(dest, src, len);
    dest[len] = '\0';

    return dest;
}

int main() {
    const char* src = "Hello, World!";

    char* copy = string_copy(src, 5);

    if (copy != NULL) {
        printf("Copy: %s\n", copy);
        free(copy);
    }

    return 0;
}
```

## String Joining

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* join_strings(const char* s1, const char* s2) {
    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);

    char* result = malloc(len1 + len2 + 1);
    if (result == NULL) {
        return NULL;
    }

    strcpy(result, s1);
    strcat(result, s2);

    return result;
}

int main() {
    const char* str1 = "Hello, ";
    const char* str2 = "World!";

    char* joined = join_strings(str1, str2);

    if (joined != NULL) {
        printf("Joined: %s\n", joined);
        free(joined);
    }

    return 0;
}
```

## String Padding

```c
#include <stdio.h>
#include <string.h>

void pad_right(char* str, size_t width, char pad_char) {
    size_t len = strlen(str);

    for (size_t i = len; i < width; i++) {
        str[i] = pad_char;
    }

    str[width] = '\0';
}

int main() {
    char text[20] = "Hello";

    pad_right(text, 10, '.');

    printf("Padded: '%s'\n", text);

    return 0;
}
```

## String Trimming

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

void trim_left(char* str) {
    while (isspace((unsigned char)*str)) {
        str++;
    }

    if (str != str) {
        memmove(str, str, strlen(str) + 1);
    }
}

void trim_right(char* str) {
    char* end = str + strlen(str) - 1;

    while (end >= str && isspace((unsigned char)*end)) {
        end--;
    }

    *(end + 1) = '\0';
}

void trim(char* str) {
    trim_left(str);
    trim_right(str);
}

int main() {
    char text[] = "   Hello, World!   ";
    printf("Original: '%s'\n", text);

    trim(text);

    printf("Trimmed: '%s'\n", text);

    return 0;
}
```

## String Replace

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* replace_char(const char* str, char old, char new) {
    char* result = malloc(strlen(str) + 1);
    if (result == NULL) {
        return NULL;
    }

    size_t i;
    for (i = 0; str[i] != '\0'; i++) {
        result[i] = (str[i] == old) ? new : str[i];
    }
    result[i] = '\0';

    return result;
}

int main() {
    const char* str = "Hello, World!";

    char* replaced = replace_char(str, 'o', '0');

    if (replaced != NULL) {
        printf("Replaced: %s\n", replaced);
        free(replaced);
    }

    return 0;
}
```

> **Warning**: `strcpy` and `strcat` don't check buffer boundaries. Use `strncpy` and `strncat` with proper null termination in production code.
