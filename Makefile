#
# Makefile for Sparki projects,
# derived from the verbose output of the Arduino IDE
#

ARDUINO_DIR = /usr/share/arduino
AVR_BIN_DIR = $(ARDUINO_DIR)/hardware/tools/avr/bin
AVR_DIR     = $(ARDUINO_DIR)/hardware/arduino/avr

# Use sparkic submodule
SPARKI_DIR  = sparkic/src

SPARKI_FLAGS = -DNO_ACCEL -DNO_MAG
INCLUDES = "-I$(AVR_DIR)/cores/arduino" \
           "-I$(AVR_DIR)/variants/leonardo"
MCU = atmega32u4
F_CPU = 16000000
BAUD = 9600
ARDUINO_FLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -DBAUD=$(BAUD) \
                -DARDUINO=10608 -DARDUINO_AVR_LEONARDO -DARDUINO_ARCH_AVR \
                -DUSB_VID=0x2341 -DUSB_PID=0x8036 \
                '-DUSB_MANUFACTURER="Unknown"' '-DUSB_PRODUCT="Arduino Leonardo"' \
                $(INCLUDES)
CC_FLAGS  = -c -g -Os -Wall -std=gnu11 -ffunction-sections -fdata-sections -MMD $(SPARKI_FLAGS)
CPP_FLAGS = -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD

BUILD_DIR = build



all: $(BUILD_DIR)/$(NAME).hex

objects: $(BUILT_SPARKI_CPP_OBJS)

# Ensure the output dirs we need are there
$(BUILD_DIR)/:
	mkdir -p $@

$(BUILD_DIR)/sparki/:
	mkdir -p $@

$(BUILD_DIR)/core/:
	mkdir -p $@



include sparkic/sparki.mk

include sparkic/arduino_core.mk


# Need to build $(BUILD_DIR)/*.c.o for various .c files
#
# e.g.
# $(BUILD_DIR)/$(NAME).c.o: $(NAME).c $(BUILD_DIR)/
# 	"$(AVR_BIN_DIR)/avr-gcc" $(CC_FLAGS) $(ARDUINO_FLAGS) "-Isrc/" $< -o $@
include examples.mk


$(BUILD_DIR)/%.elf: $(BUILD_DIR)/%.c.o $(BUILD_DIR)/core/core.a $(BUILD_DIR)/sparki.a
	"$(AVR_BIN_DIR)/avr-gcc" -w -Os -Wl,--gc-sections -mmcu=atmega32u4 -o $@ $< $(BUILD_DIR)/sparki.a "$(BUILD_DIR)/core/core.a" "-L$(BUILD_DIR)" -lm

# .eeprom section (not uploaded)
$(BUILD_DIR)/$(NAME).eep: $(BUILD_DIR)/$(NAME).elf
	"$(AVR_BIN_DIR)/avr-objcopy" -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 "$(BUILD_DIR)/$(NAME).elf" "$(BUILD_DIR)/$(NAME).eep"

# Intel Hex format
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
	"$(AVR_BIN_DIR)/avr-objcopy" -O ihex -R .eeprom $< $@



clean:
	@rm $(BUILD_DIR)/sparki.a 2> /dev/null || true
	@rm $(BUILT_SPARKI_C_OBJS) 2> /dev/null || true
	@rm $(BUILT_SPARKI_C_OBJS:.o=.d) 2> /dev/null || true
	@rm $(BUILT_CORE_C_OBJS) 2> /dev/null || true
	@rm $(BUILT_CORE_C_OBJS:.o=.d) 2> /dev/null || true
	@rm $(BUILD_DIR)/sparki.a 2> /dev/null || true
	@rm $(BUILD_DIR)/core/core.a 2> /dev/null || true
	@rm $(BUILD_DIR)/*.o 2> /dev/null || true
	@rm $(BUILD_DIR)/*.d 2> /dev/null || true
	@rm $(BUILD_DIR)/*.elf 2> /dev/null || true
	@rm $(BUILD_DIR)/*.hex 2> /dev/null || true

.PHONY: clean
