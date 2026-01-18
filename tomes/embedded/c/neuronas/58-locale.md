---
id: "c.stdlib.locale"
title: "Localization (setlocale, localeconv)"
category: stdlib
difficulty: intermediate
tags: [c, stdlib, locale, internationalization, i18n]
keywords: [setlocale, localeconv, locale, i18n, localization]
use_cases: [internationalization, currency formatting, date formatting]
prerequisites: []
related: ["c.stdlib.time"]
next_topics: ["c.stdlib.wchar"]
---

# Localization

## setlocale - Set Locale

```c
#include <stdio.h>
#include <locale.h>

int main() {
    // Set locale to system default
    setlocale(LC_ALL, "");

    // Set specific categories
    setlocale(LC_TIME, "C");
    setlocale(LC_MONETARY, "en_US.UTF-8");

    printf("Locale: %s\n", setlocale(LC_ALL, NULL));

    return 0;
}
```

## Locale Information

```c
#include <stdio.h>
#include <locale.h>

void print_locale_info(void) {
    const char* locale = setlocale(LC_ALL, NULL);
    printf("Current locale: %s\n", locale);

    // Print specific categories
    printf("  LC_CTYPE: %s\n", setlocale(LC_CTYPE, NULL));
    printf("  LC_NUMERIC: %s\n", setlocale(LC_NUMERIC, NULL));
    printf("  LC_TIME: %s\n", setlocale(LC_TIME, NULL));
    printf("  LC_COLLATE: %s\n", setlocale(LC_COLLATE, NULL));
    printf("  LC_MONETARY: %s\n", setlocale(LC_MONETARY, NULL));
    printf("  LC_MESSAGES: %s\n", setlocale(LC_MESSAGES, NULL));
}

int main() {
    setlocale(LC_ALL, "");
    print_locale_info();

    return 0;
}
```

## localeconv - Numeric Formatting

```c
#include <stdio.h>
#include <locale.h>

void print_numeric_formatting(void) {
    struct lconv* lc = localeconv();

    printf("Numeric formatting:\n");
    printf("  Decimal point: '%s'\n", lc->decimal_point);
    printf("  Thousands separator: '%s'\n", lc->thousands_sep);
    printf("  Grouping: %d\n", lc->grouping);
}

int main() {
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    print_numeric_formatting();

    return 0;
}
```

## Currency Formatting

```c
#include <stdio.h>
#include <locale.h>

void print_currency_formatting(void) {
    struct lconv* lc = localeconv();

    printf("Currency formatting:\n");
    printf("  Currency symbol: %s\n", lc->currency_symbol);
    printf("  Int'l currency symbol: %s\n", lc->int_curr_symbol);
    printf("  Monetary decimal point: %s\n", lc->mon_decimal_point);
    printf("  Monetary thousands separator: %s\n", lc->mon_thousands_sep);
    printf("  Positive sign: %s\n", lc->positive_sign);
    printf("  Negative sign: %s\n", lc->negative_sign);
}

int main() {
    setlocale(LC_MONETARY, "en_US.UTF-8");
    print_currency_formatting();

    return 0;
}
```

## Format Currency

```c
#include <stdio.h>
#include <locale.h>

char* format_currency(double amount, const char* locale_name) {
    static char buffer[100];

    setlocale(LC_MONETARY, locale_name);

    struct lconv* lc = localeconv();
    char* curr_sym = lc->currency_symbol;
    char* dec_point = lc->mon_decimal_point;
    char* thousands_sep = lc->mon_thousands_sep;

    // Simplified formatting
    snprintf(buffer, sizeof(buffer), "%s%.2f", curr_sym, amount);

    return buffer;
}

int main() {
    printf("%s\n", format_currency(1234.56, "en_US.UTF-8"));
    printf("%s\n", format_currency(1234.56, "de_DE.UTF-8"));

    return 0;
}
```

## Date Formatting by Locale

```c
#include <stdio.h>
#include <locale.h>
#include <time.h>

void print_formatted_date(const char* locale_name) {
    setlocale(LC_TIME, locale_name);

    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    char buffer[80];
    strftime(buffer, sizeof(buffer), "%c", local);

    printf("Date in %s: %s\n", locale_name, buffer);
}

int main() {
    print_formatted_date("en_US.UTF-8");
    print_formatted_date("de_DE.UTF-8");
    print_formatted_date("fr_FR.UTF-8");

    return 0;
}
```

## Character Classification by Locale

```c
#include <stdio.h>
#include <locale.h>
#include <ctype.h>

void test_characters_by_locale(const char* locale_name) {
    setlocale(LC_CTYPE, locale_name);

    printf("Testing locale: %s\n", locale_name);
    printf("  Is 'a' alpha? %d\n", isalpha('a'));
    printf("  Is '1' digit? %d\n", isdigit('1'));
    printf("  Is ' ' space? %d\n", isspace(' '));
}

int main() {
    test_characters_by_locale("en_US.UTF-8");
    test_characters_by_locale("C");

    return 0;
}
```

## String Comparison by Locale

```c
#include <stdio.h>
#include <locale.h>
#include <wchar.h>

void compare_strings_by_locale(const char* s1, const char* s2,
                              const char* locale_name) {
    setlocale(LC_COLLATE, locale_name);

    int result = strcoll(s1, s2);

    printf("'%s' vs '%s' in %s: %d\n", s1, s2, locale_name, result);

    if (result == 0) {
        printf("  Strings are equal\n");
    } else if (result < 0) {
        printf("  '%s' comes before '%s'\n", s1, s2);
    } else {
        printf("  '%s' comes after '%s'\n", s1, s2);
    }
}

int main() {
    compare_strings_by_locale("apple", "banana", "en_US.UTF-8");
    compare_strings_by_locale("strass", "straße", "de_DE.UTF-8");

    return 0;
}
```

## Number Formatting

```c
#include <stdio.h>
#include <locale.h>

void print_formatted_number(double number, const char* locale_name) {
    setlocale(LC_NUMERIC, locale_name);

    struct lconv* lc = localeconv();

    char buffer[100];
    snprintf(buffer, sizeof(buffer), "%.2f", number);

    printf("Number %s in %s: %s\n", locale_name, number, buffer);
}

int main() {
    print_formatted_number(1234567.89, "en_US.UTF-8");
    print_formatted_number(1234567.89, "de_DE.UTF-8");
    print_formatted_number(1234567.89, "fr_FR.UTF-8");

    return 0;
}
```

## Available Locales

```c
#include <stdio.h>
#include <locale.h>

void list_available_locales(void) {
    printf("Available locales:\n");

    const char* locales[] = {
        "C",
        "POSIX",
        "en_US.UTF-8",
        "en_GB.UTF-8",
        "de_DE.UTF-8",
        "fr_FR.UTF-8",
        "es_ES.UTF-8",
        "it_IT.UTF-8",
        "ja_JP.UTF-8",
        "zh_CN.UTF-8"
    };

    for (int i = 0; i < 11; i++) {
        const char* result = setlocale(LC_CTYPE, locales[i]);

        if (strcmp(result, locales[i]) == 0) {
            printf("  %s - Available\n", locales[i]);
        } else {
            printf("  %s - Not available\n", locales[i]);
        }

        setlocale(LC_CTYPE, "");  // Reset
    }
}

int main() {
    list_available_locales();

    return 0;
}
```

## Locale-Aware String Copy

```c
#include <stdio.h>
#include <locale.h>
#include <wchar.h>

void locale_aware_copy(const char* src, char* dst, size_t max_len,
                       const char* locale_name) {
    setlocale(LC_CTYPE, locale_name);

    size_t i = 0;

    while (i < max_len - 1 && src[i] != '\0') {
        dst[i] = src[i];
        i++;
    }

    dst[i] = '\0';
}

int main() {
    const char* src = "Héllo, Wörld!";
    char dst[100];

    locale_aware_copy(src, dst, sizeof(dst), "en_US.UTF-8");
    printf("Copied: %s\n", dst);

    return 0;
}
```

## Check Locale Support

```c
#include <stdio.h>
#include <locale.h>

void check_locale_support(const char* locale_name) {
    printf("Checking locale: %s\n", locale_name);

    const char* ctype = setlocale(LC_CTYPE, locale_name);
    if (strcmp(ctype, locale_name) != 0) {
        printf("  LC_CTYPE: Not supported\n");
    } else {
        printf("  LC_CTYPE: Supported\n");
    }

    setlocale(LC_CTYPE, "C");

    const char* numeric = setlocale(LC_NUMERIC, locale_name);
    if (strcmp(numeric, locale_name) != 0) {
        printf("  LC_NUMERIC: Not supported\n");
    } else {
        printf("  LC_NUMERIC: Supported\n");
    }

    setlocale(LC_NUMERIC, "C");

    const char* time = setlocale(LC_TIME, locale_name);
    if (strcmp(time, locale_name) != 0) {
        printf("  LC_TIME: Not supported\n");
    } else {
        printf("  LC_TIME: Supported\n");
    }

    setlocale(LC_TIME, "C");
}

int main() {
    check_locale_support("en_US.UTF-8");
    check_locale_support("invalid_locale");

    return 0;
}
```

## Environment Variable for Locale

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Read LANG environment variable
    const char* lang = getenv("LANG");

    if (lang != NULL) {
        printf("LANG: %s\n", lang);

        // Set locale from environment
        setlocale(LC_ALL, lang);

        printf("Locale set from LANG\n");
    } else {
        printf("LANG not set\n");

        // Set default locale
        setlocale(LC_ALL, "C");
    }

    return 0;
}
```

> **Note**: Locale affects string collation, number formatting, and date/time formatting. Always reset to "C" when needed.
