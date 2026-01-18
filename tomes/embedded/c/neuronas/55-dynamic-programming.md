---
id: "c.algorithms.dynamic"
title: "Dynamic Programming"
category: c.algorithms.sorting
difficulty: advanced
tags: [c, c.algorithms.sorting, dynamic, dp, memoization]
keywords: [dynamic programming, dp, memoization, optimal substructure]
use_cases: [optimization, combinatorial problems, pathfinding]
prerequisites: ["c.algorithms.search"]
related: ["c.algorithms.graph"]
next_topics: ["c.algorithms.greedy"]
---

# Dynamic Programming

## Fibonacci - Naive Recursive

```c
#include <stdio.h>

int fibonacci_naive(int n) {
    if (n <= 1) {
        return n;
    }
    return fibonacci_naive(n - 1) + fibonacci_naive(n - 2);
}

int main() {
    int n = 10;
    printf("Fibonacci(%d) = %d\n", n, fibonacci_naive(n));
    return 0;
}
```

## Fibonacci - Memoization

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_N 100
#define UNKNOWN -1

int memo[MAX_N];

void init_memo(void) {
    for (int i = 0; i < MAX_N; i++) {
        memo[i] = UNKNOWN;
    }
}

int fibonacci_memo(int n) {
    if (n <= 1) {
        return n;
    }

    if (memo[n] != UNKNOWN) {
        return memo[n];
    }

    memo[n] = fibonacci_memo(n - 1) + fibonacci_memo(n - 2);
    return memo[n];
}

int main() {
    int n = 50;
    init_memo();
    printf("Fibonacci(%d) = %d\n", n, fibonacci_memo(n));
    return 0;
}
```

## Fibonacci - Bottom-Up DP

```c
#include <stdio.h>

int fibonacci_dp(int n) {
    if (n <= 1) {
        return n;
    }

    int* dp = malloc((n + 1) * sizeof(int));
    if (dp == NULL) {
        return -1;
    }

    dp[0] = 0;
    dp[1] = 1;

    for (int i = 2; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2];
    }

    int result = dp[n];
    free(dp);
    return result;
}

int main() {
    int n = 50;
    printf("Fibonacci(%d) = %d\n", n, fibonacci_dp(n));
    return 0;
}
```

## Longest Common Subsequence

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int lcs(const char* a, const char* b, int m, int n) {
    int** dp = malloc((m + 1) * sizeof(int*));

    for (int i = 0; i <= m; i++) {
        dp[i] = malloc((n + 1) * sizeof(int));
    }

    for (int i = 0; i <= m; i++) {
        for (int j = 0; j <= n; j++) {
            if (i == 0 || j == 0) {
                dp[i][j] = 0;
            } else if (a[i - 1] == b[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ?
                           dp[i - 1][j] : dp[i][j - 1];
            }
        }
    }

    int result = dp[m][n];

    for (int i = 0; i <= m; i++) {
        free(dp[i]);
    }
    free(dp);

    return result;
}

int main() {
    const char* a = "AGGTAB";
    const char* b = "GXTXAYB";

    int m = strlen(a);
    int n = strlen(b);

    printf("LCS length: %d\n", lcs(a, b, m, n));
    return 0;
}
```

## Coin Change Problem

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int coin_change(int* coins, int n, int amount) {
    int* dp = malloc((amount + 1) * sizeof(int));

    dp[0] = 0;
    for (int i = 1; i <= amount; i++) {
        dp[i] = INT_MAX;
    }

    for (int i = 1; i <= amount; i++) {
        for (int j = 0; j < n; j++) {
            if (coins[j] <= i && dp[i - coins[j]] != INT_MAX) {
                int new_count = dp[i - coins[j]] + 1;
                dp[i] = dp[i] < new_count ? dp[i] : new_count;
            }
        }
    }

    int result = dp[amount];
    free(dp);
    return result == INT_MAX ? -1 : result;
}

int main() {
    int coins[] = {1, 2, 5};
    int n = sizeof(coins) / sizeof(coins[0]);
    int amount = 11;

    int result = coin_change(coins, n, amount);
    printf("Minimum coins for %d: %d\n", amount, result);

    return 0;
}
```

## Knapsack Problem

```c
#include <stdio.h>
#include <stdlib.h>

int knapsack(int* weights, int* values, int n, int capacity) {
    int** dp = malloc((n + 1) * sizeof(int*));

    for (int i = 0; i <= n; i++) {
        dp[i] = malloc((capacity + 1) * sizeof(int));
    }

    for (int i = 0; i <= n; i++) {
        for (int w = 0; w <= capacity; w++) {
            if (i == 0 || w == 0) {
                dp[i][w] = 0;
            } else if (weights[i - 1] <= w) {
                int include = values[i - 1] + dp[i - 1][w - weights[i - 1]];
                int exclude = dp[i - 1][w];
                dp[i][w] = include > exclude ? include : exclude;
            } else {
                dp[i][w] = dp[i - 1][w];
            }
        }
    }

    int result = dp[n][capacity];

    for (int i = 0; i <= n; i++) {
        free(dp[i]);
    }
    free(dp);

    return result;
}

int main() {
    int weights[] = {1, 3, 4, 5};
    int values[] = {1, 4, 5, 7};
    int n = 4;
    int capacity = 7;

    int result = knapsack(weights, values, n, capacity);
    printf("Knapsack value: %d\n", result);

    return 0;
}
```

## Longest Increasing Subsequence

```c
#include <stdio.h>
#include <stdlib.h>

int lis(int* arr, int n) {
    int* dp = malloc(n * sizeof(int));

    for (int i = 0; i < n; i++) {
        dp[i] = 1;
    }

    for (int i = 1; i < n; i++) {
        for (int j = 0; j < i; j++) {
            if (arr[j] < arr[i] && dp[j] + 1 > dp[i]) {
                dp[i] = dp[j] + 1;
            }
        }
    }

    int result = 0;
    for (int i = 0; i < n; i++) {
        result = result > dp[i] ? result : dp[i];
    }

    free(dp);
    return result;
}

int main() {
    int arr[] = {10, 22, 9, 33, 21, 50, 41, 60};
    int n = sizeof(arr) / sizeof(arr[0]);

    printf("LIS length: %d\n", lis(arr, n));

    return 0;
}
```

## Edit Distance

```c
#include <stdio.h>
#include <stdlib.h>

int edit_distance(const char* a, const char* b) {
    int m = strlen(a);
    int n = strlen(b);

    int** dp = malloc((m + 1) * sizeof(int*));

    for (int i = 0; i <= m; i++) {
        dp[i] = malloc((n + 1) * sizeof(int));
    }

    for (int i = 0; i <= m; i++) {
        dp[i][0] = i;
    }

    for (int j = 0; j <= n; j++) {
        dp[0][j] = j;
    }

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (a[i - 1] == b[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1];
            } else {
                int insert = dp[i][j - 1] + 1;
                int delete = dp[i - 1][j] + 1;
                int replace = dp[i - 1][j - 1] + 1;

                dp[i][j] = insert < delete ? insert : delete;
                dp[i][j] = dp[i][j] < replace ? dp[i][j] : replace;
            }
        }
    }

    int result = dp[m][n];

    for (int i = 0; i <= m; i++) {
        free(dp[i]);
    }
    free(dp);

    return result;
}

int main() {
    const char* a = "kitten";
    const char* b = "sitting";

    printf("Edit distance: %d\n", edit_distance(a, b));

    return 0;
}
```

## Matrix Chain Multiplication

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int matrix_chain_order(int* p, int n) {
    int** m = malloc(n * sizeof(int*));
    int** s = malloc(n * sizeof(int*));

    for (int i = 0; i < n; i++) {
        m[i] = malloc(n * sizeof(int));
        s[i] = malloc(n * sizeof(int));
    }

    for (int i = 1; i < n; i++) {
        m[i][i] = 0;
    }

    for (int L = 2; L < n; L++) {
        for (int i = 1; i < n - L + 1; i++) {
            int j = i + L - 1;
            m[i][j] = INT_MAX;

            for (int k = i; k <= j - 1; k++) {
                int q = m[i][k] + m[k + 1][j] + p[i - 1] * p[k] * p[j];

                if (q < m[i][j]) {
                    m[i][j] = q;
                    s[i][j] = k;
                }
            }
        }
    }

    int result = m[1][n - 1];

    for (int i = 0; i < n; i++) {
        free(m[i]);
        free(s[i]);
    }
    free(m);
    free(s);

    return result;
}

int main() {
    int p[] = {10, 30, 5, 60};
    int n = 4;

    printf("Minimum multiplications: %d\n", matrix_chain_order(p, n));

    return 0;
}
```

## Partition Problem

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

bool find_partition(int* arr, int n, int sum1, int sum2, int pos) {
    if (pos == n) {
        return sum1 == sum2;
    }

    return find_partition(arr, n, sum1 + arr[pos], sum2, pos + 1) ||
           find_partition(arr, n, sum1, sum2 + arr[pos], pos + 1);
}

bool can_partition(int* arr, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }

    if (sum % 2 != 0) {
        return false;
    }

    return find_partition(arr, n, 0, 0, 0);
}

int main() {
    int arr[] = {1, 5, 11, 5};
    int n = sizeof(arr) / sizeof(arr[0]);

    if (can_partition(arr, n)) {
        printf("Can be partitioned\n");
    } else {
        printf("Cannot be partitioned\n");
    }

    return 0;
}
```

## Word Break Problem

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool word_break(const char* s, const char** dict, int dict_size) {
    int n = strlen(s);
    bool* dp = malloc((n + 1) * sizeof(bool));

    dp[0] = true;

    for (int i = 1; i <= n; i++) {
        dp[i] = false;

        for (int j = 0; j < i; j++) {
            if (!dp[j]) {
                continue;
            }

            int len = i - j;
            char word[len + 1];
            strncpy(word, s + j, len);
            word[len] = '\0';

            for (int k = 0; k < dict_size; k++) {
                if (strcmp(word, dict[k]) == 0) {
                    dp[i] = true;
                    break;
                }
            }

            if (dp[i]) {
                break;
            }
        }
    }

    bool result = dp[n];
    free(dp);
    return result;
}

int main() {
    const char* s = "leetcode";
    const char* dict[] = {"leet", "code"};
    int dict_size = 2;

    if (word_break(s, dict, dict_size)) {
        printf("Word can be segmented\n");
    } else {
        printf("Word cannot be segmented\n");
    }

    return 0;
}
```

> **Note**: DP reduces O(2^n) to O(n²) or O(n³). Key steps: 1) Define subproblems, 2) Build solution bottom-up, 3) Store results in table.
