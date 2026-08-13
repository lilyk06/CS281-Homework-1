#!/bin/bash
# Same build as buildandrunwcode.sh, at -O1 instead of -O0, specifically
# to give GCC's combine pass a chance to fold the `c = c + 5;` volatile
# read-modify-write into a single x86-64 memory-operand `add`, something
# -O0 never does on either target (see demo.c and README.md Section 5).
# RISC-V's disassembly should look structurally the same shape as the
# -O0 build for this line (still an explicit ld/addi/sd, just possibly
# fewer address-materialization instructions elsewhere if -O1 hoists
# a's base address), since RISC-V has no memory-operand ALU instruction
# to fold into at any optimization level.

#X64
\x86_64-linux-gnu-gcc \
    -g -S -O1 -fno-pie -no-pie \
    demo.c -o demo-x64-O1.s
x86_64-linux-gnu-gcc \
    -g -O1 -fno-pie -no-pie \
    demo.c -o demo-x64-O1
x86_64-linux-gnu-objdump \
    -d -S -M intel --disassemble=main demo-x64-O1

#RISCV
\riscv64-linux-gnu-gcc \
    -g -S -O1 -fno-pie -no-pie \
    -march=rv64g -mabi=lp64d \
    demo.c -o demo-riscv-O1.s
riscv64-linux-gnu-gcc \
    -g -O1 -fno-pie -no-pie \
    -march=rv64g -mabi=lp64d \
    demo.c -o demo-riscv-O1
riscv64-linux-gnu-objdump \
    -d -S --disassemble=main demo-riscv-O1
