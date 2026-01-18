---
id: "c.stdlib.endian"
title: c.stdlib.endian
category: system
difficulty: intermediate
tags:
  - c.stdlib.endian
  - byte-order
  - network-byte-order
keywords:
  - c.stdlib.endian
  - byte order
  - big endian
  - little endian
  - network byte order
use_cases:
  - Network programming
  - File I/O
  - Binary data
  - Cross-platform
prerequisites:
  - 
  - 
  - 
related:
  - 
  - 
next_topics:
  - c.stdlib.io
---

# c.stdlib.endian

Endianness determines the byte order in which multi-byte data types are stored.

## Detecting c.stdlib.endian

```c
#include <stdio.h>

int is_little_endian(void) {
    unsigned int i = 1;
    char *c = (char *)&i;
    return (*c);  // Returns 1 if little endian
}

int is_big_endian(void) {
    return !is_little_endian();
}

void print_endianness(void) {
    if (is_little_endian()) {
        printf("System is little endian\n");
    } else {
        printf("System is big endian\n");
    }

    union {
        unsigned int i;
        char c[4];
    } test = {0x01020304};

    printf("0x01020304 stored as: ");
    for (int i = 0; i < 4; i++) {
        printf("%02X ", (unsigned char)test.c[i]);
    }
    printf("\n");
}

int main(void) {
    print_endianness();
    return 0;
}
```

## Byte Swapping

```c
#include <stdio.h>
#include <stdint.h>

// Swap 16-bit value
uint16_t swap16(uint16_t value) {
    return (value << 8) | (value >> 8);
}

// Swap 32-bit value
uint32_t swap32(uint32_t value) {
    return ((value << 24) |
            ((value << 8) & 0x00FF0000) |
            ((value >> 8) & 0x0000FF00) |
            (value >> 24));
}

// Swap 64-bit value
uint64_t swap64(uint64_t value) {
    value = ((value << 8) & 0xFF00FF00FF00FF00ULL) |
            ((value >> 8) & 0x00FF00FF00FF00FFULL);
    value = ((value << 16) & 0xFFFF0000FFFF0000ULL) |
            ((value >> 16) & 0x0000FFFF0000FFFFULL);
    value = (value << 32) | (value >> 32);
    return value;
}

// Using built-in  (GCC/Clang)
uint16_t swap16_builtin(uint16_t value) {
    return __builtin_bswap16(value);
}

uint32_t swap32_builtin(uint32_t value) {
    return __builtin_bswap32(value);
}

uint64_t swap64_builtin(uint64_t value) {
    return __builtin_bswap64(value);
}

int main(void) {
    uint16_t val16 = 0x1234;
    uint32_t val32 = 0x12345678;
    uint64_t val64 = 0x12345678ABCDEF01ULL;

    printf("Original 16-bit: 0x%04X\n", val16);
    printf("Swapped 16-bit: 0x%04X\n", swap16(val16));
    printf("Swapped (builtin): 0x%04X\n\n", swap16_builtin(val16));

    printf("Original 32-bit: 0x%08X\n", val32);
    printf("Swapped 32-bit: 0x%08X\n", swap32(val32));
    printf("Swapped (builtin): 0x%08X\n\n", swap32_builtin(val32));

    printf("Original 64-bit: 0x%016llX\n", (unsigned long long)val64);
    printf("Swapped 64-bit: 0x%016llX\n", (unsigned long long)swap64(val64));
    printf("Swapped (builtin): 0x%016llX\n", (unsigned long long)swap64_builtin(val64));

    return 0;
}
```

## Network Byte Order

```c
#include <stdio.h>
#include <stdint.h>
#include <arpa/inet.h>  // For POSIX network 

// Host to network byte order (16-bit)
uint16_t htons_custom(uint16_t hostshort) {
    return is_little_endian() ? swap16(hostshort) : hostshort;
}

// Network to host byte order (16-bit)
uint16_t ntohs_custom(uint16_t netshort) {
    return is_little_endian() ? swap16(netshort) : netshort;
}

// Host to network byte order (32-bit)
uint32_t htonl_custom(uint32_t hostlong) {
    return is_little_endian() ? swap32(hostlong) : hostlong;
}

// Network to host byte order (32-bit)
uint32_t ntohl_custom(uint32_t netlong) {
    return is_little_endian() ? swap32(netlong) : netlong;
}

int main(void) {
    uint16_t host_short = 0x1234;
    uint32_t host_long = 0x12345678;

    printf("Host short: 0x%04X\n", host_short);
    printf("Network short (htons): 0x%04X\n", htons(host_short));
    printf("Network short (custom): 0x%04X\n\n", htons_custom(host_short));

    printf("Host long: 0x%08X\n", host_long);
    printf("Network long (htonl): 0x%08X\n", htonl(host_long));
    printf("Network long (custom): 0x%08X\n\n", htonl_custom(host_long));

    return 0;
}
```

## Portable Endian Conversion

```c
#include <stdio.h>
#include <stdint.h>

// Platform-independent c.stdlib.endian conversion
#if defined(__BYTE_ORDER__)
    #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
        #define IS_LITTLE_ENDIAN 1
    #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
        #define IS_LITTLE_ENDIAN 0
    #else
        #error "Unknown endianness"
    #endif
#else
    #define IS_LITTLE_ENDIAN is_little_endian()
#endif

// Conversion 
static inline uint16_t to_big_endian16(uint16_t value) {
    return IS_LITTLE_ENDIAN ? swap16(value) : value;
}

static inline uint32_t to_big_endian32(uint32_t value) {
    return IS_LITTLE_ENDIAN ? swap32(value) : value;
}

static inline uint64_t to_big_endian64(uint64_t value) {
    return IS_LITTLE_ENDIAN ? swap64(value) : value;
}

static inline uint16_t from_big_endian16(uint16_t value) {
    return IS_LITTLE_ENDIAN ? swap16(value) : value;
}

static inline uint32_t from_big_endian32(uint32_t value) {
    return IS_LITTLE_ENDIAN ? swap32(value) : value;
}

static inline uint64_t from_big_endian64(uint64_t value) {
    return IS_LITTLE_ENDIAN ? swap64(value) : value;
}

int main(void) {
    uint32_t value = 0x12345678;

    printf("Host value: 0x%08X\n", value);
    printf("Big endian: 0x%08X\n", to_big_endian32(value));
    printf("Back to host: 0x%08X\n", from_big_endian32(to_big_endian32(value)));

    return 0;
}
```

## Writing Binary Files with c.stdlib.endian

```c
#include <stdio.h>
#include <stdint.h>

void write_u32_big_endian(FILE *file, uint32_t value) {
    uint32_t be = to_big_endian32(value);
    fwrite(&be, sizeof(be), 1, file);
}

void write_u16_big_endian(FILE *file, uint16_t value) {
    uint16_t be = to_big_endian16(value);
    fwrite(&be, sizeof(be), 1, file);
}

uint32_t read_u32_big_endian(FILE *file) {
    uint32_t value;
    fread(&value, sizeof(value), 1, file);
    return from_big_endian32(value);
}

uint16_t read_u16_big_endian(FILE *file) {
    uint16_t value;
    fread(&value, sizeof(value), 1, file);
    return from_big_endian16(value);
}

int main(void) {
    const char *filename = "data.bin";

    // Write data in big-endian
    FILE *file = fopen(filename, "wb");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    uint32_t u32_value = 0x12345678;
    uint16_t u16_value = 0x1234;

    write_u32_big_endian(file, u32_value);
    write_u16_big_endian(file, u16_value);

    fclose(file);

    // Read back
    file = fopen(filename, "rb");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    uint32_t read_u32 = read_u32_big_endian(file);
    uint16_t read_u16 = read_u16_big_endian(file);

    printf("Read u32: 0x%08X\n", read_u32);
    printf("Read u16: 0x%04X\n", read_u16);

    fclose(file);
    return 0;
}
```

## Best Practices

### Always Use Network Byte Order

```c
// GOOD - Convert to network byte order
uint16_t port = htons(8080);
send_data(port);

// BAD - Use host byte order
uint16_t port = 8080;
send_data(port);  // Might be wrong on some systems
```

### Test on Different Platforms

```c
// Always verify on both little and big endian systems
// Use cross-platform testing or emulators
```

### Use Built-in 

```c
// GOOD - Use built-in when available
#if defined(__GNUC__) || defined(__clang__)
    return __builtin_bswap32(value);
#else
    return swap32(value);
#endif
```

## Common Pitfalls

### 1. Assuming c.stdlib.endian

```c
// WRONG - Assumes little endian
uint32_t value = *(uint32_t*)buffer;

// CORRECT - Handle c.stdlib.endian
uint32_t value = from_big_endian32(*(uint32_t*)buffer);
```

### 2. Forgetting to Convert

```c
// WRONG - Direct use of host byte order
struct {
    uint16_t port;
    uint32_t address;
} packet;
send(&packet, sizeof(packet));

// CORRECT - Convert to network byte order
struct {
    uint16_t port;
    uint32_t address;
} packet;
packet.port = htons(port);
packet.address = htonl(address);
send(&packet, sizeof(packet));
```

### 3. Mixed c.stdlib.endian in Files

```c
// WRONG - Not documenting file format
// File format unclear

// CORRECT - Document c.stdlib.endian
/*
 * File format:
 * Header (big endian):
 *   - magic: 4 bytes (0x4D595449)
 *   - version: 2 bytes
 *   - flags: 2 bytes
 */
```

> **Note: Always be explicit about endianness. Use network byte order for network communications. Document file formats clearly. Test on different platforms.
