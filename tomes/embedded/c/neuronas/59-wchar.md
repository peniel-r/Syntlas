---
id: "c.stdlib.wchar"
title: "Wide Characters (wchar.h)"
category: stdlib
difficulty: intermediate
tags: [c, stdlib, wchar, wide, unicode]
keywords: [wchar, wprintf, wscanf, wcslen]
use_cases: [unicode support, international text, wide strings]
prerequisites: ["c.stdlib.string"]
related: ["c.stdlib.locale"]
next_topics: ["c.stdlib.stdio"]
---

# Wide Characters

## Basic Wide String

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    // Wide string literal
    const wchar_t* wstr = L"Hello, 世界!";

    wprintf(L"String: %ls\n", wstr);

    return 0;
}
```

## Wide Character 

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    wchar_t ch = L'A';

    // Wide character classification
    wprintf(L"Is alpha: %d\n", iswalpha(ch));
    wprintf(L"Is digit: %d\n", iswdigit(ch));
    wprintf(L"Is lower: %d\n", iswlower(ch));
    wprintf(L"Is upper: %d\n", iswupper(ch));
    wprintf(L"Is space: %d\n", iswspace(ch));

    return 0;
}
```

## Wide String Length

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* wstr = L"Hello";

    // Wide string length
    size_t len = wcslen(wstr);

    wprintf(L"Length: %zu\n", len);

    return 0;
}
```

## Wide String Copy

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* src = L"Hello, 世界!";
    wchar_t dest[100];

    // Wide string copy
    wcscpy(dest, src);

    wprintf(L"Copied: %ls\n", dest);

    return 0;
}
```

## Wide String Concatenation

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* str1 = L"Hello, ";
    const wchar_t* str2 = L"世界!";

    wchar_t dest[100];

    // Wide string concatenation
    wcscpy(dest, str1);
    wcscat(dest, str2);

    wprintf(L"Concatenated: %ls\n", dest);

    return 0;
}
```

## Wide String Comparison

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* str1 = L"hello";
    const wchar_t* str2 = L"world";

    // Wide string comparison
    int cmp = wcscmp(str1, str2);

    wprintf(L"Comparison result: %d\n", cmp);

    if (cmp < 0) {
        wprintf(L"'%ls' comes before '%ls'\n", str1, str2);
    } else if (cmp > 0) {
        wprintf(L"'%ls' comes after '%ls'\n", str1, str2);
    } else {
        wprintf(L"Strings are equal\n");
    }

    return 0;
}
```

## Wide String Search

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* haystack = L"Hello, 世界!";
    const wchar_t* needle = L"世界";

    // Wide string search
    const wchar_t* result = wcsstr(haystack, needle);

    if (result != NULL) {
        wprintf(L"Found at position: %td\n", result - haystack);
    } else {
        wprintf(L"Not found\n");
    }

    return 0;
}
```

## Wide Character Conversion

```c
#include <stdio.h>
#include <wchar.h>
#include <locale.h>

int main() {
    // Set locale for wide character support
    setlocale(LC_ALL, "en_US.UTF-8");

    // Narrow to wide
    const char* narrow = "Hello";
    wchar_t wide[100];

    size_t len = mbstowcs(wide, narrow, 100);
    wide[len] = L'\0';

    wprintf(L"Wide string: %ls\n", wide);

    // Wide to narrow
    char narrow_out[100];
    len = wcstombs(narrow_out, wide, 100);

    if (len != (size_t)-1) {
        printf("Narrow string: %s\n", narrow_out);
    }

    return 0;
}
```

## Wide Case Conversion

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* str = L"Hello, 世界!";

    wchar_t lower[100];
    wchar_t upper[100];

    // Convert to lowercase
    for (int i = 0; str[i] != L'\0'; i++) {
        lower[i] = towlower(str[i]);
    }
    lower[wcslen(str)] = L'\0';

    // Convert to uppercase
    for (int i = 0; str[i] != L'\0'; i++) {
        upper[i] = towupper(str[i]);
    }
    upper[wcslen(str)] = L'\0';

    wprintf(L"Lowercase: %ls\n", lower);
    wprintf(L"Uppercase: %ls\n", upper);

    return 0;
}
```

## Wide String Tokenization

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* str = L"apple,banana,cherry";

    wchar_t* token;
    const wchar_t* delim = L",";

    // Wide string tokenization
    token = wcstok(str, delim);

    int count = 1;
    wprintf(L"Token %d: %ls\n", count++, token);

    while ((token = wcstok(NULL, delim)) != NULL) {
        wprintf(L"Token %d: %ls\n", count++, token);
    }

    return 0;
}
```

## Wide String Formatting

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* name = L"Alice";
    int age = 30;

    // Wide string formatting
    wprintf(L"Name: %ls, Age: %d\n", name, age);

    return 0;
}
```

## Wide File I/O

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* filename = L"wide_data.txt";

    // Write wide string to file
    FILE* file = _wfopen(filename, L"w, ccs=UTF-8");

    if (file == NULL) {
        fwprintf(stderr, L"Failed to open file\n");
        return 1;
    }

    fwprintf(file, L"Hello, 世界!\n");
    fclose(file);

    // Read wide string from file
    file = _wfopen(filename, L"r, ccs=UTF-8");

    if (file == NULL) {
        fwprintf(stderr, L"Failed to open file\n");
        return 1;
    }

    wchar_t buffer[256];
    while (fgetws(buffer, 256, file) != NULL) {
        wprintf(L"Read: %ls", buffer);
    }

    fclose(file);

    return 0;
}
```

## Wide Character Input

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    wprintf(L"Enter a wide string: ");

    wchar_t input[100];
    if (fgetws(input, 100, stdin) != NULL) {
        wprintf(L"You entered: %ls", input);
    }

    return 0;
}
```

## Wide String Manipulation

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* str = L"Hello, 世界!";

    // Wide string substring
    wchar_t substr[100];
    wcsncpy(substr, str + 7, 2);
    substr[2] = L'\0';

    wprintf(L"Substring: %ls\n", substr);

    // Find character
    const wchar_t* pos = wcschr(str, L'世');

    if (pos != NULL) {
        wprintf(L"Position: %td\n", pos - str);
    }

    // Find last character
    pos = wcsrchr(str, L'!');

    if (pos != NULL) {
        wprintf(L"Last '!' position: %td\n", pos - str);
    }

    return 0;
}
```

## Wide String Comparison (Locale-Aware)

```c
#include <stdio.h>
#include <wchar.h>
#include <locale.h>

int main() {
    // Set locale for collation
    setlocale(LC_ALL, "en_US.UTF-8");

    const wchar_t* str1 = L"café";
    const wchar_t* str2 = L"cafe";

    // Locale-aware comparison
    int cmp = wcscoll(str1, str2);

    wprintf(L"Collation result: %d\n", cmp);

    return 0;
}
```

## Wide String Copy with Length

```c
#include <stdio.h>
#include <wchar.h>

int main() {
    const wchar_t* src = L"Hello, 世界!";
    wchar_t dest[100];

    // Safe wide string copy
    size_t len = wcslen(src);
    if (len >= 100) {
        len = 99;
    }

    wcsncpy(dest, src, len);
    dest[len] = L'\0';

    wprintf(L"Copied: %ls\n", dest);

    return 0;
}
```

> **Note**: Wide characters support Unicode. Use wchar_t  for internationalization. Set locale for proper behavior.
