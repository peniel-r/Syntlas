---
id: "c.inline-asm"
title: "Inline Assembly"
category: language
difficulty: expert
tags: [c, assembly, inline-asm, optimization, low-level]
keywords: [asm, __asm__, inline, registers, optimization]
use_cases: [optimization, hardware access, intrinsics]
prerequisites: []
related: []
next_topics: []
---

# Inline Assembly

Inline assembly embeds assembly code in C functions.

## Basic Syntax

```c
// GCC/Clang syntax
asm volatile (
    "assembly code"
    : output operands   /* optional */
    : input operands    /* optional */
    : clobbers         /* optional */
);
```

## Simple Assembly

```c
// Read time stamp counter
uint64_t rdtsc() {
    unsigned int hi, lo;
    __asm__ volatile (
        "rdtsc"
        : "=a" (lo), "=d" (hi)
    );
    return ((uint64_t)hi << 32) | lo;
}
```

## Input and Output Operands

```c
// Add two numbers
int asm_add(int a, int b) {
    int result;
    __asm__ (
        "addl %1, %0"  // result += b
        : "=r" (result)  // Output
        : "0" (a), "r" (b)  // Inputs
    );
    return result;
}

// Usage
int sum = asm_add(10, 20);  // sum = 30
```

## Constraints

```c
int value = 42;
int pointer_var = 0;

__asm__ volatile (
    "movl %0, %%eax\n\t"
    "movl %%eax, %1"
    :
    : "r" (value),      // Any register
      "m" (pointer_var) // Memory operand
    : "%eax"           // Clobbered register
);

// Common constraints:
// "r"  - Any general register
// "m"  - Memory operand
// "i"  - Immediate value
// "a"  - EAX register
// "b"  - EBX register
// "c"  - ECX register
// "d"  - EDX register
// "S"  - ESI register
// "D"  - EDI register
```

## Clobber List

```c
void function_with_asm(int x, int y) {
    int result;
    __asm__ volatile (
        "movl %1, %%eax\n\t"
        "addl %2, %%eax\n\t"
        "movl %%eax, %0"
        : "=r" (result)
        : "r" (x), "r" (y)
        : "%eax"  // Tell compiler EAX is modified
    );

    // Compiler won't keep value in EAX after this
}
```

## CPUID

```c
// Get CPU vendor string
void cpuid_string(int code, char* output) {
    int eax, ebx, ecx, edx;

    __asm__ volatile (
        "cpuid"
        : "=a" (eax), "=b" (ebx),
          "=c" (ecx), "=d" (edx)
        : "a" (code)
    );

    // Copy to output (ebx order changed)
    *(int*)(output + 0) = ebx;
    *(int*)(output + 4) = edx;
    *(int*)(output + 8) = ecx;
}

// Usage
char vendor[13] = {0};
cpuid_string(0, vendor);
printf("CPU Vendor: %s\n", vendor);
```

## Port I/O

```c
// Write to I/O port
void outb(uint8_t value, uint16_t port) {
    __asm__ volatile (
        "outb %0, %1"
        :
        : "a" (value), "Nd" (port)
    );
}

// Read from I/O port
uint8_t inb(uint16_t port) {
    uint8_t value;
    __asm__ volatile (
        "inb %1, %0"
        : "=a" (value)
        : "Nd" (port)
    );
    return value;
}

// Usage
outb(0xAA, 0x80);  // Write to port 0x80
uint8_t status = inb(0x80);  // Read from port 0x80
```

## Spinlock with Pause

```c
typedef volatile struct {
    int locked;
} spinlock_t;

void spinlock_acquire(spinlock_t* lock) {
    while (__builtin_expect(
        __sync_lock_test_and_set(&lock->locked, 1), 0
    )) {
        // Hint CPU we're in spin loop
        __asm__ volatile ("pause");
    }
}

void spinlock_release(spinlock_t* lock) {
    __sync_lock_release(&lock->locked);
}
```

## Atomic Operations

```c
// Atomic compare and swap (CAS)
int atomic_cas(int* ptr, int old_val, int new_val) {
    int result;
    __asm__ volatile (
        "lock; cmpxchgl %2, %0"
        : "+m" (*ptr), "=a" (result)
        : "r" (new_val), "0" (old_val)
        : "memory"
    );
    return result;
}

// Atomic increment
void atomic_inc(int* ptr) {
    __asm__ volatile (
        "lock; incl %0"
        : "+m" (*ptr)
        :
        : "memory"
    );
}
```

## Memory Barriers

```c
// Full memory barrier
void mfence() {
    __asm__ volatile ("mfence" ::: "memory");
}

// Write barrier
void sfence() {
    __asm__ volatile ("sfence" ::: "memory");
}

// Read barrier
void lfence() {
    __asm__ volatile ("lfence" ::: "memory");
}

// Usage with shared memory
volatile int* shared_data = ...;

// Write data
*shared_data = 42;
sfence();  // Ensure write completes

// Read data
lfence();  // Ensure reads see latest writes
int value = *shared_data;
```

## SIMD Operations

```c
// SSE addition
void add_floats_sse(float* a, float* b, float* result, int n) {
    for (int i = 0; i < n; i += 4) {
        __asm__ (
            "movups %1, %%xmm0\n\t"
            "addps %2, %%xmm0\n\t"
            "movups %%xmm0, %0"
            :
            : "m" (result[i]), "m" (a[i]), "m" (b[i])
            : "%xmm0", "memory"
        );
    }
}

// AVX version (256-bit)
void add_floats_avx(float* a, float* b, float* result, int n) {
    for (int i = 0; i < n; i += 8) {
        __asm__ (
            "vmovups %1, %%ymm0\n\t"
            "vaddps %2, %%ymm0, %%ymm0\n\t"
            "vmovups %%ymm0, %0"
            :
            : "m" (result[i]), "m" (a[i]), "m" (b[i])
            : "%ymm0", "memory"
        );
    }
}
```

## Extended ASM with Local Labels

```c
// Loop in assembly
void copy_bytes(void* dst, const void* src, int n) {
    __asm__ volatile (
        "1:\n\t"
        "movb (%1), %%al\n\t"
        "movb %%al, (%0)\n\t"
        "inc %0\n\t"
        "inc %1\n\t"
        "dec %2\n\t"
        "jnz 1b"
        : "+r" (dst), "+r" (src), "+r" (n)
        :
        : "%al", "memory"
    );
}
```

## Conditional Code

```c
int is_cpuid_supported() {
    int result;
    __asm__ (
        "pushfl\n\t"           // Save flags
        "popl %%eax\n\t"
        "movl %%eax, %%ecx\n\t"
        "xorl $0x200000, %%eax\n\t"  // Flip bit 21
        "pushl %%eax\n\t"
        "popfl\n\t"
        "pushfl\n\t"
        "popl %%eax\n\t"
        "cmpl %%ecx, %%eax\n\t"
        "setne %0"
        : "=r" (result)
        :
        : "%eax", "%ecx"
    );
    return result;
}
```

## String Operations

```c
// Zero memory block
void memset_zero(void* ptr, size_t size) {
    __asm__ volatile (
        "cld\n\t"
        "rep stosb"
        :
        : "D" (ptr), "a" (0), "c" (size)
        : "memory"
    );
}

// Copy memory
void memcpy_fast(void* dst, const void* src, size_t size) {
    __asm__ volatile (
        "cld\n\t"
        "rep movsb"
        :
        : "D" (dst), "S" (src), "c" (size)
        : "memory"
    );
}
```

## Compiler-Specific Syntax

```c
// MSVC (Visual Studio)
void msvc_example() {
    int x = 10;
    __asm {
        mov eax, x
        add eax, 5
        mov x, eax
    }
}

// GCC/Clang (cross-platform)
void gcc_example() {
    int x = 10;
    __asm__ (
        "movl %1, %%eax\n\t"
        "addl $5, %%eax\n\t"
        "movl %%eax, %0"
        : "=m" (x)
        : "m" (x)
        : "%eax"
    );
}
```

## Best Practices

```c
// 1. Use intrinsics when available
#include <immintrin.h>
__m128 add_sse(__m128 a, __m128 b) {
    return _mm_add_ps(a, b);  // Better than inline asm
}

// 2. Mark volatile when side effects
__asm__ volatile (
    "cli"  // Disable interrupts
    ::: "memory"
);

// 3. Use constraints correctly
int value;
__asm__ (
    "movl $42, %0"
    : "=r" (value)  // Output
    :
);

// 4. Clobber registers you use
__asm__ (
    "movl %1, %%eax\n\t"
    ...
    : ...
    : "r" (input)
    : "%eax", "%ebx"  // Tell compiler
);

// 5. Prefer built-in functions
int atomic_add(int* ptr, int val) {
    return __sync_fetch_and_add(ptr, val);
    // Better than inline asm for portability
}
```

## Common Pitfalls

```c
// ❌ WRONG: Missing clobbers
void wrong_asm(int x) {
    __asm__ (
        "movl %0, %%eax\n\t"
        "addl $5, %%eax"
        :
        : "r" (x)
        // Missing: "%eax" clobber!
    );
    // Compiler may keep value in EAX, now corrupted
}

// ✅ CORRECT: Add clobbers
void correct_asm(int x) {
    __asm__ (
        "movl %0, %%eax\n\t"
        "addl $5, %%eax"
        :
        : "r" (x)
        : "%eax"  // Tell compiler EAX is modified
    );
}

// ❌ WRONG: Not volatile when needed
void disable_interrupts() {
    __asm__ ("cli");  // May be optimized away!
}

// ✅ CORRECT: Use volatile
void disable_interrupts() {
    __asm__ volatile ("cli");
}
```

> **Warning**: Inline assembly is non-portable and difficult to maintain. Consider using compiler intrinsics or writing pure assembly files instead.
