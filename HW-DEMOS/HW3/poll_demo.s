# poll_demo.s
#
# Bare-metal RV32 program for Renode (see hw3_renode.repl). Busy-polls
# the CLINT's mtime register directly, toggling the LED on every single
# pass through the loop, for 10 timed steps. Every LED toggle is real
# work: a real memory read, a real memory write, every cycle, whether
# or not anything meaningful has happened yet.
#
# Prints "loop N of 10" at each step, same wording and same step count
# as interrupt_demo.s, so the two logs line up side by side, the
# contrast is in how many actual loop iterations happen between each
# printed step, not in how many steps get printed.
#
# Startup, the stack, and UART printing all live in bootstrap.s, this
# file only contains the polling logic itself. main is called by
# bootstrap.s's _start once the stack is set up.
#
# This is the "same outcome, different cost" partner to interrupt_demo.s,
# both blink the LED 10 times, this one keeps the CPU fully busy the
# entire time to do it.
#
# Register discipline: s0-s7 hold everything that must survive across
# a `call` (uart_puts/uart_put_udec), t0-t2 are only ever used in a
# straight line with no call in between, exactly like bootstrap.s.
#
# BUILD: see README.md, assemble and link together with bootstrap.s.

    .equ LED,          0x60000800
    .equ COUNTER,       0x1000      # scratch RAM address, holds the
                                     # loop-iteration count so it can
                                     # still be read after the run via
                                     # the Renode monitor if wanted
    .equ MTIME_LO,      0x0200BFF8
    .equ STEP_TICKS,    50000       # simulated ticks per step. Renode's
                                     # instruction-level emulation runs
                                     # this busy loop far slower than
                                     # real time (observed: roughly
                                     # 30x), so in practice each step
                                     # takes a few real seconds, tuned
                                     # for a live demo, not for matching
                                     # a wall clock
    .equ LOOP_COUNT,    10          # print exactly 10 steps, same as
                                     # interrupt_demo.s

    .section .rodata
banner:
    .string "poll_demo: busy-polling, watch the CPU work for every tick\n"
loop_prefix:
    .string "poll_demo: loop "
loop_mid:
    .string " of 10, iterations so far = "
newline:
    .string "\n"
done_msg:
    .string "poll_demo: done, final iteration count = "

    .section .text
    .global main

main:
    la      a0, banner
    call    uart_puts

    li      s4, MTIME_LO
    lw      s5, 0(s4)               # s5 = start time
    li      s0, 0                   # s0 = iteration counter
    li      s1, LED
    li      s2, COUNTER
    li      s3, STEP_TICKS          # s3 = next print threshold
    li      s7, 1                   # s7 = next step number to print (1-10)

poll_loop:
    lw      t0, 0(s1)
    xori    t0, t0, 1
    sw      t0, 0(s1)

    addi    s0, s0, 1
    sw      s0, 0(s2)

    lw      t0, 0(s4)
    sub     s6, t0, s5              # s6 = elapsed ticks, survives any
                                     # call below, unlike a t-register

    blt     s6, s3, poll_skip_print
    la      a0, loop_prefix
    call    uart_puts
    mv      a0, s7
    call    uart_put_udec
    la      a0, loop_mid
    call    uart_puts
    mv      a0, s0
    call    uart_put_udec
    la      a0, newline
    call    uart_puts
    addi    s7, s7, 1
    li      t0, STEP_TICKS
    add     s3, s3, t0
poll_skip_print:

    li      t0, LOOP_COUNT
    addi    t0, t0, 1               # continue while s7 <= LOOP_COUNT,
    blt     s7, t0, poll_loop       # i.e. while s7 < LOOP_COUNT + 1

    la      a0, done_msg
    call    uart_puts
    mv      a0, s0
    call    uart_put_udec
    la      a0, newline
    call    uart_puts

done:
    j       done                    # halt here
