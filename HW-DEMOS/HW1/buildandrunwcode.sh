#!/bin/bash

#X64
\x86_64-linux-gnu-gcc \
    -g -O0 -fno-pie -no-pie \
    demo.c -o demo-x64
x86_64-linux-gnu-objdump \
    -d -S -M intel --disassemble=main demo-x64

#RISCV
\riscv64-linux-gnu-gcc \
    -g -O0 -fno-pie -no-pie \
    -march=rv64g -mabi=lp64d \
    demo.c -o demo-riscv
riscv64-linux-gnu-objdump \
    -d -S --disassemble=main demo-riscv
