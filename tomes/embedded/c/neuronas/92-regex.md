---
id: "c.stdlib.regex"
title: Regular Expressions
category: c.algorithms.sorting
difficulty: advanced
tags:
  - regex
  - pattern-matching
  - regex-h
keywords:
  - regular expressions
  - regex
  - pattern matching
  - regex.h
use_cases:
  - Text search
  - Pattern matching
  - Data validation
  - String manipulation
prerequisites:
  - c.stdlib.string
  - c.stdlib.ctype
  - 
related:
  - c.algorithms.string
  - 
next_topics:
  - c.stdlib.time
---

# Regular Expressions

Regular expressions provide powerful pattern matching for text processing.

## Basic regex.h Usage (POSIX)

```c
#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include <string.h>

int match_pattern(const char *pattern, const char *text) {
    regex_t regex;
    int ret;

    // Compile regex
    ret = regcomp(&regex, pattern, REG_EXTENDED);
    if (ret) {
        char errbuf[100];
        regerror(ret, &regex, errbuf, sizeof(errbuf));
        fprintf(stderr, "Regex  failed: %s\n", errbuf);
        return 0;
    }

    // Execute regex
    ret = regexec(&regex, text, 0, NULL, 0);

    // Free regex
    regfree(&regex);

    return ret == 0;  // Return 1 if match, 0 if no match
}

int main(void) {
    const char *text = "Hello, World! 123";

    printf("Text: %s\n\n", text);

    // Match numbers
    printf("Contains number: %s\n",
           match_pattern("[0-9]+", text) ? "yes" : "no");

    // Match uppercase letters
    printf("Contains uppercase: %s\n",
           match_pattern("[A-Z]+", text) ? "yes" : "no");

    // Match "Hello"
    printf("Contains 'Hello': %s\n",
           match_pattern("Hello", text) ? "yes" : "no");

    // Match email pattern (simple)
    const char *email = "user@example.com";
    printf("\nEmail validation: %s\n",
           match_pattern("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", email) ? "valid" : "invalid");

    return 0;
}
```

## Extracting Matches

```c
#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include <string.h>

void extract_matches(const char *pattern, const char *text) {
    regex_t regex;
    regmatch_t matches[10];

    // Compile regex
    if (regcomp(&regex, pattern, REG_EXTENDED) != 0) {
        fprintf(stderr, "Failed to compile regex\n");
        return;
    }

    // Execute regex
    int ret = regexec(&regex, text, 10, matches, 0);

    if (ret == 0) {
        printf("Matches found:\n");

        for (int i = 0; i < 10 && matches[i].rm_so != -1; i++) {
            int start = matches[i].rm_so;
            int end = matches[i].rm_eo;
            int length = end - start;

            char match[length + 1];
            strncpy(match, text + start, length);
            match[length] = '\0';

            printf("  Match %d: '%s' (position %d-%d)\n",
                   i, match, start, end);
        }
    } else {
        printf("No matches found\n");
    }

    regfree(&regex);
}

int main(void) {
    const char *text = "The prices are: $10, $25, $100";
    printf("Text: %s\n\n", text);

    // Extract prices (dollar amounts)
    extract_matches("\\$[0-9]+", text);

    return 0;
}
```

## Finding All Matches

```c
#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include <string.h>

void find_all_matches(const char *pattern, const char *text) {
    regex_t regex;
    regmatch_t match;
    int count = 0;

    if (regcomp(&regex, pattern, REG_EXTENDED) != 0) {
        fprintf(stderr, "Failed to compile regex\n");
        return;
    }

    const char *p = text;
    int offset = 0;

    while (regexec(&regex, p, 1, &match, 0) == 0) {
        int start = match.rm_so + offset;
        int end = match.rm_eo + offset;
        int length = end - start;

        char matched[length + 1];
        strncpy(matched, text + start, length);
        matched[length] = '\0';

        printf("Match %d: '%s' at position %d\n", ++count, matched, start);

        // Move past this match
        p += end - offset;
        offset = end;
    }

    regfree(&regex);

    if (count == 0) {
        printf("No matches found\n");
    }
}

int main(void) {
    const char *text = "cat bat cat rat bat cat";
    printf("Text: %s\n\n", text);

    // Find all occurrences of "cat" or "bat"
    find_all_matches("(cat|bat)", text);

    return 0;
}
```

## Replacing Matches

```c
#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include <string.h>

char *replace_matches(const char *pattern, const char *text,
                    const char *replacement) {
    regex_t regex;
    regmatch_t match;

    if (regcomp(&regex, pattern, REG_EXTENDED) != 0) {
        fprintf(stderr, "Failed to compile regex\n");
        return NULL;
    }

    // Calculate new string length
    int count = 0;
    const char *p = text;
    while (regexec(&regex, p, 1, &match, 0) == 0) {
        count++;
        p += match.rm_eo;
    }

    int replacement_len = strlen(replacement);
    int text_len = strlen(text);
    int total_len = text_len + count * (replacement_len - 1);

    char *result = malloc(total_len + 1);
    if (result == NULL) {
        regfree(&regex);
        return NULL;
    }

    // Build new string
    p = text;
    char *r = result;
    int offset = 0;

    while (regexec(&regex, p, 1, &match, 0) == 0) {
        // Copy text before match
        int before_len = match.rm_so;
        strncpy(r, p, before_len);
        r += before_len;
        p += before_len;

        // Copy replacement
        strcpy(r, replacement);
        r += replacement_len;

        // Move past match
        p += match.rm_eo - match.rm_so;
    }

    // Copy remaining text
    strcpy(r, p);

    regfree(&regex);
    return result;
}

int main(void) {
    const char *text = "Hello world! Hello everyone!";
    printf("Original: %s\n", text);

    char *result = replace_matches("Hello", text, "Hi");
    printf("Replaced: %s\n", result);

    free(result);

    return 0;
}
```

## Pattern Groups

```c
#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include <string.h>

void extract_groups(const char *pattern, const char *text) {
    regex_t regex;
    regmatch_t matches[10];

    if (regcomp(&regex, pattern, REG_EXTENDED) != 0) {
        fprintf(stderr, "Failed to compile regex\n");
        return;
    }

    if (regexec(&regex, text, 10, matches, 0) == 0) {
        printf("Groups extracted:\n");

        for (int i = 0; i < 10 && matches[i].rm_so != -1; i++) {
            int start = matches[i].rm_so;
            int end = matches[i].rm_eo;
            int length = end - start;

            if (length > 0) {
                char group[length + 1];
                strncpy(group, text + start, length);
                group[length] = '\0';

                printf("  Group %d: '%s'\n", i, group);
            }
        }
    } else {
        printf("No match found\n");
    }

    regfree(&regex);
}

int main(void) {
    // Extract date components
    const char *date = "2024-01-15";
    printf("Date: %s\n\n", date);

    extract_groups("([0-9]{4})-([0-9]{2})-([0-9]{2})", date);
    // Group 1: year
    // Group 2: month
    // Group 3: day

    return 0;
}
```

## Common Patterns

```c
#include <stdio.h>
#include <regex.h>
#include <string.h>

void test_pattern(const char *name, const char *pattern, const char *text) {
    regex_t regex;
    int match;

    if (regcomp(&regex, pattern, REG_EXTENDED) != 0) {
        fprintf(stderr, "Failed to compile regex\n");
        return;
    }

    match = regexec(&regex, text, 0, NULL, 0);

    printf("%s: '%s' - %s\n",
           name, text, match == 0 ? "match" : "no match");

    regfree(&regex);
}

int main(void) {
    // Email (simple)
    test_pattern("Email", "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", "user@example.com");

    // URL
    test_pattern("URL", "^(https?://)?[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", "http://example.com");

    // Phone number (US)
    test_pattern("Phone", "^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$", "(123) 456-7890");

    // Date (YYYY-MM-DD)
    test_pattern("Date", "^[0-9]{4}-[0-9]{2}-[0-9]{2}$", "2024-01-15");

    // IPv4 address
    test_pattern("IPv4", "^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", "192.168.1.1");

    // Hex color
    test_pattern("Hex color", "^#[0-9A-Fa-f]{6}$", "#FF5733");

    // Username (alphanumeric and underscore)
    test_pattern("Username", "^[A-Za-z0-9_]+$", "user_name_123");

    return 0;
}
```

## Case-Insensitive Matching

```c
#include <stdio.h>
#include <regex.h>
#include <string.h>

int match_case_insensitive(const char *pattern, const char *text) {
    regex_t regex;

    // Use REG_ICASE for case-insensitive matching
    int ret = regcomp(&regex, pattern, REG_EXTENDED | REG_ICASE);
    if (ret != 0) {
        return 0;
    }

    ret = regexec(&regex, text, 0, NULL, 0);
    regfree(&regex);

    return ret == 0;
}

int main(void) {
    const char *pattern = "hello";

    printf("Pattern: %s\n\n", pattern);

    printf("%s: %s\n", "HELLO",
           match_case_insensitive(pattern, "HELLO") ? "match" : "no match");
    printf("%s: %s\n", "Hello",
           match_case_insensitive(pattern, "Hello") ? "match" : "no match");
    printf("%s: %s\n", "hello",
           match_case_insensitive(pattern, "hello") ? "match" : "no match");
    printf("%s: %s\n", "HeLLo",
           match_case_insensitive(pattern, "HeLLo") ? "match" : "no match");

    return 0;
}
```

## Best Practices

### Escape Special Characters

```c
// Special regex characters: . ^ $ * + ? { } [ ] \ | ( )
// Escape with backslash when matching literally

// GOOD - Escape special chars
char pattern[] = "\\$\\d+\\.\\d{2}";  // Match "$10.50"

// WRONG - Interpreted as regex c.controlflow
char pattern[] = "$\\d+.\\d{2}";
```

### Use Anchors for Full Match

```c
// GOOD - Use ^ and $ for full string match
"^hello$"  // Matches only "hello", not "hello world"

// WRONG - Partial match
"hello"  // Matches "hello world", "shello", etc.
```

### Compile Once, Use Many Times

```c
// GOOD - Compile once
regex_t regex;
regcomp(&regex, pattern, REG_EXTENDED);
for (int i = 0; i < 100; i++) {
    regexec(&regex, text[i], ...);
}
regfree(&regex);

// WRONG - Compile in loop
for (int i = 0; i < 100; i++) {
    regex_t regex;
    regcomp(&regex, pattern, REG_EXTENDED);
    regexec(&regex, text[i], ...);
    regfree(&regex);
}
```

## Common Pitfalls

### 1. Not Freeing Regex

```c
// WRONG - Memory leak
regex_t regex;
regcomp(&regex, pattern, REG_EXTENDED);
// Forgot regfree!

// CORRECT - Always free
regex_t regex;
regcomp(&regex, pattern, REG_EXTENDED);
regexec(&regex, text, ...);
regfree(&regex);
```

### 2. Ignoring Return Values

```c
// WRONG - Not checking 
regex_t regex;
regcomp(&regex, pattern, REG_EXTENDED);
// Might have failed!

// CORRECT - Check 
regex_t regex;
if (regcomp(&regex, pattern, REG_EXTENDED) != 0) {
    // Handle error
    return;
}
```

### 3. Greedy Matching

```c
// WRONG - Too greedy, matches too much
"<.*>"  // Matches entire "<a>test</a>" instead of "<a>"

// CORRECT - Use non-greedy or specific patterns
"<[^>]*>"  // Match anything except >
```

> **Note: Regular expressions are powerful but can be complex. Use them for simple to moderate pattern matching. For complex parsing, consider using dedicated parsers. Always compile regex once and reuse it. Don't forget to call regfree().
