MKIMAGE := mkimage-aml
ASM := blinky.asm
ELF := blinky.elf
BIN := blinky.bin
IMG := blinky.aml

all: elf bin

elf:
	aarch64-linux-gnu-as -o $(ELF) $(ASM)

bin:
	aarch64-linux-gnu-objcopy $(ELF) --strip-all -O binary $(BIN)

clean:
	rm -f $(ELF) $(BIN) $(IMG)

dis: all
	aarch64-linux-gnu-objdump -D blinky

img: all
	$(MKIMAGE) -T amlimage -n sm1 -d $(BIN) $(IMG)

run: img
	echo TODO
	aml_boot write 0x40000000 $(IMG)
	aml_boot exec 0x40000000
