---
id: "c.stdlib.string"
title: "String Functions (string.h)"
category: stdlib
difficulty: beginner
tags: [c, string, strlen, strcpy, strcmp, strcat]
keywords: [strlen, strcpy, strcmp, strcat, strstr, strncmp]
use_cases: [string manipulation, text processing, validation]
prerequisites: []
related: [c.algorithms.greedy]
next_topics: [c.stdlib.stdio]
---

# String Functions

## strlen - String Length

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "Hello, World!";

    size_t len = strlen(str);

    printf("Length: %zu\n", len);

    return 0;
}
```

## strcpy - String Copy

```c
#include <stdio.h>
#include <string.h>

int main() {
    char dest[20];
    const char* src = "Hello";

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
    char dest[10];
    const char* src = "This is too long";

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
    const char* str1 = "Hello";
    const char* str2 = "hello";

    int result = strcmp(str1, str2);

    if (result == 0) {
        printf("Strings are equal\n");
    } else if (result < 0) {
        printf("'%s' < '%s'\n", str1, str2);
    } else {
        printf("'%s' > '%s'\n", str1, str2);
    }

    return 0;
}
```

## strncmp - Partial Comparison

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str1 = "Hello, World!";
    const char* str2 = "Hello, Everyone!";

    int result = strncmp(str1, str2, 5);

    printf("First 5 chars: %d\n", result);

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
    char dest[20] = "Hello, ";
    const char* src = "World!";

    size_t space_left = sizeof(dest) - strlen(dest) - 1;
    strncat(dest, src, space_left);

    printf("Concatenated: %s\n", dest);

    return 0;
}
```

## strchr - Find Character

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "Hello, World!";
    const char* ch = "W";

    const char* result = strchr(str, ch);

    if (result != NULL) {
        printf("Found '%c' at position: %ld\n", *ch, result - str);
    } else {
        printf("Character not found\n");
    }

    return 0;
}
```

## strrchr - Find Last Character

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "Hello, World!";

    const char* result = strrchr(str, 'l');

    if (result != NULL) {
        printf("Last 'l' at position: %ld\n", result - str);
    } else {
        printf("Character not found\n");
    }

    return 0;
}
```

## strstr - Find Substring

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* haystack = "Hello, World!";
    const char* needle = "World";

    const char* result = strstr(haystack, needle);

    if (result != NULL) {
        printf("Found at position: %ld\n", result - haystack);
    printf("From match: %s\n", result);
    } else {
        printf("Substring not found\n");
    }

    return 0;
}
```

## strtok - String Tokenization

```c
#include <stdio.h>
#include <string.h>

int main() {
    char str[] = "apple,banana,cherry,date";
    const char* delim = ",";

    char* token = strtok(str, delim);

    printf("Tokens:\n");
    while (token != NULL) {
        printf("  %s\n", token);
        token = strtok(NULL, delim);
    }

    return 0;
}
```

## strdup - Duplicate String

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    const char* original = "Hello, World!";

    char* copy = strdup(original);

    if (copy != NULL) {
        printf("Copied: %s\n", copy);
        free(copy);
    }

    return 0;
}
```

## memset - Set Memory

```c
#include <stdio.h>
#include <string.h>

int main() {
    char buffer[100];

    memset(buffer, 0, sizeof(buffer));

    printf("Buffer cleared\n");
    printf("First char: %d\n", (int)buffer[0]);

    return 0;
}
```

## memcpy - Copy Memory

```c
#include <stdio.h>
#include <string.h>

int main() {
    char src[] = "Hello, World!";
    char dest[20];

    memcpy(dest, src, sizeof(src));

    printf("Copied: %s\n", dest);

    return 0;
}
}

## memmove - Overlapping Copy

```c
#include <stdio.h>
#include <string.h>

int main() {
    char buffer[20] = "Hello, World!";

    memmove(buffer + 5, buffer, 5);

    printf("After memmove: %s\n", buffer);

    return 0;
}
```

## memcmp - Memory Comparison

```c
#include <stdio.h>
#include <string.h>

int main() {
    char str1[] = "Hello";
    char str2[] = "Hello";
    char str3[] = "Hello";

    int result1 = memcmp(str1, str2, sizeof(str1));
    int result2 = memcmp(str1, str3, sizeof(str1));

    printf("str1 == str2: %d\n", result1);
    printf("str1 == str3: %d\n", result2);

    return 0;
}
```

## strcoll - Locale-Aware Comparison

```c
#include <stdio.h>
#include <string.h>
#include <locale.h>

int main() {
    setlocale(LC_ALL, "en_US.UTF-8");

    const char* str1 = "café";
    const char* str2 = "cafe";

    int result = strcoll(str1, str2);

    printf("Locale comparison: %d\n", result);

    return 0;
}
```

## strxfrm - Transformation

```c
#include <stdio.h>
#include <string.h>
#include <locale.h>

int main() {
    setlocale(LC_ALL, "en_US.UTF-8");

    const char* src = "café";
    char dest[100];

    size_t len = strxfrm(dest, src, sizeof(dest));

    printf("Transformed: %s\n", dest);
    printf("Length: %zu\n", len);

    return 0;
}
```

## strspn - Span of Characters

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "123abc456";
    const char* digits = "0123456789";

    size_t count = strspn(str, digits);

    printf("Leading digits: %zu\n", count);

    return 0;
}
```

## strcspn - Complement Span

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "123abc456";
    const char* vowels = "aeiouAEIOU";

    size_t count = strcspn(str, vowels);

    printf("Consonants until first vowel: %zu\n", count);

    return 0;
}
```

## strpbrk - Find Any of a Set

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "Hello, World!";
    const char* charset = "aeiouAEIOU";

    const char* result = strpbrk(str, charset);

    if (result != NULL) {
        printf("First vowel: %c at position: %ld\n",
               *result, result - str);
    } else {
        printf("No vowels found\n");
    }

    return 0;
}
```

> **Note**: Always ensure destination buffers have enough space. Check for NULL before dereferencing.
