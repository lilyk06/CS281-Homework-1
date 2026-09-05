# HW2 Demo: Same Operations, Different Speed

One RISC-V assembly program, `HW2_Locality_Demo.s`, that sums the same
16 MB 2D array of 32-bit integers two ways: row-major (walking across
each row before moving to the next) and column-major (walking down
each column instead). Both traversals do the identical number of
additions and the identical number of loads, same array, same total
work by any operation-count measure. Only the *order* the memory gets
touched in differs. This is the live hook `HW2_v2_draft.md`'s Confront
section asks the instructor to run in class, built out as a real,
runnable program instead of numbers asserted on a slide.

## What we're investigating

The assignment's Confront section sets up a broken mental model: "same
number of operations should mean roughly the same speed." This demo is
what breaks it, concretely, with a program you can actually run and
time. The array is deliberately sized (2048 x 2048 ints, 16 MB) to be
larger than a typical CPU's cache, so the effect isn't hidden by the
whole array simply living in cache the entire time.

**Row-major** reads `a[0][0], a[0][1], a[0][2], ...`, elements that sit
back to back in memory. The first access to a row pulls in a 64-byte
cache line containing the next several elements for free, they're
already in the cache by the time the loop asks for them.

**Column-major** reads `a[0][0], a[1][0], a[2][0], ...`, elements that
are each one full row-length apart (2048 ints x 4 bytes = 8192 bytes
apart). Every single access lands in a different, unused cache line:
the CPU pulls in a full 64-byte line to use 4 bytes of it, then throws
the rest away and does it again next iteration.

Same additions, same loads, same math, wildly different number of real
trips out to memory. That's the concrete number this demo puts in
front of the class, matching directly to the Concept section's
cache-line table.

## Files

- `HW2_Locality_Demo.s`: the program. Uses raw Linux syscalls only (no
  libc), `clock_gettime` (via `ecall`) to time each traversal, and
  prints both elapsed times in nanoseconds. Fully static, no sysroot
  needed for QEMU user-mode. Extensive header comment inside the file
  documents the wall-clock-vs-`rdcycle` choice and which
  execution environments will and won't show a real difference (see
  the caveat in Section 3 below, it matters).
- `HW2_Locality_Demo.o` / `HW2_Locality_Demo`: a build output already
  in the folder. Rebuilding overwrites both, see Section 2.
- [`output.md`](./output.md):  Sample output from the HW2 demo. 

## 0. Prerequisites (Ubuntu VM)

Two things: a RISC-V cross toolchain (to assemble and link the `.s`
file directly, no C compiler involved), and QEMU's user-mode emulator
(to run the resulting RISC-V binary on the VM's x86_64 host).

```
sudo apt update
sudo apt install gcc-riscv64-linux-gnu qemu-user
```

- `gcc-riscv64-linux-gnu` provides `riscv64-linux-gnu-as` and
  `riscv64-linux-gnu-ld`, the assembler and linker this demo actually
  uses (no `gcc` invocation needed, the file is hand-written assembly).
- `qemu-user` provides `qemu-riscv64`, which runs a RISC-V Linux binary
  directly on an x86_64 host by translating each instruction on the
  fly, and, critically for this demo, by routing the guest's memory
  accesses through the *host's* real cache hierarchy (see the caveat in
  Section 3).

Verify both are on the `PATH`:

```
riscv64-linux-gnu-as --version
riscv64-linux-gnu-ld --version
qemu-riscv64 --version
```

## 1. Build

```
riscv64-linux-gnu-as -march=rv64gc -o HW2_Locality_Demo.o HW2_Locality_Demo.s
riscv64-linux-gnu-ld -o HW2_Locality_Demo HW2_Locality_Demo.o
```

(Matches the `BUILD` comment already at the top of the `.s` file, kept
here so the whole workflow is in one place.)

## 2. Run

Build and run the demo with:

```bash
make run
```

A recent run produced:

```text
row-major:    96569961 ns
column-major: 700622416 ns
speedup:      7.2x
```

The `speedup` is calculated as:

```text
column-major time / row-major time
```

So in this example, the row-major traversal completed approximately **7.2× faster** than the column-major traversal.

Remember that both versions:

- visit every array element exactly once,
- execute the same number of loads,
- execute the same number of additions,
- and produce the same result.

The important difference is only the **order in which memory is accessed**.

> **Same logical work. Same data. Different memory access pattern. About 7× different performance.**

Exact timings and the speedup ratio will vary somewhat depending on the machine and normal system activity, but the substantial performance difference produced by the access pattern should remain visible.

## 3. Read this before running it live: the result depends on where you run it

This is the single most important thing to know about this demo, and
it's spelled out in the `.s` file's own header comment too:

- **Plain instruction-level simulators** (RARS, Venus, a default
  `spike` run with no memory-timing model) will **not** show a
  difference. They execute every load in the same simulated time
  regardless of address pattern, because they don't model a cache or
  memory hierarchy at all. If a student runs this under one of those
  and reports back "both numbers came out the same," that's the
  simulator telling the truth about itself, not a bug in the demo.
- **QEMU user-mode emulation** (`qemu-riscv64`, what Section 2 above
  uses) **should** show a real difference, because QEMU translates the
  guest's loads and stores into actual reads and writes against host
  RAM, which goes through the host machine's real cache hierarchy. The
  timing you see is the *host's* real cache timing, even though the
  instructions being emulated are RISC-V, not a simulated RISC-V cache
  model.
- **Real RISC-V hardware**, or a full-system VM running on real
  hardware, would show it most cleanly of all, for the obvious reason
  that there's no emulation layer between the program and a real cache.
- **A cycle-accurate simulator with a configured cache model** (gem5,
  for example) would also show it, and could additionally report exact
  cache hit/miss counts instead of just wall-clock time. Early
  groundwork for a gem5 SE-mode version of this exact comparison is in
  `gem5_Setup.md` at the project root (Section 8), not required for
  this demo and not yet verified against a working gem5 build, worth
  knowing about if you want a stronger, numbers-not-just-timing version
  down the line.

Worth being upfront with the class about exactly what QEMU is and
isn't proving here: the *existence* of the row-major/column-major gap
is real, it's a fact about how the host's cache responds to the access
pattern the guest program produces. But the *magnitude* of the gap is
a host-machine number, not a guest RISC-V hardware number, run this
demo on a different host and the ratio can shift. That's a fair,
honest caveat to say out loud in class rather than presenting QEMU's
timing as if it came from real RISC-V silicon.

## 4. What to point out live

- Read both instruction counts, or better, walk through
  `sum_row_major` and `sum_col_major` in the source together, they are
  identical in every way except the order of the two index terms
  feeding the address computation (`row * n + col` vs. `col * n + row`,
  effectively). Same instructions, same count, different order.
- The array is intentionally 16 MB, larger than a typical L2/L3 cache,
  worth saying why: if the whole array fit in cache, both traversal
  orders would eventually get all their data from the cache regardless
  of order, and the gap would shrink or disappear. Making it too big to
  fully cache is what forces the row-major/column-major access pattern
  to actually matter.
- Tie the ratio you see directly back to the Concept section's table:
  row-major uses all 64 bytes of every cache line fetched, column-major
  effectively uses only 4 of those 64 bytes before moving on to a
  different line entirely.

## 5. Why this file writes raw syscalls instead of using libc

`clock_gettime` is invoked directly via `ecall` (syscall 113) rather
than linking against a C library and calling a wrapper function. This
keeps the binary fully static and self-contained, no libc, no dynamic
linker, nothing QEMU user-mode needs to resolve at load time beyond
the kernel's raw syscall interface, which keeps the build command in
Section 1 to exactly two lines with no extra flags.

`rdcycle` was deliberately not used for timing, also explained in the
file's header comment: it can be trapped or disabled for user-mode
programs depending on the kernel or emulator's counter-enable
settings, and isn't reliably readable under QEMU user-mode emulation
specifically. `clock_gettime` works everywhere this demo is likely to
run, which is why it's the one used here despite being one syscall
call away from the "purer" cycle-count approach.
