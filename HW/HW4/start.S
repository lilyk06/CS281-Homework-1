# start.S
#
# Minimal freestanding entry point for fp_demo.c, no libc, no crt0.
# The Linux kernel already sets up a valid stack pointer before jumping
# here (it just isn't guaranteed to be 16-byte aligned), so all this
# needs to do is align it to satisfy the C calling convention, call
# straight into main, then exit with main's return value.
#
# mno-relax / --no-relax are passed at build time (see Makefile), same
# defensive reasoning as the HW2 and HW3 demos: hand-written assembly
# combined with linker relaxation has bitten this project twice
# already, cheap insurance here even though this file has none of the
# specific patterns (la/call mixed with .align) that caused those bugs.

    .section .text
    .global _start

_start:
    andi    sp, sp, -16    # satisfy the C ABI's 16-byte stack alignment
    call    main
    li      a7, 93         # sys_exit
    ecall
