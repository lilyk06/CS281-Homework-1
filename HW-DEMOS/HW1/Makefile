# Makefile for the HW1 demo (see readme.md). Replaces the three
# standalone build scripts (buildandrunwcode.sh, buildandrunwcode_O1.sh,
# buildandrun.sh) and clean.sh with equivalent make targets, so the
# whole demo is driven one consistent way, same as every other HW-DEMOS
# folder.
#
#   make            same as `make run`
#   make run        build + disassemble both ISAs, -O0 then -O1 (the
#                   two-step sequence readme.md Section 1 documents)
#   make run-o0     -O0 only, source-interleaved (was buildandrunwcode.sh)
#                   shows RISC-V's load/store address-materialization cost
#   make run-o1     -O1 only (was buildandrunwcode_O1.sh)
#                   shows x86-64's memory-operand fold, RISC-V can't do this
#                   at any optimization level
#   make run-o0-raw -O0, no -g/-S source interleaving (was buildandrun.sh)
#                   raw addresses/bytes only, use if the source-interleaved
#                   output feels too busy
#   make clean      remove every generated binary and .s file
#
# SRC selects which C file to build. Defaults to demo.c (the current
# 7-element array, the main demo). demo2.c is the original 3-element
# version output.md was captured from; `make run-o0 SRC=demo2.c`
# reproduces output.md exactly if you want to check it against a fresh
# run instead of trusting the saved copy.

CC_X64      = x86_64-linux-gnu-gcc
OBJDUMP_X64 = x86_64-linux-gnu-objdump
CC_RISCV    = riscv64-linux-gnu-gcc
OBJDUMP_RISCV = riscv64-linux-gnu-objdump
RISCV_FLAGS = -march=rv64g -mabi=lp64d

SRC ?= demo.c

.PHONY: all run run-o0 run-o1 run-o0-raw clean

all: run

run: run-o0 run-o1

# -O0, source-interleaved. Was buildandrunwcode.sh.
run-o0:
	$(CC_X64) -g -O0 -fno-pie -no-pie $(SRC) -o demo-x64
	$(OBJDUMP_X64) -d -S -M intel --disassemble=main demo-x64
	$(CC_RISCV) -g -O0 -fno-pie -no-pie $(RISCV_FLAGS) $(SRC) -o demo-riscv
	$(OBJDUMP_RISCV) -d -S --disassemble=main demo-riscv

# -O1, also saves each target's raw compiler-generated .s alongside the
# objdump disassembly. Was buildandrunwcode_O1.sh.
run-o1:
	$(CC_X64) -g -S -O1 -fno-pie -no-pie $(SRC) -o demo-x64-O1.s
	$(CC_X64) -g -O1 -fno-pie -no-pie $(SRC) -o demo-x64-O1
	$(OBJDUMP_X64) -d -S -M intel --disassemble=main demo-x64-O1
	$(CC_RISCV) -g -S -O1 -fno-pie -no-pie $(RISCV_FLAGS) $(SRC) -o demo-riscv-O1.s
	$(CC_RISCV) -g -O1 -fno-pie -no-pie $(RISCV_FLAGS) $(SRC) -o demo-riscv-O1
	$(OBJDUMP_RISCV) -d -S --disassemble=main demo-riscv-O1

# -O0, no -g/-S: raw addresses and bytes, no source lines interleaved.
# Was buildandrun.sh. Overwrites the same demo-x64/demo-riscv binaries
# run-o0 produces, same as the original scripts did.
run-o0-raw:
	$(CC_X64) -O0 -fno-pie -no-pie $(SRC) -o demo-x64
	$(OBJDUMP_X64) -d -M intel --disassemble=main demo-x64
	$(CC_RISCV) -O0 -fno-pie -no-pie $(RISCV_FLAGS) $(SRC) -o demo-riscv
	$(OBJDUMP_RISCV) -d --disassemble=main demo-riscv

clean:
	rm -f demo-x64 demo-riscv demo-x64-O1 demo-riscv-O1 \
	      demo-x64-O1.s demo-riscv-O1.s
