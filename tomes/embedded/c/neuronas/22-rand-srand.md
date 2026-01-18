---
id: "c.stdlib.rand"
title: "Random Number Generation (rand, srand)"
category: stdlib
difficulty: beginner
tags: [c, stdlib, rand, srand, random, seeding]
keywords: [rand, srand, random, seed, pseudo-random]
use_cases: [simulations, games, testing, cryptography]
prerequisites: ["c.stdlib.atoi"]
related: ["c.stdlib.time"]
next_topics: ["c.stdlib.qsort"]
---

# Random Number Generation

## rand - Basic Random Number

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Generate random numbers in range [0, RAND_MAX]
    for (int i = 0; i < 10; i++) {
        printf("%d\n", rand());
    }

    return 0;
}
```

## srand - Seed the Generator

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    // Seed with current time
    srand((unsigned int)time(NULL));

    // Generate random numbers
    for (int i = 0; i < 10; i++) {
        printf("%d\n", rand());
    }

    return 0;
}
```

## Random in Range

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int random_in_range(int min, int max) {
    return min + rand() % (max - min + 1);
}

int main() {
    srand((unsigned int)time(NULL));

    // Random numbers 1-6 (dice roll)
    for (int i = 0; i < 10; i++) {
        int dice = random_in_range(1, 6);
        printf("Roll %d: %d\n", i + 1, dice);
    }

    return 0;
}
```

## Random Float

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

double random_double(void) {
    return (double)rand() / RAND_MAX;
}

int main() {
    srand((unsigned int)time(NULL));

    // Random doubles [0.0, 1.0]
    for (int i = 0; i < 5; i++) {
        printf("%f\n", random_double());
    }

    return 0;
}
```

## Shuffle Array

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void shuffle(int* arr, size_t size) {
    // Fisher-Yates shuffle
    for (size_t i = size - 1; i > 0; i--) {
        size_t j = rand() % (i + 1);
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}

int main() {
    srand((unsigned int)time(NULL));

    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    printf("Original: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    shuffle(numbers, size);

    printf("Shuffled: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Random Selec.stdlib.stdion

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

const char* get_random_item(const char* items[], size_t count) {
    size_t index = rand() % count;
    return items[index];
}

int main() {
    srand((unsigned int)time(NULL));

    const char* fruits[] = {"apple", "banana", "cherry", "date", "elderberry"};
    size_t count = sizeof(fruits) / sizeof(fruits[0]);

    for (int i = 0; i < 5; i++) {
        const char* fruit = get_random_item(fruits, count);
        printf("Random fruit: %s\n", fruit);
    }

    return 0;
}
```

## Random Password Generator

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

void generate_password(char* password, size_t length) {
    const char charset[] = "abcdefghijklmnopqrstuvwxyz"
                          "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                          "0123456789"
                          "!@#$%^&*()";

    size_t charset_size = strlen(charset);

    for (size_t i = 0; i < length; i++) {
        password[i] = charset[rand() % charset_size];
    }
    password[length] = '\0';
}

int main() {
    srand((unsigned int)time(NULL));

    char password[16];
    generate_password(password, 15);

    printf("Generated password: %s\n", password);

    return 0;
}
```

## Monte Carlo Pi Estimation

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

double estimate_pi(int samples) {
    int inside = 0;

    for (int i = 0; i < samples; i++) {
        double x = (double)rand() / RAND_MAX;
        double y = (double)rand() / RAND_MAX;

        if (x * x + y * y <= 1.0) {
            inside++;
        }
    }

    return 4.0 * inside / samples;
}

int main() {
    srand((unsigned int)time(NULL));

    int samples[] = {1000, 10000, 100000, 1000000};

    for (int i = 0; i < 4; i++) {
        double pi = estimate_pi(samples[i]);
        printf("%d samples: %.6f\n", samples[i], pi);
    }

    return 0;
}
```

## Weighted Random Choice

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct {
    const char* name;
    int weight;
} WeightedItem;

const char* weighted_random(WeightedItem* items, size_t count) {
    int total_weight = 0;

    for (size_t i = 0; i < count; i++) {
        total_weight += items[i].weight;
    }

    int random = rand() % total_weight;
    int cumulative = 0;

    for (size_t i = 0; i < count; i++) {
        cumulative += items[i].weight;
        if (random < cumulative) {
            return items[i].name;
        }
    }

    return items[count - 1].name;
}

int main() {
    srand((unsigned int)time(NULL));

    WeightedItem items[] = {
        {"Common", 50},
        {"Uncommon", 30},
        {"Rare", 15},
        {"Legendary", 5}
    };

    for (int i = 0; i < 10; i++) {
        const char* result = weighted_random(items, 4);
        printf("Got: %s\n", result);
    }

    return 0;
}
```

> **Note**: `rand()` is not suitable for cryptographic purposes. Use OS-provided CSPRNG for security applications.
