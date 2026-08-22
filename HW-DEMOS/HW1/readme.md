# HW1 Demo: Same Program, Two Instruction Sets

The exact same tiny C program, cross-compiled once for x86-64 and once
for RISC-V, disassembled side by side. This is the live hook
`HW1_v2_draft.md`'s Background section already asks the instructor to
run in class ("compile a trivial function containing one `add` for
both `riscv64` and `x86_64` targets, disassemble both with objdump,
and project them side by side"), just built out as a real, runnable
demo instead of something assembled live on the fly, with several
instructive extra findings the original single-`add` version wouldn't
have surfaced.

There are two build modes, at two different optimization levels, and
they tell two different, complementary parts of the same story:

- **`-O0`** (`make run-o0`) shows RISC-V's *load/store* cost: every
  array access needs its address rebuilt from scratch, an honest worst
  case that isn't optimized away.
- **`-O1`** (`make run-o1`) shows x86-64's actual *expressiveness*
  advantage: the ability to fold a memory read directly into an ALU
  instruction, something RISC-V's ISA cannot do at any optimization
  level, since it has no register-memory ALU instruction to fold into
  in the first place.

## Files

- `demo.c`: the program, now widened to a 6-term array sum
  (`a[6] = a[0] + a[1] + a[2] + a[3] + a[4] + a[5]`, see Section 2)
  plus one scalar add (`b = b + 5`). The array was originally 3
  elements with a single 2-term add; widened specifically to make the
  `-O1` memory-fold gap grow without bound as more terms are added,
  rather than staying fixed. `output.md` was captured from the
  original 3-element/2-term version and is kept for the `-O0`
  discussion in Section 3, which is unaffected by the widening; see
  the note at the top of that section.
- `demo2.c`: the original 3-element/2-term version of the program,
  kept as-is so `output.md` can be reproduced exactly on demand (see
  Section 3) instead of only trusting the saved copy.
- `Makefile`: builds and disassembles both targets. `make run-o0` /
  `make run-o1` / `make run-o0-raw` map directly to the three build
  modes described below; `make run` does `run-o0` then `run-o1`, the
  sequence Section 1 walks through; `make clean` removes every
  generated binary and `.s` file. Pass `SRC=demo2.c` to any `run-*`
  target to build the original version `output.md` came from instead
  of the current `demo.c`.
- `demo-x64` / `demo-riscv` / `demo-x64-O1` / `demo-riscv-O1`: compiled
  binaries from the last `make` run. Rebuilding overwrites the matching
  pair.
- [`output.md`](./output.md):  Sample output from the HW1 demo. 

## 0. Prerequisites (Ubuntu)

Two cross-compilers, both providing a matching `objdump`, plus `make`:

```
sudo apt update
sudo apt install build-essential gcc-x86-64-linux-gnu gcc-riscv64-linux-gnu
```

- `build-essential` provides `make` (skip if already installed).

Verify all four remaining tools are on the `PATH`:

```
x86_64-linux-gnu-gcc --version
x86_64-linux-gnu-objdump --version
riscv64-linux-gnu-gcc --version
riscv64-linux-gnu-objdump --version
```

## 1. Run

```
make run
```

This runs `run-o0` (-O0: RISC-V's load/store cost) then `run-o1` (-O1:
x86-64's memory-fold advantage) back to back, and prints both
disassemblies to the terminal, x86-64 first, then RISC-V, for each. Run
either step on its own with `make run-o0` or `make run-o1` if you only
want one half of the story. `output.md` has a saved copy of the `-O0`
run if you want to read it without a toolchain installed, and
`make clean` removes everything the build produces.

## 2. The main finding: x86-64 folds, RISC-V can't, and the gap widens

This is the demo's central point, and it's been run and verified, not
just predicted. For `a[6] = a[0] + a[1] + a[2] + a[3] + a[4] + a[5]`
at `-O1`:

**x86-64** loads `a[1]` into a register once, then chains five `add
reg, QWORD PTR [addr]` instructions, each one reading the next array
element straight out of memory as an ALU operand, no separate load
needed, then stores the result: 7 instructions total (1 `mov` + 5
folded `add`s + 1 `mov`). This is the real, concrete version of what
the Concept section's illustrative memory-operand table is gesturing
at: `add`'s second operand can be a memory address directly, not just
a register.

**RISC-V** cannot do this at any optimization level, because its ALU
instructions only ever operate on registers, full stop; there is no
RISC-V `add` variant that reads one of its operands from memory. Every
term has to be loaded into a register first with a separate `ld`, then
added with a separate register-register `add`: 6 `ld`s + 5 `add`s + 1
`sd`, plus 2 instructions (`lui`/`addi`) to materialize the shared base
address once = 14 instructions total.

**7 vs. 14; the gap is structural, not incidental.** For an `N`-term
sum, this pattern generalizes cleanly: x86-64 costs `N + 1`
instructions (one initial load, `N - 1` folded adds, one store).
RISC-V costs `2N + 2` (address setup, `N` loads, `N - 1` adds, one
store). The gap isn't a fixed multiple, it grows by 1 more instruction
per side, times two, for every additional term: widen the sum further
and the ratio keeps moving in x86-64's favor. That's a much stronger
demonstration of "expressiveness" than a byte-count comparison on a
single instruction, it's the direct, provable consequence of x86-64
being a register-memory architecture and RISC-V being a strict
load/store architecture, the actual ISA-level distinction the
"expressive vs. RISC" framing is really about.

`b = b + 5` sits right next to this as a useful control: 3 instructions
on both sides (`mov`/`add`/`mov` vs. `ld`/`addi`/`sd`), because there's
only one memory location involved and nothing for x86-64 to fold
beyond what it's already doing. The fold advantage only shows up, and
grows, when multiple memory operands are chained together in one
expression, exactly the `a[]` case.

## 3. What the `-O0` build (`output.md`) shows instead

*(Reflects the original 3-element array, `a[2] = a[0] + a[1]`, before
the array was widened to 7 elements/6 terms for Section 2 above. This
finding is unaffected by that change, it's about RISC-V's address cost
specifically, not the number of terms being summed. Reproduce it
directly with `make run-o0 SRC=demo2.c` if you want a fresh run instead
of the saved copy.)*

At `-O0`, neither ISA folds anything, GCC doesn't run the optimization
pass responsible for that at `-O0` on either target, so both sides
show the same load-compute-store shape. What `-O0` does show clearly
is RISC-V's address-materialization cost: `a` sits at an address
RISC-V can't reach in one instruction's immediate field, so the
compiler emits `lui`+`addi` to rebuild the full address, and at `-O0`
it does this three separate times, once per array access, instead of
computing it once and reusing it. The result: `a[2] = a[0] + a[1]`
compiles to 4 x86-64 instructions (`mov`, `mov`, `add`, `mov`) but 10
RISC-V instructions. `b = b + 5`, by contrast, ties at 3 instructions
each, since `b` fits within reach of RISC-V's `gp`-relative small-data
addressing and needs no address rebuilding at all. Same file, same
optimization level, one line pays RISC-V's address cost and the very
next one doesn't.

Total instruction count for the whole (original, 3-element) function,
from `output.md`: 13 x86-64 instructions vs. 23 RISC-V instructions.

Worth being upfront about `-O0` itself: it's what makes the address-
materialization cost visible at all. A real compiler at `-O1` or
higher hoists `a`'s base address into a register once and reuses it
(confirmed directly in Section 2's `-O1` run: the `lui`/`addi` pair
appears exactly once, not three times, even for the widened 6-term
version), closing most of that specific gap. `-O0`'s number is a
teaching worst case, not what you'd see from production-optimized
code, exactly why it's presented separately from Section 2's `-O1`
finding rather than combined with it.

## 4. If you want to use this live instead of (or alongside) the Concept table

The current instructor hook in `HW1_v2_draft.md` describes compiling a
single `add` on the fly. This demo is a ready-made, saved-output
alternative that shows a fuller picture: fixed vs. variable
instruction width, RISC-V's address-materialization cost at `-O0`
(Section 3), and, most directly relevant to the "x86-64 is more
expressive" framing, a real, verified, and scalable memory-fold
advantage at `-O1` (Section 2). Nothing in the assignment text itself
needs to change to use this, the existing Concept table's byte-length
numbers are still accurate on their own; this demo is a complementary,
more concrete, and now more dramatic version of the same in-class
moment, not a replacement for the Concept section's content.
