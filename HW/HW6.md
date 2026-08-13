I will start `HW6.md` now.

Because of the length, I will provide only the file content. No additional commentary.

---

# HW6: Your Program Is Sequential. Your Processor Is Not.

## Connect

For the first half of this course, we have mostly looked at processors from the perspective of software.

You wrote programs.

You followed instructions.

You analyzed memory behavior.

You investigated caches, interrupts, and ISA extensions.

Even when the hardware underneath became more complicated, the programming model remained comfortable.

For example:

```asm
add t0, t1, t2
add t3, t4, t5
mul t6, t7, t8
```

As a programmer, you naturally think about execution like this:

```text
Instruction 1
Instruction 2
Instruction 3
```

One instruction happens.

Then the next.

Then the next.

That sequential model is one of the most useful abstractions in computer science.

However, it hides an important detail:

> **The processor underneath your program does not necessarily execute instructions one at a time.**

Modern processors contain multiple execution resources that can perform different kinds of work at the same time.

This creates an important architectural question:

> If a program is written sequentially, how can a processor execute parts of it in parallel?


# Confront

Consider the following RISC-V instructions:

```asm
add t0, t1, t2

add t3, t4, t5

mul t6, t7, t8
```

From a programmer's perspective, these instructions execute in order:

```text
add
add
mul
```

Before watching the demonstration, make a prediction:

**How should these instructions execute?**

- ☐ The processor must complete one instruction before starting the next.
- ☐ The processor can overlap execution if the instructions do not depend on each other.
- ☐ The processor can only execute one instruction at a time because the program is sequential.
- ☐ I am not sure yet.


## Instructor Demo

The instructor will demonstrate a simplified processor scheduler.

The processor contains three execution resources:

```text
                 Scheduler

              /      |      \

            INT0    INT1    MUL0
```

where:

- `INT0` is an integer execution engine.
- `INT1` is an integer execution engine.
- `MUL0` is a multiply execution engine.

The goal of the demonstration is not to model a complete CPU.

Instead, it demonstrates two important processor concepts:

1. Independent instructions can execute at the same time.
2. Data dependencies can prevent instructions from executing even when hardware is available.


---

## Scenario 0: Independent Instructions

The processor receives:

```asm
add t0, t1, t2

add t3, t4, t5

mul t6, t7, t8
```

These instructions are independent.

The first instruction produces `t0`.

The second instruction produces `t3`.

The third instruction uses `t7` and `t8`.

None of the instructions requires the result produced by another instruction.

The scheduler can assign:

```text
add t0, t1, t2  ---> INT0

add t3, t4, t5  ---> INT1

mul t6, t7, t8  ---> MUL0
```

The program is still sequential.

However, the execution overlaps.

The processor is not making any individual operation faster.

Instead, it increases throughput by allowing multiple execution resources to work at the same time.


---

## Scenario 1: Data Dependency

Now consider:

```asm
add t0, t1, t2

add t3, t4, t5

mul t6, t3, t8
```

This looks almost identical.

However, there is an important difference:

```text
add t3, t4, t5

        |
        v

mul t6, t3, t8
```

The multiply instruction requires the value produced by:

```asm
add t3, t4, t5
```

The processor has a multiply unit.

The multiply unit is available.

But the instruction cannot begin until the required input exists.

The scheduler can still execute:

```text
add t0, t1, t2  ---> INT0

add t3, t4, t5  ---> INT1

mul t6, t3, t8  ---> WAIT
```

After `t3` is available:

```text
mul t6, t3, t8  ---> MUL0
```

The important observation:

> Available hardware does not guarantee available parallelism.


The annotated execution analysis is available here:

[View HW6 execution analysis](hw6_execution_analysis.png)


# Concept

## Execution Resources

A simple processor design might use one shared execution unit:

```text
Instruction

     |

     v

    ALU

     |

     v

 Result
```

Every instruction uses the same hardware.

This design is simple, but only one operation can use the hardware at a time.


Modern processors contain multiple execution resources:

```text
              Scheduler

           /      |      \

        INT0     INT1    MUL0
```

Different execution resources can specialize in different operations.

Examples include:

- integer execution units
- multiply/divide units
- floating-point units
- vector units
- load/store units


## Latency and Throughput

A key processor design concept is the difference between latency and throughput.


### Latency

Latency describes how long one operation takes to complete.

Example:

```text
multiply latency = 5 cycles
```

Adding more multiply hardware does not necessarily make one multiplication complete faster.

The latency of the individual operation may remain the same.


### Throughput

Throughput describes how much work can be completed over time.

Consider:

```text
ADD
ADD
MUL
```

With one shared execution resource:

```text
ADD
ADD
MUL
```

Each operation must wait.

With multiple resources:

```text
INT0 -> ADD

INT1 -> ADD

MUL0 -> MUL
```

The processor can complete more work in the same amount of time.

The important idea:

> Processors often improve performance by increasing throughput rather than reducing the latency of every operation.


## Data Dependencies

Scenario 1 introduced a data dependency.

Consider:

```asm
add t3, t4, t5

mul t6, t3, t8
```

The multiply depends on the add.

The processor must preserve correctness.

It cannot execute:

```asm
mul t6, t3, t8
```

until:

```asm
add t3, t4, t5
```

has completed.


This creates an important architectural lesson:

> A processor may have available hardware but still be unable to execute an instruction because the required data is not ready.


## Why Not Add Unlimited Execution Units?

If more hardware can improve throughput, why not add:

- 20 integer units?
- 20 multiply units?
- 20 vector units?

Because hardware has costs:

- chip area
- power consumption
- design complexity
- verification effort


Additionally, programs do not always contain enough independent work to use all available hardware.

Processor designers must balance:

```text
More execution hardware

          versus

Hardware cost + workload benefit
```

This is similar to the tradeoff explored in HW4.

The question is not:

> Can we build more hardware?

The question is:

> Will the workload benefit enough to justify the cost?


---


# Construct

Use an AI assistant for this investigation.

The prompts below are starting points, not questions you must copy exactly.

Your goal is not to ask AI for a summary.

Your goal is to investigate how real processors create and manage parallel execution opportunities.


## Step 1 — How does a processor find parallel work?

The demonstration used a simplified scheduler.

Investigate:

> How does a real processor determine which instructions can execute at the same time?

Explore concepts such as:

- instruction scheduling
- issue width
- superscalar execution
- execution ports
- reservation stations

Focus on answering:

> How does a processor identify opportunities for multiple instructions to execute simultaneously?


---

## Step 2 — Why do processors have specialized execution resources?

Find a real processor or processor family.

Investigate the execution resources it contains.

Look for examples such as:

- multiple integer execution units
- multiply/divide units
- floating-point units
- vector units
- load/store units
- branch execution hardware


Answer:

> Why does this processor provide these resources instead of using one universal execution unit?


Things you might investigate:

- Which operations are common?
- Which operations require more hardware?
- Which operations benefit from specialization?
- Why might a processor include multiple copies of some resources but only one copy of others?


---

## Step 3 — How do real processors handle dependencies?

The demonstration showed:

```asm
add t3, t4, t5

mul t6, t3, t8
```

The multiply instruction cannot execute until the value in `t3` exists.

Investigate how real processors handle situations where one instruction depends on another.

Explore concepts such as:

- RAW dependencies
- data hazards
- stalls
- forwarding
- register renaming
- out-of-order execution


Your goal is not to memorize these terms.

Your goal is to understand:

> Why does executing instructions in parallel make processor design more complicated?


---

## Step 4 — Why are more execution resources not always better?

The demonstration used:

```text
INT0
INT1
MUL0
```

Investigate why real processors do not simply include unlimited execution hardware.

Consider:

- hardware area
- power consumption
- instruction frequency
- workload behavior
- resource utilization
- design complexity


Answer:

> Why might a processor choose to have multiple integer execution units but fewer multiply, floating-point, or vector execution units?


---

## Step 5 — Catch the AI

During your investigation, identify one claim from the AI that deserved verification.

The AI does not have to be wrong.

Examples:

- number of execution units in a processor
- architectural details of a real CPU
- performance claims
- explanation of a scheduling technique


Document:

**What the AI claimed:**

________________________________________________


**Why you questioned it or wanted more precision:**

________________________________________________


**How you checked it:**

________________________________________________


**What you concluded:**

________________________________________________


---

# Confirm

## Part A: Multiple Choice (5 pts each, 20 pts total)

Circle one.


### MC1

Why can the three instructions in Scenario 0 execute with overlapping execution?

A. The processor ignores instruction ordering.

B. The instructions are independent and can use different execution resources.

C. The compiler changes the instruction order automatically.

D. The processor executes every instruction twice.

---

### MC2

Why does the multiply instruction wait in Scenario 1?

A. The multiply unit is already being used by another instruction.

B. The processor does not support multiplication.

C. The multiply instruction requires a value produced by the previous add instruction.

D. Multiplication instructions always execute after additions.

---

### MC3

What is the difference between latency and throughput?

A. Latency measures chip cost, while throughput measures software complexity.

B. Latency describes how long one operation takes, while throughput describes how much work completes over time.

C. Latency and throughput describe the same measurement.

D. Latency only applies to memory operations.

---

### MC4

Why don't processors simply add unlimited execution units?

A. Additional execution hardware has costs and programs may not contain enough parallel work to use it.

B. Multiple execution units cannot operate at the same time.

C. Software cannot benefit from faster hardware.

D. Additional hardware always reduces performance.


---

# Part B: Show What You Learned


## N1 — Correct the Sequential Execution Model (20 pts)

Correct this statement:

> "Because a program is written sequentially, the processor must execute each instruction completely before beginning the next instruction."

Your answer should reference:

- multiple execution resources,
- instruction independence,
- and data dependencies.


---

## N2 — Explain the Scenario 1 Dependency (15 pts)

Using the Scenario 1 instructions:

```asm
add t0, t1, t2

add t3, t4, t5

mul t6, t3, t8
```

Explain why the multiply instruction must wait.

Your answer should identify:

- which instruction produces the required value,
- which instruction consumes that value,
- why the processor cannot safely execute the multiply early.


---

## N3 — Investigate a Real Processor (15 pts)

Choose a real processor or processor family.

Investigate its execution resources.

Provide:

**Processor / processor family:**

________________________________________________


**Execution resources identified:**

________________________________________________


**Specialized hardware you found:**

________________________________________________


**Why those resources exist:**

________________________________________________


**Source:**

________________________________________________


---

## N4 — Catch the AI (20 pts)

Identify one claim from your AI investigation that you did not simply accept.

The AI does not need to be wrong.

Good examples include:

- a claim about execution resources,
- a processor architecture detail,
- a scheduling explanation,
- a performance claim.


Document:

**What the AI claimed:**

________________________________________________


**Why you questioned it:**

________________________________________________


**How you verified it:**

________________________________________________


**What you concluded:**

________________________________________________


---

## N5 — Your Best Follow-Up Question (10 pts)

Review your AI conversation.

What follow-up question most improved your understanding?

Question:

________________________________________________


Why was this question useful?

________________________________________________


---

## N6 — Connect Back to the Demo (5 pts)

Select the two concepts that best explain what you observed.

- ☐ Multiple execution resources
- ☐ Instruction independence
- ☐ Data dependencies
- ☐ Latency versus throughput
- ☐ Specialized hardware
- ☐ Scheduling decisions


Explain each selected concept:

1.

________________________________________________


2.

________________________________________________


---

# Appendix — AI Conversation

Paste your complete AI conversation export.

The transcript is included as evidence of your investigation process.

The transcript is not graded for writing quality.

The goal is to document:

- what questions you asked,
- how your investigation developed,
- how your understanding changed.


---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment.

There are no right or wrong answers. All items below are graded on **completion only**, never on the response selected. Selecting **Prefer not to answer** counts as complete.


### B1 — Before

Before this assignment, how well could you explain why a processor can execute multiple instructions at the same time even though programs are written sequentially?

1. I could not explain this topic at all; it was new to me.
2. I knew some related terms but could not explain the idea.
3. I could explain some pieces but not how they connect.
4. I could explain the general concept and why execution resources matter.
5. I could confidently explain why processors use parallel execution resources.

- ☐ Prefer not to answer


### P1 — After

After completing this assignment, how well could you explain why a processor can execute multiple instructions at the same time even though programs are written sequentially?

1. I still do not feel comfortable explaining this concept.
2. I understand some of the ideas but need more practice.
3. I understand execution resources and dependencies separately but not how they interact.
4. I can explain the concept well enough to help another student understand it.
5. I can confidently explain how instruction-level parallelism affects processor design.

- ☐ Prefer not to answer


### INV — What drove your investigation?

Thinking about your AI investigation on this assignment, which statement best describes what **primarily drove your approach**?

Pick the one that fits best.

- ☐ I mainly wanted to complete the required assignment efficiently.
- ☐ I mainly wanted to understand enough to answer the required questions.
- ☐ I mainly wanted to understand why sequential RISC-V instructions could overlap in hardware while a data dependency could prevent that overlap.
- ☐ I mainly wanted to understand processor scheduling and parallel execution well enough that I could explain or apply the ideas beyond this assignment.
- ☐ Something else. *(Optional: tell us what.)*
- ☐ Prefer not to answer


### DEMO — Did the demonstration create a useful question?

After seeing the instruction-scheduling demonstration, how strongly did you want to understand **why independent instructions could overlap execution while the dependent multiply instruction had to wait even though the multiply hardware was available?**

1. Not at all — the result did not make me curious about the reason.
2. Slightly — I noticed the behavior but was not particularly motivated to investigate it.
3. Moderately — I wanted to understand the basic explanation.
4. Strongly — the result made me want to understand how processors find and manage parallel execution opportunities.
5. Very strongly — the result made me want to investigate beyond what the assignment required.

- ☐ Prefer not to answer


### FAV — What helped most?

Which part of this homework helped you **understand the topic the most**?

Pick one.

- ☐ The in-class demonstration
- ☐ The waveform analysis
- ☐ Connecting the demo to RISC-V instructions
- ☐ Reading the Concept section
- ☐ The AI investigation
- ☐ Investigating a real processor
- ☐ Challenging or verifying something the AI told me
- ☐ Answering the Confirm questions
- ☐ Prefer not to answer


### SCA — What should we do with this format?

Thinking about the topic and the process overall, what should we do with this homework format going forward?

- ☐ **Continue as is.** *Tell us more (optional): any suggestions to make it even better?*
- ☐ **Adjust something.** *Tell us more (optional): what would you change?*
- ☐ **Stop, and go back to a traditional homework model.** *Tell us more (optional): what didn't work for you?*
- ☐ Prefer not to answer


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
| AI Conversation | Included and documents the investigation process | Required |

**Assignment Total: 100 points**

**Feedback: +5 free points**