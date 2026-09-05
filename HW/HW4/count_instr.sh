#!/usr/bin/env bash
# count_instr.sh
#
# Counts the real RISC-V instructions inside each soft_* function in
# fp_demo_soft, via objdump, and compares against the single hardware
# instruction (fadd.s/fsub.s/fmul.s/fdiv.s) each one replaces.
#
# This is a per-function, per-call static count, not a count of the
# whole program: fp_demo.c marks soft_add/soft_sub/soft_mul/soft_div
# noinline specifically so this works reliably. Two earlier approaches
# both broke: counting by function name without noinline let GCC
# inline some functions away at -O2, leaving no symbol to find (some
# functions silently counted as 0); comparing whole-.text-section
# totals avoided that but introduced a worse problem, main's outer
# loop (ITERATIONS iterations) is a real runtime loop that appears
# only once in .text no matter how large ITERATIONS is, while the
# inner 8-pass loop may get fully unrolled in one build and kept as a
# real loop in the other, so a whole-program byte count doesn't
# actually track dynamic execution cost. Per-function counts sidestep
# both problems: each function's static size is a fixed, honest
# per-call cost, and both builds perform the exact same number of
# calls (ITERATIONS * OPS_PER_ITER for each of the four operations),
# so the per-call ratio here equals the true total dynamic instruction
# ratio.
#
# Invoked via `make instr-count`, see README.md Section 4.

set -e

BIN=fp_demo_soft
OBJDUMP=riscv64-linux-gnu-objdump

if [ ! -f "$BIN" ]; then
    echo "error: $BIN not found, run 'make' first" >&2
    exit 1
fi

if ! command -v "$OBJDUMP" >/dev/null 2>&1; then
    echo "error: $OBJDUMP not found on PATH" >&2
    exit 1
fi

count_fn() {
    local fn="$1"
    "$OBJDUMP" -d "$BIN" | awk -v fn="<${fn}>:" '
        index($0, fn) > 0 { infn=1; next }
        infn && /^[0-9a-f]+ </ { infn=0 }
        infn && /:\t/ { count++ }
        END { print count+0 }
    '
}

total=0
missing=0
echo "Real RISC-V instructions per call, from fp_demo_soft (objdump -d):"
echo ""
for fn in soft_add soft_sub soft_mul soft_div; do
    n=$(count_fn "$fn")
    if [ "$n" -eq 0 ]; then
        missing=1
    fi
    total=$((total + n))
    printf "  %-9s %4d instructions   (fp_demo_hard: 1 instruction, e.g. fadd.s)\n" "$fn" "$n"
done
echo ""

if [ "$missing" -eq 1 ]; then
    echo "warning: at least one function showed 0 instructions, meaning its"
    echo "<name>: symbol wasn't found in the disassembly. fp_demo.c marks all"
    echo "four functions noinline specifically to prevent this, if you're"
    echo "still seeing it, confirm fp_demo.c in this directory has the"
    echo "__attribute__((noinline)) markers and that fp_demo_soft was rebuilt"
    echo "after they were added (make clean && make)."
    exit 1
fi

echo "  4 ops combined: ${total} instructions in fp_demo_soft, vs 4 instructions in fp_demo_hard"
ratio=$(awk -v t="$total" 'BEGIN { printf "%.1f", t/4 }')
echo "  static instruction-count ratio: ${ratio}x"
echo ""
echo "Both builds perform the exact same number of calls to these four"
echo "operations (ITERATIONS * ${OPS_PER_ITER:-8} each), so this per-call"
echo "ratio is also the true ratio of total dynamic instructions executed,"
echo "not just a per-function snapshot."
echo ""
echo "Compare this to the wall-clock ratio from 'time qemu-riscv64 ./fp_demo_hard'"
echo "vs './fp_demo_soft'. The wall-clock ratio will be noticeably smaller,"
echo "see README.md Section 4 for why: qemu-riscv64 implements RISC-V's"
echo "hardware float instructions through its own internal software float"
echo "library, so the timed run compares two different software"
echo "implementations, not software against real silicon."
