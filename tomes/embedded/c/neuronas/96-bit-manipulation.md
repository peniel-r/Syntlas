---
id: 96-bit-manipulation
title: Bit Manipulation
category: algorithms
difficulty: intermediate
tags:
  - bitwise
  - bit-operations
  - binary
keywords:
  - bitwise
  - bit manipulation
  - binary operations
  - flags
use_cases:
  - Flag management
  - Compression
  - Cryptography
  - Embedded systems
prerequisites:
  - operators
  - integers
related:
  - structs-unions
  - macros
next_topics:
  - endianness
---

# Bit Manipulation

Bit manipulation allows efficient storage and processing of boolean flags and data.

## Basic Bit Operations

```c
#include <stdio.h>

int main(void) {
    unsigned int x = 5;  // Binary: 0101

    // Bitwise AND (&)
    unsigned int and_result = x & 3;  // 0101 & 0011 = 0001 (1)
    printf("5 & 3 = %u\n", and_result);

    // Bitwise OR (|)
    unsigned int or_result = x | 3;  // 0101 | 0011 = 0111 (7)
    printf("5 | 3 = %u\n", or_result);

    // Bitwise XOR (^)
    unsigned int xor_result = x ^ 3;  // 0101 ^ 0011 = 0110 (6)
    printf("5 ^ 3 = %u\n", xor_result);

    // Bitwise NOT (~)
    unsigned int not_result = ~x;  // ~0101 = 1010... (assuming 8 bits)
    printf("~5 = %u\n", not_result);

    // Left shift (<<)
    unsigned int left_shift = x << 2;  // 0101 << 2 = 010100 (20)
    printf("5 << 2 = %u\n", left_shift);

    // Right shift (>>)
    unsigned int right_shift = x >> 1;  // 0101 >> 1 = 0010 (2)
    printf("5 >> 1 = %u\n", right_shift);

    return 0;
}
```

## Setting, Clearing, Toggling Bits

```c
#include <stdio.h>

// Set bit at position n
unsigned int set_bit(unsigned int num, int n) {
    return num | (1U << n);
}

// Clear bit at position n
unsigned int clear_bit(unsigned int num, int n) {
    return num & ~(1U << n);
}

// Toggle bit at position n
unsigned int toggle_bit(unsigned int num, int n) {
    return num ^ (1U << n);
}

// Check if bit at position n is set
int is_bit_set(unsigned int num, int n) {
    return (num & (1U << n)) != 0;
}

int main(void) {
    unsigned int num = 5;  // Binary: 0101

    printf("Original: %u (binary: ", num);
    for (int i = 7; i >= 0; i--) {
        printf("%d", (num >> i) & 1);
    }
    printf(")\n");

    num = set_bit(num, 1);  // Set bit 1
    printf("After setting bit 1: %u\n", num);

    num = clear_bit(num, 0);  // Clear bit 0
    printf("After clearing bit 0: %u\n", num);

    num = toggle_bit(num, 2);  // Toggle bit 2
    printf("After toggling bit 2: %u\n", num);

    printf("Bit 3 is set: %s\n", is_bit_set(num, 3) ? "yes" : "no");

    return 0;
}
```

## Counting Set Bits (Population Count)

```c
#include <stdio.h>

int count_set_bits(unsigned int num) {
    int count = 0;
    while (num) {
        count += num & 1;
        num >>= 1;
    }
    return count;
}

int count_set_bits_optimized(unsigned int num) {
    int count = 0;
    while (num) {
        num &= (num - 1);  // Clear the least significant set bit
        count++;
    }
    return count;
}

int main(void) {
    unsigned int num = 15;  // Binary: 1111

    printf("Number: %u\n", num);
    printf("Set bits: %d\n", count_set_bits(num));
    printf("Set bits (optimized): %d\n", count_set_bits_optimized(num));

    return 0;
}
```

## Swapping Values Without Temporary

```c
#include <stdio.h>

void swap_xor(int *a, int *b) {
    if (a == b) return;  // Avoid XOR with same variable

    *a ^= *b;
    *b ^= *a;
    *a ^= *b;
}

void swap_arithmetic(int *a, int *b) {
    *a = *a + *b;
    *b = *a - *b;
    *a = *a - *b;
}

int main(void) {
    int x = 5, y = 10;

    printf("Before swap: x = %d, y = %d\n", x, y);
    swap_xor(&x, &y);
    printf("After XOR swap: x = %d, y = %d\n", x, y);

    swap_arithmetic(&x, &y);
    printf("After arithmetic swap: x = %d, y = %d\n", x, y);

    return 0;
}
```

## Finding Power of Two

```c
#include <stdio.h>
#include <stdbool.h>

// Check if number is power of 2
bool is_power_of_two(unsigned int num) {
    return num != 0 && (num & (num - 1)) == 0;
}

// Get next power of 2
unsigned int next_power_of_two(unsigned int num) {
    if (num == 0) return 1;

    num--;
    num |= num >> 1;
    num |= num >> 2;
    num |= num >> 4;
    num |= num >> 8;
    num |= num >> 16;
    num++;

    return num;
}

int main(void) {
    unsigned int numbers[] = {1, 2, 3, 4, 5, 8, 16, 31, 32};

    for (int i = 0; i < 9; i++) {
        unsigned int num = numbers[i];
        printf("%u: Power of 2? %s", num, is_power_of_two(num) ? "yes" : "no");
        printf(", Next power of 2: %u\n", next_power_of_two(num));
    }

    return 0;
}
```

## Bit Fields

```c
#include <stdio.h>
#include <stdint.h>

typedef struct {
    unsigned int flag1 : 1;
    unsigned int flag2 : 1;
    unsigned int flag3 : 1;
    unsigned int flag4 : 1;
    unsigned int value : 4;
    unsigned int reserved : 24;
} BitFieldStruct;

int main(void) {
    BitFieldStruct bits = {0};

    bits.flag1 = 1;
    bits.flag2 = 0;
    bits.flag3 = 1;
    bits.flag4 = 0;
    bits.value = 7;

    printf("Size: %zu bytes\n", sizeof(BitFieldStruct));
    printf("flag1: %d\n", bits.flag1);
    printf("flag2: %d\n", bits.flag2);
    printf("flag3: %d\n", bits.flag3);
    printf("flag4: %d\n", bits.flag4);
    printf("value: %d\n", bits.value);

    return 0;
}
```

## Rotating Bits

```c
#include <stdio.h>
#include <stdint.h>

// Rotate left
uint32_t rotate_left(uint32_t num, int n) {
    n %= 32;
    return (num << n) | (num >> (32 - n));
}

// Rotate right
uint32_t rotate_right(uint32_t num, int n) {
    n %= 32;
    return (num >> n) | (num << (32 - n));
}

int main(void) {
    uint32_t num = 0x12345678;

    printf("Original: 0x%08X\n", num);
    printf("Rotate left 4: 0x%08X\n", rotate_left(num, 4));
    printf("Rotate right 4: 0x%08X\n", rotate_right(num, 4));

    return 0;
}
```

## Extracting and Inserting Bits

```c
#include <stdio.h>
#include <stdint.h>

// Extract bits from position start with length len
uint32_t extract_bits(uint32_t num, int start, int len) {
    uint32_t mask = (1U << len) - 1;
    return (num >> start) & mask;
}

// Insert bits into number at position start with length len
uint32_t insert_bits(uint32_t num, uint32_t value, int start, int len) {
    uint32_t mask = ((1U << len) - 1) << start;
    num &= ~mask;  // Clear bits
    num |= ((value & ((1U << len) - 1)) << start);
    return num;
}

int main(void) {
    uint32_t num = 0x12345678;

    printf("Original: 0x%08X\n", num);

    // Extract bits 8-15
    uint32_t extracted = extract_bits(num, 8, 8);
    printf("Extracted (bits 8-15): 0x%02X\n", extracted);

    // Insert value at bits 16-23
    uint32_t inserted = insert_bits(num, 0xAB, 16, 8);
    printf("Inserted 0xAB at bits 16-23: 0x%08X\n", inserted);

    return 0;
}
```

## Best Practices

### Use Unsigned for Bit Operations

```c
// GOOD - Use unsigned for bit operations
unsigned int flags = 0;

// BAD - Signed can cause issues with shifts
int flags = 0;
```

### Use Named Constants for Bit Positions

```c
// GOOD - Named constants
#define FLAG_A (1U << 0)
#define FLAG_B (1U << 1)
#define FLAG_C (1U << 2)

if (flags & FLAG_A) {
    // Handle flag A
}

// BAD - Magic numbers
if (flags & 1) {
    // Handle flag
}
```

### Clear Properly

```c
// GOOD - Clear specific bit
flags &= ~(1U << position);

// BAD - Using subtraction
flags -= (1U << position);  // Can underflow
```

## Common Pitfalls

### 1. Shift Beyond Size

```c
// WRONG - Undefined behavior
unsigned int x = 1;
x << 32;  // Undefined for 32-bit int

// CORRECT - Mask shift amount
x << (32 & 31);
```

### 2. Signed Bit Shifts

```c
// WRONG - Signed right shift
int x = -1;
x >> 1;  // Implementation-defined behavior

// CORRECT - Use unsigned
unsigned int x = 0xFFFFFFFF;
x >> 1;  // Well-defined
```

### 3. Operator Precedence

```c
// WRONG - Precedence issues
result = x & 1 << 2;  // Same as x & (1 << 2)

// CORRECT - Use parentheses
result = (x & 1) << 2;
```

> **Note: Bit manipulation is powerful but error-prone. Always use unsigned integers for bit operations. Be aware of undefined behavior (shifting beyond size, signed shifts). Use named constants for clarity.
