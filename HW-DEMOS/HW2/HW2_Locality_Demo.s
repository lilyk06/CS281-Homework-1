# HW2_Locality_Demo.s
#
# RV64 assembly demo for HW2: sums a large 2D array of 32-bit ints two
# ways, row-major and column-major, and times each with clock_gettime
# (wall-clock, via a raw Linux syscall). Same number of adds, same
# number of loads, in both loops. Only the memory access order differs.
#
# WHY WALL-CLOCK TIMING, NOT rdcycle: this program uses the
# clock_gettime syscall instead of the rdcycle CSR because rdcycle can
# be trapped/disabled for user-mode programs depending on the kernel or
# emulator's counter-enable settings, and it isn't reliably readable
# under QEMU user-mode emulation. clock_gettime works everywhere.
#
# IMPORTANT CAVEAT, READ BEFORE CLASS: whether this shows a real
# difference depends entirely on where you run it.
#
#   - Plain instruction-level simulators (RARS, Venus, a default `spike`
#     run with no memory-timing model) will NOT show a difference. They
#     execute every load in the same simulated time regardless of
#     address pattern, because they don't model a cache or memory
#     hierarchy at all. If you run this under one of those, expect the
#     two numbers to come out nearly identical, and that's expected, not
#     a bug in this code.
#   - Running under QEMU user-mode emulation (qemu-riscv64) SHOULD show
#     a real difference, because QEMU translates the guest's loads and
#     stores into actual reads/writes against host RAM, which goes
#     through the host machine's real cache hierarchy. The timing is the
#     host's real timing, even though the instructions being emulated
#     are RISC-V.
#   - Real RISC-V hardware (or a full-system VM on real hardware) will
#     show it most cleanly.
#   - A cycle-accurate simulator with a configured cache model (gem5, for
#     example) will also show it, and can additionally report actual
#     cache miss counts, not just wall-clock time.
#
# BUILD (Linux host with a RISC-V cross toolchain). --no-relax /
# -mno-relax are required on some binutils versions: linker relaxation
# can miscompute la/call offsets in hand-written assembly mixed with
# .align directives, and this program hits exactly that case.
#   riscv64-linux-gnu-as -march=rv64gc -mno-relax -o HW2_Locality_Demo.o HW2_Locality_Demo.s
#   riscv64-linux-gnu-ld --no-relax -o HW2_Locality_Demo HW2_Locality_Demo.o
#
# RUN under QEMU user-mode emulation:
#   qemu-riscv64 ./HW2_Locality_Demo
#
# RUN natively, if you have real riscv64 Linux hardware or a full-system
# VM:
#   ./HW2_Locality_Demo
#
# This binary makes raw Linux syscalls only (no libc), so it's fully
# static and doesn't need a sysroot for QEMU user-mode.
#
# TUNING N: N=8192 (256 MB array) is a large working set intended to
# make the locality effect very visible. Runtime grows roughly with
# N^2, so larger values can take a while, especially under emulation.
#
# OUTPUT:
#   row-major:    <nanoseconds>
#   column-major: <nanoseconds>
#   speedup:      <row/column ratio>x
#
# The speedup is defined as:
#   column-major time / row-major time
#
# So a result of 7.3x means the row-major traversal was about 7.3 times
# faster than the column-major traversal on that run.
#
# BUILD AND RUN:
#   riscv64-linux-gnu-as -march=rv64gc -mno-relax -o HW2_Locality_Demo.o HW2_Locality_Demo.s
#   riscv64-linux-gnu-ld --no-relax -o HW2_Locality_Demo HW2_Locality_Demo.o
#   qemu-riscv64 ./HW2_Locality_Demo

    .equ N, 8192

    .section .bss
    .align 3
array:
    .space N*N*4           # N x N x 4-byte ints.

    .align 3
ts0:    .space 16           # struct timespec { long tv_sec; long tv_nsec; }
ts1:    .space 16
ts2:    .space 16
ts3:    .space 16

numbuf: .space 24

    .section .data
msg_row:      .string "row-major:    "
msg_col:      .string "column-major: "
msg_speed:    .string "speedup:      "
msg_dot:      .string "."
msg_x:        .string "x\n"
msg_ns:       .string " ns\n"

    .section .text
    .global _start

_start:
    # Fill the array first so every page is actually resident in memory
    # before we start timing (avoids page-fault noise in the numbers).
    la      a0, array
    li      a1, N*N
    call    fill_array

    # ---- time row-major traversal ----
    li      a7, 113             # clock_gettime
    li      a0, 1               # CLOCK_MONOTONIC
    la      a1, ts0
    ecall

    la      a0, array
    li      a1, N
    call    sum_row_major

    li      a7, 113
    li      a0, 1
    la      a1, ts1
    ecall

    # ---- time column-major traversal ----
    li      a7, 113
    li      a0, 1
    la      a1, ts2
    ecall

    la      a0, array
    li      a1, N
    call    sum_col_major

    li      a7, 113
    li      a0, 1
    la      a1, ts3
    ecall

    # elapsed_row_ns = (ts1.sec - ts0.sec) * 1e9 + (ts1.nsec - ts0.nsec)
    la      t0, ts0
    ld      t1, 0(t0)           # ts0.sec
    ld      t2, 8(t0)           # ts0.nsec
    la      t0, ts1
    ld      t3, 0(t0)           # ts1.sec
    ld      t4, 8(t0)           # ts1.nsec
    sub     t5, t3, t1
    li      t6, 1000000000
    mul     t5, t5, t6
    sub     t2, t4, t2
    add     s2, t5, t2          # s2 = row-major elapsed ns

    # elapsed_col_ns = (ts3.sec - ts2.sec) * 1e9 + (ts3.nsec - ts2.nsec)
    la      t0, ts2
    ld      t1, 0(t0)
    ld      t2, 8(t0)
    la      t0, ts3
    ld      t3, 0(t0)
    ld      t4, 8(t0)
    sub     t5, t3, t1
    li      t6, 1000000000
    mul     t5, t5, t6
    sub     t2, t4, t2
    add     s3, t5, t2          # s3 = column-major elapsed ns

    # ----------------------------------------------------------
    # speedup_x10 = (column-major time * 10) / row-major time
    #
    # The integer part is s5 and the tenths digit is s6.
    # Example:
    #   714491596 / 97269569 ~= 7.3
    # ----------------------------------------------------------
    li      t0, 10
    mul     t1, s3, t0
    divu    s5, t1, s2          # speedup * 10
    li      t0, 10
    remu    s6, s5, t0          # tenths digit
    divu    s5, s5, t0          # integer part

    # ----------------------------------------------------------
    # Print row-major result
    # ----------------------------------------------------------
    la      a0, msg_row
    call    print_str
    mv      a0, s2
    call    print_uint
    la      a0, msg_ns
    call    print_str

    # ----------------------------------------------------------
    # Print column-major result
    # ----------------------------------------------------------
    la      a0, msg_col
    call    print_str
    mv      a0, s3
    call    print_uint
    la      a0, msg_ns
    call    print_str

    # ----------------------------------------------------------
    # Print speedup
    # ----------------------------------------------------------
    la      a0, msg_speed
    call    print_str

    mv      a0, s5
    call    print_uint

    la      a0, msg_dot
    call    print_str

    mv      a0, s6
    call    print_uint

    la      a0, msg_x
    call    print_str

    li      a7, 93              # exit
    li      a0, 0
    ecall


# ------------------------------------------------------------------
# fill_array(base=a0, count=a1): write i into each element
# ------------------------------------------------------------------
fill_array:
    li      t0, 0
fill_loop:
    bge     t0, a1, fill_done
    sw      t0, 0(a0)
    addi    a0, a0, 4
    addi    t0, t0, 1
    j       fill_loop
fill_done:
    ret


# ------------------------------------------------------------------
# sum_row_major(base=a0, n=a1): sum a[row][col], walking row-major
# (inner loop advances col, so consecutive accesses are 4 bytes apart)
# ------------------------------------------------------------------
sum_row_major:
    mv      t3, a0              # base pointer
    li      t4, 0               # row = 0
    li      s0, 0               # running sum
row_outer:
    bge     t4, a1, row_done
    li      t5, 0               # col = 0
row_inner:
    bge     t5, a1, row_next
    mul     t0, t4, a1          # row * n
    add     t0, t0, t5          # + col
    slli    t0, t0, 2           # * 4 bytes
    add     t0, t0, t3          # + base
    lw      t1, 0(t0)
    add     s0, s0, t1
    addi    t5, t5, 1
    j       row_inner
row_next:
    addi    t4, t4, 1
    j       row_outer
row_done:
    ret


# ------------------------------------------------------------------
# sum_col_major(base=a0, n=a1): sum a[row][col], walking column-major
# (inner loop advances row, so consecutive accesses are n*4 bytes
# apart, one full row length, which is the whole point)
# ------------------------------------------------------------------
sum_col_major:
    mv      t3, a0
    li      t4, 0               # col = 0
    li      s0, 0
col_outer:
    bge     t4, a1, col_done
    li      t5, 0               # row = 0
col_inner:
    bge     t5, a1, col_next
    mul     t0, t5, a1          # row * n
    add     t0, t0, t4          # + col
    slli    t0, t0, 2
    add     t0, t0, t3
    lw      t1, 0(t0)
    add     s0, s0, t1
    addi    t5, t5, 1
    j       col_inner
col_next:
    addi    t4, t4, 1
    j       col_outer
col_done:
    ret


# ------------------------------------------------------------------
# print_str(ptr=a0): write a NUL-terminated string to stdout
# ------------------------------------------------------------------
print_str:
    mv      t0, a0
    mv      t1, a0
strlen_loop:
    lb      t2, 0(t1)
    beqz    t2, strlen_done
    addi    t1, t1, 1
    j       strlen_loop
strlen_done:
    sub     a2, t1, t0          # length
    mv      a1, t0              # buf
    li      a0, 1               # fd = stdout
    li      a7, 64              # write syscall
    ecall
    ret


# ------------------------------------------------------------------
# print_uint(val=a0): print an unsigned 64-bit integer in decimal
# ------------------------------------------------------------------
print_uint:
    # print_uint makes a nested call to print_str, so it must save its
    # own return address before that call and restore it after, or the
    # second `ret` below would jump back into this function instead of
    # back to the caller (an infinite self-loop).
    addi    sp, sp, -8
    sd      ra, 0(sp)

    la      t0, numbuf
    addi    t0, t0, 23
    sb      zero, 0(t0)         # NUL terminator at the end of the buffer
    li      t1, 10
    mv      t2, a0
    bnez    t2, convert_loop

    addi    t0, t0, -1
    li      t3, '0'
    sb      t3, 0(t0)
    j       convert_done

convert_loop:
    beqz    t2, convert_done
    remu    t3, t2, t1
    addi    t3, t3, '0'
    addi    t0, t0, -1
    sb      t3, 0(t0)
    divu    t2, t2, t1
    j       convert_loop

convert_done:
    mv      a0, t0
    call    print_str

    ld      ra, 0(sp)
    addi    sp, sp, 8
    ret
