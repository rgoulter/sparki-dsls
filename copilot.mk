# Assumed to run from root dir of repo/project
copilot-c99-codegen/copilot.h copilot-c99-codegen/copilot.c: copilot/Line_Following/LineFollowing.hs
	@rm -rf copilot-c99-codegen 2> /dev/null || true
	@echo "Generating Copilot sources"
	cabal exec -- runghc copilot/Line_Following/LineFollowing.hs

# In order to make the copilot example, it can be involved, since involves
# running Haskell to generate C part.
#
# For now, we ignore copilot prefix.
$(BUILD_DIR)/copilot-line_following.c.o: copilot/Line_Following/Line_Following.c copilot-c99-codegen/copilot.h
	"$(AVR_BIN_DIR)/avr-gcc" $(CC_FLAGS) $(ARDUINO_FLAGS) "-I$(SPARKI_DIR)" -Icopilot-c99-codegen $< -o $@

$(BUILD_DIR)/copilot.o: copilot-c99-codegen/copilot.c
	"$(AVR_BIN_DIR)/avr-gcc" $(CC_FLAGS) -Wno-unused-variable $(ARDUINO_FLAGS) "-I$(SPARKI_DIR)" -Icopilot-c99-codegen $< -o $@



# Need to incl. copilot object files also
$(BUILD_DIR)/copilot-line_following.elf: $(BUILD_DIR)/copilot-line_following.c.o $(BUILD_DIR)/core/core.a $(BUILD_DIR)/sparki.a $(BUILD_DIR)/copilot.o
	"$(AVR_BIN_DIR)/avr-gcc" -w -Os -Wl,--gc-sections -mmcu=atmega32u4 -o $@ $< $(BUILD_DIR)/copilot.o $(BUILD_DIR)/sparki.a "$(BUILD_DIR)/core/core.a" "-L$(BUILD_DIR)" -lm
