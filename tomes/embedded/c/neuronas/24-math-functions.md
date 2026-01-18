---
id: "c.stdlib.math"
title: "Math  (sin, cos, pow, sqrt)"
category: stdlib
difficulty: beginner
tags: [c, math, trigonometry, power, root, geometry]
keywords: [sin, cos, tan, pow, sqrt, abs, floor, ceil, round]
use_cases: [scientific computing, graphics, game physics, engineering]
prerequisites: ["c.stdlib.atoi"]
related: ["c.stdlib.rand"]
next_topics: ["c.error.errno"]
---

# Math 

## Basic Math 

```c
#include <stdio.h>
#include <math.h>

int main() {
    // Absolute value
    printf("abs(-5) = %d\n", abs(-5));           // 5
    printf("fabs(-3.14) = %f\n", fabs(-3.14));  // 3.140000

    // Power and exponent
    printf("pow(2, 3) = %f\n", pow(2, 3));      // 8.000000
    printf("exp(1) = %f\n", exp(1));            // 2.718282

    // Square root
    printf("sqrt(16) = %f\n", sqrt(16));        // 4.000000

    // Logarithms
    printf("log(2.718282) = %f\n", log(2.718282));   // 1.000000
    printf("log10(100) = %f\n", log10(100));         // 2.000000

    return 0;
}
```

## Trigonometric 

```c
#include <stdio.h>
#include <math.h>

int main() {
    // Convert degrees to radians
    double to_radians = M_PI / 180.0;

    // Sine, cosine, tangent
    double angle = 45.0;
    double rad = angle * to_radians;

    printf("sin(45°) = %f\n", sin(rad));  // 0.707107
    printf("cos(45°) = %f\n", cos(rad));  // 0.707107
    printf("tan(45°) = %f\n", tan(rad));  // 1.000000

    // Inverse 
    double asin_val = asin(0.5);
    double acos_val = acos(0.5);
    double atan_val = atan(1.0);

    printf("asin(0.5) = %f°\n", asin_val * 180.0 / M_PI);   // 30.000000
    printf("acos(0.5) = %f°\n", acos_val * 180.0 / M_PI);   // 60.000000
    printf("atan(1.0) = %f°\n", atan_val * 180.0 / M_PI);   // 45.000000

    return 0;
}
```

## Rounding 

```c
#include <stdio.h>
#include <math.h>

int main() {
    double value = 3.7;

    printf("Value: %f\n", value);

    // Floor (round down)
    printf("floor(3.7) = %f\n", floor(value));  // 3.000000

    // Ceil (round up)
    printf("ceil(3.7) = %f\n", ceil(value));    // 4.000000

    // Round (nearest integer)
    printf("round(3.7) = %f\n", round(value));  // 4.000000
    printf("round(3.2) = %f\n", round(3.2));    // 3.000000

    // Truncate (remove fractional part)
    printf("trunc(3.7) = %f\n", trunc(value));  // 3.000000

    return 0;
}
```

## Distance Calculation

```c
#include <stdio.h>
#include <math.h>

double distance(double x1, double y1, double x2, double y2) {
    double dx = x2 - x1;
    double dy = y2 - y1;
    return sqrt(dx * dx + dy * dy);
}

int main() {
    double dist = distance(0.0, 0.0, 3.0, 4.0);
    printf("Distance: %f\n", dist);  // 5.000000

    return 0;
}
```

## Pythagorean Theorem

```c
#include <stdio.h>
#include <math.h>

double hypotenuse(double a, double b) {
    return sqrt(a * a + b * b);
}

int main() {
    double a = 3.0;
    double b = 4.0;

    double c = hypotenuse(a, b);
    printf("Hypotenuse: %f\n", c);  // 5.000000

    return 0;
}
```

## Modulus Operation (Floating Point)

```c
#include <stdio.h>
#include <math.h>

int main() {
    // Floating point modulus
    printf("fmod(10.5, 3.0) = %f\n", fmod(10.5, 3.0));   // 1.500000
    printf("fmod(-10.5, 3.0) = %f\n", fmod(-10.5, 3.0)); // -1.500000

    // Division with remainder
    double quotient = 10.5 / 3.0;
    double remainder = fmod(10.5, 3.0);

    printf("Quotient: %f, Remainder: %f\n", quotient, remainder);

    return 0;
}
```

## Interpolation

```c
#include <stdio.h>
#include <math.h>

double lerp(double a, double b, double t) {
    return a + (b - a) * t;
}

int main() {
    double start = 0.0;
    double end = 100.0;

    printf("Interpolation:\n");
    for (double t = 0.0; t <= 1.0; t += 0.25) {
        double value = lerp(start, end, t);
        printf("t=%.2f: %.2f\n", t, value);
    }

    return 0;
}
```

## Clamping Value

```c
#include <stdio.h>
#include <math.h>

double clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
}

int main() {
    double value = 150.0;
    double clamped = clamp(value, 0.0, 100.0);

    printf("Value: %f, Clamped: %f\n", value, clamped);  // 150.000000, 100.000000

    return 0;
}
```

## Conversions

```c
#include <stdio.h>
#include <math.h>

int main() {
    // Degrees to radians
    double degrees = 180.0;
    double radians = degrees * M_PI / 180.0;
    printf("180° = %f radians\n", radians);  // 3.141593

    // Radians to degrees
    double deg = radians * 180.0 / M_PI;
    printf("%f radians = %f°\n", radians, deg);  // 3.141593, 180.000000

    return 0;
}
```

## Min and Max

```c
#include <stdio.h>
#include <math.h>

int main() {
    double a = 10.0;
    double b = 20.0;

    printf("min(%.1f, %.1f) = %.1f\n", a, b, fmin(a, b));  // 10.0
    printf("max(%.1f, %.1f) = %.1f\n", a, b, fmax(a, b));  // 20.0

    // Finding min/max in array
    double numbers[] = {5.0, 2.0, 8.0, 1.0, 9.0};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    double min_val = numbers[0];
    double max_val = numbers[0];

    for (size_t i = 1; i < size; i++) {
        min_val = fmin(min_val, numbers[i]);
        max_val = fmax(max_val, numbers[i]);
    }

    printf("Min: %.1f, Max: %.1f\n", min_val, max_val);

    return 0;
}
```

## Sign Function

```c
#include <stdio.h>
#include <math.h>

int main() {
    // Copysign - copy sign from second to first
    double result1 = copysign(5.0, -3.0);
    printf("copysign(5.0, -3.0) = %f\n", result1);  // -5.000000

    // Signum-like behavior
    double value = -42.0;
    double sign = (value > 0) - (value < 0);
    printf("sign(%f) = %f\n", value, sign);  // -1.000000

    return 0;
}
```

## Hypot - Distance from Origin

```c
#include <stdio.h>
#include <math.h>

int main() {
    // hypot(x, y) = sqrt(x*x + y*y)
    double dist = hypot(3.0, 4.0);
    printf("hypot(3, 4) = %f\n", dist);  // 5.000000

    // 3D distance
    double x = 1.0, y = 2.0, z = 3.0;
    double dist_3d = hypot(hypot(x, y), z);
    printf("3D distance: %f\n", dist_3d);  // 3.741657

    return 0;
}
```

> **Note**: Remember to link with `-lm` when compiling math functions: `gcc program.c -o program -lm`
