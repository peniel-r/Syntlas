---
id: 70-string-algorithms
title: String Algorithms
category: algorithms
difficulty: intermediate
tags:
  - string
  - algorithm
  - search
  - manipulation
keywords:
  - substring search
  - pattern matching
  - string matching
  - KMP
  - Boyer-Moore
use_cases:
  - Text processing
  - Pattern searching
  - String manipulation
  - Text analysis
prerequisites:
  - arrays
  - pointers
  - loops
related:
  - string-functions
  - search-algorithms
next_topics:
  - data-structures
---

# String Algorithms

String algorithms are essential for text processing, pattern matching, and string manipulation tasks.

## Naive String Search

```c
#include <stdio.h>
#include <string.h>

// Simple O(n*m) substring search
int naive_search(const char *text, const char *pattern) {
    int n = strlen(text);
    int m = strlen(pattern);

    for (int i = 0; i <= n - m; i++) {
        int j;
        for (j = 0; j < m; j++) {
            if (text[i + j] != pattern[j])
                break;
        }
        if (j == m) {
            return i;  // Found at position i
        }
    }
    return -1;  // Not found
}

int main(void) {
    const char *text = "hello world, welcome to C";
    const char *pattern = "world";

    int pos = naive_search(text, pattern);
    if (pos >= 0) {
        printf("Pattern found at position: %d\n", pos);
    } else {
        printf("Pattern not found\n");
    }

    return 0;
}
```

## Knuth-Morris-Pratt (KMP) Algorithm

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Build LPS (Longest Prefix Suffix) array
void compute_lps(const char *pattern, int *lps) {
    int len = 0;
    int i = 1;
    int m = strlen(pattern);
    lps[0] = 0;

    while (i < m) {
        if (pattern[i] == pattern[len]) {
            len++;
            lps[i] = len;
            i++;
        } else {
            if (len != 0) {
                len = lps[len - 1];
            } else {
                lps[i] = 0;
                i++;
            }
        }
    }
}

// KMP search - O(n + m)
int kmp_search(const char *text, const char *pattern) {
    int n = strlen(text);
    int m = strlen(pattern);

    int *lps = malloc(m * sizeof(int));
    compute_lps(pattern, lps);

    int i = 0, j = 0;
    while (i < n) {
        if (pattern[j] == text[i]) {
            i++;
            j++;
        }

        if (j == m) {
            free(lps);
            return i - j;  // Found
        } else if (i < n && pattern[j] != text[i]) {
            if (j != 0) {
                j = lps[j - 1];
            } else {
                i++;
            }
        }
    }

    free(lps);
    return -1;
}

int main(void) {
    const char *text = "ABABDABACDABABCABAB";
    const char *pattern = "ABABCABAB";

    int pos = kmp_search(text, pattern);
    printf("KMP: Pattern found at position: %d\n", pos);

    return 0;
}
```

## Boyer-Moore Algorithm (Simplified)

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#define ALPHABET_SIZE 256

void compute_bad_char(const char *pattern, int *bad_char) {
    int m = strlen(pattern);

    // Initialize all occurrences as -1
    for (int i = 0; i < ALPHABET_SIZE; i++) {
        bad_char[i] = -1;
    }

    // Fill actual value of last occurrence
    for (int i = 0; i < m; i++) {
        bad_char[(int)pattern[i]] = i;
    }
}

int boyer_moore_search(const char *text, const char *pattern) {
    int n = strlen(text);
    int m = strlen(pattern);

    int *bad_char = malloc(ALPHABET_SIZE * sizeof(int));
    compute_bad_char(pattern, bad_char);

    int s = 0;  // Shift of pattern with respect to text
    while (s <= (n - m)) {
        int j = m - 1;

        // Keep reducing index while pattern and text match
        while (j >= 0 && pattern[j] == text[s + j]) {
            j--;
        }

        if (j < 0) {
            free(bad_char);
            return s;  // Pattern found
        } else {
            // Shift pattern based on bad character rule
            s += (j - bad_char[(int)text[s + j]] > 1) ?
                 j - bad_char[(int)text[s + j]] : 1;
        }
    }

    free(bad_char);
    return -1;
}

int main(void) {
    const char *text = "THIS IS A TEST TEXT";
    const char *pattern = "TEST";

    int pos = boyer_moore_search(text, pattern);
    printf("Boyer-Moore: Pattern found at position: %d\n", pos);

    return 0;
}
```

## String Palindrome Check

```c
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool is_palindrome(const char *str) {
    int left = 0;
    int right = strlen(str) - 1;

    while (left < right) {
        // Skip non-alphanumeric
        while (left < right && !isalnum(str[left])) left++;
        while (left < right && !isalnum(str[right])) right--;

        // Compare (case-insensitive)
        if (tolower(str[left]) != tolower(str[right])) {
            return false;
        }

        left++;
        right--;
    }
    return true;
}

int main(void) {
    const char *tests[] = {
        "racecar",
        "A man, a plan, a canal: Panama",
        "hello",
        ""
    };

    for (int i = 0; i < 4; i++) {
        printf("\"%s\" is %s\n", tests[i],
               is_palindrome(tests[i]) ? "palindrome" : "not palindrome");
    }

    return 0;
}
```

## Longest Common Subsequence

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int lcs(const char *s1, const char *s2) {
    int m = strlen(s1);
    int n = strlen(s2);

    int **dp = malloc((m + 1) * sizeof(int *));
    for (int i = 0; i <= m; i++) {
        dp[i] = malloc((n + 1) * sizeof(int));
    }

    // Build DP table
    for (int i = 0; i <= m; i++) {
        for (int j = 0; j <= n; j++) {
            if (i == 0 || j == 0) {
                dp[i][j] = 0;
            } else if (s1[i - 1] == s2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = (dp[i - 1][j] > dp[i][j - 1]) ?
                           dp[i - 1][j] : dp[i][j - 1];
            }
        }
    }

    int result = dp[m][n];

    // Cleanup
    for (int i = 0; i <= m; i++) {
        free(dp[i]);
    }
    free(dp);

    return result;
}

int main(void) {
    const char *s1 = "AGGTAB";
    const char *s2 = "GXTXAYB";

    printf("LCS length: %d\n", lcs(s1, s2));
    // Output: LCS length: 4 (GTAB)

    return 0;
}
```

## String Compression

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *compress_string(const char *str) {
    if (str == NULL) return NULL;

    int len = strlen(str);
    char *result = malloc(2 * len * sizeof(char));
    int result_index = 0;

    for (int i = 0; i < len; ) {
        char current = str[i];
        int count = 0;

        // Count consecutive occurrences
        while (i < len && str[i] == current) {
            count++;
            i++;
        }

        // Append character and count
        result[result_index++] = current;
        result_index += sprintf(&result[result_index], "%d", count);
    }

    result[result_index] = '\0';
    return result;
}

int main(void) {
    const char *original = "aaabccccdd";
    char *compressed = compress_string(original);

    printf("Original: %s\n", original);
    printf("Compressed: %s\n", compressed);

    free(compressed);
    return 0;
}
```

## Levenshtein Distance (Edit Distance)

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int min(int a, int b, int c) {
    return (a < b) ? ((a < c) ? a : c) : ((b < c) ? b : c);
}

int levenshtein_distance(const char *s1, const char *s2) {
    int m = strlen(s1);
    int n = strlen(s2);

    int **dp = malloc((m + 1) * sizeof(int *));
    for (int i = 0; i <= m; i++) {
        dp[i] = malloc((n + 1) * sizeof(int));
    }

    // Initialize base cases
    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;

    // Fill DP table
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (s1[i - 1] == s2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1];
            } else {
                dp[i][j] = 1 + min(
                    dp[i - 1][j],      // deletion
                    dp[i][j - 1],      // insertion
                    dp[i - 1][j - 1]   // substitution
                );
            }
        }
    }

    int result = dp[m][n];

    // Cleanup
    for (int i = 0; i <= m; i++) free(dp[i]);
    free(dp);

    return result;
}

int main(void) {
    const char *s1 = "kitten";
    const char *s2 = "sitting";

    printf("Edit distance: %d\n", levenshtein_distance(s1, s2));
    // Output: Edit distance: 3

    return 0;
}
```

## String Tokenizer (Enhanced)

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

char **tokenize_string(const char *str, const char *delimiters, int *count) {
    if (str == NULL || delimiters == NULL) {
        *count = 0;
        return NULL;
    }

    // Make a copy of the string
    char *copy = strdup(str);
    if (copy == NULL) {
        *count = 0;
        return NULL;
    }

    // First pass: count tokens
    int token_count = 0;
    char *temp = copy;
    char *token = strtok(temp, delimiters);
    while (token != NULL) {
        token_count++;
        token = strtok(NULL, delimiters);
    }

    // Allocate token array
    char **tokens = malloc(token_count * sizeof(char *));
    if (tokens == NULL) {
        free(copy);
        *count = 0;
        return NULL;
    }

    // Second pass: store tokens
    strcpy(copy, str);  // Reset copy
    temp = copy;
    int i = 0;
    token = strtok(temp, delimiters);
    while (token != NULL && i < token_count) {
        tokens[i] = strdup(token);
        if (tokens[i] == NULL) {
            // Cleanup on failure
            for (int j = 0; j < i; j++) free(tokens[j]);
            free(tokens);
            free(copy);
            *count = 0;
            return NULL;
        }
        i++;
        token = strtok(NULL, delimiters);
    }

    free(copy);
    *count = token_count;
    return tokens;
}

void free_tokens(char **tokens, int count) {
    if (tokens == NULL) return;
    for (int i = 0; i < count; i++) {
        free(tokens[i]);
    }
    free(tokens);
}

int main(void) {
    const char *text = "hello,world,this,is,a,test";
    int count;
    char **tokens = tokenize_string(text, ",", &count);

    printf("Found %d tokens:\n", count);
    for (int i = 0; i < count; i++) {
        printf("  %d: %s\n", i + 1, tokens[i]);
    }

    free_tokens(tokens, count);
    return 0;
}
```

## Performance Comparison

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// ... include all search functions from above ...

#define TEXT_LEN 1000000
#define PATTERN_LEN 10

int main(void) {
    // Generate random text
    char *text = malloc(TEXT_LEN + 1);
    for (int i = 0; i < TEXT_LEN; i++) {
        text[i] = 'a' + rand() % 26;
    }
    text[TEXT_LEN] = '\0';

    // Insert pattern
    const char *pattern = "testpattern";
    strcpy(text + TEXT_LEN / 2, pattern);

    // Time naive search
    clock_t start = clock();
    int pos = naive_search(text, pattern);
    clock_t end = clock();
    printf("Naive: %f seconds (found at %d)\n",
           (double)(end - start) / CLOCKS_PER_SEC, pos);

    // Time KMP search
    start = clock();
    pos = kmp_search(text, pattern);
    end = clock();
    printf("KMP: %f seconds (found at %d)\n",
           (double)(end - start) / CLOCKS_PER_SEC, pos);

    // Time Boyer-Moore search
    start = clock();
    pos = boyer_moore_search(text, pattern);
    end = clock();
    printf("Boyer-Moore: %f seconds (found at %d)\n",
           (double)(end - start) / CLOCKS_PER_SEC, pos);

    free(text);
    return 0;
}
```

## Best Practices

### Choose the Right Algorithm

```c
// For small patterns/text, use naive search (simple)
if (strlen(pattern) < 10 && strlen(text) < 1000) {
    pos = naive_search(text, pattern);
}
// For larger texts, use KMP
else {
    pos = kmp_search(text, pattern);
}

// For alphabets with many characters, use Boyer-Moore
if (has_large_alphabet) {
    pos = boyer_moore_search(text, pattern);
}
```

### Handle Edge Cases

```c
// Always check for NULL and empty strings
int search_string(const char *text, const char *pattern) {
    if (text == NULL || pattern == NULL) return -1;
    if (pattern[0] == '\0') return 0;  // Empty pattern matches start
    if (text[0] == '\0') return -1;     // Non-empty pattern in empty text

    return kmp_search(text, pattern);
}
```

> **Note**: String algorithms can have significant performance differences based on input size and characteristics. KMP is good for repeated searches with the same pattern (precompute LPS once). Boyer-Moore performs best when the alphabet is large and pattern has good character skipping potential.
