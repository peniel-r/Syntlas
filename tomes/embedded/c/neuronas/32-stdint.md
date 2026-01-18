---
id: "c.stdlib.stdint"
title: "Fixed-Width Integers (stdint.h)"
category: stdlib
difficulty: beginner
tags: [c, stdint, int8, int16, int32, int64, size_t]
keywords: [int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t]
use_cases: [portability, binary protocols, hardware interfacing]
prerequisites: []
related: ["c.stdlib.stdbool"]
next_topics: ["c.stdlib.stddef"]
---

# Fixed-Width Integers

## Basic Usage

```c
#include <stdio.h>
#include <stdint.h>

int main() {
    int8_t a = 127;
    int16_t b = 32767;
    int32_t c = 2147483647;
    int64_t d = 9223372036854775807LL;

    printf("int8_t: %d\n", a);
    printf("int16_t: %d\n", b);
    printf("int32_t: %d\n", c);
    printf("int64_t: %lld\n", d);

    return 0;
}
```

## Unsigned Types

```c
#include <stdio.h>
#include <stdint.h>

int main() {
    uint8_t a = 255;
    uint16_t b = 65535;
    uint32_t c = 4294967295U;
    uint64_t d = 18446744073709551615ULL;

    printf("uint8_t: %u\n", a);
    printf("uint16_t: %u\n", b);
    printf("uint32_t: %u\n", c);
    printf("uint64_t: %llu\n", d);

    return 0;
}
```

## Size Specifiers

```c
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

int main() {
    printf("sizeof(int8_t) = %zu bytes\n", sizeof(int8_t));
    printf("sizeof(int16_t) = %zu bytes\n", sizeof(int16_t));
    printf("sizeof(int32_t) = %zu bytes\n", sizeof(int32_t));
    printf("sizeof(int64_t) = %zu bytes\n", sizeof(int64_t));

    printf("sizeof(uint8_t) = %zu bytes\n", sizeof(uint8_t));
    printf("sizeof(uint16_t) = %zu bytes\n", sizeof(uint16_t));
    printf("sizeof(uint32_t) = %zu bytes\n", sizeof(uint32_t));
    printf("sizeof(uint64_t) = %zu bytes\n", sizeof(uint64_t));

    return 0;
}
```

## Range Checking

```c
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

int main() {
    printf("int8_t range: %" PRId8 " to %" PRId8 "\n", INT8_MIN, INT8_MAX);
    printf("int16_t range: %" PRId16 " to %" PRId16 "\n", INT16_MIN, INT16_MAX);
    printf("int32_t range: %" PRId32 " to %" PRId32 "\n", INT32_MIN, INT32_MAX);
    printf("int64_t range: %" PRId64 " to %" PRId64 "\n", INT64_MIN, INT64_MAX);

    printf("\nuint8_t range: 0 to %" PRIu8 "\n", UINT8_MAX);
    printf("uint16_t range: 0 to %" PRIu16 "\n", UINT16_MAX);
    printf("uint32_t range: 0 to %" PRIu32 "\n", UINT32_MAX);
    printf("uint64_t range: 0 to %" PRIu64 "\n", UINT64_MAX);

    return 0;
}
```

## Pointer-Sized Integers

```c
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

int main() {
    // Pointer-sized integers
    intptr_t ptr_val = (intptr_t)NULL;
    uintptr_t uptr_val = (uintptr_t)NULL;

    printf("sizeof(intptr_t) = %zu bytes\n", sizeof(intptr_t));
    printf("sizeof(uintptr_t) = %zu bytes\n", sizeof(uintptr_t));
    printf("sizeof(void*) = %zu bytes\n", sizeof(void*));

    // Convert pointer to integer
    int x = 42;
    uintptr_t ptr_num = (uintptr_t)&x;
    printf("Pointer as integer: %zu\n", ptr_num);

    return 0;
}
```

## Maximum Value Types

```c
#include <stdio.h>
#include <stdint.h>

int main() {
    int8_t smallest = INT8_MIN;
    int8_t largest = INT8_MAX;
    uint8_t max_u8 = UINT8_MAX;

    printf("int8_t: %" PRId8 " to %" PRId8 "\n", smallest, largest);
    printf("uint8_t: 0 to %" PRIu8 "\n", max_u8);

    return 0;
}
```

## Binary Protocol

```c
#include <stdio.h>
#include <stdint.h>

typedef struct __attribute__((packed)) {
    uint8_t  msg_type;
    uint16_t length;
    uint32_t checksum;
    uint64_t timestamp;
} MessageHeader;

void print_header(const MessageHeader* header) {
    printf("Message Header:\n");
    printf("  Type: %" PRIu8 "\n", header->msg_type);
    printf("  Length: %" PRIu16 "\n", header->length);
    printf("  Checksum: 0x%08" PRIx32 "\n", header->checksum);
    printf("  Timestamp: %" PRIu64 "\n", header->timestamp);
}

int main() {
    MessageHeader header = {
        .msg_type = 1,
        .length = 100,
        .checksum = 0xDEADBEEF,
        .timestamp = 1234567890ULL
    };

    print_header(&header);

    return 0;
}
```

## Network Byte Order

```c
#include <stdio.h>
#include <stdint.h>
#include <arpa/inet.h>

int main() {
    uint32_t host_value = 0x12345678;
    uint32_t network_value = htonl(host_value);

    printf("Host order: 0x%08" PRIx32 "\n", host_value);
    printf("Network order: 0x%08" PRIx32 "\n", network_value);

    return 0;
}
```

## Bit Manipulation

```c
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

bool get_bit(uint32_t value, int bit) {
    return (value >> bit) & 1;
}

uint32_t set_bit(uint32_t value, int bit) {
    return value | (1 << bit);
}

uint32_t clear_bit(uint32_t value, int bit) {
    return value & ~(1 << bit);
}

uint32_t toggle_bit(uint32_t value, int bit) {
    return value ^ (1 << bit);
}

int main() {
    uint32_t flags = 0;

    printf("Initial: 0x%08" PRIx32 "\n", flags);

    flags = set_bit(flags, 2);
    printf("Set bit 2: 0x%08" PRIx32 "\n", flags);

    flags = set_bit(flags, 5);
    printf("Set bit 5: 0x%08" PRIx32 "\n", flags);

    printf("Bit 2 is %s\n", get_bit(flags, 2) ? "set" : "clear");

    flags = clear_bit(flags, 2);
    printf("Clear bit 2: 0x%08" PRIx32 "\n", flags);

    flags = toggle_bit(flags, 5);
    printf("Toggle bit 5: 0x%08" PRIx32 "\n", flags);

    return 0;
}
```

## File Format

```c
#include <stdio.h>
#include <stdint.h>

typedef struct __attribute__((packed)) {
    char     magic[4];      // "WAVE"
    uint32_t file_size;
    char     format[4];     // "fmt "
    uint32_t chunk_size;
    uint16_t audio_format;
    uint16_t num_channels;
    uint32_t sample_rate;
    uint32_t byte_rate;
    uint16_t block_align;
    uint16_t bits_per_sample;
} WAVHeader;

void print_wav_header(const WAVHeader* header) {
    printf("WAV Header:\n");
    printf("  Magic: %.4s\n", header->magic);
    printf("  File Size: %" PRIu32 "\n", header->file_size);
    printf("  Audio Format: %" PRIu16 "\n", header->audio_format);
    printf("  Channels: %" PRIu16 "\n", header->num_channels);
    printf("  Sample Rate: %" PRIu32 "\n", header->sample_rate);
    printf("  Bits per Sample: %" PRIu16 "\n", header->bits_per_sample);
}

int main() {
    WAVHeader header = {
        .magic = "WAVE",
        .file_size = 36,
        .format = "fmt ",
        .chunk_size = 16,
        .audio_format = 1,
        .num_channels = 2,
        .sample_rate = 44100,
        .byte_rate = 176400,
        .block_align = 4,
        .bits_per_sample = 16
    };

    print_wav_header(&header);

    return 0;
}
```

## Hex Formatting

```c
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

int main() {
    uint32_t value = 0xDEADBEEF;

    printf("Decimal: %" PRIu32 "\n", value);
    printf("Hex (lower): 0x%08" PRIx32 "\n", value);
    printf("Hex (upper): 0x%08" PRIX32 "\n", value);
    printf("Octal: %o\n", value);

    uint64_t large = 0x123456789ABCDEF0ULL;
    printf("Large: 0x%016" PRIx64 "\n", large);

    return 0;
}
```

## Safe Arithmetic

```c
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <limits.h>

bool safe_add_uint32(uint32_t a, uint32_t b, uint32_t* result) {
    if (a > UINT32_MAX - b) {
        return false;  // Overflow
    }
    *result = a + b;
    return true;
}

int main() {
    uint32_t a = 4000000000U;
    uint32_t b = 500000000U;
    uint32_t result;

    if (safe_add_uint32(a, b, &result)) {
        printf("Result: %" PRIu32 "\n", result);
    } else {
        printf("Overflow occurred\n");
    }

    return 0;
}
```

> **Note**: Use `PRIu64`, `PRId64`, etc. for portable formatting. Not all platforms support all types; check availability.
