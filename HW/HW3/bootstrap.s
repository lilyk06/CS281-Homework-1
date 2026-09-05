# bootstrap.s
#
# Shared startup code and UART I/O helpers for the HW3 Renode demos
# (poll_demo.s, interrupt_demo.s, interrupt_diag_spin.s). Kept separate
# so each demo file only contains the logic that actually differs
# between polling and interrupts, everything else (stack setup,
# printing) lives here once.
#
# Provides:
#   _start        - sets sp, then calls main (defined in the demo file)
#   uart_putc     - a0 = character to send
#   uart_puts     - a0 = pointer to a null-terminated string
#   uart_put_hex  - a0 = 32-bit value, printed as "0x" + 8 hex digits
#   uart_put_udec - a0 = 32-bit unsigned value, printed as decimal
#
# UART is a LiteX UART (see hw3_renode.repl), register layout matches
# Renode's own UART.LiteX_UART model, transmit side only is used here:
#   RxTx    +0x00  write: transmit one byte
#   TxFull  +0x04  read:  bit0 set when the TX FIFO is full
#
# Register discipline: any value that needs to stay valid across a
# `call` must live in a saved register (s0-s11), never a temporary
# (t0-t6) or argument register (a0-a7), those are free to be clobbered
# by whatever gets called. Every helper below that itself makes a
# nested call saves/restores ra and any saved registers it uses, so
# from a caller's point of view s0-s11 always survive a call here.
#
# BUILD: assemble this file and exactly one demo file separately, then
# link both object files together, see README.md.

    .equ UART_BASE,   0x60001800
    .equ UART_RXTX,   0x00
    .equ UART_TXFULL, 0x04

    .section .text
    .global _start
    .global uart_putc
    .global uart_puts
    .global uart_put_hex
    .global uart_put_udec

_start:
    li      sp, 0x40000             # stack pointer, top of RAM
    call    main
halt:
    j       halt                    # safety net, main should never return

# ------------------------------------------------------------------
# uart_putc: send one character. a0 = character.
# Leaf function, no nested calls, no need to save ra.
# ------------------------------------------------------------------
uart_putc:
    li      t0, UART_BASE
putc_wait:
    lw      t1, UART_TXFULL(t0)
    andi    t1, t1, 1
    bnez    t1, putc_wait          # spin while the TX FIFO is full
    sw      a0, UART_RXTX(t0)
    ret

# ------------------------------------------------------------------
# uart_puts: send a null-terminated string. a0 = pointer to string.
# ------------------------------------------------------------------
uart_puts:
    addi    sp, sp, -8
    sw      ra, 4(sp)
    sw      s0, 0(sp)
    mv      s0, a0
puts_loop:
    lb      a0, 0(s0)
    beqz    a0, puts_done
    call    uart_putc
    addi    s0, s0, 1
    j       puts_loop
puts_done:
    lw      s0, 0(sp)
    lw      ra, 4(sp)
    addi    sp, sp, 8
    ret

# ------------------------------------------------------------------
# uart_put_hex: send a0 as "0x" followed by 8 hex digits.
# ------------------------------------------------------------------
uart_put_hex:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    sw      s0, 8(sp)
    sw      s1, 4(sp)
    mv      s0, a0                  # s0 = value being printed
    li      a0, '0'
    call    uart_putc
    li      a0, 'x'
    call    uart_putc
    li      s1, 28                  # s1 = bit offset of current nibble
hex_loop:
    srl     t0, s0, s1
    andi    t0, t0, 0xF
    li      t1, 10
    blt     t0, t1, hex_digit
    addi    a0, t0, 55              # 'A' - 10
    j       hex_emit
hex_digit:
    addi    a0, t0, '0'
hex_emit:
    call    uart_putc
    addi    s1, s1, -4
    bgez    s1, hex_loop
    lw      s1, 4(sp)
    lw      s0, 8(sp)
    lw      ra, 12(sp)
    addi    sp, sp, 16
    ret

# ------------------------------------------------------------------
# uart_put_udec: send a0 as an unsigned decimal number, no leading
# zeros. Digits are built into a small stack buffer least-significant
# digit first, then emitted in the correct order.
# ------------------------------------------------------------------
uart_put_udec:
    addi    sp, sp, -32
    sw      ra, 28(sp)
    sw      s0, 24(sp)              # s0 = remaining value
    sw      s1, 20(sp)              # s1 = write cursor into the buffer
    sw      s2, 16(sp)              # s2 = one-past-the-end of the buffer
    mv      s0, a0
    addi    s2, sp, 16              # buffer is sp+0 .. sp+15, 16 bytes,
    mv      s1, s2                  # enough for any 32-bit value (max 10 digits)
udec_split:
    li      t2, 10
    remu    t0, s0, t2
    addi    t0, t0, '0'
    addi    s1, s1, -1
    sb      t0, 0(s1)
    divu    s0, s0, t2
    bnez    s0, udec_split
udec_emit:
    lb      a0, 0(s1)
    call    uart_putc
    addi    s1, s1, 1
    blt     s1, s2, udec_emit
    lw      s2, 16(sp)
    lw      s1, 20(sp)
    lw      s0, 24(sp)
    lw      ra, 28(sp)
    addi    sp, sp, 32
    ret
