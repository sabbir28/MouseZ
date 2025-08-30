#ifndef MOUSEZR_H
#define MOUSEZR_H

// ---------------------------
// Standard Libraries
// ---------------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/time.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <errno.h>
#include <signal.h>
#include <ctype.h>

// ---------------------------
// Config Macros
// ---------------------------
#define SERVER_PORT 8080
#define BACKLOG     5
#define BUFFER_SIZE 1024
#define MAX_RETRIES 3
#define RETRY_DELAY 1
#define RESPONSE_SIZE 128

// ---------------------------
// Function Prototypes
// ---------------------------
void run_server();
int mouse_init_uinput();
void mouse_move_uinput(int fd, int dx, int dy);
void mouse_click_uinput(int fd, int button);
void mouse_scroll_uinput(int fd, int value);
void mouse_close_uinput(int fd);
void process_command(int uinput_fd, char *buffer, char *response, size_t *response_len);

#endif // MOUSEZR_H
