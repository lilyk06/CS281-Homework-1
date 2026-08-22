# HW-DEMOS

This directory holds the live, in-class demo that supports each
homework's Confront phase in the course's 5C model (Connect, Confront,
Concept, Construct, Confirm). The graded homework assignment itself
lives one level up, in `HW/HW#.md`; everything in here exists to make
that assignment's Confront moment a real, watchable thing rather than
an assertion on a page.

Each `HW#` subdirectory follows the same structure:

- **`readme.md`** describes the demo: what it's showing, why it's built
  the way it is, and the software that needs to be installed to run it.
- **`output.md`** is a captured, real sample run of the demo, so the
  expected result can be checked without a toolchain installed.
- **`makefile`** (or `Makefile`) drives every command the demo needs,
  build, run, and clean, so a student who wants to try it themselves
  doesn't need to piece commands together from the readme by hand.
- The remaining files are the demo's actual source: Verilog, RISC-V
  assembly, C, or Python, depending on the homework.

## The seven demos

| HW | Assignment | What the demo shows |
|---|---|---|
| [HW1](./HW1) | Same Program, Different Instructions | Explores why x86-64 and RISC-V produce very different instruction encodings for the same C code, and why RISC-V's simplicity is a deliberate tradeoff, not an accident. The demo cross-compiles identical source for both ISAs and, at `-O1`, shows x86-64 folding a memory read directly into an `add`, something RISC-V's ALU can never do at any optimization level, a real, scaling instruction-count gap rather than an abstract claim. |
| [HW2](./HW2) | Same Operations, Different Speed | Explores why the order data is accessed in memory can matter more than how many operations a program performs. The demo times row-major versus column-major traversal of the identical array, same instruction count, same math, and shows a real multi-times speed difference driven entirely by cache locality. |
| [HW3](./HW3) | Same Event, Different Power | Explores why two programs producing identical, correct output can still cost wildly different amounts of power. The demo runs a polling loop and an interrupt-driven `wfi` wait side by side, printing the same output on the same schedule, while one burns millions of wasted instructions between events and the other sits genuinely idle. |
| [HW4](./HW4) | The Extension You Don't Get for Free | Explores why an ISA extension as useful as hardware floating point is optional rather than mandatory in RISC-V. The demo compiles and times identical math with and without the F extension, showing both a real wall-clock gap and an even larger static instruction-count gap underneath it, then asks why any chip would ship without it. |
| [HW5](./HW5) | Your Code Runs One Line at a Time. Your Circuit Doesn't. | Explores why a hand-built digital circuit doesn't behave like the sequential code students are used to reasoning about. Three back-to-back Verilog demos show a real full adder producing verifiably wrong values when read with no clock, a real MISMATCH when clocked faster than its settle time, and correct output only once the clock period actually respects propagation delay. |
| [HW6](./HW6) | Your Program Is Sequential. Your Processor Is Not. | Explores how a processor can execute more than one instruction per cycle even though the program itself is written as a strict sequence. The demo drives a small scheduler with two integer units and one multiply unit through two scenarios: independent instructions issuing together, then a data-dependent instruction stalling even though its own execution unit sits completely idle, waiting on a value. |
| [HW7](./HW7) | One Architecture Doesn't Fit Every Problem | Explores why the same matrix multiplication can run dramatically faster on a GPU than a CPU, but only once the problem is large enough. The demo runs identical CPU and GPU implementations across growing matrix sizes and shows the CPU winning by orders of magnitude on tiny inputs before the GPU takes over by orders of magnitude on large ones, challenging the assumption that one processor design is simply "better." |
