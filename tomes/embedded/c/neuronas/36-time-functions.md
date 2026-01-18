---
id: "c.stdlib.time"
title: "Time  (time, ctime, strftime)"
category: stdlib
difficulty: beginner
tags: [c, time, ctime, strftime, gmtime, localtime]
keywords: [time, time_t, tm, strftime, ctime, gmtime, localtime]
use_cases: [, scheduling, timestamps]
prerequisites: []
related: ["c.stdlib.stdio"]
next_topics: ["c.stdlib.process"]
---

# Time 

## time - Current Time

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);

    if (now == -1) {
        perror("time failed");
        return 1;
    }

    printf("Current time: %ld\n", (long)now);

    return 0;
}
```

## ctime - Formatted Time

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    char* time_str = ctime(&now);

    if (time_str == NULL) {
        perror("ctime failed");
        return 1;
    }

    printf("Current time: %s", time_str);

    return 0;
}
```

## localtime - Local Time

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    if (local == NULL) {
        perror("localtime failed");
        return 1;
    }

    printf("Local time: %d/%d/%d %d:%d:%d\n",
           local->tm_year + 1900,
           local->tm_mon + 1,
           local->tm_mday,
           local->tm_hour,
           local->tm_min,
           local->tm_sec);

    return 0;
}
```

## gmtime - UTc.stdlib.time

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    struct tm* utc = gmtime(&now);

    if (utc == NULL) {
        perror("gmtime failed");
        return 1;
    }

    printf("UTc.stdlib.time: %d/%d/%d %d:%d:%d\n",
           utc->tm_year + 1900,
           utc->tm_mon + 1,
           utc->tm_mday,
           utc->tm_hour,
           utc->tm_min,
           utc->tm_sec);

    return 0;
}
```

## strftime - Custom Format

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    char buffer[80];
    size_t len = strftime(buffer, sizeof(buffer),
                        "%Y-%m-%d %H:%M:%S", local);

    if (len > 0) {
        printf("Formatted: %s\n", buffer);
    }

    return 0;
}
```

## Time Difference

```c
#include <stdio.h>
#include <time.h>
#include <unistd.h>

int main() {
    time_t start = time(NULL);

    sleep(2);  // Simulate work

    time_t end = time(NULL);
    double elapsed = difftime(end, start);

    printf("Elapsed time: %.2f seconds\n", elapsed);

    return 0;
}
```

## mktime - Time from Components

```c
#include <stdio.h>
#include <time.h>

int main() {
    struct tm time_info = {
        .tm_year = 126,  // 2026 - 1900
        .tm_mon  = 0,    // January
        .tm_mday = 18,
        .tm_hour = 11,
        .tm_min  = 4,
        .tm_sec  = 40
    };

    time_t timestamp = mktime(&time_info);

    if (timestamp == -1) {
        perror("mktime failed");
        return 1;
    }

    printf("Timestamp: %ld\n", (long)timestamp);

    return 0;
}
```

## Timer with Precision

```c
#include <stdio.h>
#include <time.h>

void benchmark_function(void) {
    volatile int sum = 0;
    for (int i = 0; i < 1000000; i++) {
        sum += i;
    }
}

int main() {
    clock_t start = clock();

    benchmark_function();

    clock_t end = clock();
    double elapsed = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Elapsed: %.6f seconds\n", elapsed);

    return 0;
}
```

## Sleep Function

```c
#include <stdio.h>
#include <time.h>

void sleep_ms(unsigned int milliseconds) {
    struct timespec ts;
    ts.tv_sec = milliseconds / 1000;
    ts.tv_nsec = (milliseconds % 1000) * 1000000;

    nanosleep(&ts, NULL);
}

int main() {
    printf("Starting...\n");
    sleep_ms(1000);
    printf("After 1 second\n");

    return 0;
}
```

## Timezone Info

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    printf("Timezone: %s\n", local->tm_zone);
    printf("DST: %d\n", local->tm_isdst);

    return 0;
}
```

## Format Options

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    const char* formats[] = {
        "%Y-%m-%d",           // 2026-01-18
        "%H:%M:%S",           // 11:04:40
        "%A, %B %d, %Y",     // Sunday, January 18, 2026
        "%I:%M %p",           // 11:04 AM
        "%Y%m%d%H%M%S",       // 20260118110440
    };

    char buffer[80];
    for (int i = 0; i < 5; i++) {
        strftime(buffer, sizeof(buffer), formats[i], local);
        printf("Format %d: %s\n", i + 1, buffer);
    }

    return 0;
}
```

## Parse Time String

```c
#include <stdio.h>
#include <time.h>
#include <string.h>

int main() {
    const char* time_str = "2026-01-18 11:04:40";
    struct tm tm;

    memset(&tm, 0, sizeof(tm));
    char* result = strptime(time_str, "%Y-%m-%d %H:%M:%S", &tm);

    if (result == NULL) {
        printf("Failed to parse time\n");
        return 1;
    }

    time_t timestamp = mktime(&tm);
    printf("Parsed timestamp: %ld\n", (long)timestamp);

    return 0;
}
```

## Weekday Calculation

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    const char* weekdays[] = {
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
    };

    printf("Day of week: %s\n", weekdays[local->tm_wday]);
    printf("Day of year: %d\n", local->tm_yday + 1);

    return 0;
}
```

## Age Calculation

```c
#include <stdio.h>
#include <time.h>

int calculate_age(int birth_year, int birth_month, int birth_day) {
    time_t now = time(NULL);
    struct tm* current = localtime(&now);

    int age = current->tm_year + 1900 - birth_year;

    if (current->tm_mon + 1 < birth_month ||
        (current->tm_mon + 1 == birth_month &&
         current->tm_mday < birth_day)) {
        age--;
    }

    return age;
}

int main() {
    int age = calculate_age(1990, 5, 15);
    printf("Age: %d\n", age);

    return 0;
}
```

## Time Comparison

```c
#include <stdio.h>
#include <time.h>

int main() {
    time_t t1 = time(NULL);

    sleep(1);

    time_t t2 = time(NULL);

    double diff = difftime(t2, t1);

    if (diff > 0) {
        printf("t2 is %.0f seconds after t1\n", diff);
    } else if (diff < 0) {
        printf("t2 is %.0f seconds before t1\n", -diff);
    } else {
        printf("t1 and t2 are the same\n");
    }

    return 0;
}
```

## Time Formatter

```c
#include <stdio.h>
#include <time.h>

const char* format_time(time_t timestamp, const char* format) {
    static char buffer[80];
    struct tm* local = localtime(&timestamp);

    if (local == NULL) {
        return "Invalid time";
    }

    strftime(buffer, sizeof(buffer), format, local);
    return buffer;
}

int main() {
    time_t now = time(NULL);

    printf("Date: %s\n", format_time(now, "%Y-%m-%d"));
    printf("Time: %s\n", format_time(now, "%H:%M:%S"));
    printf("Full: %s\n", format_time(now, "%Y-%m-%d %H:%M:%S"));

    return 0;
}
```

> **Note**: `time_t` is typically a signed integer representing seconds since Unix epoch (Jan 1, 1970). May overflow in 2038 on 32-bit systems.
