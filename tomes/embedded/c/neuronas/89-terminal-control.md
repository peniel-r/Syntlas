---
id: 89-terminal-control
title: Terminal Control
category: system
difficulty: advanced
tags:
  - terminal
  - ansi-codes
  - termios
  - ncurses
keywords:
  - terminal
  - ANSI escape codes
  - termios
  - ncurses
  - terminal control
use_cases:
  - TUI applications
  - Terminal programs
  - Interactive CLI tools
  - Terminal output formatting
prerequisites:
  - file-operations
  - strings
related:
  - stdio
  - file-descriptors
next_topics:
  - configuration-parsing
---

# Terminal Control

Terminal control enables advanced text output and input handling in terminal applications.

## ANSI Escape Codes

```c
#include <stdio.h>

int main(void) {
    // Clear screen
    printf("\033[2J");

    // Move cursor to home position (1,1)
    printf("\033[H");

    // Move cursor to specific position (row, column)
    printf("\033[10;20H");  // Row 10, Column 20

    // Save and restore cursor position
    printf("\033[s");  // Save
    printf("\033[u");  // Restore

    // Text colors
    printf("\033[31mRed text\033[0m\n");
    printf("\033[32mGreen text\033[0m\n");
    printf("\033[33mYellow text\033[0m\n");
    printf("\033[34mBlue text\033[0m\n");
    printf("\033[35mMagenta text\033[0m\n");
    printf("\033[36mCyan text\033[0m\n");
    printf("\033[37mWhite text\033[0m\n");

    // Background colors
    printf("\033[41mRed background\033[0m\n");
    printf("\033[42mGreen background\033[0m\n");
    printf("\033[44mBlue background\033[0m\n");

    // Text attributes
    printf("\033[1mBold text\033[0m\n");
    printf("\033[4mUnderlined text\033[0m\n");
    printf("\033[5mBlinking text\033[0m\n");
    printf("\033[7mReversed text\033[0m\n");

    return 0;
}
```

## Cursor Control

```c
#include <stdio.h>
#include <unistd.h>

void clear_screen(void) {
    printf("\033[2J");
    printf("\033[H");  // Move cursor to home
}

void move_cursor(int row, int col) {
    printf("\033[%d;%dH", row, col);
}

void clear_line(void) {
    printf("\033[K");  // Clear to end of line
}

void clear_from_cursor(void) {
    printf("\033[0J");  // Clear from cursor to end of screen
}

void save_cursor(void) {
    printf("\033[s");
}

void restore_cursor(void) {
    printf("\033[u");
}

int main(void) {
    clear_screen();

    move_cursor(5, 10);
    printf("Positioned at row 5, column 10\n");

    save_cursor();
    move_cursor(10, 20);
    printf("Temporary position\n");
    restore_cursor();
    printf("Back to saved position\n");

    move_cursor(15, 1);
    clear_line();

    return 0;
}
```

## Progress Bar

```c
#include <stdio.h>
#include <unistd.h>

void print_progress_bar(int percent, int width) {
    printf("\r[");

    int filled = (percent * width) / 100;
    for (int i = 0; i < width; i++) {
        if (i < filled) {
            printf("=");
        } else {
            printf(" ");
        }
    }

    printf("] %d%%", percent);
    fflush(stdout);
}

int main(void) {
    printf("Processing...\n");

    for (int i = 0; i <= 100; i++) {
        print_progress_bar(i, 50);
        usleep(50000);  // 50ms delay
    }

    printf("\nComplete!\n");
    return 0;
}
```

## Password Input (Hidden)

```c
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <string.h>

void get_password(char *password, int max_length) {
    struct termios old, new;

    // Get current terminal settings
    tcgetattr(STDIN_FILENO, &old);
    new = old;

    // Disable echo
    new.c_lflag &= ~ECHO;

    // Apply new settings
    tcsetattr(STDIN_FILENO, TCSANOW, &new);

    // Read password
    int i = 0;
    char c;
    while (i < max_length - 1 && read(STDIN_FILENO, &c, 1) > 0) {
        if (c == '\n' || c == '\r') {
            break;
        }
        password[i++] = c;
    }
    password[i] = '\0';

    // Restore original settings
    tcsetattr(STDIN_FILENO, TCSANOW, &old);
}

int main(void) {
    char password[50];

    printf("Enter password: ");
    get_password(password, sizeof(password));

    printf("\nPassword entered (length: %zu)\n", strlen(password));

    return 0;
}
```

## Raw Mode (Keypress Detection)

```c
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>

void set_raw_mode(int enable) {
    static struct termios orig;
    static int saved = 0;

    if (enable) {
        struct termios raw;

        // Save original settings
        tcgetattr(STDIN_FILENO, &orig);
        saved = 1;

        raw = orig;
        raw.c_lflag &= ~(ICANON | ECHO);
        raw.c_cc[VMIN] = 1;
        raw.c_cc[VTIME] = 0;

        tcsetattr(STDIN_FILENO, TCSANOW, &raw);
    } else if (saved) {
        // Restore original settings
        tcsetattr(STDIN_FILENO, TCSANOW, &orig);
    }
}

int main(void) {
    printf("Press any key (q to quit)...\n");

    set_raw_mode(1);

    char c;
    while (read(STDIN_FILENO, &c, 1) > 0) {
        if (c == 'q' || c == 'Q') {
            break;
        }
        printf("Key pressed: %c (ASCII: %d)\n", c, c);
    }

    set_raw_mode(0);
    printf("\nExiting...\n");

    return 0;
}
```

## Terminal Size Detection

```c
#include <stdio.h>
#include <sys/ioctl.h>
#include <unistd.h>

void get_terminal_size(int *rows, int *cols) {
    struct winsize ws;

    if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == -1) {
        *rows = 24;  // Default values
        *cols = 80;
    } else {
        *rows = ws.ws_row;
        *cols = ws.ws_col;
    }
}

int main(void) {
    int rows, cols;

    get_terminal_size(&rows, &cols);
    printf("Terminal size: %d rows x %d columns\n", rows, cols);

    return 0;
}
```

## Menu System

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

typedef struct {
    const char *title;
    int count;
    const char *items[10];
    int selected;
} Menu;

void menu_render(Menu *menu) {
    printf("\033[2J\033[H");  // Clear screen

    printf("%s\n\n", menu->title);

    for (int i = 0; i < menu->count; i++) {
        if (i == menu->selected) {
            printf("\033[7m> %s\033[0m\n", menu->items[i]);
        } else {
            printf("  %s\n", menu->items[i]);
        }
    }

    printf("\nUse arrow keys to navigate, Enter to select, q to quit");
}

void menu_run(Menu *menu) {
    struct termios old, new;

    // Set raw mode
    tcgetattr(STDIN_FILENO, &old);
    new = old;
    new.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &new);

    while (1) {
        menu_render(menu);

        char c;
        read(STDIN_FILENO, &c, 1);

        if (c == '\033') {  // Escape sequence
            read(STDIN_FILENO, &c, 1);  // '['
            read(STDIN_FILENO, &c, 1);  // Direction

            if (c == 'A') {  // Up
                if (menu->selected > 0) {
                    menu->selected--;
                }
            } else if (c == 'B') {  // Down
                if (menu->selected < menu->count - 1) {
                    menu->selected++;
                }
            }
        } else if (c == '\n' || c == '\r') {
            // Enter - return selection
            tcsetattr(STDIN_FILENO, TCSANOW, &old);
            return;
        } else if (c == 'q' || c == 'Q') {
            menu->selected = -1;  // Quit
            tcsetattr(STDIN_FILENO, TCSANOW, &old);
            return;
        }
    }
}

int main(void) {
    Menu menu = {
        .title = "Main Menu",
        .count = 4,
        .items = {"Option 1", "Option 2", "Option 3", "Exit"},
        .selected = 0
    };

    menu_run(&menu);

    if (menu.selected >= 0) {
        printf("\nSelected: %s\n", menu.items[menu.selected]);
    } else {
        printf("\nQuitted\n");
    }

    return 0;
}
```

## Terminal Colors Helper

```c
#include <stdio.h>

// Color codes
#define COLOR_RED     "\033[31m"
#define COLOR_GREEN   "\033[32m"
#define COLOR_YELLOW  "\033[33m"
#define COLOR_BLUE    "\033[34m"
#define COLOR_MAGENTA "\033[35m"
#define COLOR_CYAN    "\033[36m"
#define COLOR_WHITE   "\033[37m"
#define COLOR_RESET   "\033[0m"

void print_success(const char *msg) {
    printf(COLOR_GREEN "[SUCCESS]" COLOR_RESET " %s\n", msg);
}

void print_error(const char *msg) {
    printf(COLOR_RED "[ERROR]" COLOR_RESET " %s\n", msg);
}

void print_warning(const char *msg) {
    printf(COLOR_YELLOW "[WARNING]" COLOR_RESET " %s\n", msg);
}

void print_info(const char *msg) {
    printf(COLOR_CYAN "[INFO]" COLOR_RESET " %s\n", msg);
}

int main(void) {
    print_success("Operation completed successfully");
    print_error("An error occurred");
    print_warning("This is a warning");
    print_info("Information message");

    return 0;
}
```

## Best Practices

### Always Reset Colors

```c
// GOOD - Reset after color change
printf("\033[31mRed text\033[0m");
printf("Normal text\n");

// BAD - Forgetting to reset
printf("\033[31mRed text");
printf("This is also red!\n");
```

### Check Terminal Support

```c
// Check if terminal supports colors
if (getenv("TERM") != NULL) {
    printf("\033[31mColored text\033[0m\n");
} else {
    printf("Plain text\n");
}
```

### Restore Terminal Settings

```c
// Always restore original settings
struct termios orig;
tcgetattr(STDIN_FILENO, &orig);

// Make changes
// ...

// Restore
tcsetattr(STDIN_FILENO, TCSANOW, &orig);
```

## Common Pitfalls

### 1. Not Resetting Colors

```c
// WRONG - Color bleeds to next output
printf("\033[31mError: ");
printf("This is also red!\n");

// CORRECT - Reset after color
printf("\033[31mError: \033[0m");
printf("Normal text\n");
```

### 2. Not Restoring Terminal

```c
// WRONG - Terminal left in raw mode
set_raw_mode(1);
// Program exits, terminal is broken!

// CORRECT - Always restore
set_raw_mode(1);
// Do work...
set_raw_mode(0);
```

### 3. Assuming Terminal Size

```c
// WRONG - Hardcoded terminal size
printf("\033[50;10H");  // Might be out of bounds

// CORRECT - Get actual size
int rows, cols;
get_terminal_size(&rows, &cols);
printf("\033[%d;%dH", rows / 2, cols / 2);
```

> **Note: Terminal control can make your programs more user-friendly but requires careful handling. Always reset colors and restore terminal settings. Check for terminal capabilities. Consider using libraries like ncurses for complex terminal UIs.
