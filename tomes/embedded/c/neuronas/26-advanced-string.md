---
id: "c.stdlib.string.advanced"
title: "Advanced String Functions (strtok, strspn, strcspn)"
category: stdlib
difficulty: intermediate
tags: [c, string, parsing, tokenization, pattern matching]
keywords: [strtok, strtok_r, strspn, strcspn, strpbrk, strstr]
use_cases: [parsing, tokenization, pattern matching]
prerequisites: ["c.strings"]
related: ["c.stdlib.string"]
next_topics: ["c.io"]
---

# Advanced String Functions

## strtok - String Tokenization

```c
#include <stdio.h>
#include <string.h>

int main() {
    char str[] = "Hello,world,this,is,a,test";
    const char* delim = ",";

    char* token = strtok(str, delim);

    while (token != NULL) {
        printf("Token: %s\n", token);
        token = strtok(NULL, delim);
    }

    return 0;
}
```

## strtok - Multi-Character Delimiter

```c
#include <stdio.h>
#include <string.h>

int main() {
    char str[] = "apple,orange;banana|grape";
    const char* delim = ",;|";

    char* token = strtok(str, delim);

    while (token != NULL) {
        printf("Token: %s\n", token);
        token = strtok(NULL, delim);
    }

    return 0;
}
```

## strtok_r - Thread-Safe Tokenization

```c
#include <stdio.h>
#include <string.h>

int main() {
    char str[] = "one:two:three:four";
    char* saveptr;
    const char* delim = ":";

    char* token = strtok_r(str, delim, &saveptr);

    while (token != NULL) {
        printf("Token: %s\n", token);
        token = strtok_r(NULL, delim, &saveptr);
    }

    return 0;
}
```

## strspn - Span of Characters

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "12345abc";
    const char* accept = "0123456789";

    // Count leading digits
    size_t count = strspn(str, accept);
    printf("Leading digits: %zu\n", count);  // 5

    // Check if string starts with prefix
    const char* prefix = "123";
    size_t prefix_len = strlen(prefix);

    if (strspn(str, prefix) >= prefix_len) {
        printf("String starts with %s\n", prefix);
    }

    return 0;
}
```

## strcspn - Complement Span

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "12345abc";
    const char* reject = "abcdefghijklmnopqrstuvwxyz";

    // Count until first letter
    size_t count = strcspn(str, reject);
    printf("Digits before first letter: %zu\n", count);  // 5

    return 0;
}
```

## strpbrk - Find Any of a Set

```c
#include <stdio.h>
#include <string.h>

int main() {
    const char* str = "Hello, World!";
    const char* accept = "aeiou";

    // Find first vowel
    char* result = strpbrk(str, accept);

    if (result != NULL) {
        printf("First vowel: %c\n", *result);  // e
        printf("Position: %ld\n", result - str);  // 1
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

    // Find substring
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

## Parsing CSV

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void parse_csv_line(const char* line) {
    char buffer[256];
    strncpy(buffer, line, sizeof(buffer));

    char* token = strtok(buffer, ",");

    printf("CSV fields:\n");
    int field_num = 1;
    while (token != NULL) {
        printf("  Field %d: %s\n", field_num, token);
        token = strtok(NULL, ",");
        field_num++;
    }
}

int main() {
    const char* csv = "John,Doe,30,New York";
    parse_csv_line(csv);

    return 0;
}
```

## Word Count

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int count_words(const char* str) {
    int count = 0;
    int in_word = 0;

    while (*str) {
        if (isspace((unsigned char)*str)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            count++;
        }
        str++;
    }

    return count;
}

int main() {
    const char* text = "  Hello   world  this  is  a  test  ";
    int words = count_words(text);

    printf("Word count: %d\n", words);  // 6

    return 0;
}
```

## Trim Whitespace

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

void trim(char* str) {
    char* end;

    // Trim leading space
    while (isspace((unsigned char)*str)) {
        str++;
    }

    if (*str == '\0') {
        return;  // All spaces
    }

    // Trim trailing space
    end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end)) {
        end--;
    }

    // Write new null terminator
    *(end + 1) = '\0';
}

int main() {
    char str[] = "   Hello, World!   ";
    printf("Before: '%s'\n", str);

    trim(str);
    printf("After: '%s'\n", str);

    return 0;
}
```

## Replace Substring

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* replace_substring(const char* str, const char* old, const char* new) {
    char* result;
    char* ins;
    char* tmp;
    int len_old = strlen(old);
    int len_new = strlen(new);
    int count = 0;

    // Count occurrences
    for (ins = (char*)str; (tmp = strstr(ins, old)); ins = tmp + len_old) {
        count++;
    }

    // Calculate new string length
    int len_result = strlen(str) + (len_new - len_old) * count;
    result = malloc(len_result + 1);

    if (result == NULL) {
        return NULL;
    }

    // Perform replacement
    ins = (char*)str;
    tmp = result;

    while (count--) {
        char* next = strstr(ins, old);
        int len = next - ins;
        memcpy(tmp, ins, len);
        tmp += len;
        memcpy(tmp, new, len_new);
        tmp += len_new;
        ins = next + len_old;
    }

    strcpy(tmp, ins);

    return result;
}

int main() {
    const char* str = "Hello, world! Hello, universe!";
    const char* old = "Hello";
    const char* new = "Hi";

    char* result = replace_substring(str, old, new);
    if (result != NULL) {
        printf("Result: %s\n", result);
        free(result);
    }

    return 0;
}
```

## Split String into Array

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char** split_string(const char* str, const char* delim, int* count) {
    char buffer[1024];
    strncpy(buffer, str, sizeof(buffer));

    // First pass: count tokens
    int token_count = 0;
    char* temp = strdup(buffer);
    char* token = strtok(temp, delim);
    while (token != NULL) {
        token_count++;
        token = strtok(NULL, delim);
    }
    free(temp);

    // Allocate array
    char** result = malloc((token_count + 1) * sizeof(char*));
    if (result == NULL) {
        return NULL;
    }

    // Second pass: store tokens
    strncpy(buffer, str, sizeof(buffer));
    token = strtok(buffer, delim);
    int i = 0;
    while (token != NULL && i < token_count) {
        result[i] = strdup(token);
        token = strtok(NULL, delim);
        i++;
    }
    result[i] = NULL;

    *count = token_count;
    return result;
}

void free_string_array(char** array, int count) {
    for (int i = 0; i < count; i++) {
        free(array[i]);
    }
    free(array);
}

int main() {
    const char* str = "apple,banana,cherry,date";
    int count;
    char** tokens = split_string(str, ",", &count);

    printf("Tokens (%d):\n", count);
    for (int i = 0; i < count; i++) {
        printf("  %s\n", tokens[i]);
    }

    free_string_array(tokens, count);

    return 0;
}
```

> **Note**: `strtok` modifies the original string. Use `strdup` or copy the string if you need to preserve it.
