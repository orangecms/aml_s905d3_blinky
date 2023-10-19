MKIMAGE := mkimage-aml
AML_BOOT := aml_boot

ELF := target/aarch64-unknown-none/release/blinky-rs
BIN := blinky.bin
IMG := blinky.aml

# SRAM base address
ADDR := 0xfffa0000

all: elf bin

elf:
	cargo build --release

bin:
	cargo objcopy --release -- -O binary $(BIN)

clean:
	cargo clean
	rm -f $(BIN) $(IMG)

dis: all
	cargo objdump --release -- -D

img: all
	$(MKIMAGE) -T amlimage -n sm1 -d $(BIN) $(IMG)

run: img
	$(AML_BOOT) run $(IMG)
	# $(AML_BOOT) write $(IMG) $(ADDR)
	# $(AML_BOOT) exec $(ADDR)
