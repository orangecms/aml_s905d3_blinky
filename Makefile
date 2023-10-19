CROSS_COMPILE := aarch64-linux-gnu-
OBJCOPY := $(CROSS_COMPILE)objcopy
OBJDUMP := $(CROSS_COMPILE)objdump
MKIMAGE := mkimage-aml
UPDATE := update

ELF := target/aarch64-unknown-none/release/blinky-rs
BIN := blinky.bin
IMG := blinky.aml

# SRAM base address
ADDR := 0xfffa0000

all: elf bin

elf:
	cargo build --release

bin:
	$(OBJCOPY) $(ELF) --strip-all -O binary $(BIN)

clean:
	cargo clean
	rm -f $(BIN) $(IMG)

dis: all
	$(OBJDUMP) -D $(ELF)

img: all
	$(MKIMAGE) -T amlimage -n sm1 -d $(BIN) $(IMG)

run: img
	aml_boot run $(IMG)
	# aml_boot write $(IMG) $(ADDR)
	# aml_boot exec $(ADDR)
