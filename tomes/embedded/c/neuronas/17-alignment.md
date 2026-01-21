---
id: "c.alignment"
title: "Alignment and Alignment Specifiers"
category: language
difficulty: advanced
tags: [c, alignment, memory, types, structs]
keywords: [alignas, alignof, alignment, padding, packed]
use_cases: [simd, dma, binary protocols]
prerequisites: []
related: []
next_topics: []
---

# Alignment and Alignment Specifiers

Alignment controls how data is arranged in memory.

## What is Alignment?

```c
// Alignment requirements
char    // 1-byte aligned (any address)
short    // 2-byte aligned (even addresses)
int      // 4-byte aligned (addresses divisible by 4)
double   // 8-byte aligned (addresses divisible by 8)
long long // 8-byte aligned (typically)
```

## Default Alignment

```c
#include <stddef.h>

struct S1 {
    char c;    // 1 byte
    int i;     // 4 bytes (aligned to 4)
    char d;    // 1 byte
};

// sizeof(S1) = 12 bytes (not 6!)
// Layout: [c][pad][pad][pad][i][i][i][i][d][pad][pad][pad]

printf("alignof(int) = %zu\n", alignof(int));     // 4
printf("alignof(double) = %zu\n", alignof(double)); // 8
printf("alignof(S1) = %zu\n", alignof(S1));     // 4
```

## Alignment Specifiers (C11)

```c
// Specify minimum alignment
_Alignas(16) int aligned_int;

// Using types
_Alignas(double) char buffer[sizeof(double)];

// Struct with aligned member
struct S2 {
    char c;
    _Alignas(16) int aligned_i;
    char d;
};

// sizeof(S2) = 32 (with alignment)
```

## alignof Operator

```c
#include <stddef.h>

int x;
printf("Alignment of int: %zu\n", _Alignof(int));     // 4
printf("Alignment of double: %zu\n", _Alignof(double)); // 8
printf("Alignment of long: %zu\n", _Alignof(long));    // 8
printf("Alignment of x: %zu\n", _Alignof(x));         // 4
```

## Practical Alignment Example

```c
// Without alignment (may cause bus error)
struct Unaligned {
    char data[4];
    int value;  // Not aligned!
};

// With alignment (safe)
struct Aligned {
    char data[4];
    _Alignas(4) int value;  // Force 4-byte alignment
};

// Better: Use standard alignment
struct BetterAligned {
    char data[4];
    int value;  // Compiler handles padding
};
```

## Struct Packing

```c
// Default (with padding)
struct Default {
    char c;   // 1 byte
    // 3 bytes padding
    int i;    // 4 bytes
    char d;   // 1 byte
    // 3 bytes padding
}; // Total: 12 bytes

// Packed (no padding)
#pragma pack(push, 1)
struct Packed {
    char c;
    int i;   // Not aligned!
    char d;
}; // Total: 6 bytes
#pragma pack(pop)

// Using alignas
struct AlignedPacked {
    char c;
    _Alignas(4) int i;  // Manual alignment
    char d;
}; // Total: 9 bytes
```

## Alignment with malloc

```c
#include <stdlib.h>
#include <stdalign.h>

// Standard aligned allocation (C11)
void* ptr = aligned_alloc(16, 1024);
if (ptr == NULL) {
    perror("aligned_alloc");
}
free(ptr);

// POSIX aligned allocation
void* ptr2 = posix_memalign(&ptr2, 16, 1024);
free(ptr2);

// Manual alignment
void* raw = malloc(1024 + 15);
uintptr_t addr = (uintptr_t)raw;
uintptr_t aligned = (addr + 15) & ~15ULL;
void* ptr3 = (void*)aligned;
```

## SIMD Alignment

```c
#include <immintrin.h>

// SSE requires 16-byte alignment
__m128 a;
alignas(16) float data[4];

// Load aligned data
__m128 vec1 = _mm_load_ps(data);  // Aligned load
__m128 vec2 = _mm_loadu_ps(data); // Unaligned load

// AVX requires 32-byte alignment
alignas(32) __m256 avx_data[8];
__m256 vec = _mm256_load_ps(avx_data);
```

## Alignment on Stack

```c
void function_with_aligned_stack() {
    // Stack variable with alignment
    alignas(64) int buffer[16];

    // For SIMD operations
    __m256* vec = (__m256*)buffer;
}
```

## Union Alignment

```c
// Union takes max alignment of members
union U {
    char c;         // 1 byte alignment
    int i;         // 4 byte alignment
    double d;       // 8 byte alignment
}; // alignof(U) = 8

// Force specific alignment
union AlignedUnion {
    char data[16];
    _Alignas(1) char unaligned;  // No effect
    _Alignas(16) int force_16;
};
```

## Bit Fields and Alignment

```c
struct BitField {
    unsigned int a : 3;
    unsigned int b : 5;
    unsigned int c : 8;
    // Padding to align to int boundary
};

// With alignment
struct AlignedBitFields {
    unsigned int a : 3;
    unsigned int b : 5;
    unsigned int c : 8;
    _Alignas(4) unsigned int : 0;  // Force alignment
    unsigned int d : 10;
};
```

## Common Alignments

| Type | Typical Alignment |
|------|------------------|
| char | 1 byte |
| short | 2 bytes |
| int | 4 bytes |
| long | 8 bytes |
| long long | 8 bytes |
| float | 4 bytes |
| double | 8 bytes |
| pointer | 8 bytes (64-bit) |
| SSE | 16 bytes |
| AVX | 32 bytes |
| AVX-512 | 64 bytes |

## Memory Layout Example

```c
struct Complex {
    char a;
    int b;
    char c;
    double d;
};

// Layout (64-bit):
// a     : [0]      (1 byte)
// pad   : [1][2][3] (3 bytes padding)
// b     : [4-7]    (4 bytes, aligned to 4)
// c     : [8]      (1 byte)
// pad   : [9-15]   (7 bytes padding)
// d     : [16-23]  (8 bytes, aligned to 8)
// Total: 24 bytes (not 14!)

// Optimize layout
struct Optimized {
    double d;  // 8 bytes [0-7]
    int b;    // 4 bytes [8-11]
    char a;   // 1 byte  [12]
    char c;   // 1 byte  [13]
    // pad   : 2 bytes [14-15]
}; // Total: 16 bytes (save 8 bytes!)
```

## Alignment for DMA

```c
// Direct Memory Access often requires alignment
struct DmaBuffer {
    _Alignas(4096) void* buffer;  // Page-aligned
    size_t size;
};

void setup_dma() {
    void* memory = aligned_alloc(4096, 65536);
    struct DmaBuffer buf = { .buffer = memory, .size = 65536 };

    // Safe to pass to hardware
    start_dma_transfer(buf.buffer, buf.size);
}
```

## Checking Alignment at Runtime

```c
#include <stdint.h>

int is_aligned(void* ptr, size_t alignment) {
    uintptr_t addr = (uintptr_t)ptr;
    return (addr & (alignment - 1)) == 0;
}

void check_alignment() {
    int x;
    double d;

    printf("x aligned to 4: %d\n", is_aligned(&x, 4));
    printf("d aligned to 8: %d\n", is_aligned(&d, 8));

    // Force misalignment for testing
    char buffer[16];
    int* misaligned = (int*)(buffer + 1);
    printf("misaligned: %d\n", is_aligned(misaligned, 4));  // 0
}
```

## Alignment in Binary Protocols

```c
// Network protocols often require specific alignment
#pragma pack(push, 1)

struct PacketHeader {
    uint8_t version;
    uint8_t type;
    _Alignas(4) uint16_t length;  // Align to 4 bytes
    uint32_t sequence;
};

#pragma pack(pop)

// Ensure packet is properly aligned
void send_packet(struct PacketHeader* pkt) {
    static_assert(alignof(struct PacketHeader) == 1,
                  "Packet should be packed");
}
```

> **Warning**: Misaligned access can cause performance degradation or crashes on some architectures. Always check alignment requirements.
