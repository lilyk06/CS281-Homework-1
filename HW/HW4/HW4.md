# HW4: The Extension You Don't Get for Free

## Connect

In Lab4 you used `mul` from the RISC-V M extension and compared it with performing multiplication through repeated addition using the base integer instruction set.

So far, you've seen that RISC-V does something unusual compared with many older architectures:

**the instruction set is modular.**

Every RISC-V processor implements the base integer ISA. Beyond that, additional capabilities can be added as **extensions**.

Some examples you've encountered or may have seen include:

| Extension | What it adds |
|---|---|
| `M` | Integer multiply and divide |
| `C` | Compressed 16-bit instructions |
| `A` | Atomic memory operations |
| `F` | Single-precision floating point |
| `D` | Double-precision floating point |

This raises a natural question:

> **Why not just put everything in the base ISA?**

If a hardware implementation can make an operation dramatically faster, it seems like the obvious thing would be to make every processor include that hardware.

We're going to test that intuition.


# Confront

In class, we're going to run the same floating-point computation two ways.

The source code performs the same floating-point operations the same number of times.

One version is compiled for a RISC-V target with hardware floating-point instructions.

The other is compiled for a target without the F extension, so the floating-point operations have to be implemented in software.

Before seeing the results, make a prediction:

**If hardware floating point can replace a large amount of software work, what should happen?**

- ☐ The two versions should take about the same amount of time
- ☐ Hardware floating point should be somewhat faster
- ☐ Hardware floating point should be dramatically faster

Now watch the demonstration.

The software implementation takes substantially longer, and when we inspect the generated RISC-V code, the architectural difference is even more striking: a hardware floating-point operation can be represented by a single floating-point instruction, while the software implementation expands into many integer instructions.

Here's the assumption we're going to challenge:

> **If hardware support makes something substantially faster, every processor should obviously include that hardware.**

That seems especially reasonable for RISC-V because the architecture was designed with modular extensions in the first place.

But putting a capability into an ISA isn't free.

Someone has to build the hardware.

Someone has to verify it.

Someone has to manufacture it.

And if the extension becomes part of a mandatory base ISA, every implementation has to support it—even implementations whose customers never use it.

That's the puzzle:

> **If an extension provides enormous performance benefits for some workloads, why would a processor designer deliberately choose not to implement it?**

Don't resolve that yet.


### Instructor Demo

The instructor will run the floating-point comparison in class.

The runnable demo, source code, build instructions, and detailed explanation are available in `HW/DEMOS/HW4` if you'd like to explore them yourself, but **running the demo yourself is not required for this homework**.

The demo shows two useful results:

- The software implementation takes substantially longer in the classroom timing comparison.
- More importantly, inspecting the RISC-V code shows a much larger architectural instruction-count difference: hardware floating-point operations appear as individual floating-point instructions, while software implementations require many integer instructions.

One important caveat: the exact wall-clock timing under QEMU should not be interpreted as a measurement of a real physical RISC-V FPU versus software floating point. QEMU implements guest RISC-V floating-point instructions using its own floating-point emulation machinery.

For this homework, the important architectural observation is therefore the **difference in the RISC-V instructions required to express the computation**, not the exact wall-clock ratio reported by QEMU.


# Concept

RISC-V is **modular by design**.

The base integer ISA is mandatory. Most other capabilities are standardized as optional extensions that a processor designer can choose to implement.

That means two real RISC-V processors can legitimately implement different subsets of the architecture.

For example:

- a small embedded processor might implement `RV32IMC`,
- while a larger application processor might implement `RV64GC`.

Both are RISC-V processors.


### Why would anyone leave something out?

Because an instruction-set extension represents more than a few extra opcode definitions.

Suppose a chip designer decides to implement hardware floating point.

That decision can create several different kinds of cost.


### 1. Hardware cost

A hardware floating-point unit requires actual digital logic.

Depending on what is supported, that can include hardware for multiplication, addition, division, normalization, rounding, exception handling, and other parts of IEEE-754 floating-point behavior.

Those circuits consume **area on the chip**.

On a large processor, that may be a reasonable trade.

On a tiny microcontroller, the same hardware may represent a meaningful fraction of the total design.


### 2. Verification cost

Hardware has to work correctly—not just on ordinary numbers, but on the behaviors defined by the specification.

IEEE-754 floating point includes things such as:

- multiple rounding modes,
- NaNs,
- infinities,
- signed zero,
- subnormal values,
- exception and status behavior.

Supporting an extension therefore creates a verification burden in addition to the transistor cost.

A design team isn't just building the hardware.

It has to demonstrate that the hardware behaves correctly across the cases the architecture promises to support.


### 3. Manufacturing and product cost

A processor may ship into products that never use a particular capability.

Imagine a tiny sensor controller whose firmware performs integer arithmetic all day and never performs floating-point calculations.

For that product, an FPU may provide essentially no customer value.

But if the chip contains one anyway, its hardware still has to be designed, verified, powered, and manufactured.

At very high volume, even small per-chip costs matter.


### The modularity tradeoff

This gives us a more useful way to think about RISC-V extensions.

The question isn't:

> **Is hardware support useful?**

It obviously can be.

The question is:

> **For which products is the benefit worth the cost of guaranteeing that hardware exists?**

That's enough of the model to begin the investigation.

You know that extensions can provide large performance benefits.

Now investigate why making those extensions optional can itself be an important architectural feature.


# Construct

Use any AI assistant for this investigation.

The prompts below are **starting points**, not questions you need to copy word-for-word.

Follow the investigation where your understanding requires it. Ask follow-up questions when something is unclear, incomplete, surprising, or worth checking.

At least once, you must stop and verify or challenge something the AI tells you. You'll document that moment in Confirm.


### Step 1 — Why not put everything in the base ISA?

Start with the central question:

> **Why did RISC-V designers choose a small mandatory base ISA plus optional extensions instead of one large mandatory instruction set?**

Investigate what problem modularity solves for processor designers.

Among the questions you might explore:

- What does a small mandatory ISA allow a chip designer to avoid?
- Why might two processors serving different markets want different extensions?
- Why is "one architecture for everyone" not necessarily the same thing as "one hardware design for everyone"?

Follow the reasoning wherever it leads.


### Step 2 — What does an extension actually cost?

Choose **one specific extension**, with hardware floating point as the primary example.

Investigate the concrete costs of implementing it.

Among the things you might explore:

- die area,
- transistor count,
- verification effort,
- power,
- clocking or pipeline complexity,
- manufacturing cost,
- or another hardware consequence you can support with evidence.

Then find **at least one real quantitative figure** from a credible source.

The goal isn't to produce an exact universal number.

The goal is to replace:

> **"An FPU probably costs something."**

with:

> **"Here is evidence for what that cost can look like in a real design."**


### Step 3 — Find processors on both sides of the decision

Find two real RISC-V processors or cores:

**One that does not implement F/D**, and

**one that does.**

For each, investigate:

- What extensions does it implement?
- What kind of product is it intended for?
- What workloads is it designed to support?
- What does that suggest about why its designers made the extension choices they did?

You're looking for evidence that modularity isn't an abstract architecture exercise.

**Real processors make different choices because they serve different markets.**


### Step 4 — Catch the AI

During Steps 1–3, identify **one claim that deserves checking**.

The AI does **not** have to be wrong.

It might give you:

- a transistor or area estimate,
- the extension list for a specific processor,
- a claim about a vendor's design decision,
- a statement about IEEE-754 hardware,
- or an explanation that sounds plausible but needs evidence.

Push back.

Ask for more precision, request evidence, consult a primary source, compare multiple sources, or otherwise investigate whether the claim deserves your confidence.

What matters isn't proving the AI wrong.

What matters is recognizing:

> **"This sounds plausible, but I need evidence before I rely on it."**


### Step 5 — Why would anyone tolerate the software version?

Return to the demonstration.

You saw a large instruction-count penalty when floating-point operations were implemented in software.

So ask the harder question:

> **What kind of system could reasonably decide that the performance penalty is acceptable?**

Consider things such as:

- how frequently floating point is actually used,
- whether the workload has tight timing requirements,
- whether low cost matters more than peak performance,
- whether the chip has a tiny silicon budget,
- whether the workload is integer-dominated,
- and whether the processor can simply avoid paying for hardware the application doesn't need.

You are trying to move beyond:

> **F is faster, therefore F is better.**

toward:

> **F is faster for some workloads, but whether F belongs in a chip depends on the product's constraints.**

By the end of the investigation, you should be able to answer:

> **Why is "put more hardware in the chip" not automatically the best architecture?**


# Confirm

## Part A: Multiple Choice (5 pts each, 20 pts total)

Circle one.


**MC1.** Why does RISC-V make most extensions optional rather than putting every capability into the mandatory base ISA?

- A. The extensions were unfinished
- B. Different processors can implement only the capabilities that provide value for their target products
- C. Optional extensions execute faster than mandatory instructions
- D. RISC-V prevents different processors from using different hardware


**MC2.** Which is a real cost of adding hardware floating point to a small processor?

- A. Only the software compiler becomes more complicated
- B. Hardware area, verification effort, power, and manufacturing cost
- C. Floating-point instructions become incompatible with integer instructions
- D. There is no meaningful cost after the ISA is defined


**MC3.** Which processor is most likely to omit the F extension?

- A. A low-cost, high-volume microcontroller that performs mostly integer control work
- B. A processor designed for computation-heavy scientific workloads
- C. A high-end application processor intended to run a full OS and graphics workloads
- D. All processors are equally likely to omit F


**MC4.** What is the main architectural tradeoff behind optional extensions?

- A. Faster instructions are always better, so every extension should be mandatory
- B. A capability can provide significant benefits for some workloads while imposing costs on every implementation that supports it
- C. Optional extensions exist mainly to make assembly programming harder
- D. Hardware extensions matter only when software is poorly optimized


## Part B: Show What You Learned


### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement:

> **"If hardware support makes an operation much faster, every processor should include that hardware."**

Your answer should name at least one concrete cost of adding an extension and explain why the right choice can differ between products.


### N2 — Make the hardware cost real (15 pts)

Give the real quantitative evidence you investigated in Step 2.

- **Extension / hardware feature:**
- **Processor or core:**
- **Cost you investigated:**
- **Reported value:**
- **What the number means:**
- **Source:**


### N3 — Find the design decision in the real world (10 pts)

Compare the two real RISC-V processors or cores you investigated.

- **Processor/core without F/D:**
- **Processor/core with F/D:**
- **What each is designed for:**
- **Why the extension choice makes sense for each:**


### N4 — Catch the AI (20 pts)

Identify one claim from your AI investigation that you did not simply accept.

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

Remember: there is no requirement that the AI actually be wrong. Good technical investigation means recognizing which claims deserve checking and finding evidence before deciding whether to trust them.


### N5 — Your best follow-up (10 pts)

Look back through your AI conversation.

**What follow-up question most improved your understanding?**

Write the question:

> ________________________________________________________________

In 1–2 sentences, explain **why that question was useful or how it changed or refined your understanding.**


### N6 — Connect back (5 pts)

Check the **two** lecture concepts that most directly explain the design decision you investigated.

Write one sentence for each explaining the connection.

- ☐ ISA extensions and modular instruction-set design
- ☐ Hardware versus software implementation of an operation
- ☐ Die area / transistor budget
- ☐ IEEE-754 floating-point representation
- ☐ Hardware verification as an engineering constraint


## Appendix — AI Conversation

Paste your full AI chat export.

No cleanup is required. The transcript is not graded for writing quality. It is included as evidence of the investigation you performed.


---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment.

There are no right or wrong answers. All items below are graded on **completion only**, never on the response selected. Selecting **Prefer not to answer** counts as complete.


### B1 — Before

Before this assignment, how well could you explain why a useful hardware capability such as floating point might be optional rather than mandatory in a processor architecture?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the reasoning behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the design tradeoff coming in.

- ☐ Prefer not to answer


### P1 — After

After this assignment, how well could you explain why a useful hardware capability such as floating point might be optional rather than mandatory in a processor architecture?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts but not fully how they connect into a design tradeoff.
4. I am confident I could explain the tradeoff well enough to help a fellow classmate understand it.
5. I could confidently explain and defend the tradeoff in a technical discussion with someone knowledgeable about processor architecture.

- ☐ Prefer not to answer


### INV — What drove your investigation?

Thinking about your AI investigation on this assignment, which statement best describes what **primarily drove your approach**?

Pick the one that fits best.

- ☐ I mainly wanted to complete the required assignment efficiently.
- ☐ I mainly wanted to understand enough to answer the assignment questions correctly.
- ☐ I mainly wanted to understand why a processor designer might deliberately leave useful hardware out.
- ☐ I mainly wanted to understand the design tradeoff well enough that I could explain or apply it to other processors or systems.
- ☐ Something else. *(Optional: tell us what.)*
- ☐ Prefer not to answer


### FAV — What helped most?

Which part of this homework helped you **understand the topic the most**?

Pick one.

- ☐ The in-class demonstration / prediction
- ☐ Reading the Concept section
- ☐ The AI investigation
- ☐ Challenging or verifying something the AI told me
- ☐ Looking at real processors and their design choices
- ☐ Answering the Confirm questions
- ☐ Prefer not to answer


### SCA — What should we do with this format?

Thinking about the topic and the process overall, what should we do with this homework format going forward?

- ☐ **Continue as is.** *Tell us more (optional): any suggestions to make it even better?*
- ☐ **Adjust something.** *Tell us more (optional): what would you change?*
- ☐ **Stop, and go back to a traditional homework model.** *Tell us more (optional): what didn't work for you?*
- ☐ Prefer not to answer


## AI Investigation Skills

For each statement below, indicate how much you agree or disagree **based on what you can do right now**, not what you think you are expected to be able to do.

| | Strongly disagree | Disagree | Neither agree nor disagree | Agree | Strongly agree | Prefer not to answer |
|---|---|---|---|---|---|---|
| **AI1.** When investigating an unfamiliar technical topic with AI, I can decide what question would be useful to ask next. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| **AI2.** I can recognize when an AI explanation or technical claim needs further investigation. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| **AI3.** I know how to check a technical claim made by AI using evidence beyond the AI's own explanation. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| **AI4.** I can use follow-up questions with AI to improve my own understanding of a technical topic. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| **AI5.** I can decide when I have enough evidence to accept, reject, or remain uncertain about a technical explanation provided by AI. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |


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
| Feedback | Completes the required feedback items; “Prefer not to answer” counts as complete | 5 |

**Total: 100 points.**