---
id: "c.algorithms.numeric"
title: "Numeric Algorithms"
category: c.algorithms.sorting
difficulty: intermediate
tags: [c, c.algorithms.sorting, numeric, math, gcd, lcm]
keywords: [gcd, lcm, prime, modular, arithmetic]
use_cases: [number theory, cryptography, c.algorithms.sorting]
prerequisites: [c.stdlib.math]
related: [c.algorithms.greedy]
next_topics: [c.algorithms.combinatorics]
---

# Numeric c.algorithms.sorting

## GCD (Greatest Common Divisor)

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
    printf("GCD(48, 18) = %d\n", gcd(48, 18));
    printf("GCD(17, 23) = %d\n", gcd(17, 23));

    return 0;
}
```

## LCM (Least Common Multiple)

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

int lcm(int a, int b) {
    return (a * b) / gcd(a, b);
}

int main() {
    printf("LCM(4, 6) = %d\n", lcm(4, 6));
    printf("LCM(5, 10) = %d\n", lcm(5, 10));

    return 0;
}
```

## Prime Number Check

```c
#include <stdio.h>
#include <stdbool.h>
#include <math.h>

bool is_prime(int n) {
    if (n <= 1) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;

    for (int i = 3; i <= sqrt(n); i += 2) {
        if (n % i == 0) {
            return false;
        }
    }

    return true;
}

int main() {
    for (int i = 1; i <= 20; i++) {
        printf("%2d: %s\n", i, is_prime(i) ? "prime" : "composite");
    }

    return 0;
}
```

## Sieve of Eratosthenes

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

void sieve_of_eratosthenes(int n) {
    bool* is_prime = (bool*)malloc((n + 1) * sizeof(bool));

    for (int i = 0; i <= n; i++) {
        is_prime[i] = true;
    }

    is_prime[0] = is_prime[1] = false;

    for (int p = 2; p * p <= n; p++) {
        if (is_prime[p]) {
            for (int i = p * p; i <= n; i += p) {
                is_prime[i] = false;
            }
        }
    }

    printf("Prime numbers up to %d:\n", n);
    for (int i = 2; i <= n; i++) {
        if (is_prime[i]) {
            printf("%d ", i);
        }
    }
    printf("\n");

    free(is_prime);
}

int main() {
    sieve_of_eratosthenes(50);

    return 0;
}
```

## Prime Factorization

```c
#include <stdio.h>
#include <stdlib.h>

void prime_factors(int n) {
    printf("Prime factors of %d: ", n);

    while (n % 2 == 0) {
        printf("2 ");
        n /= 2;
    }

    for (int i = 3; i <= sqrt(n); i += 2) {
        while (n % i == 0) {
            printf("%d ", i);
            n /= i;
        }
    }

    if (n > 2) {
        printf("%d", n);
    }

    printf("\n");
}

int main() {
    prime_factors(100);
    prime_factors(17);
    prime_factors(13);

    return 0;
}
```

## Modular Arithmetic

```c
#include <stdio.h>

int mod_add(int a, int b, int m) {
    return ((a % m) + (b % m)) % m;
}

int mod_mult(int a, int b, int m) {
    return ((a % m) * (b % m)) % m;
}

int mod_pow(int base, int exp, int mod) {
    if (exp == 0) return 1 % mod;

    int result = 1;
    base = base % mod;

    while (exp > 0) {
        if (exp % 2 == 1) {
            result = mod_mult(result, base, mod);
        }

        exp /= 2;
        base = mod_mult(base, base, mod);
    }

    return result;
}

int main() {
    printf("(5 + 7) mod 3 = %d\n", mod_add(5, 7, 3));
    printf("(5 * 7) mod 3 = %d\n", mod_mult(5, 7, 3));
    printf("5^7 mod 13 = %d\n", mod_pow(5, 7, 13));

    return 0;
}
```

## Modular Inverse

```c
#include <stdio.h>

int mod_inverse(int a, int m) {
    int m0 = m;
    int x0 = 0;
    int x1 = 1;

    if (m == 1) return 0;

    while (a > 1) {
        int q = a / m;
        int t = m;

        m = a % m;
        a = t;
        t = x0;
        x0 = x1 - q * x0;
        x1 = t;
    }

    if (x1 < 0) {
        x1 += m0;
    }

    return x1;
}

int main() {
    int a = 3, m = 11;
    int inv = mod_inverse(a, m);

    if (inv == -1) {
        printf("No inverse exists\n");
    } else {
        printf("Inverse of %d mod %d = %d\n", a, m, inv);
    printf("Check: (%d * %d) mod %d = %d\n", a, inv, m, (a * inv) % m);
    }

    return 0;
}
```

## Chinese Remainder Theorem

```c
#include <stdio.h>

int mod_inverse(int a, int m) {
    int m0 = m;
    int x0 = 0;
    int x1 = 1;

    if (m == 1) return 0;

    while (a > 1) {
        int q = a / m;
        int t = m;

        m = a % m;
        a = t;
        t = x0;
        x0 = x1 - q * x0;
        x1 = t;
    }

    if (x1 < 0) {
        x1 += m0;
    }

    return x1;
}

int crt(int* a, int* m, int n) {
    int result = a[0];
    int prod = m[0];

    for (int i = 1; i < n; i++) {
        int inv = mod_inverse(prod, m[i]);
        result += (a[i] - result) * inv * prod;
        prod *= m[i];
        result %= prod;
    }

    return result;
}

int main() {
    int a[] = {2, 3, 2};
    int m[] = {3, 5, 7};
    int n = 3;

    int result = crt(a, m, n);

    printf("Solution: %d\n", result);

    return 0;
}
```

## Euclidean Algorithm

```c
#include <stdio.h>

typedef struct {
    int x;
    int y;
    int gcd;
} ExtendedGCD;

ExtendedGCD extended_gcd(int a, int b) {
    if (a == 0) {
        return (ExtendedGCD){0, 1, b};
    }

    ExtendedGCD eg = extended_gcd(b % a, a);

    int x = eg.y - (b / a) * eg.x;
    int y = eg.x;

    return (ExtendedGCD){x, y, eg.gcd};
}

int main() {
    int a = 48, b = 18;

    ExtendedGCD result = extended_gcd(a, b);

    printf("Extended GCD(%d, %d):\n", a, b);
    printf("  GCD: %d\n", result.gcd);
    printf("  x: %d (%d*%d + %d*%d = %d)\n", result.x, result.x, a, result.y, b, result.gcd);
    printf("  y: %d\n", result.y);

    return 0;
}
```

## Absolute Value

```c
#include <stdio.h>

int my_abs(int x) {
    return x < 0 ? -x : x;
}

long long my_abs_ll(long long x) {
    return x < 0 ? -x : x;
}

double my_abs_double(double x) {
    return x < 0.0 ? -x : x;
}

int main() {
    printf("|-5| = %d\n", my_abs(-5));
    printf("|-123456789| = %lld\n", my_abs_ll(-123456789LL));
    printf("|-3.14| = %.2f\n", my_abs_double(-3.14));

    return 0;
}
```

## Rounding 

```c
#include <stdio.h>
#include <math.h>

int round_half_up(double x) {
    return (int)floor(x + 0.5);
}

int round_half_down(double x) {
    return (int)ceil(x - 0.5);
}

int round_towards_zero(double x) {
    return x >= 0.0 ? (int)floor(x) : (int)ceil(x);
}

int round_half_to_even(double x) {
    if (x < 0.0) {
        return (int)round_half_to_even(-x) * -1);
    }

    int i = (int)floor(x);
    double diff = x - (double)i;

    if (diff < 0.5) {
        return i;
    } else if (diff > 0.5) {
        return i + 1;
    } else {
        return i % 2 == 0 ? i : i + 1;
    }
}

int main() {
    printf("round_half_up(2.3) = %d\n", round_half_up(2.3));
    printf("round_half_down(2.7) = %d\n", round_half_down(2.7));
    printf("round_towards_zero(-2.7) = %d\n", round_towards_zero(-2.7));
    printf("round_half_to_even(2.5) = %d\n", round_half_to_even(2.5));

    return 0;
}
```

## Power Function

```c
#include <stdio.h>

double power(double base, int exp) {
    if (exp == 0) return 1.0;
    if (base == 0.0) return 0.0;

    double result = 1.0;
    bool negative_exp = exp < 0;

    if (negative_exp) {
        exp = -exp;
    }

    while (exp > 0) {
        if (exp % 2 == 1) {
            result *= base;
        }
        base *= base;
        exp /= 2;
    }

    return negative_exp ? 1.0 / result : result;
}

int main() {
    printf("2^10 = %.0f\n", power(2, 10));
    printf("3^-3 = %.4f\n", power(3, -3));
    printf("5^0 = %.0f\n", power(5, 0));

    return 0;
}
```

## Integer Square Root

```c
#include <stdio.h>

int isqrt(int n) {
    if (n < 0) return -1;

    int x = n;
    int y = (x + 1) / 2;

    while (y < x) {
        x = y;
        y = (x + n / x) / 2;
    }

    return x;
}

int main() {
    printf("isqrt(16) = %d\n", isqrt(16));
    printf("isqrt(17) = %d\n", isqrt(17));
    printf("isqrt(25) = %d\n", isqrt(25));

    return 0;
}
```

## Digit Sum

```c
#include <stdio.h>

int digit_sum(int n) {
    int sum = 0;
    n = n < 0 ? -n : n;  // Handle negative numbers

    while (n != 0) {
        sum += n % 10;
        n /= 10;
    }

    return sum;
}

int main() {
    printf("Digit sum of 12345 = %d\n", digit_sum(12345));
    printf("Digit sum of -987 = %d\n", digit_sum(-987));

    return 0;
}
```

## Digit Reverse

```c
#include <stdio.h>

int reverse_number(int n) {
    int reversed = 0;
    int sign = n < 0 ? -1 : 1;
    n = n < 0 ? -n : n;

    while (n != 0) {
        reversed = reversed * 10 + n % 10;
        n /= 10;
    }

    return sign * reversed;
}

int main() {
    printf("Reverse of 12345 = %d\n", reverse_number(12345));
    printf("Reverse of -6789 = %d\n", reverse_number(-6789));

    return 0;
}
```

> **Note**: Numeric c.algorithms.sorting require careful handling of edge cases (negative numbers, overflow, division by zero).
