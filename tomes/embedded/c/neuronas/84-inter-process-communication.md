---
id: "c.ipc.main"
title: Inter-Process Communication
category: system
difficulty: advanced
tags:
  - ipc
  - pipes
  - shared-memory
  - message-queues
keywords:
  - IPC
  - pipes
  - shared memory
  - message queues
  - semaphores
use_cases:
  - Process coordination
  - Data sharing
  - c.ipc.sync
  - Communication
prerequisites:
  - 
  - 
  - 
related:
  - 
  - c.ipc.sync
next_topics:
  - c.stdlib.signal
---

# Inter-Process Communication (IPC)

IPC allows separate processes to communicate and synchronize with each other.

## Anonymous Pipes

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(void) {
    int pipefd[2];
    pid_t pid;
    char write_msg[] = "Hello from parent!";
    char read_msg[100];

    // Create pipe
    if (pipe(pipefd) == -1) {
        perror("Pipe failed");
        return 1;
    }

    // Fork process
    pid = fork();

    if (pid == 0) {
        // Child process - read from pipe
        close(pipefd[1]);  // Close write end

        read(pipefd[0], read_msg, sizeof(read_msg));
        printf("Child received: %s\n", read_msg);

        close(pipefd[0]);
    } else {
        // Parent process - write to pipe
        close(pipefd[0]);  // Close read end

        write(pipefd[1], write_msg, strlen(write_msg) + 1);
        printf("Parent sent: %s\n", write_msg);

        close(pipefd[1]);
        wait(NULL);
    }

    return 0;
}
```

## Named Pipes (FIFO)

```c
// writer.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define FIFO_NAME "/tmp/myfifo"

int main(void) {
    int fd;
    char message[] = "Hello through FIFO!";

    // Create named pipe
    mkfifo(FIFO_NAME, 0666);

    // Open for writing (blocks until reader opens)
    fd = open(FIFO_NAME, O_WRONLY);
    if (fd == -1) {
        perror("Open failed");
        return 1;
    }

    // Write message
    write(fd, message, sizeof(message));
    printf("Writer: Sent '%s'\n", message);

    close(fd);
    unlink(FIFO_NAME);  // Remove FIFO

    return 0;
}
```

```c
// reader.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define FIFO_NAME "/tmp/myfifo"

int main(void) {
    int fd;
    char buffer[100];

    // Open for reading (blocks until writer opens)
    fd = open(FIFO_NAME, O_RDONLY);
    if (fd == -1) {
        perror("Open failed");
        return 1;
    }

    // Read message
    read(fd, buffer, sizeof(buffer));
    printf("Reader: Received '%s'\n", buffer);

    close(fd);

    return 0;
}
```

## Shared Memory

```c
// writer.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <string.h>

#define SHM_SIZE 1024
#define SHM_KEY 1234

typedef struct {
    int counter;
    char message[256];
} SharedData;

int main(void) {
    int shmid;
    SharedData *shared_data;

    // Create shared memory segment
    shmid = shmget(SHM_KEY, sizeof(SharedData), 0666 | IPC_CREAT);
    if (shmid == -1) {
        perror("shmget failed");
        return 1;
    }

    // Attach to shared memory
    shared_data = (SharedData *)shmat(shmid, NULL, 0);
    if (shared_data == (void *)-1) {
        perror("shmat failed");
        return 1;
    }

    // Write to shared memory
    shared_data->counter = 42;
    strcpy(shared_data->message, "Hello from writer!");

    printf("Writer: counter=%d, message='%s'\n",
           shared_data->counter, shared_data->message);

    printf("Press Enter to detach...");
    getchar();

    // Detach from shared memory
    shmdt(shared_data);

    // Remove shared memory
    shmctl(shmid, IPC_RMID, NULL);

    return 0;
}
```

```c
// reader.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#define SHM_SIZE 1024
#define SHM_KEY 1234

typedef struct {
    int counter;
    char message[256];
} SharedData;

int main(void) {
    int shmid;
    SharedData *shared_data;

    // Get existing shared memory
    shmid = shmget(SHM_KEY, sizeof(SharedData), 0666);
    if (shmid == -1) {
        perror("shmget failed");
        return 1;
    }

    // Attach to shared memory
    shared_data = (SharedData *)shmat(shmid, NULL, 0);
    if (shared_data == (void *)-1) {
        perror("shmat failed");
        return 1;
    }

    // Read from shared memory
    printf("Reader: counter=%d, message='%s'\n",
           shared_data->counter, shared_data->message);

    // Detach
    shmdt(shared_data);

    return 0;
}
```

## Message Queues

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/msg.h>

#define MSG_SIZE 256
#define MSG_KEY 5678

typedef struct {
    long msg_type;
    char msg_text[MSG_SIZE];
} Message;

int main(void) {
    int msgid;
    Message msg;
    key_t key;

    // Generate unique key
    key = ftok(".", 'A');
    if (key == -1) {
        perror("ftok failed");
        return 1;
    }

    // Create message queue
    msgid = msgget(key, 0666 | IPC_CREAT);
    if (msgid == -1) {
        perror("msgget failed");
        return 1;
    }

    // Send message
    msg.msg_type = 1;
    strcpy(msg.msg_text, "Hello via message queue!");

    if (msgsnd(msgid, &msg, sizeof(msg.msg_text), 0) == -1) {
        perror("msgsnd failed");
        return 1;
    }

    printf("Message sent: %s\n", msg.msg_text);

    // Receive message
    if (msgrcv(msgid, &msg, sizeof(msg.msg_text), 1, 0) == -1) {
        perror("msgrcv failed");
        return 1;
    }

    printf("Message received: %s\n", msg.msg_text);

    // Remove message queue
    msgctl(msgid, IPC_RMID, NULL);

    return 0;
}
```

## Semaphores for c.ipc.sync

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/sem.h>
#include <unistd.h>

#define SEM_KEY 9999

// Semaphore operations
void P(int semid) {
    struct sembuf op = {0, -1, 0};  // Wait
    semop(semid, &op, 1);
}

void V(int semid) {
    struct sembuf op = {0, 1, 0};  // Signal
    semop(semid, &op, 1);
}

int main(void) {
    int semid;
    pid_t pid;

    // Create semaphore set
    semid = semget(SEM_KEY, 1, 0666 | IPC_CREAT);
    if (semid == -1) {
        perror("semget failed");
        return 1;
    }

    // Initialize semaphore to 1 (unlocked)
    semctl(semid, 0, SETVAL, 1);

    // Fork process
    pid = fork();

    if (pid == 0) {
        // Child process
        for (int i = 0; i < 5; i++) {
            P(semid);
            printf("Child in critical sec.stdlib.stdion %d\n", i);
            sleep(1);
            printf("Child leaving critical sec.stdlib.stdion %d\n", i);
            V(semid);
            sleep(1);
        }
    } else {
        // Parent process
        for (int i = 0; i < 5; i++) {
            P(semid);
            printf("Parent in critical sec.stdlib.stdion %d\n", i);
            sleep(1);
            printf("Parent leaving critical sec.stdlib.stdion %d\n", i);
            V(semid);
            sleep(1);
        }

        wait(NULL);

        // Remove semaphore
        semctl(semid, 0, IPC_RMID, 0);
    }

    return 0;
}
```

## Shared Memory with Semaphores

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <unistd.h>

#define SHM_KEY 1000
#define SEM_KEY 1001

typedef struct {
    int data;
    int ready;
} SharedBuffer;

// Semaphore operations
void P(int semid) {
    struct sembuf op = {0, -1, 0};
    semop(semid, &op, 1);
}

void V(int semid) {
    struct sembuf op = {0, 1, 0};
    semop(semid, &op, 1);
}

int main(void) {
    int shmid, semid;
    SharedBuffer *buffer;
    pid_t pid;

    // Create shared memory
    shmid = shmget(SHM_KEY, sizeof(SharedBuffer), 0666 | IPC_CREAT);
    buffer = (SharedBuffer *)shmat(shmid, NULL, 0);
    buffer->ready = 0;

    // Create semaphore
    semid = semget(SEM_KEY, 1, 0666 | IPC_CREAT);
    semctl(semid, 0, SETVAL, 1);

    pid = fork();

    if (pid == 0) {
        // Child - producer
        for (int i = 0; i < 10; i++) {
            P(semid);
            buffer->data = i * 10;
            buffer->ready = 1;
            printf("Producer: wrote %d\n", buffer->data);
            V(semid);
            sleep(1);
        }
    } else {
        // Parent - consumer
        for (int i = 0; i < 10; i++) {
            P(semid);
            if (buffer->ready) {
                printf("Consumer: read %d\n", buffer->data);
                buffer->ready = 0;
            }
            V(semid);
            sleep(1);
        }

        wait(NULL);

        // Cleanup
        shmdt(buffer);
        shmctl(shmid, IPC_RMID, NULL);
        semctl(semid, 0, IPC_RMID, 0);
    }

    return 0;
}
```

## Unix Domain Sockets

```c
// server.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define SOCKET_PATH "/tmp/uds_socket"

int main(void) {
    int server_fd, client_fd;
    struct sockaddr_un server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[1024];

    // Create socket
    server_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket failed");
        return 1;
    }

    // Configure address
    server_addr.sun_family = AF_UNIX;
    strcpy(server_addr.sun_path, SOCKET_PATH);

    // Remove existing socket file
    unlink(SOCKET_PATH);

    // Bind
    if (bind(server_fd, (struct sockaddr *)&server_addr,
             sizeof(server_addr)) == -1) {
        perror("Bind failed");
        close(server_fd);
        return 1;
    }

    // Listen
    if (listen(server_fd, 5) == -1) {
        perror("Listen failed");
        close(server_fd);
        return 1;
    }

    printf("Server listening...\n");

    // Accept connec.stdlib.stdion
    client_fd = accept(server_fd,
                      (struct sockaddr *)&client_addr,
                      &addr_len);
    if (client_fd == -1) {
        perror("Accept failed");
        close(server_fd);
        return 1;
    }

    // Receive data
    ssize_t bytes = recv(client_fd, buffer, sizeof(buffer), 0);
    if (bytes > 0) {
        buffer[bytes] = '\0';
        printf("Received: %s\n", buffer);

        // Send response
        const char *response = "Hello from server!";
        send(client_fd, response, strlen(response), 0);
    }

    close(client_fd);
    close(server_fd);
    unlink(SOCKET_PATH);

    return 0;
}
```

```c
// client.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define SOCKET_PATH "/tmp/uds_socket"

int main(void) {
    int sockfd;
    struct sockaddr_un server_addr;
    char buffer[1024];

    // Create socket
    sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("Socket failed");
        return 1;
    }

    // Configure address
    server_addr.sun_family = AF_UNIX;
    strcpy(server_addr.sun_path, SOCKET_PATH);

    // Connect
    if (connect(sockfd, (struct sockaddr *)&server_addr,
                sizeof(server_addr)) == -1) {
        perror("Connect failed");
        close(sockfd);
        return 1;
    }

    // Send data
    const char *message = "Hello from client!";
    send(sockfd, message, strlen(message), 0);
    printf("Sent: %s\n", message);

    // Receive response
    ssize_t bytes = recv(sockfd, buffer, sizeof(buffer), 0);
    if (bytes > 0) {
        buffer[bytes] = '\0';
        printf("Received: %s\n", buffer);
    }

    close(sockfd);
    return 0;
}
```

## Best Practices

### Use Appropriate IPC Mechanism

```c
// Pipes - Parent-child communication, simple data flow

// FIFOs - Unrelated processes, simple data flow

// Shared Memory - Large data, high performance

// Message Queues - Multiple senders/receivers

// Unix Sockets - Complex communication, bidirectionnal
```

### Handle Errors Properly

```c
// Always check return values
if (pipe(pipefd) == -1) {
    perror("Pipe creation failed");
    return 1;
}

// Clean up resources
close(pipefd[0]);
close(pipefd[1]);
shmctl(shmid, IPC_RMID, NULL);
semctl(semid, 0, IPC_RMID, 0);
```

### Use c.ipc.sync

```c
// Always synchronize access to shared memory
P(semaphore);
// Critical sec.stdlib.stdion
// Access shared memory
V(semaphore);
```

## Common Pitfalls

### 1. Deadlock

```c
// WRONG - Potential deadlock
P(sem1);
P(sem2);
// Critical sec.stdlib.stdion
V(sem1);
V(sem2);

// CORRECT - Consistent ordering
P(sem1);
P(sem2);
// Critical sec.stdlib.stdion
V(sem2);
V(sem1);
```

### 2. Resource Leaks

```c
// WRONG - Forgetting cleanup
shmid = shmget(key, size, IPC_CREAT);
// Forgot to shmdt and shmctl

// CORRECT - Always cleanup
shmdt(shm_ptr);
shmctl(shmid, IPC_RMID, NULL);
```

### 3. Race Conditions

```c
// WRONG - No c.ipc.sync
shared_data->counter++;  // Race condition!

// CORRECT - Use semaphore
P(semaphore);
shared_data->counter++;
V(semaphore);
```

> **Note: IPC mechanisms require careful error handling and resource management. Always clean up shared resources. Use c.ipc.sync primitives to avoid race conditions. Choose the right IPC mechanism based on your requirements.
