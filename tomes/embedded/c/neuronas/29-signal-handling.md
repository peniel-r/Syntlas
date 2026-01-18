---
id: "c.stdlib.signal"
title: "Signal Handling (signal, sigaction)"
category: stdlib
difficulty: advanced
tags: [c, signal, sigaction, interrupt, exception, async]
keywords: [signal, sigaction, SIGINT, SIGTERM, SIGSEGV]
use_cases: [graceful shutdown, cleanup, error handling]
prerequisites: ["c.stdlib.exit"]
related: ["c.stdlib.process"]
next_topics: ["c.stdlib.threads"]
---

# Signal Handling

## signal - Basic Signal Handler

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

volatile sig_atomic_t interrupted = 0;

void handle_sigint(int sig) {
    interrupted = 1;
    printf("\nReceived SIGINT\n");
}

int main() {
    // Register signal handler
    signal(SIGINT, handle_sigint);

    printf("Running... Press Ctrl+C to stop\n");

    while (!interrupted) {
        printf("Working...\n");
        sleep(1);
    }

    printf("Cleaning up...\n");

    return 0;
}
```

## Multiple Signal Handlers

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void handle_sigint(int sig) {
    printf("Received SIGINT (Ctrl+C)\n");
}

void handle_sigterm(int sig) {
    printf("Received SIGTERM\n");
}

void handle_sigusr1(int sig) {
    printf("Received SIGUSR1\n");
}

int main() {
    signal(SIGINT, handle_sigint);
    signal(SIGTERM, handle_sigterm);
    signal(SIGUSR1, handle_sigusr1);

    printf("Process ID: %d\n", getpid());
    printf("Send signals with: kill -<signal> %d\n", getpid());

    while (1) {
        sleep(1);
    }

    return 0;
}
```

## Graceful Shutdown

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

volatile sig_atomic_t keep_running = 1;

void shutdown_handler(int sig) {
    printf("\nShutting down gracefully...\n");
    keep_running = 0;
}

void cleanup(void) {
    printf("Cleaning up resources...\n");
    // Free resources, close files, etc.
}

int main() {
    signal(SIGINT, shutdown_handler);
    signal(SIGTERM, shutdown_handler);

    printf("Server started. PID: %d\n", getpid());

    while (keep_running) {
        // Server loop
        printf("Processing request...\n");
        sleep(1);
    }

    cleanup();
    printf("Shutdown complete\n");

    return 0;
}
```

## sigaction - Advanced Signal Handling

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>

void handle_signal(int sig, siginfo_t* info, void* context) {
    printf("Received signal: %d\n", sig);

    if (sig == SIGINT) {
        printf("From process: %d\n", info->si_pid);
    }
}

int main() {
    struct sigaction sa;

    // Set up signal handler
    memset(&sa, 0, sizeof(sa));
    sa.sa_sigaction = handle_signal;
    sa.sa_flags = SA_SIGINFO;

    // Register handler
    sigaction(SIGINT, &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);

    printf("Running with sigaction...\n");

    while (1) {
        sleep(1);
    }

    return 0;
}
```

## Blocking Signals

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void handle_sigint(int sig) {
    printf("SIGINT received\n");
}

int main() {
    // Block SIGINT initially
    sigset_t block_mask;
    sigemptyset(&block_mask);
    sigaddset(&block_mask, SIGINT);
    sigprocmask(SIG_BLOCK, &block_mask, NULL);

    signal(SIGINT, handle_sigint);

    printf("SIGINT blocked\n");
    sleep(2);
    printf("Sending SIGINT (blocked)\n");
    kill(getpid(), SIGINT);
    sleep(1);
    printf("Signal was blocked\n");

    // Unblock and handle pending signals
    sigprocmask(SIG_UNBLOCK, &block_mask, NULL);
    printf("SIGINT unblocked - handling pending signal\n");

    return 0;
}
```

## Signal Masking

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void handle_signal(int sig) {
    printf("Signal %d received\n", sig);
}

int main() {
    // Block multiple signals
    sigset_t mask;
    sigemptyset(&mask);
    sigaddset(&mask, SIGINT);
    sigaddset(&mask, SIGTERM);
    sigaddset(&mask, SIGUSR1);

    signal(SIGINT, handle_signal);
    signal(SIGTERM, handle_signal);
    signal(SIGUSR1, handle_signal);

    // Block signals
    sigprocmask(SIG_BLOCK, &mask, NULL);
    printf("Signals blocked\n");

    sleep(2);

    // Unblock and process
    sigprocmask(SIG_UNBLOCK, &mask, NULL);
    printf("Signals unblocked\n");

    return 0;
}
```

## Pending Signals

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void handle_signal(int sig) {
    printf("Handling signal %d\n", sig);
}

int main() {
    signal(SIGINT, handle_signal);
    signal(SIGUSR1, handle_signal);

    sigset_t mask;
    sigemptyset(&mask);
    sigaddset(&mask, SIGINT);
    sigaddset(&mask, SIGUSR1);

    sigprocmask(SIG_BLOCK, &mask, NULL);
    printf("Blocked SIGINT and SIGUSR1\n");

    // Send signals
    kill(getpid(), SIGINT);
    kill(getpid(), SIGUSR1);

    // Check pending signals
    sigset_t pending;
    sigpending(&pending);

    if (sigismember(&pending, SIGINT)) {
        printf("SIGINT is pending\n");
    }
    if (sigismember(&pending, SIGUSR1)) {
        printf("SIGUSR1 is pending\n");
    }

    sleep(1);

    // Unblock
    sigprocmask(SIG_UNBLOCK, &mask, NULL);
    printf("Unblocked - signals will be handled\n");

    return 0;
}
```

## Signal with Cleanup

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

volatile sig_atomic_t cleanup_requested = 0;
FILE* log_file = NULL;

void cleanup_handler(int sig) {
    cleanup_requested = 1;
    printf("\nCleanup requested (signal %d)\n", sig);
}

void do_cleanup(void) {
    if (log_file != NULL) {
        fprintf(log_file, "Shutdown complete\n");
        fclose(log_file);
        log_file = NULL;
    }
}

int main() {
    signal(SIGINT, cleanup_handler);
    signal(SIGTERM, cleanup_handler);

    log_file = fopen("server.log", "w");
    if (log_file == NULL) {
        return 1;
    }

    fprintf(log_file, "Server started\n");

    while (!cleanup_requested) {
        fprintf(log_file, "Processing...\n");
        fflush(log_file);
        sleep(1);
    }

    do_cleanup();
    printf("Exiting\n");

    return 0;
}
```

## Ignore Signal

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

int main() {
    // Ignore SIGINT
    signal(SIGINT, SIG_IGN);

    printf("SIGINT ignored. Press Ctrl+C to test.\n");
    printf("This will continue running...\n");

    for (int i = 0; i < 10; i++) {
        printf("Still running %d/10\n", i + 1);
        sleep(1);
    }

    printf("Finished\n");

    return 0;
}
```

## Signal with Data

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void handle_sigusr1(int sig, siginfo_t* info, void* context) {
    printf("SIGUSR1 received\n");
    printf("From PID: %d\n", info->si_pid);
    printf("UID: %d\n", info->si_uid);

    if (info->si_code == SI_QUEUE) {
        printf("User data: %d\n", info->si_value.sival_int);
    }
}

int main() {
    struct sigaction sa;
    sa.sa_sigaction = handle_sigusr1;
    sa.sa_flags = SA_SIGINFO;
    sigemptyset(&sa.sa_mask);

    sigaction(SIGUSR1, &sa, NULL);

    printf("PID: %d\n", getpid());

    union sigval value;
    value.sival_int = 42;

    // Send signal with data
    sigqueue(getpid(), SIGUSR1, value);

    sleep(1);

    return 0;
}
```

## Alarm Signal

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void handle_alarm(int sig) {
    printf("Alarm triggered after %d seconds\n", alarm(0));
}

int main() {
    signal(SIGALRM, handle_alarm);

    printf("Setting alarm for 3 seconds\n");
    alarm(3);

    while (1) {
        sleep(1);
    }

    return 0;
}
```

> **Warning**: Signal handlers should be minimal. Avoid using non-reentrant functions in signal handlers. Only set flags of type `volatile sig_atomic_t`.
