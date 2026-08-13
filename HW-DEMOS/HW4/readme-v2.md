# HW4 Demo: Software vs. Hardware Floating Point

The same floating-point loop, computing the same math, compiled twice
for two different RISC-V targets: once with no floating-point hardware
at all (this file's own software routines do the arithmetic instead),
once with the F hardware extension (the compiler emits real hardware
instructions). Same source file, same math, radically different cost
to get there.

This demo is intentionally minimal: two small files, one Makefile, no
custom peripherals, no simulator platform to configure, timed with the
plain Unix `time` command rather than any custom instrumentation.

## Files

- `fp_demo.c`: the floating-point loop, freestanding (no libc), so the
  exact same source builds cleanly for both targets. Includes its own
  small single-precision software float implementation (`soft_add`,
  `soft_sub`, `soft_mul`, `soft_div`), used only in the soft build, see
  Section 3 for why.
- `start.S`: a few lines of entry-point assembly (stack alignment,
  call `main`, exit), replacing the usual C runtime startup that this
  demo deliberately doesn't use.
- `Makefile`: builds `fp_demo_soft` (no F extension) and `fp_demo_hard`
  (rv64gc, hardware F) from the same source file.

## 0. Prerequisites (Ubuntu)

Two things needed beyond a normal Ubuntu install: a RISC-V cross
compiler, and a way to run the resulting RISC-V binaries on an x86_64
machine.

```
sudo apt update
sudo apt install build-essential gcc-riscv64-linux-gnu qemu-user
```

- `build-essential` provides `make` (skip if already installed).
- `gcc-riscv64-linux-gnu` is the cross compiler, provides
  `riscv64-linux-gnu-gcc`. This same package is used elsewhere in this
  project for HW2's demo.
- `qemu-user` provides `qemu-riscv64`, which runs a RISC-V Linux binary
  directly on an x86_64 host, translating each instruction on the fly.
  This is the same tool HW2's demo uses.

Verify both are on the `PATH`:

```
riscv64-linux-gnu-gcc --version
qemu-riscv64 --version
```

## 1. Build

```
make
```

This produces `fp_demo_soft` and `fp_demo_hard`. Both come from the
same `fp_demo.c`, the difference is the `-march`/`-mabi` flags in the
`Makefile` (`rv64imac`/`lp64`, no float hardware, vs. `rv64gc`/`lp64d`,
hardware F) plus one `-DSOFT_FLOAT` define that switches which
arithmetic path the loop uses, see Section 3.

If your build shows `ld.bfd: warning: ... has a LOAD segment with RWX
permissions`, that's expected for a minimal `-nostdlib` build with no
linker script, and harmless for a demo binary that's built, run once,
and discarded. It's suppressed by default in this Makefile
(`-Wl,-z,separate-code`); if you still see it, your `binutils` version
may not support that flag, safe to ignore either way.

## 2. Run

```
time qemu-riscv64 ./fp_demo_hard
time qemu-riscv64 ./fp_demo_soft
```

Watch the `real` time each one reports. Both programs do the same
number of adds, multiplies, subtracts, and divides, `fp_demo_soft`
should take noticeably longer, since each operation is doing real
integer instruction work under the hood instead of a single hardware
instruction.

In testing, `fp_demo_soft` lands around 7-7.5x slower in wall-clock
time, at the default `ITERATIONS=10000000` that's roughly 11 seconds
for `fp_demo_soft` and 1.5 seconds for `fp_demo_hard`, short enough to
run live without much dead air (drop `ITERATIONS` if 11 seconds feels
too long, see below).

That ~7x number moved twice over the course of building this demo,
worth knowing why if you're curious, both changes are explained in
full elsewhere in this file:

- It started around 3-3.5x with one add/multiply/subtract/divide per
  iteration. Doing eight independent passes per iteration instead of
  one (to rule out loop-bookkeeping dilution as the cause) barely
  moved it, to about 3.4x, see the note further down.
- It jumped to the current ~7x after `soft_add`/`soft_sub`/`soft_mul`/
  `soft_div` were marked `noinline, noclone` (Section 4). That wasn't
  a change to what the loop computes, it removed a real compiler
  optimization (GCC had been quietly generating faster, specialized
  versions of three of these functions for their constant arguments),
  needed to get `make instr-count`'s per-function counts to work at
  all. Losing that optimization made the software build slower and
  the ratio bigger, an honest side effect of insisting on stable,
  disassemblable functions rather than whatever the optimizer felt
  like doing that day.

See Section 4 for what explains the remaining gap between this
wall-clock number and the even bigger static instruction-count
difference.

If the difference isn't dramatic enough to feel convincing live, or if
either run takes too long, adjust the work per run and rebuild:

```
make clean
make ITERATIONS=5000000    # fewer iterations, faster/smaller difference
make ITERATIONS=20000000   # more iterations, slower/larger difference
```

## 3. Why this file writes its own software float, not libgcc

The natural way to build a soft-float target is to just exclude the F
extension from `-march` and let the compiler call into `libgcc`'s
built-in software float routines. That's how this demo was first
built, and it doesn't work on every install: the standard Ubuntu
`gcc-riscv64-linux-gnu` package ships a single, non-multilib `libgcc.a`
built assuming hardware double-float support (confirmed directly,
`riscv64-linux-gnu-gcc -print-multi-lib` reports only one
configuration). Linking that library into a soft-float-ABI binary
fails with "can't link double-float modules with soft-float modules",
because the library object itself was compiled assuming hardware float
exists, which defeats the entire point of a soft-float build.

Rather than depend on a toolchain feature that may or may not be
installed, `fp_demo.c` provides its own minimal single-precision
software float routines, compiled in only for the soft build
(`-DSOFT_FLOAT`). They're deliberately narrow: positive numbers only,
no zero, no NaN/Infinity, no subnormals, no rounding-mode handling
beyond round-to-nearest. That's fine, every value this demo computes is
a small positive finite number, real IEEE-754 edge cases never come
up. `soft_div` is built on one native 64-bit integer division rather
than a hand-written bit-by-bit division loop (that was tried first and
had a real, hard-to-spot bug), integer divide is a legitimate building
block real software-float libraries use too, not a shortcut around
what's being measured.

Two more details worth knowing if you read the source, both are the
same underlying lesson showing up twice:

- The loop doesn't feed its accumulator back through a divide-by-
  nearly-1 each iteration. An earlier version did, and it turned out
  to be numerically unstable, tiny, individually harmless rounding
  differences between two correct implementations compounded into a
  wildly different final answer over millions of iterations. The
  current loop computes an independent, bounded value each iteration
  and sums it instead, which keeps hard and soft results in close
  agreement without changing what's being measured, the same four
  arithmetic operations, the same number of times, hardware vs.
  software.
- The per-iteration value cycles using float addition and an
  integer-only reset check, never an int-to-float conversion. An
  earlier version used `(float)(i % 1000)`, which needs a hardware
  conversion instruction this build doesn't have either, so the
  compiler emitted a call to `__floatdisf`, another `libgcc` symbol
  that hits the exact same non-multilib wall `soft_add` and friends
  were written to avoid. Same root cause, same fix: don't rely on
  anything `libgcc` provides in the soft build, write the small piece
  needed instead.

With both fixed, hard and soft match exactly in native testing at
every iteration count tried, not just closely, confirmation the
remaining difference between the two builds really is just timing, not
divergent math.

## 4. Look at the disassembly, and the real instruction-count gap

The wall-clock number (Section 2) tells you *that* one is slower, but
it understates *how much* slower the two approaches really are at the
ISA level. Two ways to see that directly:

```
riscv64-linux-gnu-objdump -d fp_demo_hard | grep -A 25 '<main>:'
riscv64-linux-gnu-objdump -d fp_demo_soft | grep -A 40 '<main>:'
```

In `fp_demo_hard`, each `+`, `*`, `-`, and `/` in the C source shows up
as a single hardware instruction: `fadd.s`, `fmul.s`, `fsub.s`,
`fdiv.s`. One instruction, one operation, straight to the FPU.

In `fp_demo_soft`, the exact same four operations each show up as a
`call` (to `soft_add`, `soft_mul`, `soft_sub`, `soft_div`), and
disassembling further into any of those functions
(`riscv64-linux-gnu-objdump -d fp_demo_soft | grep -A 40 '<soft_div>:'`,
for instance) shows real, readable integer work: shifting mantissas,
comparing exponents, one hardware integer divide standing in for what
a real IEEE-754 division algorithm does. Since this is our own code
rather than an opaque library call, it's also a good live-walkthrough
opportunity: point at a specific shift or compare and explain exactly
what bit of the floating-point format it's manipulating.

To put an actual number on that gap instead of eyeballing it:

```
make instr-count
```

This counts the real RISC-V instructions inside each `soft_add`/
`soft_sub`/`soft_mul`/`soft_div` function and compares against the
single hardware instruction each one replaces. `fp_demo.c` marks all
four `noinline, noclone`, and both attributes turned out to matter for
different reasons:

- Without `noinline`, GCC's inliner treats them inconsistently at
  `-O2` (a function called from one site tends to get inlined away,
  one called from two tends to be kept as a real function), which used
  to make some functions vanish from the disassembly entirely.
- Without `noclone`, GCC noticed that `soft_sub`, `soft_mul`, and
  `soft_div` are each always called with one argument fixed at the
  same compile-time constant (`a` or `b` in `main`), and replaced the
  plain symbol with a specialized clone renamed
  `soft_sub.constprop.0` (and similarly for the others), a real,
  separate optimization from inlining that `noinline` alone doesn't
  stop. A name-based lookup for `soft_sub` then found nothing, the
  same visible symptom as the inlining problem, a different cause,
  caught by testing this script against an actual build rather than
  trusting it from the source alone.

Together they guarantee all four stay real, unspecialized,
disassemblable functions, and since both builds perform the exact same
number of calls to each operation (`ITERATIONS * 8`, once per
`OPS_PER_ITER` pass), this per-call ratio is also the true ratio of
total instructions executed, not just a snapshot of one function's
size. In testing this lands around 40-45x (individual functions
ranging from about 28 to 54 instructions each, against 1 hardware
instruction). That's a genuinely different number from the ~7x
wall-clock ratio in Section 2, and the gap between them is worth
putting directly to the class: if software float takes 40x more
instructions, why does the timed run only show about 7x?

The answer is `qemu-riscv64` itself, and specifically how it
implements RISC-V's F extension. `fadd.s`, `fmul.s`, `fsub.s`, and
`fdiv.s` are not translated into a single host FPU instruction the way
you might expect. QEMU's RISC-V target implements them as calls to
internal helper functions (`helper_fadd_s` and friends) that go
through QEMU's own software floating-point library
(`fpu/softfloat.c`), the same general approach QEMU uses for target
FPU instructions across most of its supported guest architectures,
because it has to reproduce the guest ISA's exact IEEE-754 rounding
mode, flag, and NaN-handling behavior, which a raw host `+`/`*`
doesn't guarantee. So under `qemu-riscv64`, `fp_demo_hard`'s "hardware"
float instructions are, under the hood, also running through
software, QEMU's own softfloat library, not this demo's, and QEMU's is
more complete and general than the narrow `soft_add`/`soft_mul`/
`soft_sub`/`soft_div` written for this demo. What Section 2's timing
is really comparing is two different software float implementations,
QEMU's internal one, reached through a guest instruction and a helper
call, against this demo's own, reached through an ordinary guest
function call, not software float against real silicon hardware float.
That's why the measured gap lands well under the static
instruction-count difference: the "hardware" side was never touching
a real FPU in the first place. Getting a wall-clock number that
reflects genuine hardware would require running the RISC-V binary on
real RISC-V silicon, which isn't practical for this course, so `make
instr-count`'s static number is the one to trust as the real
architectural claim, and the timing comparison in Section 2 is better
framed as "two flavors of software float in a foreign-architecture
emulator" than "software vs. hardware."

It's the same category of caveat as HW2's cache demo and HW3's
interrupt demo (the tool you're measuring with isn't a neutral window
onto the hardware), just showing up for a different reason here: HW2's
gap came from the host's real cache responding to guest behavior QEMU
doesn't model, HW3's came from a specific Renode build's timer
hardware not firing at all, this one comes from QEMU quietly
substituting its own software floating point for what looks, from the
guest ISA's point of view, like a hardware instruction.

Two other things worth ruling out, since they're natural guesses:

- **Is this a caching effect, since the loop does very repetitive
  work?** Not the asymmetry here. Both binaries are small, hot loops
  that fit entirely in the host's instruction cache almost
  immediately, and QEMU's TCG only translates each loop body once,
  then re-executes the cached host code on every pass (block
  chaining), it doesn't re-translate from scratch each iteration.
  That benefits `fp_demo_hard` and `fp_demo_soft` equally, so it
  affects how fast both runs are in absolute terms, but it doesn't
  explain why the *ratio* between them is smaller than the
  instruction count predicts, the softfloat substitution above does.
- **Could `-O2` be hiding something, should optimizations be turned
  off?** A fair concern, and it was real, twice, see the `noinline,
  noclone` explanation above for the details (inlining making
  functions disappear, then constant-propagation cloning renaming
  them). Both are handled now, and you can confirm all four functions
  are present with their plain names, no `.constprop` suffix, with:

  ```
  riscv64-linux-gnu-objdump -d fp_demo_soft | grep '<soft_'
  ```

  If you want to see how much `-O2` is helping either build overall
  (a broader question than just inlining/cloning), rebuild at a
  different level:

  ```
  make clean
  make OPT=-O0
  ```

  That'll make both binaries noticeably slower in absolute terms since
  neither gets any optimization, expected, only the relative ratio
  between them is the interesting number.

## 5. What this demo does and doesn't share with HW2 and HW3's caveats

Worth calling out explicitly, since HW2's cache-locality demo and
HW3's interrupt demo both had real caveats about what they were
actually measuring, and (per Section 4) this one turns out to have its
own, of a different kind.

What this demo gets right, that HW2 didn't: the *existence* of the
difference is real RISC-V, not a host artifact. HW2's timing gap came
from the *host* machine's real cache responding to the guest's access
pattern, since QEMU doesn't model a target cache at all, run it on a
different host and the numbers can shift. This demo's underlying
difference, roughly 40-45x more instructions for software float than
hardware float per operation, is a fact about the compiled RISC-V
code itself (`make instr-count` measures it directly), true
regardless of what machine executes it.

What this demo shares with HW2 and HW3: the number QEMU reports isn't
the real magnitude. HW2's issue was the host's cache substituting for
a target cache model that doesn't exist. HW3's was a specific Renode
build's timer-interrupt hardware not firing at all. This demo's is
QEMU implementing RISC-V's own hardware float instructions through its
own internal software float library, which compresses a real ~40x
instruction-count difference down to a measured ~7x wall-clock one
(Section 4). All three demos end up teaching the same
meta-lesson from different angles: a simulator or emulator is a model
of the hardware, not the hardware, and knowing exactly where that
model diverges from reality is part of doing systems work honestly.

## 6. Why no libc, and why timing is external

Two more deliberate simplifications:

- **No libc (`-nostdlib`, `start.S` instead of a C runtime).** Keeps
  the build independent of whatever the cross toolchain's target glibc
  happens to include, `fp_demo.c` only needs `main` to exist and
  return, nothing else from a runtime.
- **Timing via the `time` command, not code inside the program.**
  HW2's demo reads the clock from inside the RISC-V program itself and
  prints it. This demo doesn't need that: the only output that matters
  is total wall-clock duration, so letting the host's `time` command
  wrap the whole `qemu-riscv64` invocation is simpler and avoids
  writing any print/formatting code at all.
