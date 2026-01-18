---
id: "c.stdlib.time"
title: "Time Library Functions"
category: stdlib
difficulty: intermediate
tags: [c, stdlib, time, ctime, clock]
keywords: [time, ctime, clock, difftime, strftime, asctime]
use_cases: [time measurement, timing code, timestamps, delays]
prerequisites: []
related: ["c.stdlib.math"]
next_topics: []
---

# Time Library Functions

C's <time.h> provides date and time functions.

## Getting Current Time

```c
#include <stdio.h>
#include <time.h>

int main() {
    // Get calendar time
    time_t now = time(NULL);
    struct tm* local = localtime(&now);
    
    printf("Current time: %s", asctime(local));
    printf("Formatted: %02d:%02d:%02d\n", 
        local->tm_hour, local->tm_min, local->tm_sec);
    
    return 0;
}
```

## Time Measurement

```c
#include <stdio.h>
#include <time.h>

int main() {
    clock_t start = clock();
    
    // Simulate work
    for (volatile int i = 0; i < 1000000; i++);
        // Busy wait
    }
    
    clock_t end = clock();
    double elapsed = (double)(end - start) / CLOCKS_PER_SEC;
    
    printf("Elapsed: %.4f seconds\n", elapsed);
    return 0;
}
```

## Time Differences

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    struct tm future = *localtime(&now);
    future.tm_mday += 7;  // 7 days from now
    
    time_t future_time = mktime(&future);
    double diff = difftime(future_time, now);
    
    printf("Days until next week: %.0f\n", diff / 86400.0);  // Convert to days
    return 0;
}
```

## Time Conversion

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    
    // Convert to string
    char time_str[26];
    strftime(time_str, sizeof(time_str), "%Y-%m-%d %H:%M:%S", localtime(&now));
    printf("Time: %s\n", time_str);
    
    // Parse string to time
    struct tm parsed_time = {0};
    char* time_str = "2026-01-18 14:30:00";
    strptime(time_str, "%Y-%m-%d %H:%M:%S", &parsed_time);
    
    time_t parsed_time_t = mktime(&parsed_time);
    printf("Parsed time: %s", asctime(&parsed_time));
    
    return 0;
}
```

## Common Patterns

### Execution timer

```c
#include <stdio.h>
#include <time.h>

typedef struct {
    clock_t start;
    const char* name;
} Timer;

Timer timer_start(const char* name) {
    Timer t = {clock(), name};
    printf("Starting: %s\n", name);
    return t;
}

double timer_end(Timer t) {
    clock_t end = clock();
    double elapsed = (double)(end - t.start) / CLOCKS_PER_SEC;
    printf("Finished %s: %.4f seconds\n", t.name, elapsed);
    return elapsed;
}

int main() {
    Timer timer = timer_start("Process Data");
    
    // Simulate work
    for (volatile int i = 0; i < 1000000; i++);
        // Work...
    }
    
    timer_end(timer);
    return 0;
}
```

### Rate limiting with time

```c
#include <stdio.h>
#include <time.h>

#define MAX_REQUESTS_PER_SECOND 10

typedef struct {
    time_t last_time;
    int request_count;
} RateLimiter;

void init_rate_limiter(RateLimiter* limiter) {
    limiter->last_time = time(NULL);
    limiter->request_count = 0;
}

int allow_request(RateLimiter* limiter) {
    time_t now = time(NULL);
    
    // Reset counter if second has passed
    if (difftime(now, limiter->last_time) >= 1.0) {
        limiter->request_count = 0;
        limiter->last_time = now;
    }
    
    if (limiter->request_count < MAX_REQUESTS_PER_SECOND) {
        limiter->request_count++;
        return 1;
    }
    
    return 0;
}
```

### Timeout check

```c
#include <stdio.h>
#include <time.h>

int check_timeout(time_t deadline) {
    time_t now = time(NULL);
    return difftime(now, deadline) >= 0.0;
}

int main() {
    time_t deadline = time(NULL);
    
    // Wait up to 10 seconds
    printf("Waiting...\n");
    while (!check_timeout(deadline)) {
        // Busy wait
    }
    
    printf("Timeout reached\n");
    return 0;
}
```

### Formatting timestamps

```c
#include <stdio.h>
#include <time.h>

const char* formats[] = {
    "%Y-%m-%d %H:%M:%S",
    "%Y-%m-%d",
    "%H:%M",
    "%Y-%m-%d %H:%M",
    "%d/%m/%Y",
};

void print_timestamps(time_t t) {
    struct tm* local = localtime(&t);
    
    for (int i = 0; i < 5; i++) {
        char buffer[100];
        strftime(buffer, sizeof(buffer), formats[i], local);
        printf("Format %d: %s\n", i, buffer);
    }
}

int main() {
    print_timestamps(time(NULL));
    return 0;
}
```

### High-resolution timing (clock_gettime on Unix)

```c
#if defined(__unix__)
#include <sys/time.h>
#include <stdio.h>

double get_time_ms() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec * 1000.0 + tv.tv_usec / 1000.0;
}

int main() {
    double start = get_time_ms();
    
    // Simulate work
    for (volatile int i = 0; i < 1000000; i++);
        // Work...
    }
    
    double end = get_time_ms();
    printf("Elapsed: %.4f ms\n", end - start);
    return 0;
}
#endif
```

### Date arithmetic

```c
#include <stdio.h>
#include <time.h>

time_t add_days(time_t date, int days) {
    return date + days * 86400;  // Seconds per day
}

int main() {
    time_t now = time(NULL);
    time_t next_week = add_days(now, 7);
    
    printf("Next week: %s", ctime(&next_week));
    return 0;
}
```

> **Note**: Use time_t for simple timestamp storage. Use struct tm for date-time manipulation. Be aware of timezone issues when parsing timestamps.
