# Makefile for the HW3 Renode demo (see README.md).
#
# Targets:
#   make            build both poll_demo.elf and interrupt_demo.elf
#   make diag       build interrupt_diag_spin.elf (debugging aid only)
#   make run-poll   build (if needed) and launch poll_demo in Renode
#   make run-int    build (if needed) and launch interrupt_demo in Renode
#   make run-diag   build (if needed) and launch interrupt_diag_spin in Renode
#   make clean      remove all built .o/.elf files

AS      = riscv64-unknown-elf-as
LD      = riscv64-unknown-elf-ld
ASFLAGS = -march=rv32im_zicsr -mabi=ilp32 -mno-relax
LDFLAGS = -m elf32lriscv --no-relax

.PHONY: all diag run-poll run-int run-diag clean

all: poll_demo.elf interrupt_demo.elf

diag: interrupt_diag_spin.elf

bootstrap.o: bootstrap.s
	$(AS) $(ASFLAGS) -o $@ $<

poll_demo.o: poll_demo.s
	$(AS) $(ASFLAGS) -o $@ $<

interrupt_demo.o: interrupt_demo.s
	$(AS) $(ASFLAGS) -o $@ $<

interrupt_diag_spin.o: interrupt_diag_spin.s
	$(AS) $(ASFLAGS) -o $@ $<

poll_demo.elf: bootstrap.o poll_demo.o
	$(LD) $(LDFLAGS) -o $@ $^

interrupt_demo.elf: bootstrap.o interrupt_demo.o
	$(LD) $(LDFLAGS) -o $@ $^

interrupt_diag_spin.elf: bootstrap.o interrupt_diag_spin.o
	$(LD) $(LDFLAGS) -o $@ $^

run-poll: poll_demo.elf
	renode poll_demo.resc

run-int: interrupt_demo.elf
	renode interrupt_demo.resc

run-diag: interrupt_diag_spin.elf
	renode interrupt_diag_spin.resc

clean:
	rm -f *.o *.elf
