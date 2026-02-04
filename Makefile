################################################################################
# Makefile for GRBL 1.1h - Woodpecker CNC / Arduino UNO (ATmega328P @ 16MHz)
################################################################################

# Target Configuration
TARGET = grbl
MCU = atmega328p
F_CPU = 16000000UL

# Upload Configuration (configurable via environment variables)
UPLOAD_PORT ?= /dev/ttyUSB0
UPLOAD_BAUD = 57600
PROGRAMMER = arduino

# Compiler and Tools
CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
AVRDUDE = avrdude

# Compiler Flags
CFLAGS = -mmcu=$(MCU)
CFLAGS += -DF_CPU=$(F_CPU)
CFLAGS += -Os
CFLAGS += -Wall
CFLAGS += -std=gnu99
CFLAGS += -funsigned-char
CFLAGS += -funsigned-bitfields
CFLAGS += -fpack-struct
CFLAGS += -fshort-enums
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections

# Linker Flags
LDFLAGS = -mmcu=$(MCU)
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -Wl,-Map=$(BUILD_DIR)/$(TARGET).map

# Auto-detect GRBL source location
ifneq ($(wildcard grbl/*.c),)
    GRBL_DIR = grbl
else
    GRBL_DIR = .
endif

# Include Directories
INCLUDES = -I$(GRBL_DIR)

# Source Files - automatically find all .c files in GRBL directory
SOURCES = $(wildcard $(GRBL_DIR)/*.c)

# Build Directory
BUILD_DIR = build

# Object Files
OBJECTS = $(SOURCES:$(GRBL_DIR)/%.c=$(BUILD_DIR)/%.o)

# Output Files
HEX = $(BUILD_DIR)/$(TARGET).hex
ELF = $(BUILD_DIR)/$(TARGET).elf
LSS = $(BUILD_DIR)/$(TARGET).lss

################################################################################
# Targets
################################################################################

.PHONY: all clean size upload help

# Default target
all: $(HEX) size

# Help target
help:
	@echo "GRBL 1.1h Build System for Woodpecker CNC / Arduino UNO"
	@echo ""
	@echo "Targets:"
	@echo "  all      - Build the project (default)"
	@echo "  clean    - Remove build artifacts"
	@echo "  size     - Display memory usage"
	@echo "  upload   - Upload to board via avrdude"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "Configuration:"
	@echo "  MCU:          $(MCU)"
	@echo "  F_CPU:        $(F_CPU)"
	@echo "  GRBL_DIR:     $(GRBL_DIR)"
	@echo "  UPLOAD_PORT:  $(UPLOAD_PORT) (override with UPLOAD_PORT=...)"
	@echo "  UPLOAD_BAUD:  $(UPLOAD_BAUD)"
	@echo ""
	@echo "Examples:"
	@echo "  make                           # Build project"
	@echo "  make upload                    # Upload with default port"
	@echo "  make upload UPLOAD_PORT=/dev/ttyACM0  # Upload with custom port"
	@echo "  make clean all                 # Clean and rebuild"

# Create build directory
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Compile source files
$(BUILD_DIR)/%.o: $(GRBL_DIR)/%.c | $(BUILD_DIR)
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Link object files
$(ELF): $(OBJECTS)
	@echo "Linking $(ELF)..."
	@$(CC) $(LDFLAGS) $(OBJECTS) -o $(ELF)

# Create hex file
$(HEX): $(ELF)
	@echo "Creating hex file..."
	@$(OBJCOPY) -O ihex -R .eeprom $(ELF) $(HEX)
	@echo "Creating listing file..."
	@$(OBJDUMP) -h -S $(ELF) > $(LSS)

# Display memory usage
size: $(ELF)
	@echo ""
	@echo "Memory Usage:"
	@echo "============="
	@$(SIZE) --mcu=$(MCU) --format=avr $(ELF)
	@echo ""
	@$(SIZE) $(ELF)
	@echo ""

# Upload to board
upload: $(HEX)
	@echo "Uploading to $(UPLOAD_PORT)..."
	@$(AVRDUDE) -v -p $(MCU) -c $(PROGRAMMER) -P $(UPLOAD_PORT) -b $(UPLOAD_BAUD) -D -U flash:w:$(HEX):i

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Done."

# Check if sources exist
check-sources:
	@if [ -z "$(SOURCES)" ]; then \
		echo "ERROR: No GRBL source files found!"; \
		echo "Expected location: $(GRBL_DIR)/*.c"; \
		echo ""; \
		echo "Please ensure GRBL source files are placed in:"; \
		echo "  - ./grbl/ directory, OR"; \
		echo "  - repository root directory"; \
		exit 1; \
	fi
	@echo "Found $(words $(SOURCES)) source files in $(GRBL_DIR)/"

# Dependency on source check
$(OBJECTS): | check-sources
