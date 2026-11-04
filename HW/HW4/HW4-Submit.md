# HW4 — Submission Template

This is the only file you need to fill out and submit for HW4. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW4.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** Why does RISC-V make most extensions optional rather than putting every capability into the mandatory base ISA?

- [ ] A. The extensions were unfinished
- [x] B. Different processors can implement only the capabilities that provide value for their target products
- [ ] C. Optional extensions execute faster than mandatory instructions
- [ ] D. RISC-V prevents different processors from using different hardware

**MC2.** Which is a real cost of adding hardware floating point to a small processor?

- [ ] A. Only the software compiler becomes more complicated
- [x] B. Hardware area, verification effort, power, and manufacturing cost
- [ ] C. Floating-point instructions become incompatible with integer instructions
- [ ] D. There is no meaningful cost after the ISA is defined

**MC3.** Which processor is most likely to omit the F extension?

- [x] A. A low-cost, high-volume microcontroller that performs mostly integer control work
- [ ] B. A processor designed for computation-heavy scientific workloads
- [ ] C. A high-end application processor intended to run a full OS and graphics workloads
- [ ] D. All processors are equally likely to omit F

**MC4.** What is the main architectural tradeoff behind optional extensions?

- [ ] A. Faster instructions are always better, so every extension should be mandatory
- [x] B. A capability can provide significant benefits for some workloads while imposing costs on every implementation that supports it
- [ ] C. Optional extensions exist mainly to make assembly programming harder
- [ ] D. Hardware extensions matter only when software is poorly optimized

---

# Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement: "If hardware support makes an operation much faster, every processor should include that hardware."

> Your answer: Even though hardware support can make an operation faster, it does not mean that every processor needs it. Adding hardware like an FPU takes up chip space, uses power, and increases manufacturing costs. A processor designed mainly for simple integer operations might not benefit enough from an FPU to justify those costs, while a processor used for scientific computing or signal processing might benefit from having one.

### N2 — Make the hardware cost real (15 pts)

- **Extension / hardware feature:** RISC-V F extension (hardware floating-point support).
- **Processor or core:** RI5CY 32-bit RISC-V core with the FPnew transprecision FPU.
- **Cost you investigated:** Hardware area (silicon area).
- **Reported value:** The FPU uses 69 kGE out of the core's total 147 kGE.
- **What the number means:** The floating-point unit takes up about 47% of the processor core's total area. This shows that adding floating-point hardware can take up a significant amount of space, especially in a small processor.
- **Source:** Mach et al., FPnew: An Open-Source Multi-Format Floating-Point Unit Architecture for Energy-Proportional Transprecision Computing, Section IV-A, "Impact of the TP-FPU," and Figure 4. https://arxiv.org/pdf/2007.01530

### N3 — Find the design decision in the real world (10 pts)

- **Processor/core without F/D:** Espressif ESP32-C3 (RV32IMC), which doesn't have hardware floating-point support.
- **Processor/core with F/D:** RI5CY (RV32IMFC), configured with the FPnew hardware floating-point unit.
- **What each is designed for:** The ESP32-C3 is designed for low-cost IoT devices that use Wi-Fi, Bluetooth, sensors, and basic control operations. RI5CY is designed for low-power embedded applications, including digital signal processing and workloads that consist of more complex mathematical calculations.
- **Why the extension choice makes sense for each:** The ESP32-C3 can leave out floating-point hardware because most of its intended tasks rely on integer operations, saving chip area, power, and cost. RI5CY benefits from an FPU because its signal-processing and math-heavy workloads can use faster floating-point calculations, therefore making the additional hardware worthwhile.

### N4 — Catch the AI (20 pts)

- **What the AI claimed:** The AI agent, Claude, initially explained that the FPnew hardware increased the RI5CY core's area by 29% compared to a standard core. It also estimated that adding an FPU to a core without one would increase its area by approximately 88%.
- **Why you questioned it or wanted more precision:** I wanted to know what the 29% was actually being compared to. I realized that the comparison might be misleading because the standard RI5CY core already included an FP32 floating-point unit. I also questioned whether the 88% estimate was an actual measurement or just an assumption.
- **What you did to check it:** I asked the AI to identify the original comparison in the FPnew paper and explain what the 29% represented. I then asked it to explain how it calculated the 88% estimate and whether the paper actually supported that number.
- **What you concluded:** I learned that the 29% increase was comparing a multi-format FPU to an FP32-only FPU, and not comparing a processor with an FPU to one without it. The 88% figure was just a rough estimate based on the reported area numbers, not an actual measurement from the paper. This showed me that AI can present calculations that seem convincing but still depend on assumptions that need to be checked manually.

### N5 — Your best follow-up (10 pts)

**Your follow-up question:**

> Based on the ESP32-C3 and RI5CY examples, would it be fair to say that having an FPU is not automatically better, even if it makes floating-point calculations faster? Are there situations where software floating-point is actually the better design choice?

**Why that question was useful, or how it changed/refined your understanding (1–2 sentences):**

> This question helped me understand that faster hardware is not always the best choice for every processor. Whether an FPU is worth including depends on the processor's intended workload and whether or not the performance benefits outweigh the additional cost, area, and power consumption.

### N6 — Connect back (5 pts)

Check the **two** lecture concepts that most directly explain the design decision you investigated, and explain each in one sentence.

- [x] ISA extensions and modular instruction-set design — explanation:
- [x] Hardware versus software implementation of an operation — explanation:
- [ ] Die area / transistor budget — explanation:
- [ ] IEEE-754 floating-point representation — explanation:
- [ ] Hardware verification as an engineering constraint — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

> **I am completing a Systems Architecture homework assignment. Why does RISC-V make some hardware features, like floating-point support, optional instead of requiring every processor to include them? Explain the benefits and drawbacks simply, and give me a real-world example of a processor that might choose not to include floating-point hardware.**
> RISC-V is built as a small mandatory base plus optional extensions. The base integer instruction set (RV32I or RV64I) is tiny, and everything else (multiply/divide “M”, atomics “A”, single-precision float “F”, double-precision float “D”, compressed instructions “C”, vectors “V”, and so on) is a separate module a chip designer can add or leave out. Floating-point is just one of those modules.

Why it’s designed this way

The core idea is that RISC-V is meant to span an enormous range of hardware, from a tiny sensor controller to a data-center CPU. No single feature set is right for both. Earlier architectures like x86 accumulated mandatory features over decades, so every implementation had to carry them. RISC-V avoids that by letting each chip include only what its job needs.

Benefits

Smaller, cheaper chips. A floating-point unit (FPU) takes silicon area. Leaving it out reduces cost.
Lower power. Fewer transistors means less leakage and less energy use, which matters for battery-powered devices.
Simpler design and verification. Less hardware means less to design, test, and debug.
Flexibility. Designers can tailor a chip to a specific workload instead of paying for features they’ll never use.
Room to grow. New extensions can be added later without breaking the base.

Drawbacks

Software compatibility risk. A program compiled to use floating-point instructions won’t run on a chip without an FPU. Software must be built for the right combination of extensions.
Fragmentation. With many possible combinations, it’s harder for the ecosystem to agree on what “a RISC-V chip” can do. RISC-V addresses this with standard bundles of extensions (for example, “G” means IMAFD, and “profiles” like RVA23 define what application-class software can expect).
Slower workarounds. If code needs floating-point and the hardware lacks it, a software library has to emulate it using integer instructions, which is much slower.
More complexity for toolchain builders. Compilers and operating systems need to handle many configurations.

Real-world example

A good example is a low-cost microcontroller in a smart thermostat or a simple sensor node, such as chips built on the RV32IMC configuration (32-bit base, multiply/divide, compressed instructions, no FPU). Its job is mostly reading sensors, comparing integers, and toggling pins. It rarely needs fractional math, and when it does, it can use fixed-point arithmetic (storing values as scaled integers, like keeping temperature in hundredths of a degree). Dropping the FPU makes the chip smaller, cheaper, and more power-efficient, which is exactly what you want in a device that may run on a coin cell for years. The Espressif ESP32-C3 is a commercial chip in this category: it uses a RISC-V core with integer instructions and no hardware FPU.

Short version for your homework: RISC-V makes floating-point optional so designers can trade capability against cost, power, and complexity. The price is potential software incompatibility and slow emulation, which the ecosystem manages through standardized extension bundles and profiles.

**Ok, what is a real example of a RISC-V processor that includes hardware floating-point support? Find me a specific measurement of the hardware cost of including floating-point support, such as additional chip area, power consumption, or transistor count. Give me the processor name, the actual measurement, and a reliable source that I can look through to verify it.**

The best measurement I found comes from the FPnew paper, which implements the RI5CY RISC-V core with a hardware FPU.

Processor: RI5CY (a 32-bit RISC-V core from the PULP project), as part of the PULPissimo SoC, with the FPnew “transprecision” FPU added.

Measurement: The RI5CY core with the FPU totals 147 kGE (kilo gate-equivalents), and the FPU alone takes 69 kGE, which is 47% of the core. In the same paper, 1 GE is about 0.199 µm², so the FPU is roughly 0.0137 mm² in that technology. By simple subtraction, the rest of the core is about 78 kGE. This means the FPU is a bit under half of the core’s area. The area is only a small fraction of the whole PULPissimo SoC, which comes to 5.1 MGE including memories. The cost is dramatic for the core but modest for the full chip. 
FPnew: An Open-Source Multi-Format Floating-Point Unit Architecture for Energy-Proportional Transprecision Computing
 +2

Caveats:

This FPU supports several formats (FP32 plus smaller ones like FP16, bfloat16, and FP8), so it’s larger than a plain single-precision FPU. The paper notes compared with a standard RI5CY core that supports only FP32, the area grows by 29% and static energy by 37%. That 29% is relative to an FP32-capable core, not to a core with no FPU. 
arxiv
I only saw excerpts of the paper, not the full text, so check the exact figures in the “Impact of the TP-FPU” section and its area-distribution figure.

A simpler data point for homework: A talk from the same research group (ETH Zürich / PULP) says that FPUs add large area overhead: about 20 kGE for single-precision and about 50 kGE for double-precision, versus 10-20 kGE for an entire area-optimized core. By that estimate, adding even a single-precision FPU can roughly double the size of a tiny core. These are slide figures, so I’d cite the FPnew paper as your primary source. 
pulp-platform

Where to verify:

Stefan Mach, Fabian Schuiki, Florian Zaruba, Luca Benini, “FPnew: An Open-Source Multi-Format Floating-Point Unit Architecture for Energy-Proportional Transprecision Computing”: https://arxiv.org/pdf/2007.01530
Bertaccini et al., “A Tiny RISC-V Floating-Point Unit” (RISC-V Summit 2020 slides): https://pulp-platform.org/docs/riscv2020/Bertaccini-A_Tiny_RISC-V_FPU.pdf

Sources:

FPnew paper (arXiv)
A Tiny RISC-V Floating-Point Unit (PULP Platform)

**Can you help me verify the 69 kGE measurement in the FPnew paper? Where exactly in the paper is this number reported, and what does kGE mean? Also, does the 69 kGE represent the entire processor or just the floating-point unit?**

I only saw search excerpts before, so I’ll open the paper and check the exact location.

The 69 kGE figure checks out against the paper, and I found a detail that corrects something I said earlier.

Where it appears

Section IV (“Implementation Results”), subsection A, “PULPissimo: RI5CY with Transprecision FPU”, item 2), “Impact of the TP-FPU”.
It’s in the first sentence of that item: the RI5CY core with the FPU totals 147 kGE, of which the FPU occupies 69 kGE (47%). The same paragraph says the entire PULPissimo system including memories is 5.1 MGE.
The numbers are shown graphically in Fig. 4, “Area distribution of the PULPissimo SoC and the RI5CY core.”

What kGE means

kGE stands for kilo gate equivalents, meaning thousands of gate equivalents (GE).
A GE is a technology-independent unit of chip area. By convention it’s the area of one basic logic gate, usually a 2-input NAND, so a design’s size can be compared across manufacturing processes. The paper doesn’t spell out that convention in the text I read. It only gives the conversion for its process: 1 GE ≈ 0.199 µm² (GlobalFoundries 22FDX, 22 nm).
So 69 kGE is roughly 69,000 × 0.199 µm² ≈ 13,700 µm², or about 0.0137 mm².

FPU only, or the whole processor?

The 69 kGE is the FPU only. The whole RI5CY core with the FPU is 147 kGE, and the whole SoC is 5.1 MGE. By subtraction, the non-FPU part of the core is about 78 kGE.
The FPU is a large share of this small core, but the paper notes memories make up 92% of the SoC area. Per the paper, the added FPU area and static energy account for only 0.7% and 0.9% of the system.

Corrections to my earlier answer

I said this FPU supports FP32, FP16, bfloat16, and FP8. That describes the paper’s FPU in general, but Table I shows the RI5CY configuration includes only FP32, FP16, and FP16alt (the paper’s bfloat16-like format). FP8 is only in the 64-bit Ariane configuration.
The divide/square-root block is disabled in the RI5CY configuration, so the 69 kGE excludes it.
The core reuses the integer register file for floating-point values, so the 69 kGE doesn’t include a separate FP register file either. A standard RISC-V “F” implementation normally has one, so its cost would be higher.
The “29% larger” figure compares this core to a standard RI5CY with FP32-only FPU support. It is not the cost of FPU versus no FPU.

A second data point from the same paper (Section IV-B, item 2): The 64-bit Ariane core with the FPU is 742 kGE, and the FPU alone is 247 kGE, about a third of the core.

For your homework, I’d cite it as: Mach, Schuiki, Zaruba, Benini, “FPnew: An Open-Source Multi-Format Floating-Point Unit Architecture for Energy-Proportional Transprecision Computing,” Section IV-A.2 and Fig. 4. Keep in mind that it’s a multi-format FPU, not a minimal single-precision one.

Sources:

FPnew paper (arXiv)

**Ok, you mentioned that some of your earlier information was not correct. How could someone misunderstand the 29% area increase and assume that it represents the cost of adding an FPU compared to having no FPU? Why is that distinction important when looking at whether or not floating-point hardware is worth including?**

The 29% is easy to misread because of how the sentence is built.

How the misunderstanding happens

The sentence sits under the heading “Impact of the TP-FPU,” right after the 147 kGE and 69 kGE numbers. That makes “area increases by 29%” sound like “this is what the FPU costs.”
The baseline is tucked into a clause in the middle: compared to a standard RI5CY core with support for only FP32. That baseline already has an FPU. The 29% measures the cost of going from a basic FP32 FPU to the fancier multi-format one.
A percentage always depends on its denominator, and the denominator here isn’t “a core with no floating-point hardware.”

A rough estimate of the other comparison
This is my own arithmetic, not a figure from the paper, so treat it as a ballpark. If the full core is 147 kGE and the FPU is 69 kGE, the rest of the core is about 78 kGE. Adding the FPU to a no-FPU core would then increase its area by about 69 / 78 ≈ 88%, roughly three times the 29% figure. Working backward, the FP32-only baseline core would be about 147 / 1.29 ≈ 114 kGE, which would put a basic FP32 FPU at around 36 kGE. That assumes the non-FPU logic is identical in both designs, which the paper doesn’t state.

Why the distinction matters for deciding if floating-point is worth it

Designers choose among options, not yes/no. The real choices are no FPU, a small FP32 FPU, or a large multi-format FPU. Each step has a different marginal cost, and the 29% only describes the last step.
Using the wrong baseline understates the cost. Reading 29% as “FPU vs. none” would make floating-point look about three times cheaper than it is for a tiny chip, which is the case where the cost matters most.
The denominator changes the story. The same extra area is 29% of the core but only 0.7% of the whole SoC, because memories make up 92% of the SoC’s area. Whether that’s a lot depends on whether you’re paying for core area or total chip area.
The cost has to be weighed against the benefit. The alternative to hardware floating-point isn’t free. Software emulation costs code size and speed, as the earlier slide deck noted (about 5 kB of library code for single-precision emulation). The paper also argues the system-level energy difference between FP and integer processing is small enough for FP to be affordable even on microcontrollers.

So when you cite a percentage, state what it’s relative to. For your homework, “the FPU is 69 kGE of a 147 kGE core” is the safer claim, with the 29% presented as the cost of the multi-format upgrade over an FP32-only FPU.

**So, you estimated that adding an FPU to a core without one would increase its area by about 88%. Since you said this assumes the non-FPU hardware stays identical, how confident should I be in that estimate? Is there even enough evidence in the paper to treat 88% as an actual measured result, or should I only use it as a rough estimate?**

Use it only as a rough, derived estimate. The paper doesn’t measure it, so it shouldn’t be presented as a result.

Why it isn’t a measurement

No one built and measured that comparison. The paper reports 147 kGE for the core with the FPU, 69 kGE for the FPU, and 29% over an FP32-only core. The 88% comes from my arithmetic on those numbers (69 / 78), not from a no-FPU core being synthesized. In the text I read, the paper never gives the area of a core with no FPU at all.
The subtraction assumes the 69 kGE captures everything floating-point adds. Some FP-related cost may sit outside the FPU block, such as decoder changes, load/store modifications for NaN-boxing, and control logic. The paper calls these changes “not very substantial,” but they exist, and they’d be counted in the 78 kGE rather than the FPU. That would make the true no-FPU core smaller and the true percentage larger.
The baseline numbers are rounded and may come from different runs. 147, 69, and 29% are all rounded. The paper also notes the FPU uses relatively more fast, low-threshold cells because of timing pressure, which suggests area depends on the synthesis setup. A separate synthesis of a different core might not line up neatly with the subtraction.
There’s a sanity-check warning sign. Working backward from the 29%, I estimated an FP32-only FPU at about 36 kGE. The earlier PULP slide deck quoted roughly 20 kGE for single-precision. They’re different designs and sources, so it isn’t a contradiction, but it shows the estimate can vary by tens of percent depending on assumptions.

How much confidence to place in it

Reasonable: “adding this FPU to a no-FPU version of this core would plausibly nearly double its area.” The 69 kGE FPU versus roughly 78 kGE of everything else supports that.
Not justified: treating “88%” as a precise figure. I’d say something like “on the order of 80-90%, give or take.”

How to firm it up

Check Fig. 4 in the paper (I couldn’t view the figure itself). It breaks down the RI5CY core’s area and may show the non-FPU components directly, which would let you compute the ratio from reported numbers.
If it doesn’t, look at the RI5CY (now CV32E40P) design from the OpenHW Group or PULP, which has published area figures for configurations with and without an FPU.

In your write-up, I’d phrase it as: “The paper reports the FPU as 69 kGE of a 147 kGE core. Based on these numbers, I estimate that adding it to a core without one would increase area by roughly 90%, but this is a derived estimate, not a reported measurement.”

**Could you compare the Espressif ESP32-C3, which does not have hardware floating-point support, with the RI5CY processor, which does? What is each processor designed for, and why does including or leaving out an FPU make sense for its intended purpose? Please provide sources for both.**

I stated earlier that the ESP32-C3 has no hardware FPU from memory, so I’ll check that along with the details of both chips.

The search results confirm the ESP32-C3’s RV32IMC core but say nothing explicit about the FPU. I’ll look for a direct statement.

Both chips fit the same pattern, but they’re different kinds of things. The ESP32-C3 is a complete, shipping chip (a system-on-chip with Wi-Fi and Bluetooth). RI5CY is a processor core design from the PULP project, now maintained as CV32E40P, which other chips are built around.

	ESP32-C3	RI5CY (CV32E40P)
What it is	Commercial Wi-Fi + Bluetooth LE microcontroller SoC	Open-source 32-bit core design for embedded and signal-processing use
Core	Single-core 32-bit RISC-V, up to 160 MHz	4-stage in-order core, RV32IMFC plus custom DSP extensions
FPU	None. Floating-point math runs in software	Optional 32-bit FPU supporting the F extension
Target	Low-cost IoT devices	Low-power embedded and DSP workloads

ESP32-C3: why leave out the FPU

Espressif’s own developer blog says the ESP32-C3 executes floating-point math in software, using standard libraries that are slower but still accurate. This also confirms what I stated earlier from memory.
A secondary source (CNX Software) describes the core as RV32IMC, meaning base integer, multiply/divide, and compressed instructions, with no F or D extension.
The chip is positioned as a low-cost Wi-Fi and Bluetooth LE alternative to the ESP8266 for applications where the older chip’s resources are too low, and it draws 5 µA in deep sleep, per the sources above.
My inference, not stated by Espressif: typical IoT work (networking, sensor reads, control logic, encryption) is mostly integer-based, so an FPU would add cost and area for little benefit. The chip already devotes its silicon to Wi-Fi, Bluetooth, and crypto hardware. Espressif does say hardware floating-point is much faster, so the trade-off is real for math-heavy code.

RI5CY: why include an FPU

The CORE-V roadmap describes the core as an embedded-class design with an optional 32-bit FPU plus custom DSP extensions such as hardware loops, SIMD, bit manipulation, and post-increment instructions. The GitHub README says the extensions improve performance for signal processing.
The FPnew paper calls it a low-power, MCU-class core focused on embedded and DSP applications. DSP-style workloads (filtering, accumulating products, as in the paper’s case study) are where floating-point hardware pays off.
Per the paper, the FPU takes up 69 kGE of the 147 kGE core, but only a small share of the SoC. The authors conclude FP computation is affordable even in an MCU context.

Caveat on the comparison: the FPU in RI5CY is optional, so not every RI5CY-based chip includes one. The FPnew paper’s version does, and it’s a multi-format design, so it’s larger than a basic single-precision FPU.

The takeaway for your homework: the same architecture supports both choices. The ESP32-C3 optimizes for cost and low power in integer-heavy IoT work. RI5CY, in the configuration the FPnew paper studies, optimizes for math-heavy embedded and signal-processing work where the extra area and power buy real speed and energy savings.

Sources:

Espressif developer blog, “Cores with FPU”: software floating-point on ESP32-C3
ESP32-C3 Series Datasheet (Espressif): 160 MHz single-core RISC-V, Wi-Fi/BLE SoC (the version I saw in search results was a mirror)
CNX Software ESP32-C3 announcement: RV32IMC description and 5 µA deep sleep
Elektor, ESP32-C3 RISC-V core: positioning against ESP8266
OpenHW Group CORE-V cores: CV32E40P (formerly RI5CY), RV32IMFC, optional FPU, DSP extensions
PULP Platform implementation page: CV32E40P description
FPnew paper (arXiv): RI5CY with TP-FPU, area figures, MCU-class framing

**Based on those ESP32-C3 and RI5CY examples, would it be fair to say that having an FPU is not automatically better, even if it makes floating-point calculations faster? Are there situations where software floating-point is actually going to be the better design choice? Explain why.**

Yes, that’s a fair conclusion. An FPU is a trade, not a free upgrade. It makes floating-point math faster, but it costs area, power, and design effort, and whether that’s worth it depends on how much floating-point work the chip will actually do.

What the two examples support

The FPnew paper reports the FPU as 69 kGE of a 147 kGE core, nearly half of it. An FPU is a big share of a small core.
The ESP32-C3 shows that a commercially successful chip can ship without one, because its job (networking, sensors, control) is mostly integer work.
The same paper argues the system-level cost of the FPU is small, because memories dominate the SoC. So “an FPU is expensive” is not universally true either. It depends on whether you’re counting core area or whole-chip area.

Situations where software floating-point is the better choice

These are reasoned from the trade-offs rather than taken directly from the sources, so treat them as design logic, not measured results.

Floating-point is rare in the workload. If a program does a few float operations per second, the slower software path costs almost nothing, while an always-present FPU costs silicon area on every chip sold. Cost matters most at high volumes and low prices.
The chip is extremely cost- or area-constrained. Earlier I cited slides from the PULP group saying area-optimized cores are about 10-20 kGE while a single-precision FPU is about 20 kGE. At that scale, adding one could roughly double the core.
Power budget is very tight. More transistors means more leakage, which matters for devices that sleep most of the time on small batteries. The paper itself found the FPU had a higher relative increase in static energy than in area.
Code can avoid floating-point. Fixed-point arithmetic (scaled integers) gives fractional math on integer hardware. For many sensor and control tasks it’s fast enough and needs no emulation library.
Simpler design and verification matter. Less hardware means less to design, test, and certify, which can be important for safety-critical or quick-turnaround products.

Where the FPU is worth it (the other side)

Heavy signal processing, machine learning, graphics, or scientific computing, where floating-point dominates the runtime.
Cases where software emulation would eat too much time or energy. Espressif’s own blog says the main advantage of an FPU is speed, since software floating-point requires many integer operations per float operation.
Code that benefits from floating-point’s dynamic range and automatic handling of precision, where converting to fixed-point would take significant engineering effort.

A hidden cost of going without: software floating-point also needs library code (the PULP slides estimated roughly 5 kB for single-precision), which uses memory that a tiny chip may not have to spare. Software emulation isn’t free, it just moves the cost from silicon to code size and execution time.

A way to state it in your homework: “An FPU is justified when the time and energy saved on floating-point work outweighs the area, power, and cost it adds for all workloads. For integer-dominated devices like the ESP32-C3, software floating-point or fixed-point is the better trade. For DSP-oriented cores like RI5CY, hardware support can be worth it.”

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why a useful hardware capability such as floating point might be optional rather than mandatory in a processor architecture?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the reasoning behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the design tradeoff coming in.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** _2_

### P1 — After

After this assignment, how well could you explain why a useful hardware capability such as floating point might be optional rather than mandatory in a processor architecture?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts but not fully how they connect into a design tradeoff.
4. I am confident I could explain the tradeoff well enough to help a fellow classmate understand it.
5. I could confidently explain and defend the tradeoff in a technical discussion with someone knowledgeable about processor architecture.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** _4_

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [x] I mainly wanted to understand why a processor designer might deliberately leave useful hardware out.
- [ ] I mainly wanted to understand the design tradeoff well enough that I could explain or apply it to other processors or systems.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] The in-class demonstration / prediction
- [ ] Reading the Concept section
- [x] The AI investigation
- [ ] Challenging or verifying something the AI told me
- [ ] Looking at real processors and their design choices
- [ ] Answering the Confirm questions
- [ ] Prefer not to answer

### SCA — What should we do with this format?

- [x] Continue as is. *Tell us more (optional): any suggestions to make it even better?*
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

- **AI1.** When investigating an unfamiliar technical topic with AI, I can decide what question would be useful to ask next. **Your answer (1–6):** _4_
- **AI2.** I can recognize when an AI explanation or technical claim needs further investigation. **Your answer (1–6):** _4_
- **AI3.** I know how to check a technical claim made by AI using evidence beyond the AI's own explanation. **Your answer (1–6):** _5_
- **AI4.** I can use follow-up questions with AI to improve my own understanding of a technical topic. **Your answer (1–6):** _5_
- **AI5.** I can decide when I have enough evidence to accept, reject, or remain uncertain about a technical explanation provided by AI. **Your answer (1–6):** _4_

---

# Grading Rubric

| # | What's being evaluated | Points |
|---|---|---:|
| MC1–MC4 | Correctly identifies the core concepts behind modular ISA design and extension tradeoffs | 20 |
| N1 | States the corrected model: identifies a concrete extension cost and explains why the tradeoff differs between products | 20 |
| N2 | Provides a specific quantitative hardware-cost figure for a named processor/core with a credible source | 15 |
| N3 | Compares real processors/cores with different extension choices and explains why those choices fit their intended products | 10 |
| N4 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N5 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N6 | Selects two defensible lecture concepts and correctly explains their connection to the investigated design choice | 5 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
