---
id: "c.controlflow"
title: "Control Flow Statements"
category: language
difficulty: novice
tags: [c, if, else, switch, for, while, do-while, break, continue, goto]
keywords: [control-flow, conditional, branching, c.controlflow, iteration]
use_cases: [decision making, repetition, state machines]
prerequisites: []
related: ["c.functions"]
next_topics: []
---

# Control Flow Statements

C provides various control flow mechanisms for program logic.

## if-else Statement

```c
#include <stdio.h>

int main() {
    int x = 5;
    
    if (x > 10) {
        printf("Large\n");
    } else if (x > 0) {
        printf("Small\n");
    } else {
        printf("Zero or negative\n");
    }
    
    return 0;
}
```

## switch Statement

```c
#include <stdio.h>

int main() {
    int day = 3;
    
    switch (day) {
        case 1:
            printf("Monday\n");
            break;
        case 2:
            printf("Tuesday\n");
            break;
        case 3:
            printf("Wednesday\n");
            break;
        case 4:
            printf("Thursday\n");
            break;
        case 5:
            printf("Friday\n");
            break;
        default:
            printf("Weekend\n");
    }
    
    return 0;
}
```

## for Loop

```c
#include <stdio.h>

int main() {
    // Classic for loop
    for (int i = 0; i < 5; i++) {
        printf("%d\n", i);
    }
    
    // Multiple initializations and updates
    for (int i = 0, j = 10; i < 5 && j > 0; i++, j--) {
        printf("i=%d, j=%d\n", i, j);
    }
    
    return 0;
}
```

## while Loop

```c
#include <stdio.h>

int main() {
    int count = 0;
    
    while (count < 5) {
        printf("Count: %d\n", count);
        count++;
    }
    
    return 0;
}
```

## do-while Loop

```c
#include <stdio.h>

int main() {
    int sum = 0;
    int i = 0;
    
    // Executes at least once
    do {
        sum += i;
        i++;
    } while (i <= 5);
    
    printf("Sum: %d\n", sum);
    return 0;
}
```

## break Statement

```c
#include <stdio.h>

int main() {
    for (int i = 0; i < 10; i++) {
        if (i == 5) {
            break;  // Exit loop
        }
        printf("%d\n", i);
    }
    
    return 0;
}
```

## continue Statement

```c
#include <stdio.h>

int main() {
    for (int i = 0; i < 10; i++) {
        if (i % 2 == 0) {
            continue;  // Skip even numbers
        }
        printf("%d\n", i);
    }
    
    return 0;
}
```

## Nested c.controlflow

```c
#include <stdio.h>

int main() {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("i=%d, j=%d\n", i, j);
        }
    }
    
    return 0;
}
```

## Conditional Operator (Ternary)

```c
#include <stdio.h>

int main() {
    int x = 5;
    int y = 10;
    
    // Conditional expression
    int max = (x > y) ? x : y;
    printf("Max: %d\n", max);
    
    return 0;
}
```

## goto Statement

```c
#include <stdio.h>

int main() {
    int x = 0;
    
    // Label for goto
    start:
    
    if (x < 5) {
        x++;
        goto start;  // Loop using goto
    }
    
    printf("Final: %d\n", x);
    return 0;
}
```

## Logical c.controlflow

```c
#include <stdio.h>

int main() {
    int a = 5;
    int b = 10;
    int c = 15;
    
    // Logical AND (&&)
    if (a > 0 && b > 0 && c > 0) {
        printf("All positive\n");
    }
    
    // Logical OR (||)
    if (a > 10 || b > 10 || c > 10) {
        printf("Some > 10\n");
    }
    
    // Logical NOT (!)
    if (!(a == b)) {
        printf("Not equal\n");
    }
    
    return 0;
}
```

## Loop Control Variants

```c
#include <stdio.h>

int main() {
    int i = 0;
    
    // for loop with multiple conditions
    for (; i < 10 && i < 5; i++) {
        printf("%d\n", i);
    }
    
    // while loop with break condition
    int sum = 0;
    while (true) {
        sum += i;
        if (sum >= 50) break;
        i++;
    }
    
    printf("Sum: %d\n", sum);
    return 0;
}
```

## Common Patterns

### Count items

```c
#include <stdio.h>

int main() {
    int count = 0;
    
    for (int i = 0; i < 10; i++) {
        count++;
    }
    
    printf("Count: %d\n", count);
    return 0;
}
```

### Find maximum

```c
#include <stdio.h>

int main() {
    int numbers[] = {5, 3, 8, 1, 9};
    int max = numbers[0];
    
    for (int i = 1; i < 5; i++) {
        if (numbers[i] > max) {
            max = numbers[i];
        }
    }
    
    printf("Max: %d\n", max);
    return 0;
}
```

### Early exit from c.controlflow

```c
#include <stdio.h>

int main() {
    for (int i = 0; i < 10; i++) {
        if (i == 5) {
            break;  // Early exit
        }
        printf("%d\n", i);
    }
    
    printf("Exited early\n");
    return 0;
}
```

### Infinite loop with break

```c
#include <stdio.h>

int main() {
    int count = 0;
    
    while (true) {
        count++;
        printf("Count: %d\n", count);
        
        if (count >= 10) {
            break;  // Exit infinite loop
        }
    }
    
    return 0;
}
```

### Switch with range

```c
#include <stdio.h>

int main() {
    int score = 85;
    
    // Switch with fall-through
    switch (score / 10) {
        case 0 ... 5:
            printf("F\n");
            break;
        case 6 ... 8:
            printf("D\n");
            break;
        case 9 ... 10:
            printf("A\n");
            break;
        default:
            printf("E\n");
    }
    
    return 0;
}
```

> **Note**: Prefer structured control flow (if-else) over nested if-else chains. Use switch for multi-way branches with integer or enum values.
