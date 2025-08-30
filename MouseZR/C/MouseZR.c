#include "MouseZR.h"

volatile sig_atomic_t keep_running = 1;

void signal_handler(int sig) {
    keep_running = 0;
}

int set_non_blocking(int fd) {
    int flags = fcntl(fd, F_GETFL, 0);
    if (flags == -1) return -1;
    return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}

int main() {
    // Install signal handlers for graceful shutdown
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);

    printf("Starting MouseZR Server...\n");

    // Self-test
    int fd = mouse_init_uinput();
    if (fd > 0) {
        printf("[TEST] Virtual mouse device created successfully.\n");
        mouse_move_uinput(fd, 10, 0);
        mouse_click_uinput(fd, BTN_LEFT);
        mouse_scroll_uinput(fd, 1); // Test scrolling
        printf("[TEST] Mouse self-test completed.\n");
        mouse_close_uinput(fd);
    } else {
        printf("[TEST] Failed to create virtual mouse device!\n");
        return EXIT_FAILURE;
    }

    // Run server
    run_server();
    return 0;
}

void process_command(int uinput_fd, char *buffer, char *response, size_t *response_len) {
    int dx = 0, dy = 0, scroll_value = 0;
    char cmd[16], arg1[16], arg2[16];
    memset(cmd, 0, sizeof(cmd));
    memset(arg1, 0, sizeof(arg1));
    memset(arg2, 0, sizeof(arg2));

    // Parse command safely
    sscanf(buffer, "%15s %15s %15s", cmd, arg1, arg2);

    // Convert command to uppercase for case-insensitive comparison
    for (char *p = cmd; *p; p++) *p = toupper(*p);

    if (strcmp(cmd, "MOVE") == 0) {
        dx = atoi(arg1);
        dy = atoi(arg2);
        mouse_move_uinput(uinput_fd, dx, dy);
        snprintf(response, RESPONSE_SIZE, "OK: MOVED X=%d Y=%d\n", dx, dy);
        *response_len = strlen(response);
    } else if (strcmp(cmd, "CLICK") == 0) {
        int button = BTN_LEFT;
        // Convert arg1 to uppercase for case-insensitive comparison
        for (char *p = arg1; *p; p++) *p = toupper(*p);
        if (strcmp(arg1, "RIGHT") == 0) button = BTN_RIGHT;
        mouse_click_uinput(uinput_fd, button);
        snprintf(response, RESPONSE_SIZE, "OK: CLICK %s\n", arg1);
        *response_len = strlen(response);
    } else if (strcmp(cmd, "SCROLL") == 0) {
        scroll_value = atoi(arg1);
        mouse_scroll_uinput(uinput_fd, scroll_value);
        snprintf(response, RESPONSE_SIZE, "OK: SCROLLED %d\n", scroll_value);
        *response_len = strlen(response);
    } else {
        snprintf(response, RESPONSE_SIZE, "ERR: UNKNOWN COMMAND\n");
        *response_len = strlen(response);
    }
}

void run_server() {
    int server_fd = -1, client_fd = -1;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];
    char response[RESPONSE_SIZE];
    int uinput_fd = -1;
    int opt = 1;

    // Create socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("Error creating socket");
        exit(EXIT_FAILURE);
    }

    // Set socket options
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt))) {
        perror("Error setting socket options");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    // Configure server address
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(SERVER_PORT);

    // Bind socket
    if (bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("Error binding socket");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    // Listen for connections
    if (listen(server_fd, BACKLOG) < 0) {
        perror("Error listening on socket");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    // Set server socket to non-blocking
    if (set_non_blocking(server_fd) < 0) {
        perror("Error setting non-blocking mode");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    printf("MouseZR Server is running on port %d...\n", SERVER_PORT);

    // Initialize uinput
    uinput_fd = mouse_init_uinput();
    if (uinput_fd < 0) {
        printf("Failed to initialize uinput device\n");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    while (keep_running) {
        // Accept client connection with timeout
        struct timeval tv;
        tv.tv_sec = 1;
        tv.tv_usec = 0;
        fd_set read_fds;
        FD_ZERO(&read_fds);
        FD_SET(server_fd, &read_fds);

        int activity = select(server_fd + 1, &read_fds, NULL, NULL, &tv);
        if (activity < 0 && errno != EINTR) {
            perror("Select error");
            continue;
        }

        if (activity == 0) continue;

        client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &addr_len);
        if (client_fd < 0) {
            if (errno != EAGAIN && errno != EWOULDBLOCK) {
                perror("Error accepting client connection");
            }
            continue;
        }

        printf("Client connected: %s:%d\n",
               inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));

        // Set client socket to non-blocking
        if (set_non_blocking(client_fd) < 0) {
            perror("Error setting client non-blocking mode");
            close(client_fd);
            continue;
        }

        int retries = 0;
        while (keep_running) {
            memset(buffer, 0, BUFFER_SIZE);
            ssize_t bytes_received = recv(client_fd, buffer, BUFFER_SIZE - 1, 0);

            if (bytes_received < 0) {
                if (errno == EAGAIN || errno == EWOULDBLOCK) {
                    usleep(100000); // Wait 100ms before retry
                    continue;
                }
                printf("Client disconnected: %s\n", strerror(errno));
                break;
            }

            if (bytes_received == 0) {
                printf("Client disconnected gracefully.\n");
                break;
            }

            buffer[bytes_received] = '\0';
            printf("Received: %s", buffer); // No newline in buffer

            size_t response_len = 0;
            memset(response, 0, RESPONSE_SIZE);
            process_command(uinput_fd, buffer, response, &response_len);

            // Send response with retries
            retries = 0;
            while (response_len > 0) {
                ssize_t bytes_sent = send(client_fd, response, response_len, 0);
                if (bytes_sent < 0) {
                    if (errno == EAGAIN || errno == EWOULDBLOCK) {
                        if (retries++ < MAX_RETRIES) {
                            sleep(RETRY_DELAY);
                            continue;
                        }
                    }
                    printf("Error sending response: %s\n", strerror(errno));
                    break;
                }
                response_len -= bytes_sent;
                if (response_len > 0) {
                    memmove(response, response + bytes_sent, response_len);
                    retries = 0;
                } else {
                    break;
                }
            }
        }

        if (client_fd >= 0) {
            close(client_fd);
            client_fd = -1;
        }
    }

    // Cleanup
    if (uinput_fd >= 0) {
        mouse_close_uinput(uinput_fd);
    }
    if (server_fd >= 0) {
        close(server_fd);
    }
    printf("MouseZR Server shutting down...\n");
}

int mouse_init_uinput() {
    int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
    if (fd < 0) {
        perror("Error opening /dev/uinput");
        return -1;
    }

    // Enable events
    if (ioctl(fd, UI_SET_EVBIT, EV_KEY) < 0 ||
        ioctl(fd, UI_SET_KEYBIT, BTN_LEFT) < 0 ||
        ioctl(fd, UI_SET_KEYBIT, BTN_RIGHT) < 0 ||
        ioctl(fd, UI_SET_EVBIT, EV_REL) < 0 ||
        ioctl(fd, UI_SET_RELBIT, REL_X) < 0 ||
        ioctl(fd, UI_SET_RELBIT, REL_Y) < 0 ||
        ioctl(fd, UI_SET_RELBIT, REL_WHEEL) < 0) {
        perror("Error setting uinput events");
        close(fd);
        return -1;
    }

    // Setup device
    struct uinput_setup usetup;
    memset(&usetup, 0, sizeof(usetup));
    usetup.id.bustype = BUS_USB;
    usetup.id.vendor = 0x1234;
    usetup.id.product = 0x5678;
    strcpy(usetup.name, "MouseZR Virtual Mouse");

    if (ioctl(fd, UI_DEV_SETUP, &usetup) < 0 ||
        ioctl(fd, UI_DEV_CREATE) < 0) {
        perror("Error setting up uinput device");
        close(fd);
        return -1;
    }

    sleep(1); // Allow device to initialize
    return fd;
}

void mouse_move_uinput(int fd, int dx, int dy) {
    if (fd < 0) return;

    struct input_event ev;
    memset(&ev, 0, sizeof(ev));
    gettimeofday(&ev.time, NULL);

    // Move X
    if (dx != 0) {
        ev.type = EV_REL;
        ev.code = REL_X;
        ev.value = dx;
        if (write(fd, &ev, sizeof(ev)) < 0) {
            perror("Error writing REL_X");
        }
    }

    // Move Y
    if (dy != 0) {
        ev.type = EV_REL;
        ev.code = REL_Y;
        ev.value = dy;
        if (write(fd, &ev, sizeof(ev)) < 0) {
            perror("Error writing REL_Y");
        }
    }

    // Sync
    ev.type = EV_SYN;
    ev.code = SYN_REPORT;
    ev.value = 0;
    if (write(fd, &ev, sizeof(ev)) < 0) {
        perror("Error syncing move");
    }
}

void mouse_click_uinput(int fd, int button) {
    if (fd < 0) return;

    struct input_event ev;
    memset(&ev, 0, sizeof(ev));
    gettimeofday(&ev.time, NULL);

    // Press
    ev.type = EV_KEY;
    ev.code = button;
    ev.value = 1;
    if (write(fd, &ev, sizeof(ev)) < 0) {
        perror("Error pressing button");
    }

    // Sync
    ev.type = EV_SYN;
    ev.code = SYN_REPORT;
    ev.value = 0;
    if (write(fd, &ev, sizeof(ev)) < 0) {
        perror("Error syncing press");
    }

    // Release
    ev.type = EV_KEY;
    ev.code = button;
    ev.value = 0;
    if (write(fd, &ev, sizeof(ev)) < 0) {
        perror("Error releasing button");
    }

    // Sync
    ev.type = EV_SYN;
    ev.code = SYN_REPORT;
    ev.value = 0;
    if (write(fd, &ev, sizeof(ev)) < 0) {
        perror("Error syncing release");
    }
}

void mouse_scroll_uinput(int fd, int value) {
    if (fd < 0) return;

    struct input_event ev;
    memset(&ev, 0, sizeof(ev));
    gettimeofday(&ev.time, NULL);

    // Scroll
    if (value != 0) {
        ev.type = EV_REL;
        ev.code = REL_WHEEL;
        ev.value = value;
        if (write(fd, &ev, sizeof(ev)) < 0) {
            perror("Error writing REL_WHEEL");
        }
    }

    // Sync
    ev.type = EV_SYN;
    ev.code = SYN_REPORT;
    ev.value = 0;
    if (write(fd, &ev, sizeof(ev)) < 0) {
        perror("Error syncing scroll");
    }
}

void mouse_close_uinput(int fd) {
    if (fd >= 0) {
        if (ioctl(fd, UI_DEV_DESTROY) < 0) {
            perror("Error destroying uinput device");
        }
        close(fd);
    }
}
