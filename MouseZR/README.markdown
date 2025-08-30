# MouseZR

MouseZR is a lightweight server application for Linux that creates a virtual mouse device using the `uinput` interface. It listens for mouse control commands (e.g., move, click, scroll) over a TCP socket on port 8080, allowing remote or local applications to control the mouse cursor programmatically. This project is ideal for automation, remote desktop applications, or testing mouse input on Linux systems.

![MouseZR Architecture](MouseZR/chart.png)

## Features
- Creates a virtual mouse device using Linux `uinput`.
- Supports commands: `MOVE` (move cursor), `CLICK` (left or right click), and `SCROLL` (vertical scroll).
- Handles one client connection at a time over TCP port 8080.
- Non-blocking I/O for efficient command processing.
- Graceful shutdown on SIGINT or SIGTERM signals.

## Prerequisites
To build and run MouseZR on Linux, you need:
- A Linux distribution with `uinput` support (e.g., Ubuntu, Debian, Fedora).
- GCC compiler (`gcc`).
- Development libraries: `libc-dev`, `libudev-dev`.
- Root privileges to access `/dev/uinput` (or appropriate permissions).

## Installation
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/sabbir28/MouseZ.git
   cd MouseZ/MouseZR/C
   ```

2. **Install Dependencies**:
   On Ubuntu/Debian, install the required packages:
   ```bash
   sudo apt update
   sudo apt install build-essential libudev-dev
   ```

3. **Compile the Code**:
   Compile the `MouseZR.c` source file:
   ```bash
   gcc -o MouseZR MouseZR.c -ludev
   ```

## Usage
1. **Run the Server**:
   Run MouseZR with root privileges to access `/dev/uinput`:
   ```bash
   sudo ./MouseZR
   ```
   The server will start and listen on port 8080. You should see:
   ```
   Starting MouseZR Server...
   MouseZR Server is running on port 8080...
   ```

2. **Send Commands**:
   Connect to the server using a TCP client (e.g., `netcat`) and send commands in the format:
   ```
   COMMAND ARG1 ARG2
   ```
   - `MOVE X Y`: Move the mouse cursor by `X` (horizontal) and `Y` (vertical) pixels.
   - `CLICK LEFT|RIGHT`: Perform a left or right mouse click.
   - `SCROLL VALUE`: Scroll vertically by `VALUE` (positive for up, negative for down).

   Example using `netcat`:
   ```bash
   echo "MOVE 10 20" | nc localhost 8080
   echo "CLICK LEFT" | nc localhost 8080
   echo "SCROLL -5" | nc localhost 8080
   ```

3. **Stop the Server**:
   Press `Ctrl+C` to send a SIGINT signal, or use `kill` to send a SIGTERM signal. The server will close the virtual mouse device and socket gracefully.

## Project Structure
- **MouseZR.c**: Main C source file implementing the server and mouse control logic.
- **MouseZR.h**: Header file with function declarations and constants.
- **MouseZR.asm**: Assembly output of the compiled C code (for reference or debugging).
- **chart.png**: Diagram illustrating the MouseZR architecture or performance metrics.

## Example Workflow
The following diagram (from `chart.png`) provides a visual overview of MouseZR's architecture:

![MouseZR Architecture](MouseZR/chart.png)

1. The server initializes a virtual mouse device via `/dev/uinput`.
2. It listens for TCP connections on port 8080.
3. A client sends commands (e.g., `MOVE 100 50`).
4. MouseZR processes the command and sends input events to the virtual mouse device.
5. The Linux system interprets these events as mouse movements, clicks, or scrolls.

## Notes
- Ensure `/dev/uinput` is accessible. You may need to add your user to the `input` group or run as root:
  ```bash
  sudo usermod -aG input $USER
  ```
- The server handles one client at a time. For multiple clients, modify the code to support concurrent connections.
- The estimated RAM usage is approximately 100–150 KB, making it lightweight for most Linux systems.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue on the [GitHub repository](https://github.com/sabbir28/MouseZ) for bug reports, feature requests, or improvements.

## Acknowledgments
Developed by [sabbir28](https://github.com/sabbir28). Thanks to the open-source community for tools and libraries like `uinput` and `libudev`.
