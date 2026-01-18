---
id: "c.stdlib.math"
title: "Math Library Functions"
category: stdlib
difficulty: novice
tags: [c, stdlib, math, cmath]
keywords: [abs, sqrt, sin, cos, pow, floor, ceil, round]
use_cases: [mathematical calculations, numeric operations]
prerequisites: []
related: ["c.stdlib.io"]
next_topics: []
---

# Math Library Functions

C's <math.h> provides mathematical functions and macros.

## Basic Math Functions

```c
#include <stdio.h>
#include <math.h>

int main() {
    // Absolute value
    printf("abs(-5.5): %.2f\n", fabs(-5.5));
    printf("abs(5.5): %.2f\n", fabs(5.5));
    
    // Square root
    printf("sqrt(25): %.2f\n", sqrt(25.0));
    printf("sqrt(2): %.2f\n", sqrt(2.0));
    
    // Power
    printf("pow(2, 3): %.2f\n", pow(2.0, 3.0));
    printf("pow(2, 10): %.2f\n", pow(2.0, 10.0));
    
    return 0;
}
```

## Trigonometric Functions

```c
#include <stdio.h>
#include <math.h>

int main() {
    double angle = 1.5708;  // 90 degrees in radians
    
    printf("sin(90°): %.4f\n", sin(angle));
    printf("cos(90°): %.4f\n", cos(angle));
    printf("tan(45°): %.4f\n", tan(3.14159 / 4));
    
    return 0;
}
```

## Rounding Functions

```c
#include <stdio.h>
#include <math.h>

int main() {
    double value = 3.7;
    
    // Floor (round down)
    printf("floor(3.7): %.2f\n", floor(value));
    
    // Ceil (round up)
    printf("ceil(3.7): %.2f\n", ceil(value));
    
    // Round (nearest)
    printf("round(3.7): %.2f\n", round(value));
    
    return 0;
}
```

## Common Patterns

### Clamp value between min and max

```c
#include <stdio.h>
#include <math.h>

double clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
}

int main() {
    double clamped = clamp(15.0, 0.0, 100.0);
    printf("Clamped: %.2f\n", clamped);
    return 0;
}
```

### Linear interpolation

```c
#include <stdio.h>

double lerp(double a, double b, double t) {
    // Linear interpolation between a and b
    return a + t * (b - a);
}

int main() {
    printf("Lerp 0.5: %.2f\n", lerp(0.0, 10.0, 0.5));
    printf("Lerp 0.75: %.2f\n", lerp(0.0, 10.0, 0.75));
    return 0;
}
```

### Min and max of multiple values

```c
#include <stdio.h>

int main() {
    int values[] = {5, 3, 9, 1, 7};
    int count = sizeof(values) / sizeof(values[0]);
    
    int min = values[0];
    int max = values[0];
    
    for (int i = 1; i < count; i++) {
        if (values[i] < min) min = values[i];
        if (values[i] > max) max = values[i];
    }
    
    printf("Min: %d, Max: %d\n", min, max);
    return 0;
}
```

### Check if value is within range

```c
#include <stdio.h>

int is_between(int value, int min, int max) {
    return value >= min && value <= max;
}

int main() {
    int test_value = 50;
    printf("50 in [0, 100]: %s\n", is_between(test_value, 0, 100) ? "yes" : "no");
    return 0;
}
```

### Safe division with integer division

```c
#include <stdio.h>

// Safe integer division that checks for divide by zero
int safe_div(int numerator, int denominator, int* result) {
    if (denominator == 0) {
        *result = 0;
        return 0;  // Error: division by zero
    }
    
    *result = numerator / denominator;
    return 1;
}

int main() {
    int result;
    if (safe_div(10, 2, &result)) {
        printf("10 / 2 = %d\n", result);
    } else {
        printf("Error: division by zero\n");
    }
    return 0;
}
```

### GCD (Greatest Common Divisor)

```c
#include <stdio.h>

int gcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

int main() {
    printf("GCD(48, 18): %d\n", gcd(48, 18));
    printf("GCD(60, 48): %d\n", gcd(60, 48));
    return 0;
}
```

### LCM (Least Common Multiple)

```c
#include <stdio.h>

int lcm(int a, int b) {
    return a * b / gcd(a, b);
}

int main() {
    printf("LCM(12, 18): %d\n", lcm(12, 18));
    printf("LCM(4, 6): %d\n", lcm(4, 6));
    return 0;
}
```

> **Note**: Be aware of floating-point precision issues. Use <math.h> for mathematical operations and <tgmath.h> for type-generic math when possible.
