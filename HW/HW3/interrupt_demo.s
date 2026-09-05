# interrupt_demo.s
#
# Bare-metal RV32 program for Renode (see hw3_renode.repl). Enables the
# CLINT's software interrupt line, then executes wfi, a genuine
# low-power halt, and does nothing else until an interrupt actually
# wakes the CPU. The trap handler clears the pending interrupt, toggles
# the LED, prints a line over UART, and returns.
#
# Why software interrupt and not the timer: this demo originally
# scheduled interrupts via mtimecmp (the standard RISC-V timer
# interrupt). On this specific Renode 1.16.1 build, that path never
# fires, confirmed directly: mtime was read well past mtimecmp with
# mip still 0, and even a fresh write to mtimecmp with an already-
# elapsed target didn't set mip's timer bit, despite Renode's own
# published source suggesting it should. The CLINT-to-CPU wiring
# itself is fine, confirmed by writing the software interrupt register
# directly and seeing mip respond immediately. So this demo uses that
# working path instead: interrupt_demo.resc pulses the CLINT's
# software interrupt register on a real timer, from the Renode monitor
# itself, roughly every 5 seconds, standing in for "some real external
# event woke an idle CPU." Everything else, wfi, mtvec, mie/mstatus,
# the trap handler, mret, is exactly the same mechanism a real timer
# interrupt would use.
#
# This is the "same outcome, different cost" partner to poll_demo.s,
# both blink the LED 10 times, this one keeps the CPU fully idle the
# entire time in between. Both print "loop N of 10" with the same
# wording so the two logs line up side by side.
#
# A real trap handler in general-purpose code should save and restore
# every register it touches before returning. This one deliberately
# doesn't, because the only thing ever interrupted here is the wfi/loop
# below, which has no live register state to protect. Worth saying
# explicitly rather than leaving it as an accident: this is a
# simplification made because we know exactly what we're interrupting,
# not a general pattern to copy into real firmware.
#
# Startup, the stack, and UART printing all live in bootstrap.s, this
# file only contains the interrupt setup/handler logic. main is called
# by bootstrap.s's _start once the stack is set up.
#
# BUILD: see README.md, assemble and link together with bootstrap.s.
# RUN: see interrupt_demo.resc, it drives the periodic interrupt.

    .equ LED,           0x60000800
    .equ COUNTER,        0x1000     # scratch RAM address, holds the
                                     # count of real interrupts fired,
                                     # still readable after the run via
                                     # the Renode monitor if wanted
    .equ CLINT_MSIP,     0x02000000 # CLINT software interrupt register
                                     # for hart 0, write 1 to raise it,
                                     # write 0 to clear it
    .equ MIE_MSIE,       0x8        # mie bit 3, machine software interrupt enable
    .equ MSTATUS_MIE,    0x8        # mstatus bit 3, global interrupt enable
                                     # (same bit position, different CSR)

    .section .rodata
banner:
    .string "interrupt_demo: wfi (truly idle) until an interrupt wakes the CPU\n"
loop_prefix:
    .string "interrupt_demo: loop "
loop_suffix:
    .string " of 10\n"

    .section .text
    .global main
    .global trap_handler

main:
    li      t0, COUNTER
    sw      zero, 0(t0)             # interrupt-fired counter starts at 0

    la      a0, banner
    call    uart_puts

    la      t0, trap_handler        # direct mode: mtvec low 2 bits = 00,
    csrw    mtvec, t0               # all traps jump straight here

    li      t0, MIE_MSIE            # enable the software interrupt source
    csrs    mie, t0
    li      t0, MSTATUS_MIE         # enable interrupts globally
    csrs    mstatus, t0

wait_loop:
    wfi                             # halt here, truly idle, until a
                                     # real interrupt wakes the CPU
    j       wait_loop

# ------------------------------------------------------------------
# trap_handler: runs only when a real interrupt fires. Clears the
# pending software interrupt first, before anything else, so we don't
# immediately re-enter this handler the instant we mret. Each nested
# call below (uart_puts, uart_put_udec) is a plain sequential call, not
# a nested-then-continue call, so trap_handler itself never needs to
# preserve its own ra.
# ------------------------------------------------------------------
    .align 4
trap_handler:
    li      t0, CLINT_MSIP
    sw      zero, 0(t0)             # acknowledge/clear the interrupt

    li      t0, LED                 # toggle the LED, this happens once
    lw      t1, 0(t0)                # per real interrupt, not every cycle
    xori    t1, t1, 1
    sw      t1, 0(t0)

    li      t0, COUNTER              # bump the interrupt-fired count
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

    la      a0, loop_prefix
    call    uart_puts
    li      t0, COUNTER
    lw      a0, 0(t0)
    call    uart_put_udec
    la      a0, loop_suffix
    call    uart_puts

    mret
