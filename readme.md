# Computer Architecture Homework --- Learning Through Investigation

## Welcome

The homework in this course may feel different from homework you have
completed in other CS courses.

That is intentional.

Most traditional homework follows a familiar pattern:

``` text
Learn a concept
      ↓
Practice the concept
      ↓
Answer questions about it
```

Our homework will often begin somewhere else:

``` text
Something surprising happens
      ↓
Your current model does not fully explain it
      ↓
You investigate why
      ↓
You build a better model
```

Throughout the course, we will use this process to explore computer
architecture from the perspective of a computer scientist:

> **What is actually happening in hardware underneath the software I
> write?**

RISC-V gives us a concrete processor architecture to work with, but the
larger goal is to develop the ability to reason about how software and
hardware interact.

------------------------------------------------------------------------

# Repository Organization

The repository separates the student-facing homework materials from the
runnable demonstrations used to create the questions we investigate.

``` text
SYSARCH-HW/
├── HW/
│   ├── HW1.md
│   ├── HW1_demo.md
│   ├── HW2.md
│   ├── HW2_demo.md
│   ├── ...
│   ├── HW7.md
│   └── HW7_demo.md
│
├── HW-DEMOS/
│   ├── HW1/
│   ├── HW2/
│   ├── HW3/
│   ├── HW4/
│   ├── HW5/
│   ├── HW6/
│   └── HW7/
│
├── research/
│   ├── original-dgl-preprint.pdf
│   └── readme.md
│
└── readme.md
```

## `HW/` --- Assignments and Demo Guides

This is the primary student-facing directory.

For each homework:

-   `HW#.md` is the **actual homework assignment**.
-   `HW#_demo.md` describes the **instructor demonstration** used to
    create the Confront moment and the question that begins the
    investigation.

For example:

``` text
HW/HW2.md
HW/HW2_demo.md
```

The first file is the assignment.

The second explains the demonstration that motivates it.

## `HW-DEMOS/` --- Runnable Demonstrations

The `HW-DEMOS` directory contains the complete implementations behind
the instructor demonstrations.

Depending on the homework, these directories may contain:

-   RISC-V assembly,
-   C,
-   Python,
-   Verilog,
-   Makefiles and build scripts,
-   simulator configuration,
-   waveform-viewer configuration,
-   sample output,
-   diagrams,
-   and other supporting artifacts.

These files are included for transparency, reproducibility, and optional
exploration.

You are generally **not required to build or run the demonstrations
yourself** unless an assignment specifically says otherwise.

> **The demo creates the question. The investigation is the homework.**

## `research/` — Background on the Homework Model

The `research/` directory is **not part of the assigned course material**.

It contains supporting research materials documenting how this homework model developed.

If you're interested in the educational research behind these assignments, you can explore:

- `original-dgl-preprint.pdf` — the original research paper introducing **Deliberate Gap Learning (DGL)** and reporting results from its initial classroom deployment.
- `readme.md` — an overview of the original DGL model, what we learned from that deployment, how the model has been revised for this course, and what we hope to study in a future research evaluation.

These materials are included for transparency and for students, instructors, or researchers who are curious about **how we got here and why the homework is designed this way**.

You do not need to read anything in `research/` to complete the course assignments.

------------------------------------------------------------------------

# The 5C Homework Model

Each homework follows the same general structure:

``` text
Connect
   ↓
Confront
   ↓
Concept
   ↓
Construct
   ↓
Confirm
```

These are the **5 Cs**.

## 1. Connect

Every homework begins with something you already know.

That might come from:

-   lecture,
-   a lab,
-   a previous homework,
-   programming experience,
-   or a mental model that has worked well for you in software.

The goal is to start from familiar ground and connect the new
investigation to something you already understand.

## 2. Confront

Next, we challenge that model.

Usually this involves a short instructor demonstration.

You may see:

-   two programs doing the same work at very different speeds,
-   two correct approaches producing the same result with very different
    amounts of CPU activity,
-   a circuit producing the wrong value when sampled at the wrong time,
-   instructions overlapping even though the program is sequential,
-   or two processor architectures behaving very differently on the same
    computation.

Before seeing the result, you will often be asked to make a prediction.

There is no penalty for predicting incorrectly.

In fact, an unexpected result is useful.

The purpose of the demonstration is to create a question:

> **Why did that happen?**

That question is the starting point for the homework.

## 3. Concept

After the demonstration, the homework provides enough background to give
you a useful starting model.

This section is intentionally **not a complete lecture on the topic**.

It gives you enough vocabulary and structure to begin asking better
questions.

The remaining gaps are intentional.

## 4. Construct

This is the investigation.

You will use an AI assistant to explore the questions created by the
demonstration.

The homework provides starting prompts and directions, but you are not
expected to simply copy those prompts and accept the first answers you
receive.

You should:

-   ask follow-up questions,
-   ask for simpler explanations when something is unclear,
-   push deeper when an answer feels incomplete,
-   connect new ideas back to lecture and lab,
-   investigate real processors and systems,
-   and verify technical claims when evidence matters.

The goal is to **construct your own understanding through
investigation**.

## 5. Confirm

Finally, you demonstrate what you learned.

Each homework contains a short set of multiple-choice questions followed
by questions that ask you to:

-   correct an incomplete mental model,
-   explain the architectural tradeoff you investigated,
-   apply the idea to a real system,
-   connect the investigation back to course concepts,
-   identify a useful AI follow-up question,
-   and document something you verified rather than simply accepted.

These questions are where you show that your model changed.

------------------------------------------------------------------------

# Why Are We Using AI?

AI tools are becoming part of professional technical work.

Knowing how to ask an AI for an answer is easy.

Knowing how to **investigate with AI** is harder.

There is an important difference between:

``` text
"What is a cache?"
```

and:

``` text
"Why did changing only the order of these memory accesses
make one version of my program several times slower?"
```

The second question begins an investigation.

Throughout the course, you will practice using AI to:

-   explore unfamiliar technical ideas,
-   decide what question to ask next,
-   refine incomplete explanations,
-   recognize when a claim deserves verification,
-   find and evaluate evidence,
-   and decide when you have enough information to trust a conclusion.

The goal is not:

> **Get the answer from AI.**

The goal is:

> **Use AI as a tool for developing your own technical understanding.**

------------------------------------------------------------------------

# Catch the AI

Every homework includes an activity called **Catch the AI**.

Despite the name, your AI assistant does **not** need to be wrong.

Instead, identify one claim where your reaction is:

> **That sounds plausible, but how do I know?**

It might be:

-   a performance number,
-   a processor specification,
-   an architectural claim,
-   a hardware capability,
-   an explanation that sounds too universal,
-   or anything else that deserves evidence.

Then investigate it.

You might:

-   ask the AI for more precision,
-   consult processor documentation,
-   find a manufacturer datasheet,
-   compare multiple sources,
-   inspect generated assembly,
-   or use another credible technical reference.

Technical judgment includes knowing **when not to simply accept an
answer**.

------------------------------------------------------------------------

# What to Expect on Each Homework

The assignments use the same 5C structure, but each explores a different
gap between the software model you already know and the hardware
underneath it.

  -----------------------------------------------------------------------
  HW                      Theme                   The gap we will
                                                  investigate
  ----------------------- ----------------------- -----------------------
  **HW1 --- Same Program, Instruction-set design  If simpler instructions
  Different                                       make simpler
  Instructions**                                  processors, why can
                                                  x86-64 express some
                                                  computations with far
                                                  fewer architectural
                                                  instructions than
                                                  RISC-V?

  **HW2 --- Same          Memory hierarchy and    If two programs perform
  Operations, Different   locality                the same operations the
  Speed**                                         same number of times,
                                                  why can changing only
                                                  the order of memory
                                                  accesses dramatically
                                                  change runtime?

  **HW3 --- Same Event,   Polling, interrupts,    If polling and
  Different Power**       and power               interrupts produce the
                                                  same visible result,
                                                  why can they require
                                                  dramatically different
                                                  amounts of CPU activity
                                                  and energy?

  **HW4 --- The Extension ISA extensions and      If hardware support can
  You Don't Get for       hardware tradeoffs      make an operation
  Free**                                          dramatically faster,
                                                  why would a processor
                                                  designer deliberately
                                                  leave that hardware
                                                  out?

  **HW5 --- Your Code     Physical hardware and   Software lets us think
  Runs One Line at a      timing                  of operations as
  Time. Your Circuit                              completed sequential
  Doesn't.**                                      steps. Why can't
                                                  physical hardware
                                                  behave that way?

  **HW6 --- Your Program  Execution resources and If programs are
  Is Sequential. Your     instruction-level       sequential, how can a
  Processor Is Not.**     parallelism             processor execute
                                                  multiple instructions
                                                  at the same time, and
                                                  why do dependencies
                                                  sometimes prevent it?

  **HW7 --- One           CPUs, GPUs, and         If CPUs are
  Architecture Doesn't    specialized             extraordinarily fast
  Fit Every Problem**     accelerators            general-purpose
                                                  processors, why can
                                                  workloads such as AI
                                                  benefit from machines
                                                  built around completely
                                                  different architectural
                                                  tradeoffs?
  -----------------------------------------------------------------------

The sequence is intentional.

We begin at the interface between software and the processor:

``` text
software
   ↓
instructions
   ↓
memory
   ↓
events and interrupts
   ↓
architectural features
```

Then we move underneath the instructions:

``` text
physical circuits
   ↓
timing
   ↓
parallel execution
   ↓
processor organization
```

Finally, we step back and ask:

``` text
Is a CPU the only way to build a machine?
```

It isn't.

------------------------------------------------------------------------

# The Instructor Demonstrations

Most assignments begin with a short demonstration.

The demo exists to create the **Confront** moment.

You are generally **not required to reproduce the demonstration
yourself** unless the assignment specifically says otherwise.

The student-facing description of each demonstration is available in:

``` text
HW/HW#_demo.md
```

The complete runnable implementation is available in:

``` text
HW-DEMOS/HW#/
```

The source code is available because:

-   you may want to explore further,
-   you may want to inspect how the demonstration works,
-   instructors should be able to reproduce the result,
-   and reproducibility matters in technical work.

But the demo is not the homework.

> **The demo gives you the question. Your investigation is the
> homework.**

------------------------------------------------------------------------

# What a Good AI Investigation Looks Like

Suppose AI tells you:

> "GPUs are faster because they have more cores."

That might be a starting point.

It should not be the end of your investigation.

Useful follow-ups might be:

``` text
What is actually different between a GPU execution resource
and a CPU core?
```

Then:

``` text
What does the GPU give up or simplify to devote more
hardware to parallel throughput?
```

Then:

``` text
If massive parallelism is so effective, why did the CPU
beat the GPU on the smallest workload in our demo?
```

Then perhaps:

``` text
How does memory bandwidth affect this tradeoff?
```

Notice what happened:

``` text
question
   ↓
explanation
   ↓
new question
   ↓
better explanation
   ↓
evidence
   ↓
understanding
```

That process is what we are practicing.

A strong AI conversation does not need to be long for the sake of being
long.

It needs to show that you are actively using questions to improve your
model.

------------------------------------------------------------------------

# You Are Allowed to Be Confused

Some of these assignments are deliberately designed to expose a place
where your current model stops working.

That means there may be a point where you think:

> **I don't understand why this happened.**

That is the beginning of the investigation.

Use the AI assistant to locate exactly what you do not understand.

Questions such as these can be useful:

``` text
Explain that again without assuming I understand _____.
```

``` text
What assumption am I making that is causing me to
misunderstand this?
```

``` text
Can you connect this back to what I learned about _____?
```

``` text
Give me a concrete example.
```

``` text
I don't think that explanation fully answers my question.
What am I missing?
```

Being able to identify the edge of your own understanding is an
important technical skill.

------------------------------------------------------------------------

# Sources Matter

AI assistants can produce explanations that sound confident even when:

-   details depend on the processor,
-   numbers depend on operating conditions,
-   terminology varies between vendors,
-   the source is outdated,
-   or the explanation is simply incorrect.

When the homework asks for a real:

-   processor specification,
-   current measurement,
-   cache latency,
-   hardware cost,
-   architectural feature,
-   or other quantitative fact,

find a credible source.

Good sources often include:

-   processor manuals,
-   architecture documentation,
-   manufacturer datasheets,
-   vendor technical documentation,
-   academic papers,
-   and other primary technical references.

AI can help you find and understand evidence.

> **AI should not automatically become the evidence.**

------------------------------------------------------------------------

# Your AI Conversation Is Part of the Work

Each assignment asks you to include your AI conversation.

You do **not** need to clean it up.

We are not looking for a perfect transcript.

A useful investigation may contain:

-   questions that went nowhere,
-   misunderstandings,
-   corrections,
-   follow-up questions,
-   challenges,
-   and moments where your model changed.

That's normal.

The transcript helps show the path you took through the investigation.

------------------------------------------------------------------------

# What You Will Submit

Each homework will tell you exactly what to submit.

In general, expect to complete:

1.  The **Confirm** questions.
2.  Any requested real-world investigation or source.
3.  The **Catch the AI** verification.
4.  Your **best follow-up question** and why it helped.
5.  The requested connections back to course concepts.
6.  Your **AI conversation transcript**.
7.  The short **assignment feedback** section.

You do not need to submit or recreate the instructor demo unless the
homework explicitly asks you to do so.

------------------------------------------------------------------------

# Assignment Points and Feedback

Each homework contains:

``` text
100 points — academic assignment

+5 free points — assignment feedback
```

The feedback questions are graded on **completion only**.

There are no correct answers.

Selecting:

> **Prefer not to answer**

counts as completing the item.

The feedback helps us understand:

-   what you knew before the investigation,
-   what you feel able to explain afterward,
-   what drove your investigation,
-   whether the demonstration created useful curiosity,
-   and which parts of the homework helped most.

At the beginning, midpoint, and end of the homework sequence, you will
also be asked about your confidence using AI as an investigative tool.

Those questions help us understand whether your investigation skills
change over the term.

------------------------------------------------------------------------

# How to Get the Most Out of These Assignments

A few habits will make these homeworks much more useful.

## Make the prediction

When the homework asks you to predict what a demo will do, commit to an
answer before seeing the result.

Being wrong is useful because the difference between:

``` text
what I expected
```

and:

``` text
what actually happened
```

often identifies exactly what you need to investigate.

## Don't stop at the first plausible explanation

AI is very good at producing explanations that sound complete.

Ask yourself:

> **Does this actually explain what I observed?**

If not, keep going.

## Ask "why" one more time

If the answer is:

> "The column-major loop has more cache misses."

ask:

> "Why does that make it slower?"

If the answer is:

> "The GPU has more parallel execution resources."

ask:

> "What architectural tradeoff allowed the GPU to devote more hardware
> to them?"

The second or third question is often where the interesting architecture
begins.

## Connect new ideas to things you already know

The assignments intentionally build on one another.

Memory locality connects to caches.

Interrupts connect software behavior to processor activity.

ISA extensions connect performance to hardware cost.

Timing explains why physical hardware needs coordination.

Execution scheduling builds on hardware parallelism.

GPU architecture takes the parallelism question to a completely
different scale.

Look for those connections.

## Follow something interesting

The Construct prompts are a path, not a fence.

If your investigation uncovers something that genuinely helps you
understand the architectural question, follow it.

The goal is not to produce seven identical AI conversations.

The goal is to become better at investigating unfamiliar technical
systems.

------------------------------------------------------------------------

# One Important Rule

Do not optimize these assignments for:

> **How quickly can I get through the required questions?**

That approach is possible.

It also defeats most of the value of the homework.

Instead, when something catches your attention, follow it.

When an explanation doesn't quite make sense, ask another question.

When the AI says something surprisingly specific, check it.

When you discover something interesting that isn't explicitly required,
explore it.

You are not expected to become an expert on every topic.

You are expected to practice becoming a better **technical
investigator**.

------------------------------------------------------------------------

# The Bigger Goal

This is a computer architecture course for computer scientists.

You may spend most of your career writing software rather than designing
processors.

But the software you write always executes somewhere.

Performance, power, memory behavior, concurrency, instruction selection,
accelerators, and system design all depend on what is happening
underneath your abstractions.

Throughout these seven homeworks, we will keep returning to one
question:

> **What is the hardware actually doing underneath my software?**

By the end of the course, the goal is not simply that you recognize more
computer-architecture vocabulary.

It is that when software behaves in a way you did not expect, you are
more likely to ask that question.

And that you have developed a process for finding out.
