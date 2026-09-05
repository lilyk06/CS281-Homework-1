# HW1: Same Program, Different Instructions

## Connect

In lecture and Lab1 you've been introduced to the basic shape of RISC-V:

- instructions use simple, regular formats,
- arithmetic operates on registers,
- memory is accessed through explicit load and store instructions,
- and the base instructions we've been working with are 32 bits wide.

Those choices probably seem reasonable for a modern processor.

But RISC-V is not the only successful way to design an instruction set.

In class, we're going to compile the **same C code** for two different architectures: RISC-V and x86-64. Both processors have to accomplish exactly the same programming task.

Watch what the compiler produces.


## Confront

Consider an expression that adds several values from an array.

On x86-64, the processor can perform an arithmetic operation using a value directly from memory. The compiler can therefore generate instructions that effectively say:

> Add the value stored at this memory address to this register.

RISC-V can't express that operation in one instruction.

Its load/store design requires the value to be loaded into a register first and then added with a separate instruction.

In the demonstration, we'll compile the same six-term array sum for both architectures.

Before seeing the complete output, make a prediction:

**Which architecture do you expect will require more assembly instructions to express the same computation?**

**My prediction:** ________________________________________________

Now look at the generated code.

For the optimized six-term sum in our demo:

**x86-64: 7 instructions**

**RISC-V: 14 instructions**

Same source code.

Same calculation.

Roughly twice as many architectural instructions.

Here's the assumption we're going to challenge:

> **A simpler instruction set must be better because simpler instructions make a simpler processor.**

If simplicity is such an advantage, why did one of the most successful processor architectures ever built deliberately provide instructions capable of doing more work at once?

And there's another side to the puzzle.

If you were writing assembly by hand, being able to express the same work with fewer instructions seems pretty attractive.

But most programmers today don't write application software directly in assembly.

So perhaps the real question isn't:

> **Which instruction set is better?**

It is:

> **What was each instruction set optimizing for, what does that choice cost, and what changed over time?**

Don't resolve that yet. That's what the rest of this homework is for.


### Instructor Demo

The instructor will run the RISC-V/x86-64 comparison in class.

The demo source, scripts, and saved output are available in `HW/DEMOS/HW1` if you'd like to experiment with them yourself, but **running the demo yourself is not required for this homework**.

The demo contains two useful comparisons:

- an unoptimized (`-O0`) version that makes RISC-V's explicit load/store and address-materialization requirements especially visible, and
- an optimized (`-O1`) version that demonstrates x86-64's ability to fold a memory operand directly into an arithmetic instruction.

The optimized six-term array sum is the main comparison for this homework.


## Concept

The difference you just saw comes from two very different instruction-set design philosophies.


### RISC-V: simple operations composed by software

Consider a RISC-V instruction such as:

```text
add x5, x6, x7
```

The instruction performs a simple operation between registers.

If a value is in memory, RISC-V generally requires software to load that value into a register before an arithmetic instruction can use it.

Conceptually:

```text
load value from memory
add value to register
```

Those are separate architectural instructions.


### x86-64: more expressive architectural instructions

x86-64 allows some arithmetic instructions to include a memory operand directly.

For example, an x86-64 `add` can describe operations ranging from a simple register-to-register addition to an addition involving a memory address.

Real x86-64 encodings therefore vary in length:

| Assembly | Bytes (hex) | Length |
|---|---|---:|
| `add eax, ebx` | `01 D8` | 2 bytes |
| `add DWORD PTR [rax+0x10], ebx` | `01 5C 24 10` | 4 bytes |
| `add DWORD PTR [rax+rcx*4+0x1000], ebx` | `01 9C 88 00 10 00 00` | 7 bytes |

The shortest example is actually smaller than a 32-bit RISC-V instruction.

The more complicated examples can also express work that would require multiple architectural instructions in a strict load/store ISA.


### But modern x86-64 processors don't execute that complexity directly

Modern x86-64 processors contain decode hardware that translates architectural x86 instructions into simpler internal operations commonly called **micro-operations (µops)**.

A simple register operation may translate into a small number of µops, while an instruction involving memory may require additional internal work associated with accessing memory and performing the arithmetic.

That gives us the central tradeoff.

One architecture exposes relatively simple operations directly through its ISA.

The other exposes a richer architectural interface and relies on substantial hardware machinery to make that interface execute efficiently.

That's enough of the model to begin investigating.

You already know **what** differs.

Now you need to figure out:

- why the richer design made sense historically,
- what changed when compilers became responsible for generating most machine code,
- what modern hardware has to do to support a complex architectural interface,
- and whether either design can really be called simply "better."


# Construct

Use any AI assistant for this investigation.

The prompts below are **starting points**, not questions you need to copy word-for-word.

Follow the investigation where your understanding requires it. Ask follow-up questions when something is unclear, incomplete, surprising, or worth checking.

At least once, you must stop and verify or challenge something the AI tells you. You'll document that moment in Confirm.


### Step 1 — Who was the complex instruction set helping?

Start by putting yourself in the position of a programmer working before modern optimizing compilers became the normal way software was produced.

Investigate why a programmer writing assembly directly might value:

- instructions capable of expressing more work,
- memory operands inside arithmetic instructions,
- compact instruction encodings,
- and fewer instructions needed to express a task.

What did those features buy the **human programmer**?

Don't stop at "CISC uses fewer instructions."

Try to understand why that mattered given the way software was actually written at the time.


### Step 2 — What changed?

Today, most programmers don't decide which individual machine instructions implement every line of their programs.

The compiler does.

Investigate how improving compiler technology changed the tradeoff between rich architectural instructions and simpler instruction sets.

Among the questions you might explore:

- What work can an optimizing compiler do that assembly programmers once had to do themselves?
- Why are simple, regular instructions attractive compiler targets?
- What kinds of scheduling, register allocation, instruction selection, or optimization can compilers perform automatically?
- Does the fact that a program uses more architectural instructions necessarily mean it will run more slowly?

Follow up wherever your existing model starts to become incomplete.


### Step 3 — Where did the complexity go?

The x86-64 instructions from the demonstration look more expressive from the outside.

But modern x86 processors still need to execute them efficiently internally.

Investigate what happens between fetching an x86-64 instruction and executing the work it describes.

In particular:

- What is a µop?
- Why do modern x86 processors translate architectural instructions into µops?
- How might a register-only `add` differ internally from an `add` that also needs a memory operand?
- What hardware is involved in decoding a variable-length x86 instruction stream?
- Why can instruction boundaries themselves be more difficult to find in x86-64 than in a fixed-width ISA?

Don't worry about memorizing the exact internal design of a particular Intel or AMD processor.

The goal is to understand **where the complexity went**.


### Step 4 — Catch the AI

During Steps 1–3, identify **one claim that deserves checking**.

The AI does **not** have to be wrong.

It might give you:

- a specific µop count,
- a historical claim,
- a statement about compiler performance,
- a claim about instruction decoding,
- or an explanation that simply sounds more certain or universal than you think it should.

Push back.

Ask for more precision, request evidence, compare the claim against technical documentation, find another credible source, or otherwise investigate whether the claim deserves your confidence.

What matters is not proving the AI wrong.

What matters is recognizing:

> **"I shouldn't accept this technical claim just because the AI said it."**


### Step 5 — So which architecture actually made the better choice?

At this point it's tempting to replace one oversimplified model with another:

> **x86 is complicated, so RISC-V must be better.**

Don't stop there.

Investigate the tradeoff from both sides.

Consider things such as:

- code density,
- decode complexity,
- compatibility with decades of existing software,
- implementation complexity,
- compiler responsibility,
- power and silicon costs,
- and the enormous economic value of an established software ecosystem.

Find **one real modern example** that helps make the tradeoff concrete. This could be a processor, product, or workload where architectural compatibility, efficiency, code density, power, or implementation simplicity meaningfully influenced the design.

By the end of your investigation, you should be able to answer:

> **What does each architectural approach buy, what does it cost, and who or what was it optimized for?**


# Confirm

## Part A: Multiple Choice (5 pts each, 20 pts total)

Circle one.


**MC1.** Why could a richer instruction set be attractive to a programmer writing assembly directly?

- A. It can express some operations with fewer architectural instructions and less hand-written code
- B. It guarantees every program will execute faster
- C. It eliminates the need for registers
- D. It guarantees lower processor power


**MC2.** What is a micro-operation (µop)?

- A. A simplified internal operation used by modern processors when executing decoded architectural instructions
- B. A separate 16-bit RISC-V instruction
- C. A compiler optimization pass
- D. A type of cache miss


**MC3.** What changed that reduced the importance of designing an ISA primarily for humans writing assembly directly?

- A. Instruction count stopped mattering completely
- B. Optimizing compilers became capable of automatically performing much of the instruction selection, register allocation, scheduling, and optimization work
- C. Modern processors stopped executing machine code
- D. RISC architectures added x86-compatible instructions


**MC4.** What is one consequence of supporting a variable-length, highly expressive architectural instruction set such as x86-64?

- A. The processor may require substantial front-end hardware to identify, decode, and translate instructions into operations the execution machinery can handle efficiently
- B. Every instruction must take exactly the same number of cycles
- C. Memory operands require no internal memory access
- D. Compilers are no longer useful


## Part B: Show What You Learned


### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement:

> **"RISC is just better because simpler instructions make a simpler processor."**

Your answer should explain **what the richer and simpler approaches buy**, and how the shift from humans writing assembly toward compiler-generated machine code changed the tradeoff.


### N2 — Make the tradeoff real (15 pts)

Give the modern example you investigated in Step 5.

- **Processor, product, or workload:**
- **Architecture involved:**
- **Design consideration you investigated:**
- **What the architecture buys in this example:**
- **What it costs or trades away:**
- **Source:**


### N3 — Catch the AI (20 pts)

Identify one claim from your AI investigation that you did not simply accept.

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

Remember: there is no requirement that the AI actually be wrong. Good technical investigation means recognizing which claims deserve checking and finding evidence before deciding whether to trust them.


### N4 — Your best follow-up (10 pts)

Look back through your AI conversation.

**What follow-up question most improved your understanding?**

Write the question:

> ________________________________________________________________

In 1–2 sentences, explain **why that question was useful or how it changed/refined your understanding.**


### N5 — Connect back (10 pts)

Check the **two** RISC-V design choices from lecture that most directly connect to the architectural tradeoff you investigated.

Write one sentence for each explaining the connection.

- ☐ Fixed 32-bit base instruction width
- ☐ Load/store model
- ☐ Register-only ALU operations
- ☐ 32 general-purpose registers
- ☐ Regular/separated instruction formats such as R-type and I-type


## Appendix — AI Conversation

Paste your full AI chat export.

No cleanup is required. The transcript is not graded for writing quality. It is included as evidence of the investigation you performed.


---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment.

There are no right or wrong answers. All items below are graded on **completion only**, never on the response selected. Selecting **Prefer not to answer** counts as complete.


### B1 — Before

Before this assignment, how well could you explain why x86-64 and RISC-V make such different choices about instruction complexity?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge of this topic and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the architectural tradeoff to someone else.

- ☐ Prefer not to answer


### P1 — After

After this assignment, how well could you explain why x86-64 and RISC-V make such different choices about instruction complexity?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts but not fully how they connect into an architectural tradeoff.
4. I am confident I could explain the tradeoff well enough to help a fellow classmate understand it.
5. I could confidently explain and defend the tradeoff in a technical discussion with someone knowledgeable about processor architecture.

- ☐ Prefer not to answer


### INV — What drove your investigation?

Thinking about your AI investigation on this assignment, which statement best describes what **primarily drove your approach**?

Pick the one that fits best.

- ☐ I mainly wanted to complete the required assignment efficiently.
- ☐ I mainly wanted to understand enough to answer the assignment questions correctly.
- ☐ I mainly wanted to resolve something from the demonstration or assignment that didn't make sense to me.
- ☐ I mainly wanted to understand the architectural tradeoff well enough that I could explain or apply it beyond this assignment.
- ☐ Something else. *(Optional: tell us what.)*
- ☐ Prefer not to answer


### FAV — What helped most?

Which part of this homework helped you **understand the topic the most**?

Pick one.

- ☐ The in-class demonstration / hook
- ☐ Reading the Concept section
- ☐ The AI investigation
- ☐ Challenging or verifying something the AI told me
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
| MC1–MC4 | Correctly identifies the four core concepts covered in this homework | 20 |
| N1 | States the corrected model: explains what richer and simpler ISA approaches buy and how compiler-generated code changed the tradeoff | 20 |
| N2 | Provides a specific modern example, identifies the architectural consideration, and explains both what it buys and what it trades away with a credible source | 15 |
| N3 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N4 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N5 | Selects two defensible RISC-V design choices and correctly explains their connection to the investigated tradeoff | 10 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; “Prefer not to answer” counts as complete | 5 |

**Total: 100 points.**