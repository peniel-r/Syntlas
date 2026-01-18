---
id: "c.stdlib.stdbool"
title: "Boolean Operations"
category: stdlib
difficulty: novice
tags: [c, stdlib, stdbool, true, false, bool]
keywords: [stdbool, true, false, and, or, not]
use_cases: [boolean logic, bit manipulation, truth tables]
prerequisites: []
related: []
next_topics: ["c.stdlib.math"]
---

# Boolean Operations

C99+ introduced <stdbool.h> for boolean type.

## Boolean Values

```c
#include <stdbool.h>
#include <stdio.h>

int main() {
    // Boolean values
    bool flag1 = true;
    bool flag2 = false;
    
    // Comparisons
    if (flag1 == true) {
        printf("flag1 is true\n");
    }
    
    if (flag1 != flag2) {
        printf("flag1 != flag2\n");
    }
    
    // Logical operations
    bool result_and = flag1 && flag2;
    bool result_or = flag1 || flag2;
    bool result_not = !flag1;
    bool result_xor = flag1 ^ flag2;
    bool result_and_not = !(flag1 && flag2);
    bool result_or_not = flag1 || !flag2;
    
    printf("AND: %s\n", result_and ? "true" : "false");
    printf("OR: %s\n", result_or ? "true" : "false");
    printf("NOT: %s\n", result_not ? "true" : "false");
    printf("XOR: %s\n", result_xor ? "true" : "false");
    printf("NAND: %s\n", result_and_not ? "true" : "false");
    
    return 0;
}
```

## Boolean Conversions

```c
#include <stdbool.h>

int main() {
    int value = 42;
    
    // Integer to boolean
    bool is_positive = (value > 0);
    bool is_zero = (value == 0);
    bool is_even = (value % 2 == 0);
    bool is_odd = (value % 2 != 0);
    
    printf("Positive: %s\n", is_positive ? "true" : "false");
    printf("Zero: %s\n", is_zero ? "true" : "false");
    printf("Even: %s\n", is_even ? "true" : "false");
    printf("Odd: %s\n", is_odd ? "true" : "false");
}
    
    // Pointer to boolean
    int* ptr = &value;
    bool is_null = (ptr == NULL);
    
    printf("Pointer is null: %s\n", is_null ? "true" : "false");
    
    // Note: In C, any non-zero integer is true when converted to bool
    return 0;
}
```

## Boolean Arrays and Tables

```c
#include <stdbool.h>
#include <stdio.h>

// Truth table for AND operation
bool and_table[][2] = {
    {false, false}, {false, true}, {true},
    {false, true}, {true, false}, {true, true}, {false, true}
};

int main() {
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            printf("%s AND %s = %s\n",
                and_table[i][j] ? "true" : "false",
                and_table[i][j] ? "true" : "false",
                and_table[i][j] ? "true" : "false");
        }
    }
    
    return 0;
}
```

## Logical Operations on Booleans

```c
#include <stdbool.h>

int main() {
    bool a = true;
    bool b = false;
    
    // NOT operation (logical negation)
    bool not_a = !a;  // false
    bool not_b = !b;  // true
    
    // XOR operation (logical exclusive-or)
    bool xor_ab = a ^ b;  // true
    bool xor_ba = b ^ a;  // true
    
    // NAND operation
    bool nand_ab = !(a && b);  // true
    bool nand_ba = !(b && a);  // true
    
    printf("NOT A: %s\n", not_a ? "true" : "false");
    printf("NOT B: %s\n", not_b ? "true" : "false");
    printf("NAND A&B: %s\n", nand_ab ? "true" : "false");
    printf("NAND B&A: %s\n", nand_ba ? "true" : "false");
    
    // NOR operation (logical neither)
    bool nor_ab = !(a || b);  // false
    bool nor_ba = !(b || a);  // true
    
    printf("NOR A: %s\n", nor_ab ? "true" : "false");
    printf("NOR B: %s\n", nor_ba ? "true" : "false");
    
    printf("NOR A&B: %s\n", nor_ab ? "true" : "false");
    
    return 0;
}
```

## Boolean with Bit Fields

```c
#include <stdbool.h>

// Bit field structure
typedef struct {
    unsigned int has_flag1 : 1;
    unsigned int has_flag2 : 1;
    unsigned int has_flag3 : 1;
    unsigned int has_flag4 : 1;
    unsigned int has_flag5 : 1;
    unsigned int has_flag6 : 1;
    unsigned int has_flag7 : 1;
    unsigned int has_flag8 : 1;
} Flags;

void test_bit_flags() {
    Flags flags = {0};
    
    flags.has_flag1 = 1;
    flags.has_flag2 = 1;
    flags.has_flag3 = 1;
    
    printf("Flag 1: %s\n", flags.has_flag1 ? "set" : "clear");
    printf("Flag 2: %s\n", flags.has_flag2 ? "set" : "clear");
    printf("Flag 3: %s\n", flags.has_flag3 ? "set" : "clear");
    
    // Test if any flag set
    if (flags.has_flag1 || flags.has_flag2 || flags.has_flag3) {
        printf("Some flags are set\n");
    } else {
        printf("No flags are set\n");
    }
}
```

## Boolean in Conditional Expressions

```c
#include <stdbool.h>

int main() {
    int value = 5;
    
    // Boolean in if statement
    if (value > 0 && value < 10) {
        printf("Value is between 1 and 9\n");
    }
    
    // Boolean in ternary operator
    const char* message = value > 0 ? "Positive" : "Non-positive";
    printf("%d is %s\n", value, message);
    
    // Boolean in loop
    for (int i = 0; i < 10; i++) {
        bool condition = i % 3 == 0 || i % 5 == 1;
        printf("i=%d: condition=%s\n", i, condition ? "true" : "false");
    }
}
```

> **Note**: Use <stdbool.h> and bool type for clear boolean semantics. Avoid integer representations of true/false.
