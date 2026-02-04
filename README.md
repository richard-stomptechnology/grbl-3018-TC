# grbl-3018-TC
Grbl 1.1h with Tool change support, utilize a 2nd Z-Probe switch

## Overview

This repository provides a reproducible build environment for GRBL 1.1h firmware targeting the Woodpecker CNC board (Arduino UNO / ATmega328P @ 16MHz). It includes a Makefile and VS Code tasks for easy compilation and uploading.

## Requirements

### Software Dependencies

- **avr-gcc**: AVR cross-compiler
- **avr-binutils**: AVR binary utilities
- **avr-libc**: C library for AVR
- **avrdude**: Tool for uploading firmware to AVR microcontrollers
- **make**: Build automation tool

#### Installation

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install gcc-avr avr-libc avrdude make
```

**macOS (Homebrew):**
```bash
brew tap osx-cross/avr
brew install avr-gcc avrdude make
```

**Windows:**
- Install [WinAVR](https://sourceforge.net/projects/winavr/) or [AVR toolchain from Microchip](https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers)
- Add the toolchain to your PATH

### Hardware

- Woodpecker CNC board / Arduino UNO (ATmega328P @ 16MHz)
- USB cable for programming

## GRBL Source Files

Place the GRBL 1.1h source files in one of the following locations:
- `./grbl/` directory (recommended)
- Repository root directory

The build system will automatically detect the location.

## Building

### Command Line

Build the project:
```bash
make
```

View memory usage:
```bash
make size
```

Clean build artifacts:
```bash
make clean
```

Clean and rebuild:
```bash
make clean all
```

Get help:
```bash
make help
```

### VS Code

If using Visual Studio Code, open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`) and select:
- **Tasks: Run Task** → **GRBL: Build** - Build the project
- **Tasks: Run Build Task** (`Ctrl+Shift+B` or `Cmd+Shift+B`) - Quick build
- **Tasks: Run Task** → **GRBL: Clean** - Clean build artifacts
- **Tasks: Run Task** → **GRBL: Show Memory Usage** - Display memory usage

## Uploading

### Command Line

Upload with default port (`/dev/ttyUSB0`):
```bash
make upload
```

Upload with custom port:
```bash
make upload UPLOAD_PORT=/dev/ttyACM0
```

or

```bash
UPLOAD_PORT=/dev/ttyACM0 make upload
```

Build and upload in one command:
```bash
make all upload UPLOAD_PORT=/dev/ttyACM0
```

### VS Code

Use the VS Code tasks:
- **GRBL: Upload (default port)** - Upload using default port
- **GRBL: Upload (custom port)** - Upload with port prompt
- **GRBL: Build and Upload (default port)** - Build then upload
- **GRBL: Build and Upload (custom port)** - Build then upload with port prompt

## Configuration

### Upload Port

The default upload port is `/dev/ttyUSB0`. To change it:

1. **Environment variable:**
   ```bash
   export UPLOAD_PORT=/dev/ttyACM0
   make upload
   ```

2. **Make command line:**
   ```bash
   make upload UPLOAD_PORT=/dev/ttyACM0
   ```

3. **In Makefile:** Edit the `UPLOAD_PORT` line in the Makefile

### Common Port Names

- **Linux:** `/dev/ttyUSB0`, `/dev/ttyACM0`
- **macOS:** `/dev/cu.usbserial-*`, `/dev/cu.usbmodem*`
- **Windows:** `COM3`, `COM4`, etc.

To find your port:
- **Linux/macOS:** `ls /dev/tty*` (with board disconnected, then connected)
- **Windows:** Check Device Manager → Ports (COM & LPT)

## Build Settings

The Makefile is configured for:
- **Target:** ATmega328P (Arduino UNO / Woodpecker CNC)
- **Clock:** 16MHz
- **Optimization:** `-Os` (optimize for size)
- **Programmer:** Arduino bootloader
- **Baud rate:** 57600

These settings are optimized for the Woodpecker CNC board and should not require modification.

## Memory Usage

After building, the memory usage report shows:
- **Flash (Program Memory):** Maximum 32KB on ATmega328P
- **RAM (Data Memory):** Maximum 2KB on ATmega328P

GRBL is optimized to fit within these constraints.

## Troubleshooting

### Build Errors

**"No GRBL source files found"**
- Ensure GRBL source files (`.c` and `.h`) are in `./grbl/` or repository root
- Check file permissions

**"avr-gcc: command not found"**
- Install the AVR toolchain (see Requirements section)

### Upload Errors

**"Permission denied" on upload port**
- Add user to dialout group: `sudo usermod -a -G dialout $USER`
- Log out and back in for changes to take effect
- Or use sudo: `sudo make upload`

**"Device not found" or "Port not available"**
- Check the USB connection
- Verify correct port with `ls /dev/tty*` (Linux/macOS) or Device Manager (Windows)
- Ensure no other program (serial monitor, etc.) is using the port

**"Verification error"**
- Press reset button on board before upload
- Check USB cable quality
- Try a different USB port

## License

This build system is provided as-is. GRBL itself is licensed under GPLv3. See GRBL documentation for details.
