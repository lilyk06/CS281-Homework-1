# interrupt_diag_spin.s
#
# DIAGNOSTIC ONLY, not the classroom demo. Identical setup to
# interrupt_demo.s (same mtvec/mtimecmp/mie/mstatus sequence), except
# wait_loop busy-spins instead of executing wfi, and prints a status
# line periodically so its progress is visible over UART the same way
# poll_demo's is. If the timer interrupt fires here but never fires in
# interrupt_demo.s, that proves the CLINT/mtimecmp mechanism itself is
# fine and the bug is specifically in how this CPU model advances
# simulated time while genuinely halted in wfi.
#
# BUILD: see README.md, assemble and link together with bootstrap.s.

    .equ COUNTER,        0x1000
    .equ MTIME_LO,       0x0200BFF8
    .equ MTIMECMP_LO,    0x02004000
    .equ TICK_INTERVAL,  500000     # see poll_demo.s: kept small because
                                     # Renode's instruction-level emulation
                                     # runs a busy loop far slower than
                                     # real time (observed roughly 30x)
    .equ PRINT_STEP,     100000
    .equ MIE_MTIE,       0x80
    .equ MSTATUS_MIE,    0x8

    .section .rodata
banner:
    .string "interrupt_diag_spin: same interrupt setup as interrupt_demo, but spinning on nop instead of wfi\n"
status_msg:
    .string "interrupt_diag_spin: still spinning, no IRQ yet, elapsed ticks = "
irq_msg:
    .string "interrupt_diag_spin: IRQ fired! count = "
newline:
    .string "\n"

    .section .text
    .global main
    .global trap_handler

main:
    li      t0, COUNTER
    sw      zero, 0(t0)

    la      a0, banner
    call    uart_puts

    la      t0, trap_handler
    csrw    mtvec, t0

    call    schedule_next_interrupt

    li      t0, MIE_MTIE
    csrs    mie, t0
    li      t0, MSTATUS_MIE
    csrs    mstatus, t0

    li      s4, MTIME_LO
    lw      s5, 0(s4)               # s5 = start time
    li      s3, PRINT_STEP          # s3 = next print threshold, start
                                     # at one full step out so we don't
                                     # print a redundant line at ~0

wait_loop:
    lw      t0, 0(s4)
    sub     s6, t0, s5              # s6 = elapsed ticks, survives any
                                     # call below, unlike a t-register

    blt     s6, s3, wait_skip_print
    la      a0, status_msg
    call    uart_puts
    mv      a0, s6
    call    uart_put_udec
    la      a0, newline
    call    uart_puts
    li      t0, PRINT_STEP
    add     s3, s3, t0
wait_skip_print:
    j       wait_loop               # busy-spin, on purpose, this file
                                     # only exists to test whether active
                                     # execution unblocks the timer

schedule_next_interrupt:
    li      t0, MTIME_LO
    lw      t1, 0(t0)
    li      t2, TICK_INTERVAL
    add     t1, t1, t2
    li      t0, MTIMECMP_LO
    sw      t1, 0(t0)
    ret

    .align 4
trap_handler:
    li      t0, COUNTER
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

    la      a0, irq_msg
    call    uart_puts
    li      t0, COUNTER
    lw      a0, 0(t0)
    call    uart_put_udec
    la      a0, newline
    call    uart_puts

    call    schedule_next_interrupt

    mret
