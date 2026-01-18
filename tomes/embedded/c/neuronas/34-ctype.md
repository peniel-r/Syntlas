---
id: "c.stdlib.ctype"
title: "Character Classification (isalpha, isdigit, toupper)"
category: stdlib
difficulty: beginner
tags: [c, ctype, isalpha, isdigit, toupper, tolower]
keywords: [isalpha, isdigit, isalnum, isspace, toupper, tolower]
use_cases: [input validation, string processing, parsing]
prerequisites: []
related: ["c.strings"]
next_topics: ["c.stdlib.stdio"]
---

# Character Classification

## Basic Classification

```c
#include <stdio.h>
#include <ctype.h>

int main() {
    char c = 'A';

    printf("isalpha('A'): %d\n", isalpha(c));   // non-zero (true)
    printf("isdigit('A'): %d\n", isdigit(c));   // 0 (false)
    printf("isalnum('A'): %d\n", isalnum(c));   // non-zero (true)
    printf("isupper('A'): %d\n", isupper(c));   // non-zero (true)
    printf("islower('A'): %d\n", islower(c));   // 0 (false)

    return 0;
}
```

## Character Conversion

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

void convert_case(const char* str) {
    char upper[strlen(str) + 1];
    char lower[strlen(str) + 1];

    for (size_t i = 0; i < strlen(str); i++) {
        upper[i] = toupper(str[i]);
        lower[i] = tolower(str[i]);
    }

    upper[strlen(str)] = '\0';
    lower[strlen(str)] = '\0';

    printf("Original: %s\n", str);
    printf("Upper: %s\n", upper);
    printf("Lower: %s\n", lower);
}

int main() {
    convert_case("Hello, World!");

    return 0;
}
```

## Input Validation

```c
#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>

bool is_valid_number(const char* str) {
    if (str == NULL || *str == '\0') {
        return false;
    }

    // Optional leading sign
    if (*str == '+' || *str == '-') {
        str++;
    }

    // Check remaining characters
    bool has_digit = false;
    while (*str != '\0') {
        if (!isdigit((unsigned char)*str)) {
            return false;
        }
        has_digit = true;
        str++;
    }

    return has_digit;
}

int main() {
    const char* tests[] = {"123", "-456", "+789", "12a3", ""};

    for (int i = 0; i < 5; i++) {
        printf("'%s': %s\n", tests[i],
               is_valid_number(tests[i]) ? "valid" : "invalid");
    }

    return 0;
}
```

## Whitespace Detection

```c
#include <stdio.h>
#include <ctype.h>

void print_non_whitespace(const char* str) {
    printf("Non-whitespace: ");

    while (*str != '\0') {
        if (!isspace((unsigned char)*str)) {
            putchar(*str);
        }
        str++;
    }

    printf("\n");
}

int main() {
    const char* text = "  Hello,   World!  ";
    print_non_whitespace(text);

    return 0;
}
```

## Hex Validation

```c
#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>

bool is_hex_digit(char c) {
    return isdigit((unsigned char)c) ||
           (tolower((unsigned char)c) >= 'a' &&
            tolower((unsigned char)c) <= 'f');
}

bool is_valid_hex(const char* str) {
    if (str == NULL || *str == '\0') {
        return false;
    }

    // Optional 0x prefix
    if (str[0] == '0' && (str[1] == 'x' || str[1] == 'X')) {
        str += 2;
    }

    while (*str != '\0') {
        if (!is_hex_digit(*str)) {
            return false;
        }
        str++;
    }

    return true;
}

int main() {
    const char* hex_tests[] = {"0xFF", "1A2B", "GH12", "0xZ"};

    for (int i = 0; i < 4; i++) {
        printf("'%s': %s\n", hex_tests[i],
               is_valid_hex(hex_tests[i]) ? "valid" : "invalid");
    }

    return 0;
}
```

## Remove Non-Alphanumeric

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

void remove_non_alnum(char* str) {
    char* dest = str;

    while (*str != '\0') {
        if (isalnum((unsigned char)*str)) {
            *dest = *str;
            dest++;
        }
        str++;
    }
    *dest = '\0';
}

int main() {
    char str[] = "Hello, World! 123";
    printf("Original: %s\n", str);

    remove_non_alnum(str);
    printf("Cleaned: %s\n", str);

    return 0;
}
```

## Word Count

```c
#include <stdio.h>
#include <ctype.h>

int count_words(const char* str) {
    int count = 0;
    int in_word = 0;

    while (*str != '\0') {
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

## Character Statistics

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

typedef struct {
    int letters;
    int digits;
    int spaces;
    int punctuation;
    int other;
} CharStats;

CharStats analyze_string(const char* str) {
    CharStats stats = {0, 0, 0, 0, 0};

    while (*str != '\0') {
        if (isalpha((unsigned char)*str)) {
            stats.letters++;
        } else if (isdigit((unsigned char)*str)) {
            stats.digits++;
        } else if (isspace((unsigned char)*str)) {
            stats.spaces++;
        } else if (ispunct((unsigned char)*str)) {
            stats.punctuation++;
        } else {
            stats.other++;
        }
        str++;
    }

    return stats;
}

int main() {
    const char* text = "Hello, World! 123";
    CharStats stats = analyze_string(text);

    printf("Statistics:\n");
    printf("  Letters: %d\n", stats.letters);
    printf("  Digits: %d\n", stats.digits);
    printf("  Spaces: %d\n", stats.spaces);
    printf("  Punctuation: %d\n", stats.punctuation);
    printf("  Other: %d\n", stats.other);

    return 0;
}
```

## Title Case

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

void to_title_case(char* str) {
    int capitalize_next = 1;

    while (*str != '\0') {
        if (isspace((unsigned char)*str)) {
            capitalize_next = 1;
        } else if (capitalize_next) {
            *str = toupper((unsigned char)*str);
            capitalize_next = 0;
        } else {
            *str = tolower((unsigned char)*str);
        }
        str++;
    }
}

int main() {
    char str[] = "hello world this is a test";
    printf("Original: %s\n", str);

    to_title_case(str);
    printf("Title case: %s\n", str);

    return 0;
}
```

## String to Number Validation

```c
#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>

bool is_integer(const char* str) {
    if (str == NULL || *str == '\0') {
        return false;
    }

    // Optional sign
    if (*str == '+' || *str == '-') {
        str++;
    }

    // At least one digit
    if (!isdigit((unsigned char)*str)) {
        return false;
    }

    // Remaining digits
    while (*str != '\0') {
        if (!isdigit((unsigned char)*str)) {
            return false;
        }
        str++;
    }

    return true;
}

bool is_float(const char* str) {
    if (str == NULL || *str == '\0') {
        return false;
    }

    // Optional sign
    if (*str == '+' || *str == '-') {
        str++;
    }

    // At least one digit
    bool has_digit = false;

    // Integer part
    while (isdigit((unsigned char)*str)) {
        has_digit = true;
        str++;
    }

    // Optional decimal point
    if (*str == '.') {
        str++;

        // Fractional part
        while (isdigit((unsigned char)*str)) {
            has_digit = true;
            str++;
        }
    }

    // Optional exponent
    if (*str == 'e' || *str == 'E') {
        str++;

        // Optional sign
        if (*str == '+' || *str == '-') {
            str++;
        }

        // Exponent digits
        if (!isdigit((unsigned char)*str)) {
            return false;
        }
        while (isdigit((unsigned char)*str)) {
            str++;
        }
    }

    return has_digit && *str == '\0';
}

int main() {
    const char* tests[] = {"123", "-456", "+789", "3.14", "-2.5e10", "abc"};

    for (int i = 0; i < 6; i++) {
        printf("'%s': int=%s, float=%s\n", tests[i],
               is_integer(tests[i]) ? "yes" : "no",
               is_float(tests[i]) ? "yes" : "no");
    }

    return 0;
}
```

## Case-Insensitive Compare

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int strcasecmp_custom(const char* s1, const char* s2) {
    while (*s1 && *s2) {
        int c1 = tolower((unsigned char)*s1);
        int c2 = tolower((unsigned char)*s2);

        if (c1 != c2) {
            return c1 - c2;
        }

        s1++;
        s2++;
    }

    return *s1 - *s2;
}

int main() {
    const char* str1 = "Hello";
    const char* str2 = "HELLO";
    const char* str3 = "World";

    printf("'%s' == '%s': %d\n", str1, str2,
           strcasecmp_custom(str1, str2));
    printf("'%s' == '%s': %d\n", str1, str3,
           strcasecmp_custom(str1, str3));

    return 0;
}
```

## Filter Characters

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

void filter_chars(char* dest, const char* src,
                int (*filter)(int)) {
    while (*src != '\0') {
        if (filter((unsigned char)*src)) {
            *dest = *src;
            dest++;
        }
        src++;
    }
    *dest = '\0';
}

int main() {
    const char* text = "Hello, World! 123";
    char filtered[256];

    // Keep only letters
    filter_chars(filtered, text, isalpha);
    printf("Letters only: %s\n", filtered);

    // Keep only digits
    filter_chars(filtered, text, isdigit);
    printf("Digits only: %s\n", filtered);

    return 0;
}
```

> **Note**: Always cast to `unsigned char` when passing to ctype functions to avoid undefined behavior with negative values.
