---
id: 74-network-programming
title: Network Programming Basics
category: system
difficulty: advanced
tags:
  - networking
  - sockets
  - tcp
  - udp
keywords:
  - socket
  - tcp
  - udp
  - bind
  - listen
  - accept
  - connect
use_cases:
  - Client-server applications
  - Network communication
  - Socket programming
  - Network protocols
prerequisites:
  - file-operations
  - pointers
  - structs
related:
  - file-operations
  - threads
  - process-management
next_topics:
  - security-bestpractices
---

# Network Programming Basics

Network programming enables applications to communicate over networks using sockets.

## Socket Basics

```c
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>

int main(void) {
    // Create a socket
    // AF_INET: IPv4
    // SOCK_STREAM: TCP
    // 0: Default protocol
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);

    if (sockfd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    printf("Socket created successfully\n");

    // Close socket when done
    close(sockfd);

    return 0;
}
```

## TCP Server

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main(void) {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];

    // Create socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Set socket options to reuse address
    int opt = 1;
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR,
                   &opt, sizeof(opt)) == -1) {
        perror("setsockopt failed");
        close(server_fd);
        return 1;
    }

    // Configure server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;  // Any available interface
    server_addr.sin_port = htons(PORT);  // Convert to network byte order

    // Bind socket to address
    if (bind(server_fd, (struct sockaddr *)&server_addr,
             sizeof(server_addr)) == -1) {
        perror("Bind failed");
        close(server_fd);
        return 1;
    }

    // Listen for connections
    if (listen(server_fd, 5) == -1) {
        perror("Listen failed");
        close(server_fd);
        return 1;
    }

    printf("Server listening on port %d\n", PORT);

    // Accept connection
    client_fd = accept(server_fd, (struct sockaddr *)&client_addr,
                       &addr_len);
    if (client_fd == -1) {
        perror("Accept failed");
        close(server_fd);
        return 1;
    }

    printf("Client connected\n");

    // Receive data
    ssize_t bytes_received = recv(client_fd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received == -1) {
        perror("Receive failed");
    } else {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);

        // Send response
        const char *response = "Hello from server!";
        send(client_fd, response, strlen(response), 0);
    }

    // Close connections
    close(client_fd);
    close(server_fd);

    return 0;
}
```

## TCP Client

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 8080
#define SERVER_IP "127.0.0.1"
#define BUFFER_SIZE 1024

int main(void) {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];

    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Configure server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);

    // Convert IP string to network address
    if (inet_pton(AF_INET, SERVER_IP, &server_addr.sin_addr) <= 0) {
        perror("Invalid address");
        close(sockfd);
        return 1;
    }

    // Connect to server
    if (connect(sockfd, (struct sockaddr *)&server_addr,
                sizeof(server_addr)) == -1) {
        perror("Connection failed");
        close(sockfd);
        return 1;
    }

    printf("Connected to server\n");

    // Send data
    const char *message = "Hello from client!";
    send(sockfd, message, strlen(message), 0);
    printf("Sent: %s\n", message);

    // Receive response
    ssize_t bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received == -1) {
        perror("Receive failed");
    } else {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);
    }

    close(sockfd);
    return 0;
}
```

## UDP Server

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main(void) {
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    char buffer[BUFFER_SIZE];
    socklen_t addr_len = sizeof(client_addr);

    // Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Configure server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // Bind socket
    if (bind(sockfd, (struct sockaddr *)&server_addr,
             sizeof(server_addr)) == -1) {
        perror("Bind failed");
        close(sockfd);
        return 1;
    }

    printf("UDP server listening on port %d\n", PORT);

    while (1) {
        // Receive data
        ssize_t bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                                          (struct sockaddr *)&client_addr,
                                          &addr_len);
        if (bytes_received == -1) {
            perror("Receive failed");
            continue;
        }

        buffer[bytes_received] = '\0';
        printf("Received from %s:%d: %s\n",
               inet_ntoa(client_addr.sin_addr),
               ntohs(client_addr.sin_port),
               buffer);

        // Send response
        const char *response = "ACK";
        sendto(sockfd, response, strlen(response), 0,
               (struct sockaddr *)&client_addr, addr_len);
    }

    close(sockfd);
    return 0;
}
```

## UDP Client

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 8080
#define SERVER_IP "127.0.0.1"
#define BUFFER_SIZE 1024

int main(void) {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];
    socklen_t addr_len = sizeof(server_addr);

    // Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Configure server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    inet_pton(AF_INET, SERVER_IP, &server_addr.sin_addr);

    // Send data
    const char *message = "Hello via UDP!";
    sendto(sockfd, message, strlen(message), 0,
           (struct sockaddr *)&server_addr, addr_len);
    printf("Sent: %s\n", message);

    // Receive response
    ssize_t bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                                      (struct sockaddr *)&server_addr,
                                      &addr_len);
    if (bytes_received == -1) {
        perror("Receive failed");
    } else {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);
    }

    close(sockfd);
    return 0;
}
```

## Non-Blocking Socket with select()

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sys/select.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main(void) {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];
    fd_set read_fds;
    struct timeval timeout;

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Set socket to non-blocking
    int flags = fcntl(server_fd, F_GETFL, 0);
    fcntl(server_fd, F_SETFL, flags | O_NONBLOCK);

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr));
    listen(server_fd, 5);

    printf("Server listening (non-blocking)\n");

    while (1) {
        FD_ZERO(&read_fds);
        FD_SET(server_fd, &read_fds);

        // Set timeout
        timeout.tv_sec = 5;
        timeout.tv_usec = 0;

        // Wait for activity
        int activity = select(server_fd + 1, &read_fds, NULL, NULL, &timeout);

        if (activity < 0) {
            perror("select error");
            break;
        } else if (activity == 0) {
            printf("Timeout, waiting...\n");
            continue;
        }

        if (FD_ISSET(server_fd, &read_fds)) {
            client_fd = accept(server_fd, (struct sockaddr *)&client_addr,
                              &addr_len);
            if (client_fd != -1) {
                printf("Client connected\n");
                // Handle client...
                close(client_fd);
            }
        }
    }

    close(server_fd);
    return 0;
}
```

## Socket Error Handling

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <errno.h>

int create_socket(int domain, int type, int protocol) {
    int sockfd = socket(domain, type, protocol);
    if (sockfd == -1) {
        fprintf(stderr, "Socket creation failed: %s\n", strerror(errno));
        return -1;
    }
    return sockfd;
}

int bind_socket(int sockfd, struct sockaddr_in *addr) {
    if (bind(sockfd, (struct sockaddr *)addr, sizeof(*addr)) == -1) {
        fprintf(stderr, "Bind failed: %s\n", strerror(errno));
        close(sockfd);
        return -1;
    }
    return 0;
}

int listen_socket(int sockfd, int backlog) {
    if (listen(sockfd, backlog) == -1) {
        fprintf(stderr, "Listen failed: %s\n", strerror(errno));
        close(sockfd);
        return -1;
    }
    return 0;
}

int accept_connection(int sockfd, struct sockaddr_in *client_addr,
                      socklen_t *addr_len) {
    int client_fd = accept(sockfd, (struct sockaddr *)client_addr, addr_len);
    if (client_fd == -1) {
        if (errno != EINTR) {  // EINTR is normal if interrupted
            fprintf(stderr, "Accept failed: %s\n", strerror(errno));
        }
        return -1;
    }
    return client_fd;
}

int main(void) {
    int server_fd = create_socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) return 1;

    struct sockaddr_in server_addr = {
        .sin_family = AF_INET,
        .sin_addr.s_addr = INADDR_ANY,
        .sin_port = htons(8080)
    };

    if (bind_socket(server_fd, &server_addr) == -1) return 1;
    if (listen_socket(server_fd, 5) == -1) return 1;

    printf("Server ready\n");

    struct sockaddr_in client_addr;
    socklen_t addr_len = sizeof(client_addr);
    int client_fd = accept_connection(server_fd, &client_addr, &addr_len);
    if (client_fd == -1) return 1;

    printf("Client connected\n");
    close(client_fd);
    close(server_fd);

    return 0;
}
```

## Socket Options

```c
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

int main(void) {
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Reuse address (allows restarting server quickly)
    int reuse = 1;
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR,
                   &reuse, sizeof(reuse)) == -1) {
        perror("setsockopt SO_REUSEADDR failed");
    }

    // Set receive timeout
    struct timeval timeout = {
        .tv_sec = 10,
        .tv_usec = 0
    };
    if (setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO,
                   &timeout, sizeof(timeout)) == -1) {
        perror("setsockopt SO_RCVTIMEO failed");
    }

    // Set send timeout
    if (setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO,
                   &timeout, sizeof(timeout)) == -1) {
        perror("setsockopt SO_SNDTIMEO failed");
    }

    // Set send buffer size
    int buffer_size = 65536;
    if (setsockopt(sockfd, SOL_SOCKET, SO_SNDBUF,
                   &buffer_size, sizeof(buffer_size)) == -1) {
        perror("setsockopt SO_SNDBUF failed");
    }

    printf("Socket options configured\n");
    close(sockfd);

    return 0;
}
```

## Simple Echo Server

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define PORT 8080
#define BUFFER_SIZE 1024

void handle_client(int client_fd) {
    char buffer[BUFFER_SIZE];

    while (1) {
        ssize_t bytes_received = recv(client_fd, buffer, BUFFER_SIZE - 1, 0);

        if (bytes_received <= 0) {
            if (bytes_received == 0) {
                printf("Client disconnected\n");
            } else {
                perror("Receive error");
            }
            break;
        }

        buffer[bytes_received] = '\0';
        printf("Received: %s", buffer);

        // Echo back
        send(client_fd, buffer, bytes_received, 0);
    }
}

int main(void) {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr));
    listen(server_fd, 5);

    printf("Echo server listening on port %d\n", PORT);

    client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &addr_len);
    if (client_fd == -1) {
        perror("Accept failed");
        close(server_fd);
        return 1;
    }

    printf("Client connected\n");
    handle_client(client_fd);

    close(client_fd);
    close(server_fd);

    return 0;
}
```

## Best Practices

### Always Check Return Values

```c
// GOOD - Check all return values
if (connect(sockfd, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
    perror("Connection failed");
    close(sockfd);
    return 1;
}

// BAD - Ignoring return values
connect(sockfd, (struct sockaddr *)&addr, sizeof(addr));
```

### Use Appropriate Buffer Sizes

```c
// GOOD - Use reasonable buffer size
#define BUFFER_SIZE 4096
char buffer[BUFFER_SIZE];

// BAD - Too small or too large
char buffer[10];  // Too small, truncates data
char buffer[10000000];  // Too large, wasteful
```

### Handle Partial Sends/Receives

```c
// Handle partial receives
size_t total_received = 0;
while (total_received < expected_size) {
    ssize_t bytes = recv(sockfd, buffer + total_received,
                        expected_size - total_received, 0);
    if (bytes <= 0) break;
    total_received += bytes;
}
```

### Set Timeouts

```c
// Set timeout to prevent hanging
struct timeval timeout = {.tv_sec = 30, .tv_usec = 0};
setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));
```

## Common Pitfalls

### 1. Forgetting Network Byte Order

```c
// WRONG - Using host byte order
server_addr.sin_port = 8080;

// CORRECT - Convert to network byte order
server_addr.sin_port = htons(8080);
```

### 2. Not Closing Sockets

```c
// WRONG - Socket leaks
sockfd = socket(AF_INET, SOCK_STREAM, 0);
// ... use socket ...
return;  // Forgot to close!

// CORRECT - Always close
sockfd = socket(AF_INET, SOCK_STREAM, 0);
// ... use socket ...
close(sockfd);
return;
```

### 3. Blocking on Send/Recv

```c
// WRONG - Might block forever
recv(sockfd, buffer, size, 0);

// CORRECT - Use timeout or non-blocking mode
struct timeval timeout = {.tv_sec = 5, .tv_usec = 0};
setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
recv(sockfd, buffer, size, 0);
```

> **Note**: Network programming requires careful error handling, resource management, and consideration of network latency and reliability. Always validate inputs, handle partial data transfers, and implement proper timeout mechanisms. For production code, consider using established networking libraries.
