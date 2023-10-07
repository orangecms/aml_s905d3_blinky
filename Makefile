CROSS_COMPILE := aarch64-linux-gnu-
AS := $(CROSS_COMPILE)as
OBJCOPY := $(CROSS_COMPILE)objcopy
OBJDUMP := $(CROSS_COMPILE)objdump
MKIMAGE := mkimage-aml

ASM := blinky.asm
ELF := blinky.elf
BIN := blinky.bin
IMG := blinky.aml

ADDR := 0xfffa0000

all: elf bin

elf:
	$(AS) -o $(ELF) $(ASM)

bin:
	$(OBJCOPY) $(ELF) --strip-all -O binary $(BIN)

clean:
	rm -f $(ELF) $(BIN) $(IMG)

dis: all
	$(OBJDUMP) -D blinky

img: all
	$(MKIMAGE) -T amlimage -n sm1 -d $(BIN) $(IMG)

run: img
	@echo ""
	@echo "TODO: implement in \`aml_boot\`; use \`update\` or \`pyamlboot\` for now"
	@echo ""
	@echo "    run \"update write $(IMG) $(ADDR); update run $(ADDR)\""
	@echo ""
	# aml_boot write $(ADDR) $(IMG)
	# aml_boot exec $(ADDR)
