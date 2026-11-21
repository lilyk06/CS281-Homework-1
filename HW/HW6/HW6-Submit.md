# HW6 — Submission Template

This is the only file you need to fill out and submit for HW6. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW6.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** Why can the three instructions in Scenario 0 execute with overlapping execution?

- [ ] A. The processor ignores instruction ordering.
- [x] B. The instructions are independent and can use different execution resources.
- [ ] C. The compiler changes the instruction order automatically.
- [ ] D. The processor executes every instruction twice.

**MC2.** Why does the multiply instruction wait in Scenario 1?

- [ ] A. The multiply unit is already being used by another instruction.
- [ ] B. The processor does not support multiplication.
- [x] C. The multiply instruction requires a value produced by the previous add instruction.
- [ ] D. Multiplication instructions always execute after additions.

**MC3.** What is the difference between latency and throughput?

- [ ] A. Latency measures chip cost, while throughput measures software complexity.
- [x] B. Latency describes how long one operation takes, while throughput describes how much work completes over time.
- [ ] C. Latency and throughput describe the same measurement.
- [ ] D. Latency only applies to memory operations.

**MC4.** Why don't processors simply add unlimited execution units?

- [x] A. Additional execution hardware has costs and programs may not contain enough parallel work to use it.
- [ ] B. Multiple execution units cannot operate at the same time.
- [ ] C. Software cannot benefit from faster hardware.
- [ ] D. Additional hardware always reduces performance.

---

# Part B: Show What You Learned

### N1 — Correct the sequential execution model (20 pts)

Correct this statement: "Because a program is written sequentially, the processor must execute each instruction completely before beginning the next instruction." Your answer should reference multiple execution resources, instruction independence, and data dependencies.

> Your answer:
>Although a program is written sequentially, a processor does not **have** to finish each instruction before starting the next. Because a modern core has multiple execution resources, such as several integer ALUs, address-generation and load/store units, and floating-point/vector units, it **can** overlap instructions that are independent of one another, meaning that neither needs a result that the other produces. Only instructions with a true data dependency, such as a read-after-write, where one instruction consumes a value another writes, need to wait for the producer's result. The processor tracks these dependencies, executes ready instructions out of order when a suitable unit is free, and commits the results in program order, so the outcome is the same as if every instruction had run one at a time.

### N2 — Explain the Scenario 1 dependency (15 pts)

Using the Scenario 1 instructions (`add t0, t1, t2` / `add t3, t4, t5` / `mul t6, t3, t8`), explain why the multiply instruction must wait.

- **Which instruction produces the required value:** (add t3, t4, t5) produces the required value. It writes the result into t3.
- **Which instruction consumes that value:** (mul t6, t3, t8) consumes it. It reads t3 as a source operand. This is a true read-after-write (RAW) data dependency from (add t3, t4, t5) to (mul t6, t3, t8). (add t0, t1, t2) is not involved: it writes t0, which nothing here reads, so (add t0, t1, t2) is independent of both of the other instructions.
- **Why the processor cannot safely execute the multiply early:** Until (add t3, t4, t5) finishes, t3 does not hold the value the program intends for (mul t6, t3, t8) to use. Instead, it holds an older value, or, in a renaming core, a physical register that has not been written yet. If the multiply ran early, it would compute t6 with the wrong t3, and the result of the program would differ from sequential execution. The dependency comes from the data itself, so adding more execution units or renaming registers cannot remove it. The processor enforces it by keeping the mul in the queue until (add t3, t4, t5) broadcasts its result, at which point the mul is then ready and can issue.

### N3 — Investigate a real processor (15 pts)

- **Processor / processor family:** AMD Ryzen 9 9950X, built on AMD's Zen 5 core (codename Granite Ridge). It has 16 cores and 32 threads, and a max boost clock of 5.7 GHz.
- **Execution resources identified:** 6 integer ALUs, 3 of them with multipliers, plus 3 branch units. Also, 4 address-generation units (AGUs), feeding 4 memory addresses per cycle to the load/store unit. Additionally, a floating-point/vector unit with a full 512-bit data path and six pipelines. Lastly, an 8-wide dispatch, with an 88-entry ALU scheduler, a 56-entry AGU scheduler, a 240-entry physical register file, and a 448-entry reorder buffer, which show it is an out-of-order design
- **Specialized hardware you found:** 512-bit SIMD (AVX-512) support. AMD's white paper says that it implements the full set of AVX-512 instructions used in 4th Gen Intel Xeon except FP16 data types. Also, a front end with dual-pipe instruction fetching and highly accurate branch prediction. Additionally, caching and prefetch hardware including a 48 KB, 12-way L1 data cache with a 4-cycle load and increased data prefetch, as well as SMT (2 hardware threads per core).
- **Why those resources exist:** More ALUs and AGUs reduce the structural hazards, so independent instructions do not have to wait for a free unit.
The large scheduler, register file, and reorder buffer allow the core to look far ahead for independent work and hide latency from dependencies and cache misses. Also, the branch predictor and wide front end keep that large window fed with correct instructions. The multipliers and the 512-bit vector unit target data-heavy work. AMD says it widened data paths so more work is done per cycle, with the goal of double-digit IPC gains and better AI/HPC performance.
- **Source:**
- AMD, 5th Gen AMD EPYC Processor Architecture white paper (doc 70353): official, covers the same Zen 5 core, though it doesn't list unit counts.
- AMD, Zen 5 Architecture slides (Hot Chips 2024), third-party-hosted copy: source of the unit counts and window sizes.
- Wccftech, Ryzen 9 9950X review: L1 cache details.

### N4 — Catch the AI (20 pts)

- **What the AI claimed:**
- **Why you questioned it:**
- **How you verified it:**
- **What you concluded:**

### N5 — Your best follow-up question (10 pts)

**Question:**

>

**Why was this question useful?**

>

### N6 — Connect back to the demo (5 pts)

Select the **two** concepts that best explain what you observed, and explain each.

- [ ] Multiple execution resources — explanation:
- [ ] Instruction independence — explanation:
- [ ] Data dependencies — explanation:
- [ ] Latency versus throughput — explanation:
- [ ] Specialized hardware — explanation:
- [ ] Scheduling decisions — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

**I am learning about instruction-level parallelism in computer architecture. I understand that programs are written sequentially, but modern processors can execute multiple instructions at the same time by using different execution resources.Can you explain how this works in a modern processor? More specifically I want to understand how execution units, instruction independence, data dependencies, and instruction scheduling work together. Please use a simple RISC-V assembly example to demonstrate the concepts, and explain it step by step rather than assuming I already understand processor architecture.**

Instruction-Level Parallelism, Step by Step

1. The core idea

A program is a sequence, but that sequence is really a contract about results, not about how the work gets done. The processor may run instructions in any manner it likes, as long as the final outcome is the same as if they ran one at a time, in order. ILP is the processor exploiting that freedom.

Three things have to line up:

Hardware that can do several things at once (execution units)
Instructions that don't need each other's results (independence)
Logic that finds and uses those opportunities (scheduling)

2. Execution units

A modern core isn't one "calculator." It has several specialized units, for example:

Integer ALUs (add, sub, shifts, logic), often 2 to 6 of them
Load/store units (talk to the data cache)
Branch unit
Multiplier/divider, floating-point/vector units

If two instructions need different units (or there are two of the same unit), they can execute in the same cycle. If both need the only unit of some type, one must wait. That's called a structural hazard.

3. A simple example

asm
lw   t0, 0(a0)     # I1: t0 = mem[a0]
lw   t1, 4(a0)     # I2: t1 = mem[a0+4]
add  t2, t0, t1    # I3: t2 = t0 + t1
lw   t3, 8(a0)     # I4: t3 = mem[a0+8]
slli t4, t3, 2     # I5: t4 = t3 << 2
add  t5, t2, t4    # I6: t5 = t2 + t4

Assumptions (simplified, real chips vary):

1 load unit (one load can start per cycle), 2 integer ALUs
A load takes 2 cycles to produce its result; ALU ops take 1

4. Data dependencies

A true (RAW, "read after write") dependency means an instruction needs a value a previous instruction produces. Let's map them:

| Instruction | Needs results from |
|---|---|
| I1 | nothing |
| I2 | nothing |
| I3 | I1 (t0), I2 (t1) |
| I4 | nothing |
| I5 | I4 (t3) |
| I6 | I3 (t2), I5 (t4) |

As a graph:

I1 ─┐
    ├─► I3 ─┐
I2 ─┘       ├─► I6
I4 ─► I5 ───┘

This graph is the heart of ILP. Instructions with no path between them (like I1, I2, I4, or the I3 and I5 chains) are independent and may overlap. The longest path (here I4 → I5 → I6, or I1/I2 → I3 → I6) limits how fast the code can ever go, no matter how much hardware you add.

5. Baseline: an in-order processor

Suppose the core issues instructions strictly in program order, one at a time, and stalls when an operand isn't ready:

| Cycle | Action |
|---|---|
| 1 | I1 lw t0 starts |
| 2 | I2 lw t1 starts |
| 3 | stall: I3 needs t1, which isn't ready until cycle 4 |
| 4 | I3 add t2 |
| 5 | I4 lw t3 starts |
| 6 | stall: I5 needs t3 (ready at cycle 7) |
| 7 | I5 slli |
| 8 | I6 add t5 |

8 cycles, and two of them wasted. Notice what went wrong: at cycle 3, I4 (the load) was perfectly ready to go and had a free load unit, but it was stuck behind the stalled I3.

6. Out-of-order scheduling

Now let the hardware look ahead in a window of upcoming instructions and issue any instruction whose operands are ready, regardless of program order:

| Cycle | Load unit | ALU | Notes |
|---|---|---|---|
| 1 | I1 | | |
| 2 | I2 | | |
| 3 | I4 | | I3 is waiting (t1 not ready), so I4 jumps ahead |
| 4 | | I3 | t0, t1 now ready |
| 5 | I5 | | t3 now ready (I3 finished in cycle 4) |
| 6 | | I6 | t2 and t4 both ready |

6 cycles, and the result is identical. The load latency of I4 was hidden behind the wait for I2, which is the essence of ILP.

(With wider, more independent code, you'd also see multiple ALUs busy in the same cycle. This tiny example is mostly serialized by the memory unit and the dependency chain, which is itself a useful lesson.)

7. How the hardware actually does this

Real out-of-order cores add machinery around the execution units:

Fetch and decode several instructions per cycle (4 to 8 on modern cores).
Register renaming: removes false dependencies (see below).
Issue queue / reservation stations: decoded instructions wait here. Each tracks which operands it's missing and watches for results to be broadcast. When all operands arrive, it becomes "ready."
Scheduler: each cycle, picks ready instructions and sends them to free execution units.
Reorder buffer (ROB): results are held here and committed in program order. This keeps the "as if sequential" promise, so exceptions and interrupts still behave precisely.

8. False dependencies and renaming

Not all dependencies are real. Consider:

asm
add  t0, a1, a2     # A
sub  t3, t0, a4     # B uses t0 (true dependency on A)
lw   t0, 0(a5)      # C reuses the name t0

C doesn't need A's value; it only reuses the register name. If C ran before B read t0, B would get the wrong value. These name clashes are called WAR ("write after read") and WAW ("write after write") hazards.

The fix is renaming: the hardware has many more physical registers (e.g., 200+) than the 32 architectural ones. Each new write to t0 gets a fresh physical register, so A's and C's t0 are different storage, and C can run early. Only true RAW dependencies remain as constraints.

9. Two ways to schedule

Dynamic (hardware) scheduling: what we just saw. Flexible, adapts to runtime events like cache misses, but costs power and complexity.
Static (compiler) scheduling: the compiler reorders instructions at compile time to separate dependent ones, e.g., moving lw t3 earlier in our example. Simple in-order cores (and VLIW designs) rely on this. Modern compilers do it even for out-of-order cores, since it gives the hardware a head start.

10. Limits of ILP

Dependency chains set a floor on execution time.
Branches: the processor must guess outcomes (branch prediction) to keep a large window of instructions in flight. A misprediction throws away speculative work.
Memory latency: cache misses can take hundreds of cycles; the window can only hide so much.
Hardware cost: wider issue and bigger windows scale poorly in area and power, which is why designers also turn to multicore and SIMD.

Summary

Execution units provide the capacity for parallelism, data dependencies define the constraints, and the scheduler (in hardware, the compiler, or both) matches ready, independent work to free units. Renaming removes fake constraints, and in-order commit makes the whole thing look sequential to the programmer.

If you'd like, a good next step is to take a longer snippet, such as a loop summing an array, and trace how unrolling and register renaming expose more ILP.

**Great now I want to make sure I understand how these concepts apply to actual RISC-V instructions. Can you walk me through the difference between Scenario 0, where three instructions can overlap in execution, and Scenario 1, where one instruction has to wait?
For each scenario, explain:Which execution resources the instructions use. Which instructions are independent of one another. Whether any data dependencies exist. How the processor decides which instructions can execute at the same time. Please explain it at an introductory computer architecture level.**

Scenario 0 and Scenario 1 weren't defined earlier in our conversation, so I've built the two most natural examples matching your descriptions. If your course materials define them differently, paste them in and I'll redo the walkthrough on those instructions.

Machine assumptions (same for both):

2 integer ALUs and 1 load/store unit
ALU ops take 1 cycle; a load takes 2 cycles to produce its value
The processor can issue up to 3 instructions per cycle and can execute out of order

Scenario 0: three instructions overlap

asm
add  t0, a0, a1    # I1
lw   t1, 0(a2)     # I2
sub  t2, a3, a4    # I3

1. Execution resources

I1 uses an integer ALU.
I2 uses the load/store unit (it computes a2+0, then reads the data cache).
I3 uses the second integer ALU.

Three instructions, and each gets its own unit, so there is no structural hazard.

2. Independence

All three are mutually independent. None of them reads a register that another one writes.

3. Data dependencies

None. The sources (a0, a1, a2, a3, a4) are all already available, and the destinations (t0, t1, t2) are three different registers, so there are no false dependencies either.

4. How the processor decides

For each instruction, the scheduler asks two questions: are all my source operands ready? and is a suitable unit free? All three answer yes in the same cycle, so all three issue together:

| Cycle | ALU 0 | ALU 1 | Load unit |
|---|---|---|---|
| 1 | I1 add | I3 sub | I2 lw |

All three begin in cycle 1. I1 and I3 finish in that cycle, and I2's value arrives at the end of cycle 2. Total: about 2 cycles, compared with 4 if each instruction ran one after another (1+2+1).

Scenario 1: one instruction must wait

asm
lw   t1, 0(a2)     # I1
add  t0, t1, a1    # I2  (needs t1 from I1)
sub  t2, a3, a4    # I3

1. Execution resources

I1 uses the load/store unit.
I2 uses an integer ALU.
I3 uses an integer ALU.

Resources aren't the problem here. Even with two free ALUs, I2 can't start early.

2. Independence

I1 and I3 are independent.
I2 and I3 are independent.
I2 is not independent of I1.

3. Data dependencies

There is one true (RAW) dependency: I2 reads t1, which I1 writes. Since the load takes 2 cycles, the value doesn't exist until the end of cycle 2, so I2 cannot execute before cycle 3. This dependency is a matter of data, so adding more hardware wouldn't remove it.

4. How the processor decides

Each cycle the scheduler checks readiness:

| Cycle | Load unit | ALU 0 | ALU 1 | What the scheduler saw |
|---|---|---|---|---|
| 1 | I1 lw | I3 sub | | I1 ready; I2 not ready (t1 missing); I3 ready |
| 2 | (I1 in progress) | | | I2 still waiting |
| 3 | | I2 add | | t1 arrives, I2 becomes ready |

The key moment is cycle 1. A strictly in-order processor would reach I2, find it blocked, and stop, so I3 would be stuck behind it for no good reason. An out-of-order scheduler lets I2 wait in the issue queue while I3 jumps ahead. I3 executes alongside the load, so its latency is hidden.

Total: about 3 cycles, compared with 4 sequentially. That's less overlap than Scenario 0, because the dependency forms a chain (I1 → I2) that sets a minimum time.

Side-by-side comparison

| | Scenario 0 | Scenario 1 |
|---|---|---|
| Units needed | ALU, ALU, load | load, ALU, ALU |
| True dependencies | none | I1 → I2 |
| Instructions that can start in cycle 1 | 3 | 2 (I1 and I3) |
| What limits speed | hardware width | the load-to-use dependency |

The takeaway

Both questions have to be answered "yes" before an instruction issues:

Is the data ready? (dependencies)
Is a unit free? (execution resources)

In Scenario 0, both answers are yes for every instruction. In Scenario 1, the first answer is "not yet" for I2, so it waits, while the scheduler fills the gap with independent work. When there is no independent work to fill the gap, the processor simply idles. This is why compilers try to place unrelated instructions between a load and its first use.

**Good, so now I want to connect these concepts to an actual commercial processor. Can you choose a specific modern Intel or AMD processor and explain its execution architecture?I'm specifically interested in:What types of execution units it contains (integer ALUs, load/store units, floating point units, branch units, etc). Whether it supports out-of-order execution. What specialized hardware it contains beyond general-purpose execution units. Why the processor designers included these different resources. Please identify the exact processor model and provide reliable sources, preferably official Intel or AMD documentation, so I can independently verify the information.**

AMD Ryzen 9 9950X (Zen 5 core)

I chose the AMD Ryzen 9 9950X because AMD publishes technical material on its Zen 5 core, so most claims can be checked against first-party documents. It has 16 cores and 32 threads, a max boost clock of 5.7 GHz and a 170 W default TDP. It is built from two 8-core chiplets (CCDs), each with 32 MB of shared L3 cache.
pcgamer

One caveat up front: AMD's Zen 5 white paper that I could read is written for the EPYC server chips, which use the same core design. I've marked below which numbers come from AMD documents and which come from press coverage of AMD's slides.

1. Execution units

Integer ALUs: 6 integer ALUs, 3 of them with multipliers, plus 3 branch units. This is a big jump from the previous generation: ALUs went from 4 to 6, multipliers from 1 to 3, and branch units from 2 to 3.
igorslab
wikichip

Address generation and load/store: 4 AGUs, which send 4 memory addresses per cycle to the load/store unit. Per cycle, the core can handle up to 4 loads (2 if they're 512-bit) and 2 stores (1 if 512-bit). The L1 data cache is 48 KB, 12-way, with a 4-cycle load latency.
igorslab
wccftech

Floating-point and vector: AMD's white paper says the FP/vector units have a full 512-bit data path and six pipelines, keeping more FP instructions in flight. Press coverage adds that floating-point add latency fell from 3 cycles to 2.
amd
gamersnexus

In terms of our earlier RISC-V examples, add/sub go to the ALUs, mul to a multiplier, beq to a branch unit, and lw first uses an AGU to compute a2+0 before the cache access. This is a more detailed version of the "load/store unit" I used in the simplified model, and with 6 ALUs, Scenario 0's three independent operations fit with room to spare.

2. Out-of-order execution

Yes. The evidence matches the machinery from the first lesson:

Schedulers (issue queues): 88 entries for ALU ops and 56 for AGU ops.
igorslab

Register renaming: a 240-entry integer physical register file, far more than RISC-V's 32 architectural registers.
igorslab

Reorder buffer (in-order commit): 448 entries. When two SMT threads share a core, it's 448 entries for a single thread and 224 per thread.
igorslab
wccftech

Width: AMD's white paper says the integer pipeline is now 8 instructions wide, one third more than Zen 4, supported by ALUs and an improved scheduler for a wide execution window.
amd

3. Specialized hardware beyond the basic units

512-bit SIMD (AVX-512): one instruction operates on a 512-bit vector. AMD says the chips implement the full AVX-512 set used in 4th Gen Intel Xeon except FP16, and a BIOS setting can run 512-bit operations as two 256-bit halves to save power.
amd

A heavy front end: AMD describes dual-pipe instruction fetch, parallel decoding, and highly accurate branch prediction. Slide figures show branch target buffers growing from 1.5K/7K to 16K/8K entries and fetch/decode bandwidth doubling to 64 bytes per cycle.
amd
igorslab

Cache and prefetch hardware: AMD notes doubled bandwidth between the core and the 48 KB L1 data cache, plus increased data prefetching, with 1 MB of L2 per core and a shared 32 MB L3 per 8-core die.
amd

SMT: the 32 threads on 16 cores means 2 hardware threads per core.

4. Why designers included these resources

AMD's own stated goals are double-digit IPC gains each generation, widening data paths so more work is done per cycle, and equipping the core for data-heavy AI workloads. Mapped onto the ILP concepts from earlier:

| Resource | Problem it addresses |
|---|---|
| More ALUs, multipliers, AGUs | Structural hazards: independent instructions shouldn't wait for a free unit |
| Big ROB, schedulers, register file | Dependency chains and cache latency: a larger window finds more independent work |
| Large branch predictor, wide fetch/decode | A big window is useless unless fed correctly; mispredictions discard work |
| 4 loads/cycle, 48 KB L1, prefetch | The load-to-use dependency from Scenario 1 is common and costly |
| 512-bit SIMD | Data parallelism, a different kind than ILP: one instruction processes many elements |

The scheduler change is a good design lesson. Zen 3 and 4 used four separate 24-entry schedulers, one per ALU, where Zen 5 has a single 88-entry unified scheduler for all six ALUs. AMD described it as more symmetric, which simplifies the pick logic. Wider hardware also costs area and power, which is why AMD ships a denser Zen 5c variant: same logic, tighter physical layout.
Zen 5: AMD’s biggest innovation since first Zen [expanded deep dive]
 +2

How to verify, and where I'm less certain

Most reliable: AMD's white paper 5th Gen AMD EPYC Processor Architecture (doc 70353). I read it directly. It supports the width, AVX-512, cache, and design-goal claims, but it doesn't list ALU/AGU counts.

Exact unit counts come from AMD's Hot Chips 2024 "Zen 5 Architecture" slides. I only found a copy hosted by a third-party site, plus press coverage that agrees on the main figures. Treat these as AMD-sourced but not first-party-hosted.

A discrepancy to check: one slide transcription lists 6 FP ops per cycle, while another outlet's Hot Chips coverage lists 4. AMD's white paper says six FP pipelines, but pipe count and ops per cycle may not be the same thing. Check the slide itself.

Not read: AMD's Software Optimization Guide for the AMD Zen5 Microarchitecture (document 58455) is the most detailed official source. I only saw it listed, not its contents, so search docs.amd.com for "58455" to verify the port-level details.

Product specs (clock, TDP) came from press reviews, so confirm them on AMD's 9950X product page.

Intel cross-check

For comparison, Intel's official Lion Cove architecture slides (used in the Core Ultra 9 285K) list 8-wide allocation/rename, 18 execution ports, a 576-entry instruction window, 6 integer ALUs, and separate integer and vector domains with independent schedulers. Some press articles on Arrow Lake quote different numbers, such as a 416-entry window and 8 ALUs. Those appear to describe the chip's E-cores rather than the P-core, so always check which core a figure belongs to.
intel

If useful, I can next map the Scenario 0 and Scenario 1 instructions onto Zen 5's actual ports and show how the scheduler would place them.

Sources:

AMD 5th Gen EPYC Processor Architecture white paper (70353)
AMD Zen 5 Architecture slides (Hot Chips 2024 copy)
Intel Lion Cove Architecture (Tech Tour 2024)
PC Gamer: AMD Zen 5 architecture
Wccftech: Zen 5 Hot Chips breakdown
WikiChip: Zen 5
HWCooling: Zen 5 deep dive
GamersNexus: Zen 5 architecture changes
Wccftech: Ryzen 9 9950X review

**So, earlier, you explained that independent instructions can execute simultaneously if they have their operands ready and the required execution units are available. I want to challenge that explanation. Is having independent instructions and available execution units always enough to guarantee that a modern processor will execute them simultaneously?
Specifically consider the AMD Ryzen 9 9950X we just discussed. Could limitations such as instruction scheduling, issue width, execution-port availability, memory operations, or power constraints prevent independent instructions from overlapping?
Please give me a concrete example and explain which limitations are architectural versus which depend on the processor's implementation.**

No. What I said earlier was a necessary condition, not a sufficient one. Ready operands and a free unit of the right type are the last two checks the scheduler makes, but several things have to go right before an instruction ever gets that far, and several things can stop it afterward. The Ryzen 9 9950X is a good case because AMD's published figures let us put numbers on the limits.

(The 9950X executes x86, not RISC-V. The examples below use RISC-V-style instructions for continuity, and each one maps to an equivalent x86 operation. The unit counts carry the same sourcing caveats as in my last answer.)

Example 1: independent instructions, free ALUs, still no full overlap

asm
mul t0, a0, a1
mul t1, a2, a3
mul t2, a4, a5
mul t3, a6, a7
mul t4, s0, s1
mul t5, s2, s3

All six multiplies are independent, and every operand is ready. Zen 5 has 6 integer ALUs, but only 3 of them have multipliers. So at most 3 of these multiplies can start in a cycle, even though 6 ALUs exist and some are idle. The unit count is not the same as the count of units that can do this particular job.
igorslab

Example 2: independent work blocked by an earlier slow load

asm
lw  t0, 0(a0)     # misses all caches, goes to DRAM (hundreds of cycles)
add t1, t0, a1    # depends on the load
...               # hundreds of independent instructions follow

The independent instructions after the load can run early, but only while they fit in the machine's windows. Zen 5's figures: an 88-entry ALU scheduler, a 56-entry AGU scheduler, a 240-entry physical register file, and a 448-entry reorder buffer. Dispatch is 8 ops per cycle, so at full speed the reorder buffer fills in about 448 ÷ 8 = 56 cycles. Things can stall even sooner, because the dependent add and anything chained to it sit in the scheduler taking up entries. Once a window fills, the front end stops accepting new instructions. If the miss takes several hundred cycles, the core idles for most of it, with ALUs free and independent work waiting in the program, just outside the window. With SMT, the reorder buffer is 448 entries for one thread but 224 per thread when two share the core, so a sibling thread shrinks your window.
igorslab
wccftech

The limitations you listed

| Limitation | What happens | Architectural or implementation? |
|---|---|---|
| True data dependency | Consumer can't start until the producer finishes | Architectural: the program's meaning requires it |
| Control flow (branches) | Instructions after an unresolved branch are speculative; a misprediction discards them | Architectural semantics (sequential order); implementation for predictor quality |
| Memory ordering | A load can't safely pass an older store to a possibly identical address; stores become visible in order; fences serialize | Architectural (the memory consistency model, plus fence instructions); how aggressively hardware speculates around it is implementation |
| Precise exceptions / in-order commit | Results retire in program order, so a stalled old instruction blocks retirement | Architectural requirement; ROB size is implementation |
| Number of architectural registers | Few names cause false (WAR/WAW) dependencies | Architectural cause; renaming and a 240-entry physical register file are the implementation fix |
| Unit mix per port | Only 3 of 6 ALUs multiply (Example 1) | Implementation |
| Issue/dispatch width | One core-wide cap of 8 ops per cycle covering integer and FP, however many units exist | Implementation |
| Load/store bandwidth | Roughly 4 loads and 2 stores per cycle, dropping to 2 and 1 for 512-bit accesses; cache banking and miss-handling resources add limits | Implementation |
| Scheduler pick logic | Each cycle it must choose among ready ops; Zen 5 uses a unified scheduler with an age matrix, and a poor pick can delay older work | Implementation |
| Window size | Reorder buffer, scheduler, and register file fill up (Example 2) | Implementation |
| SMT sharing | A second thread competes for the same units and windows | Implementation |
| Power/thermal | Clock speed or width trades against power | Implementation (and platform settings) |

Memory operations deserve special attention

Two loads can be perfectly independent in registers and still not overlap. They might hit the same cache bank, one might miss while the other waits behind it, or a younger load might sit behind an older store whose address is not yet known. The core must predict that they don't alias, or wait. That's why the load and store paths have their own queues and rules, separate from the ALU scheduler.

Power

Power rarely stops two instructions from overlapping within a cycle. Its main effect is on clock speed and design choices. AMD says Zen 5 runs AVX-512 without a frequency penalty. AMD's EPYC document also describes a BIOS option to run 512-bit instructions as two 256-bit operations in consecutive cycles to favor efficiency, which is a case of hardware being configured to overlap less on purpose. I read that in the EPYC document and haven't confirmed the same setting exists on the Ryzen 9 9950X.
yahoo
amd

The better rule

An independent instruction executes in parallel with others only if all of these hold:

It has been fetched, decoded, and dispatched (front-end bandwidth, branch prediction, and dispatch width all apply).
It has a slot in the window (scheduler, register file, reorder buffer, load/store queues).
Its operands are ready, including through memory.
It is safe under ordering rules (memory ordering, speculation).
The scheduler picks it and a compatible port is free that cycle.

Items 3 and 4 are mostly architectural, because they come from what the program means. Items 1, 2 and 5 are mostly implementation, because they come from how a given chip is built. This is why two processors running the same program can overlap very different amounts of work.

Sources:

AMD Zen 5 Architecture slides (Hot Chips 2024 copy)
Wccftech: Zen 5 Hot Chips breakdown
AMD 5th Gen EPYC Processor Architecture white paper (70353)
Tom's Guide via Yahoo: AMD Zen 5 architecture

**You explained that a processor's scheduler needs to choose between multiple ready instructions when execution resources are limited. How does the scheduler decide which instruction to prioritize? For example, does it prioritize older instructions, instructions that will take longer to execute, or instructions that will free up resources for other instructions? How does this decision affect overall processor performance?**

The short answer: most schedulers use oldest-ready-first as the baseline. Smarter priorities exist in research and in some hardware tweaks, but the decision has to be made every cycle by simple logic, which limits how clever it can be. The exact pick policy of the 9950X isn't publicly documented in detail, so I'll separate what's known from what's typical.

What's known about Zen 5

AMD's Hot Chips material describes the Zen 5 integer scheduler as unified, using an age matrix, and more symmetric across units, which simplifies the pick logic. Zen 3 and 4 instead used four separate 24-entry schedulers, one per ALU, where Zen 5 has a single 88-entry unified scheduler for all six ALUs.
wccftech
hwcooling

An age matrix is a hardware grid that records, for every pair of scheduler entries, which one is older. Each cycle, among the ready entries competing for a port, the logic can pick the oldest quickly. That strongly suggests oldest-first is the core policy, though AMD's public material doesn't spell out every exception.

Why oldest-first is the default

Older instructions are more likely to be on the critical path. Younger instructions often depend on them.
It guarantees forward progress. An unlucky instruction can't be passed over forever.
It helps retirement. Instructions retire in program order, so the oldest unfinished instruction blocks the reorder buffer. Finishing it frees reorder-buffer entries and physical registers, which keeps the window from filling (the problem from my previous answer).
It's cheap. Selection has to finish within roughly a cycle, and it sits in a tight loop with wakeup: when an instruction finishes, its consumers must be marked ready and then selected quickly enough that dependent ops can run back to back.

The alternatives you mentioned

| Policy | Idea | Catch |
|---|---|---|
| Oldest first | Safe, simple, approximates the critical path | Can pick a harmless old instruction over a critical younger one |
| Critical-path first | Prefer ops heading long dependency chains | Needs to know the chain length, which is hard to compute in one cycle (research designs use predictors) |
| Longest-latency first | Start slow ops (multiply, divide) early so they overlap other work | Helps only if those ops are actually on the critical path |
| Most-consumers first | Free up the most waiting instructions | Needs fan-out information the scheduler may not have |
| Loads first | Start cache misses early so several misses overlap | Can starve other work if loads dominate |
| Branches first | Resolve mispredictions sooner, wasting less speculative work | Not always the best use of a port |

Real designs typically combine a simple age-based rule with a few special-case preferences. I'm describing the general landscape here, not Zen 5 specifically.

A concrete example where the choice matters

Suppose only one execution unit can start an instruction each cycle, a multiply takes 3 cycles, and an add takes 1:

asm
add t1, a4, a5     # I1 (older): nothing depends on it
mul t0, a0, a1     # I2 (younger): starts a chain
mul t2, t0, a2     # I3: needs t0
add t3, t2, a3     # I4: needs t2

I1 and I2 are both ready in cycle 1, but only one can go.

| Policy | Cycle 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|
| Oldest first | I1 | I2 | | | I3 | | | I4 |
| Critical path first | I2 | I1 | | I3 | | | I4 | |

(I2's result is ready 3 cycles after it starts, so I3 can't start until cycle 5 in the first row and cycle 4 in the second.)

Oldest-first finishes in 8 cycles and critical-path-first in 7. I1 is harmless to delay, since nothing needs its result. Delaying I2 pushes back the whole chain.

How much does this matter in practice?

Only when ready instructions outnumber available ports. The 9950X has 6 ALUs, so on ordinary integer code the scheduler often has a free port for everything ready, and the policy doesn't matter. Contention shows up on scarce resources (only 3 ALUs can multiply, and the load/store paths are narrower) and in bursts, such as after a cache miss returns and many dependents wake at once.
Delaying critical work costs cycles; delaying non-critical work costs nothing. The difference is slack, the number of cycles an instruction can be delayed without delaying the program's finish. Oldest-first can't see slack, only age.
Gains from smarter policies are usually modest. Oldest-first captures most of the benefit, and the extra hardware and timing pressure of anything fancier often outweighs the gain. Memory is the exception: prioritizing loads so misses overlap can matter more than any ALU decision.

Architectural or implementation?

The priority policy is purely implementation. The architecture only says the results must match sequential execution, so different pick policies produce identical answers and differ only in timing. That's why vendors can change the policy between generations, as AMD did going from four per-ALU schedulers to one unified scheduler, without any software change.

Sources:

Wccftech: Zen 5 core architecture breakdown at Hot Chips
HWCooling: Zen 5 deep dive

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why a processor can execute multiple instructions at the same time even though programs are written sequentially?

1. I could not explain this topic at all; it was new to me.
2. I knew some related terms but could not explain the idea.
3. I could explain some pieces but not how they connect.
4. I could explain the general concept and why execution resources matter.
5. I could confidently explain why processors use parallel execution resources.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### P1 — After

After completing this assignment, how well could you explain why a processor can execute multiple instructions at the same time even though programs are written sequentially?

1. I still do not feel comfortable explaining this concept.
2. I understand some of the ideas but need more practice.
3. I understand execution resources and dependencies separately but not how they interact.
4. I can explain the concept well enough to help another student understand it.
5. I can confidently explain how instruction-level parallelism affects processor design.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the required questions.
- [ ] I mainly wanted to understand why processor behavior differs from the sequential software model.
- [ ] I mainly wanted to understand how real processors create and manage parallel execution.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] The in-class demonstration
- [ ] The waveform analysis
- [ ] Connecting the demo to RISC-V instructions
- [ ] The Concept section
- [ ] The AI investigation
- [ ] Investigating a real processor
- [ ] Challenging or verifying AI responses
- [ ] Confirm questions
- [ ] Prefer not to answer

### DEMO — Impact of the demonstration

The demonstration helped me understand how sequential programs can result in parallel hardware execution.

1. Strongly disagree
2. Disagree
3. Neither agree nor disagree
4. Agree
5. Strongly agree
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### AIUSE — How did you use AI?

Pick the one that fits best.

- [ ] To quickly obtain answers.
- [ ] To explain concepts I did not understand.
- [ ] To generate follow-up questions.
- [ ] To explore concepts beyond the assignment.
- [ ] To verify information and compare explanations.
- [ ] Other. *(Optional: tell us what.)*
- [ ] Prefer not to answer

---

# Grading Rubric

| # | What's being evaluated | Points |
|---|---|---:|
| MC1–MC4 | Understanding of execution resources, dependencies, latency, throughput, and hardware tradeoffs | 20 |
| N1 | Corrects the sequential execution mental model using parallel execution concepts | 20 |
| N2 | Correctly explains the Scenario 1 data dependency and why the MUL instruction must wait | 15 |
| N3 | Investigates a real processor and explains why it contains specific execution resources | 15 |
| N4 | Identifies an AI claim, explains why it deserved verification, documents the verification process, and reaches a supported conclusion | 20 |
| N5 | Identifies a useful follow-up question and explains how it improved understanding | 5 |
| N6 | Connects observed demo behavior to processor architecture concepts | 5 |
| Transcript | Included and documents the investigation process | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
