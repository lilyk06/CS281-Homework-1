# HW1 - Lillian Kager

This is the only file you need to fill out and submit for HW1. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW1.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** Why could a richer instruction set be attractive to a programmer writing assembly directly?

- [x] A. It can express some operations with fewer architectural instructions and less hand-written code
- [ ] B. It guarantees every program will execute faster
- [ ] C. It eliminates the need for registers
- [ ] D. It guarantees lower processor power

**MC2.** What is a micro-operation (µop)?

- [x] A. A simplified internal operation used by modern processors when executing decoded architectural instructions
- [ ] B. A separate 16-bit RISC-V instruction
- [ ] C. A compiler optimization pass
- [ ] D. A type of cache miss

**MC3.** What changed that reduced the importance of designing an ISA primarily for humans writing assembly directly?

- [ ] A. Instruction count stopped mattering completely
- [x] B. Optimizing compilers became capable of automatically performing much of the instruction selection, register allocation, scheduling, and optimization work
- [ ] C. Modern processors stopped executing machine code
- [ ] D. RISC architectures added x86-compatible instructions

**MC4.** What is one consequence of supporting a variable-length, highly expressive architectural instruction set such as x86-64?

- [x] A. The processor may require substantial front-end hardware to identify, decode, and translate instructions into operations the execution machinery can handle efficiently
- [ ] B. Every instruction must take exactly the same number of cycles
- [ ] C. Memory operands require no internal memory access
- [ ] D. Compilers are no longer useful

---

# Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement: "RISC is just better because simpler instructions make a simpler processor."

> Your answer:
>
>
>

### N2 — Make the tradeoff real (15 pts)

- **Processor, product, or workload:**
- **Architecture involved:**
- **Design consideration you investigated:**
- **What the architecture buys in this example:**
- **What it costs or trades away:**
- **Source:**

### N3 — Catch the AI (20 pts)

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

### N4 — Your best follow-up (10 pts)

**Your follow-up question:**

>

**Why that question was useful, or how it changed/refined your understanding (1–2 sentences):**

>

### N5 — Connect back (10 pts)

Check the **two** RISC-V design choices from lecture that most directly connect to the architectural tradeoff you investigated, and explain each in one sentence.

- [ ] Fixed 32-bit base instruction width — explanation:
- [ ] Load/store model — explanation:
- [ ] Register-only ALU operations — explanation:
- [ ] 32 general-purpose registers — explanation:
- [ ] Regular/separated instruction formats such as R-type and I-type — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

>My professor has assigned a homework assignment to learn about RISC-V and x86-64 processors. Why would a programmer writing assembly directly prefer a richer instruction set like x86-64? What did things like memory operands, more expressive instructions, and fewer instructions actually make easier for programmers?

Good question—let's ground this in a few real, well-documented cases rather than staying abstract.

Example 1: Apple's move away from x86-64 (Intel → Apple Silicon)

This is the clearest real-world data point most people have actually experienced. In 2020, Apple switched its entire Mac lineup from Intel's x86-64 chips to its own ARM-based chips (Apple Silicon, e.g., the M1). ARM isn't RISC-V, but it's built on the same core philosophy: simple, fixed-length, load-store instructions—so it's a legitimate real-world stand-in for "simple ISA vs. x86-64."

What happened:

Power efficiency: The M1 MacBook Air had no fan at all and got dramatically longer battery life than the Intel MacBook it replaced, while matching or beating it on performance in most workloads.
Performance: Apple's chip wasn't just "efficient but slow"—it was competitive or faster on single-thread performance too, which surprised a lot of people who assumed CISC's richer instructions were needed for peak performance.
The trade-off—compatibility: This is the cost side. Decades of Mac software were compiled for x86-64. Apple had to build Rosetta 2, a binary translator that converts x86-64 instructions into ARM instructions on the fly (or ahead-of-time at install). That translation isn't free—translated apps run slower than native ones, and some low-level software (kernel extensions, certain virtualization tools, old 32-bit apps) couldn't be translated at all and simply stopped working.

So the tradeoff was explicit: big power/performance win from the simpler ISA, paid for with a real, user-visible compatibility tax during the transition.

Example 2: Western Digital's RISC-V cores in storage controllers

This is a genuinely RISC-V (not just RISC-family) example, and it's already shipping at massive scale. Western Digital uses custom RISC-V cores inside the flash controllers of its SSDs and hard drives—reportedly over a billion RISC-V cores shipped in these products.

Why RISC-V specifically here, and what the tradeoff was:

Cost and licensing: ARM charges per-core licensing fees; RISC-V is royalty-free and open. At the volume WD ships (billions of units), licensing cost per chip matters enormously.
Customization: RISC-V's modular extension system let WD add custom instructions specific to flash-controller logic (error correction, address translation) without needing a vendor's permission or paying for a custom ARM core.
What they gave up: These controller chips don't run general-purpose software, don't need to run existing binaries, and don't need peak single-thread performance—they run small, purpose-built firmware that WD compiles itself. This is exactly the scenario where RISC-V's downsides (immature general-purpose software ecosystem, no legacy binary compatibility) don't matter at all, because there's no legacy software to be compatible with, and there's no complex OS-level workload demanding a beefy out-of-order core. It's a case chosen specifically to avoid the areas where x86-64 would still win.
Example 3: Why x86-64 still dominates gaming PCs and traditional data centers

The flip side: x86-64 remains completely entrenched in desktop gaming and most enterprise servers, for a reason that has almost nothing to do with instruction set elegance—software compatibility and the maturity of the compiler/tooling ecosystem.

Decades of Windows games, enterprise software, and legacy business applications are compiled specifically for x86-64, often as closed-source binaries nobody can recompile.
RISC-V's compiler and OS ecosystem (Linux distributions, driver support, optimizing compiler backends) is still catching up—RISC-V Linux ports have historically had noticeably slower build times and less mature compiler optimizations than the equivalent ARM or x86-64 targets, simply because fewer engineer-years have gone into tuning GCC/LLVM for RISC-V.
So even though a simpler ISA could, in principle, run this software faster or more efficiently, nobody can realistically recompile the entire installed base of x86-64 software, and the tooling isn't as mature yet, so x86-64 wins by inertia and ecosystem depth, not architectural merit.
Tying it back to the concepts from earlier
Factor	Where x86-64 wins	Where RISC/RISC-V wins
Compatibility	Decades of existing compiled software (games, enterprise apps)	N/A — this is x86-64's biggest structural advantage
Power efficiency	Loses badly (Apple Silicon vs. Intel MacBooks)	Wins clearly — simpler decode, less wasted power
Cost/licensing at scale	Loses (per-core costs, complex chip design)	Wins — WD's billion-unit RISC-V deployment
Peak single-thread performance	Still often wins in high-end desktop/server (mature out-of-order cores, decades of tuning)	Catching up, but less mature at the very top end
Toolchain/compiler maturity	Wins — decades of optimization work in GCC/LLVM/MSVC	Still maturing, e.g., slower build times reported porting Linux distributions to RISC-V

The pattern across all three examples is the same one you've been building toward in this conversation: the ISA itself isn't what wins or loses—it's the combination of the ISA plus the maturity of everything built around it (compilers, existing software, manufacturing scale) that determines the real-world outcome. Apple could only make the ARM transition work because Apple controls its whole software stack and could force a recompile; WD could only make RISC-V work because its firmware has no legacy baggage; and x86-64 survives in gaming/servers primarily because of the sheer weight of existing software, not because CISC is inherently better for those workloads.

Now help me put it all together? What does a richer ISA like x86-64 buy, what does it cost, what does a simpler ISA like RISC-V buy, what does it cost, and who or what was both approaches originally optimized for?

Here's the full picture, pulled together from everything we've covered.

What a richer ISA (x86-64) buys you
Fewer instructions per task — memory operands, complex addressing modes, and multi-step instructions (like add eax, [rbx] or lea) let one instruction do the work of several.
Less manual bookkeeping for anyone writing assembly by hand — no need to explicitly manage scratch registers or address arithmetic.
Denser code — smaller program size in memory, historically valuable when memory was scarce and expensive.
Massive software compatibility — decades of existing compiled binaries (games, enterprise software, OS-level code) run unmodified, which is arguably its single biggest advantage today.
Strong peak single-thread performance in mature, very wide out-of-order implementations, backed by decades of engineering investment.
What a richer ISA (x86-64) costs you
Complex, variable-length instruction encoding — the CPU doesn't even know how long an instruction is until it starts decoding it, which requires dedicated hardware just to find instruction boundaries.
Expensive decode hardware — multiple parallel decoders, a microcode ROM for rare complex instructions, and a µop cache just to avoid re-paying the decode cost repeatedly.
Extra pipeline stages and power draw, because every instruction has to be translated into simpler µops before the execution engine can actually use it.
Harder to pipeline and parallelize at the instruction level, since one complex instruction bundles several dependent steps together internally.
What a simpler ISA (RISC-V) buys you
Simple, fixed-length, uniform instructions — the CPU always knows exactly what it's looking at, with no boundary-detection problem.
Cheap, fast decode — little to no need for a µop cache or microcode ROM, since instructions are already close to the internal execution unit's native form.
Excellent pipelining and out-of-order scheduling — simple, atomic operations make dependency tracking and parallel execution far more tractable.
Power efficiency — less decode complexity burns meaningfully less power per instruction, which is why RISC-family designs dominate phones, embedded systems, and increasingly efficient laptops.
Openness and customizability — no licensing fees, and a modular extension system that lets companies (like Western Digital) tailor a core to a specific workload cheaply at scale.
What a simpler ISA (RISC-V) costs you
More instructions per task — the compiler (or a human) has to explicitly write out steps like loads that x86-64 would fold into one instruction.
Less code density, though extensions like RISC-V's compressed instruction set claw some of this back.
A younger, less mature software ecosystem — compiler optimization, OS tooling, and driver support are still catching up to x86-64/ARM in places, which shows up as real, measurable costs like slower build times porting Linux distributions.
No legacy compatibility to lean on — every RISC-V deployment today is either brand-new software or something built specifically for it; there's no thirty-year backlog of binaries it can just run.
Who each approach was originally optimized for

This is really the crux of everything we've discussed, and it's worth stating precisely:

x86(and its CISC ancestors) were originally optimized for the human assembly programmer and for scarce, expensive memory. In the 1970s, compilers were weak and much performance-critical code was hand-written, so a rich instruction set that did more per line was a genuine productivity and memory-footprint win. The hardware was designed to make human-written code easier and more compact.
RISC-V (and RISC generally) was optimized for the compiler and the pipeline. By the time RISC architectures emerged in the late 1970s–80s, compilers had matured enough to reliably generate longer, simpler instruction sequences automatically, so there was no more need to bake human convenience into the hardware. Instead, RISC-V's design assumes a compiler is doing the instruction selection, and it optimizes for what actually makes silicon fast: uniform, easy-to-decode, easy-to-pipeline, easy-to-parallelize operations.

The one-sentence version for your assignment: x86-64 is a snapshot of an era when hardware was designed to serve the human programmer directly; RISC-V is a product of an era when hardware could be designed to serve the compiler and the pipeline instead, because the human had already been taken out of the loop—and that shift, more than anything else, is why the two architectures look so different today.

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why x86-64 and RISC-V make such different choices about instruction complexity?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge of this topic and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the architectural tradeoff to someone else.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### P1 — After

After this assignment, how well could you explain why x86-64 and RISC-V make such different choices about instruction complexity?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts but not fully how they connect into an architectural tradeoff.
4. I am confident I could explain the tradeoff well enough to help a fellow classmate understand it.
5. I could confidently explain and defend the tradeoff in a technical discussion with someone knowledgeable about processor architecture.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to resolve something from the demonstration or assignment that didn't make sense to me.
- [ ] I mainly wanted to understand the architectural tradeoff well enough that I could explain or apply it beyond this assignment.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] The in-class demonstration / hook
- [ ] Reading the Concept section
- [ ] The AI investigation
- [ ] Challenging or verifying something the AI told me
- [ ] Answering the Confirm questions
- [ ] Prefer not to answer

### SCA — What should we do with this format?

- [ ] Continue as is. *Tell us more (optional): any suggestions to make it even better?*
- [ ] Adjust something. *Tell us more (optional): what would you change?*
- [ ] Stop, and go back to a traditional homework model. *Tell us more (optional): what didn't work for you?*
- [ ] Prefer not to answer

### AI Investigation Skills

For each statement, enter a number based on what you can do right now, not what you think you're expected to be able to do.

1. Strongly disagree.
2. Disagree.
3. Neither agree nor disagree.
4. Agree.
5. Strongly agree.
6. (or blank) = Prefer not to answer.

- **AI1.** When investigating an unfamiliar technical topic with AI, I can decide what question would be useful to ask next. **Your answer (1–6):** ___
- **AI2.** I can recognize when an AI explanation or technical claim needs further investigation. **Your answer (1–6):** ___
- **AI3.** I know how to check a technical claim made by AI using evidence beyond the AI's own explanation. **Your answer (1–6):** ___
- **AI4.** I can use follow-up questions with AI to improve my own understanding of a technical topic. **Your answer (1–6):** ___
- **AI5.** I can decide when I have enough evidence to accept, reject, or remain uncertain about a technical explanation provided by AI. **Your answer (1–6):** ___

---

# Grading Rubric

| # | What's being evaluated | Points |
|---|---|---:|
| MC1–MC4 | Correctly identifies the four core concepts covered in this homework | 20 |
| N1 | States the corrected model: explains what richer and simpler ISA approaches buy and how compiler-generated code changed the tradeoff | 20 |
| N2 | Provides a specific modern example, identifies the architectural consideration, and explains both what it buys and what it trades away with a credible source | 15 |
| N3 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N4 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N5 | Selects two defensible RISC-V design choices and correctly explains their connection to the investigated tradeoff | 10 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
