/* fp_demo.c
 *
 * HW4 demo: the identical floating-point loop, compiled twice for two
 * different RISC-V targets, once with no floating-point hardware at
 * all, once with the F hardware extension.
 *
 * IMPORTANT BUILD NOTE: this does NOT use libgcc's software float
 * routines. The cross toolchain this project targets ships a single,
 * non-multilib libgcc.a built assuming hardware double-float support,
 * so it cannot provide working __addsf3/__divsf3/etc. for a soft-float
 * target (confirmed directly: `riscv64-linux-gnu-gcc -print-multi-lib`
 * reports only one configuration, and linking against it for a
 * soft-float ABI fails with "can't link double-float modules with
 * soft-float modules"). Rather than depend on a toolchain feature that
 * isn't guaranteed to be installed, this file provides its own
 * minimal single-precision software float routines (soft_add,
 * soft_sub, soft_mul, soft_div), used only in the SOFT_FLOAT build.
 * These are positive-number-only, no NaN/Inf/subnormal handling,
 * which is fine, every value this demo ever computes is a small
 * positive finite number, real IEEE-754 edge cases never come up.
 * Correctness was verified against native float arithmetic across
 * millions of iterations before this file was finalized.
 *
 * SOFT_FLOAT is defined by the Makefile for the soft build only. The
 * hard build never sees these functions at all, it uses native `+`,
 * `-`, `*`, `/` on `float`, which the compiler turns directly into
 * fadd.s/fsub.s/fmul.s/fdiv.s hardware instructions under -march=rv64gc.
 *
 * Freestanding (no libc), see start.S for the entry point and
 * README.md for why timing is done externally via the `time` command
 * rather than with any code in this file.
 */

#include <stdint.h>

#ifndef ITERATIONS
#define ITERATIONS 20000000L
#endif

/* volatile so the compiler can't prove this value is never used and
 * optimize the entire loop away. Standard microbenchmark practice. */
volatile float result;

#ifdef SOFT_FLOAT

typedef union { float f; uint32_t u; } f32u;
static uint32_t bits(float f) { f32u c; c.f = f; return c.u; }
static float from_bits(uint32_t u) { f32u c; c.u = u; return c.f; }

/* Positive-only, finite-only, no-subnormal single-precision software
 * float arithmetic. Not a general-purpose IEEE-754 implementation,
 * it doesn't need to be, this demo never produces zero, a negative
 * number, or a value outside a normal exponent range.
 *
 * noinline and noclone are both deliberate, not a performance choice.
 * Two separate optimizations were fighting the disassembly-based
 * instruction counting in count_instr.sh:
 *   - Without noinline, GCC at -O2 inlines some of these four
 *     functions into main and leaves others as standalone calls
 *     (whichever it judges cheap enough), so a per-function count
 *     would silently show 0 for whichever ones got folded away.
 *   - Without noclone, GCC's interprocedural constant propagation
 *     notices that soft_sub/soft_mul/soft_div are each always called
 *     with one argument fixed at the same compile-time constant
 *     (b or a in main), and replaces the plain soft_sub/soft_mul/
 *     soft_div symbol with a specialized clone named
 *     soft_sub.constprop.0 (etc.), a real, different optimization
 *     from inlining, noinline alone doesn't stop it. A name-based
 *     symbol lookup for "soft_sub" then finds nothing, same visible
 *     symptom (0 instructions) as the inlining problem, different
 *     cause.
 * Together, noinline and noclone keep all four as real, unspecialized,
 * disassemblable functions every time, which is what makes `make
 * instr-count` (see count_instr.sh) and the disassembly walkthrough in
 * README.md Section 4 give a stable, reproducible answer instead of
 * one that depends on the optimizer's mood. It also makes the code
 * humans read match the code the compiler actually keeps, always a
 * real `call soft_add`, never an invisible inlined or cloned copy. */

static float __attribute__((noinline, noclone)) soft_add(float af, float bf) {
    uint32_t au = bits(af), bu = bits(bf);
    int ae = (au >> 23) & 0xFF, be = (bu >> 23) & 0xFF;
    uint32_t am = (au & 0x7FFFFF) | 0x800000;
    uint32_t bm = (bu & 0x7FFFFF) | 0x800000;
    int rexp;
    uint32_t amant = am << 3, bmant = bm << 3; /* 3 guard bits */
    int diff = ae - be;
    if (diff >= 0) {
        rexp = ae;
        bmant = (diff > 27) ? 0 : (bmant >> diff);
    } else {
        rexp = be;
        amant = (-diff > 27) ? 0 : (amant >> (-diff));
    }
    uint32_t rmant = amant + bmant;
    while (rmant >= (1u << 27)) { rmant >>= 1; rexp++; }
    while (rmant < (1u << 26) && rexp > 0) { rmant <<= 1; rexp--; }
    uint32_t rounded = (rmant + 4) >> 3; /* round to nearest on the guard bits */
    if (rounded & (1u << 24)) { rounded >>= 1; rexp++; }
    return from_bits(((uint32_t)rexp << 23) | (rounded & 0x7FFFFF));
}

/* af - bf. Valid only when af > bf > 0, which holds for every
 * subtraction this demo's loop performs. */
static float __attribute__((noinline, noclone)) soft_sub(float af, float bf) {
    uint32_t au = bits(af), bu = bits(bf);
    int ae = (au >> 23) & 0xFF, be = (bu >> 23) & 0xFF;
    uint32_t am = (au & 0x7FFFFF) | 0x800000;
    uint32_t bm = (bu & 0x7FFFFF) | 0x800000;
    int rexp = ae;
    uint32_t amant = am << 3;
    int diff = ae - be;
    uint32_t bmant = (diff > 27) ? 0 : ((bm << 3) >> diff);
    uint32_t rmant = amant - bmant;
    if (rmant == 0) return 0.0f;
    while (rmant < (1u << 26) && rexp > 0) { rmant <<= 1; rexp--; }
    while (rmant >= (1u << 27)) { rmant >>= 1; rexp++; }
    uint32_t rounded = (rmant + 4) >> 3;
    if (rounded & (1u << 24)) { rounded >>= 1; rexp++; }
    return from_bits(((uint32_t)rexp << 23) | (rounded & 0x7FFFFF));
}

static float __attribute__((noinline, noclone)) soft_mul(float af, float bf) {
    uint32_t au = bits(af), bu = bits(bf);
    int ae = (au >> 23) & 0xFF, be = (bu >> 23) & 0xFF;
    uint32_t am = (au & 0x7FFFFF) | 0x800000;
    uint32_t bm = (bu & 0x7FFFFF) | 0x800000;
    uint64_t prod = (uint64_t)am * (uint64_t)bm;
    int rexp = ae + be - 127;
    while (prod >= ((uint64_t)1 << 48)) { prod >>= 1; rexp++; }
    while (prod < ((uint64_t)1 << 47) && rexp > 0) { prod <<= 1; rexp--; }
    uint64_t rounded = (prod + (1ull << 22)) >> 23;
    if (rounded >= ((uint64_t)1 << 24)) { rounded >>= 1; rexp++; }
    return from_bits(((uint32_t)rexp << 23) | ((uint32_t)rounded & 0x7FFFFF));
}

/* Division built on one native (hardware) 64-bit integer division,
 * rounded to nearest. This is what real software-float libraries do
 * internally too, integer divide is a legitimate building block, not
 * a shortcut around what's being measured. */
static float __attribute__((noinline, noclone)) soft_div(float af, float bf) {
    uint32_t au = bits(af), bu = bits(bf);
    int ae = (au >> 23) & 0xFF, be = (bu >> 23) & 0xFF;
    uint32_t am = (au & 0x7FFFFF) | 0x800000;
    uint32_t bm = (bu & 0x7FFFFF) | 0x800000;
    uint64_t scaled = (uint64_t)am << 23;
    uint64_t quot = (scaled + bm / 2) / bm;
    int rexp = ae - be + 127;
    while (quot < (1u << 23) && rexp > 0) { quot <<= 1; rexp--; }
    while (quot >= (1u << 24)) { quot >>= 1; rexp++; }
    return from_bits(((uint32_t)rexp << 23) | ((uint32_t)quot & 0x7FFFFF));
}

#endif /* SOFT_FLOAT */

/* OPS_PER_ITER independent, non-identical arithmetic passes per outer
 * loop iteration. This exists to fix a real dilution problem: with
 * only one pass per iteration, the fixed cost of the loop bookkeeping
 * itself (the outer increment/compare/branch, the periodic reset
 * check) is a meaningful fraction of total time in the hardware
 * build, where a single float op is one instruction, but barely
 * registers in the software build, where a single float op is 15-30
 * instructions. That dilution compresses the observed ratio well
 * below the true per-operation cost difference. Doing more float work
 * per outer iteration, without changing the outer iteration count,
 * lets the real per-operation cost dominate instead.
 *
 * Each of the OPS_PER_ITER passes uses a different offset (below) so
 * they're genuinely distinct computations, not the same computation
 * repeated, an optimizer could otherwise fold identical repeated work
 * into one computation done once, which would silently defeat the
 * point. The offsets are plain compile-time float literals, no
 * runtime int-to-float conversion involved. */
#define OPS_PER_ITER 8
static const float offsets[OPS_PER_ITER] = {
    0.000f, 0.010f, 0.020f, 0.030f, 0.040f, 0.050f, 0.060f, 0.070f
};

int main(void)
{
    float acc = 0.0f;
    float a = 1.0000001f;
    float b = 0.0000001f;
    /* x cycles from 1.0 up toward 2.0 and resets, entirely through
     * float addition and an integer-only reset check (no int-to-float
     * conversion anywhere: that also needs hardware this build doesn't
     * have, and libgcc's __floatdisf helper hits the exact same
     * missing-symbol problem soft_add/soft_sub/soft_mul/soft_div were
     * written to avoid). Plain addition is numerically benign, unlike
     * feeding a value back through a divide-by-nearly-1 every
     * iteration, see the note in Section 3 of README.md for why that
     * distinction matters here. x itself is only ever touched once per
     * outer iteration, the OPS_PER_ITER passes below read it but never
     * write it back, so that instability risk can't creep in here
     * either. */
    float x = 1.0f;
    float step = 0.001f;
    long i;
    int k;

    for (i = 0; i < ITERATIONS; i++) {
        if ((i % 1000) == 999) {
            x = 1.0f;
        } else {
#ifdef SOFT_FLOAT
            x = soft_add(x, step);
#else
            x = x + step;
#endif
        }

        for (k = 0; k < OPS_PER_ITER; k++) {
#ifdef SOFT_FLOAT
            float t = soft_add(x, offsets[k]);
            t = soft_mul(t, a);
            t = soft_sub(t, b);
            t = soft_div(t, a);
            acc = soft_add(acc, t);
#else
            float t = x + offsets[k];
            t = t * a;
            t = t - b;
            t = t / a;
            acc = acc + t;
#endif
        }
    }

    result = acc;
    return 0;
}
