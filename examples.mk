#? Is there a more idiomatic way of doing this?

$(BUILD_DIR)/serial.c.o: serial-bluetooth/hello_serial.c
	"$(AVR_BIN_DIR)/avr-gcc" $(CC_FLAGS) $(ARDUINO_FLAGS) "-I$(SPARKI_DIR)" $< -o $@

$(BUILD_DIR)/serial-bluetooth.c.o: serial-bluetooth/hello_bluetooth.c
	"$(AVR_BIN_DIR)/avr-gcc" $(CC_FLAGS) $(ARDUINO_FLAGS) "-I$(SPARKI_DIR)" $< -o $@
