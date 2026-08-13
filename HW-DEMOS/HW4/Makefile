# Makefile for the HW4 soft-float vs. hardware-float demo (see README.md).
#
# Builds the identical fp_demo.c twice: once targeting the base RISC-V
# integer ISA (no F extension, floating point done by this file's own
# soft_add/soft_sub/soft_mul/soft_div routines, see fp_demo.c for why
# this doesn't use libgcc) and once targeting rv64gc (real hardware F
# instructions). The only difference between the two binaries is
# whether the target CPU has floating-point hardware, everything else
# about the source is identical.

CC         = riscv64-linux-gnu-gcc
# -fno-pie/-no-pie: Ubuntu's gcc defaults to building PIE executables,
# which embed a request for a dynamic loader (ld-linux-riscv64-*.so.1)
# even with -nostdlib and nothing actually linked in. There's no target
# libc installed to provide that loader, so without these flags the
# binary fails at qemu-riscv64 startup with "Could not open
# ld-linux-riscv64...: No such file or directory" before it ever runs
# a single instruction. This build is a single freestanding static
# binary, it was never meant to be a PIE.
# OPT is broken out separately (rather than baked into CFLAGS) so it's
# easy to override from the command line: `make clean && make OPT=-O0`
# rebuilds both binaries with optimization disabled, useful for
# checking whether -O2 is inlining the soft_* calls into main and
# giving the software build an unrepresentative advantage, see
# README.md Section 4.
OPT        ?= -O2
CFLAGS     = $(OPT) -ffreestanding -fno-builtin -fno-stack-protector -mno-relax -fno-pie
# -Wl,-z,noexecstack / -z,separate-code: without a linker script, this
# freestanding, -nostdlib build ends up with a single LOAD segment
# marked RWX, which ld.bfd warns about ("has a LOAD segment with RWX
# permissions"). Harmless for a demo binary run once under
# qemu-riscv64 and thrown away, but these flags ask the linker to keep
# code and data in separate segments where possible, which quiets the
# warning without changing behavior.
LDFLAGS    = -nostdlib -no-pie -Wl,--no-relax -Wl,-z,noexecstack -Wl,-z,separate-code
ITERATIONS ?= 10000000

.PHONY: all clean

all: fp_demo_soft fp_demo_hard

fp_demo_soft: fp_demo.c start.S
	$(CC) $(CFLAGS) -march=rv64imac -mabi=lp64 -DSOFT_FLOAT -DITERATIONS=$(ITERATIONS)L \
		$(LDFLAGS) -o $@ start.S fp_demo.c

fp_demo_hard: fp_demo.c start.S
	$(CC) $(CFLAGS) -march=rv64gc -mabi=lp64d -DITERATIONS=$(ITERATIONS)L \
		$(LDFLAGS) -o $@ start.S fp_demo.c

instr-count: fp_demo_hard fp_demo_soft
	@chmod +x count_instr.sh
	@./count_instr.sh

clean:
	rm -f fp_demo_soft fp_demo_hard
