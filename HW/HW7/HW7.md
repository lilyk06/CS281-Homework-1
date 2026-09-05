# HW7: One Architecture Doesn't Fit Every Problem

## Connect

For most of this course, we have explored one fundamental question:

> **How does the software you write actually execute in hardware?**

RISC-V gave us a concrete architecture through which to investigate that question.

We started with instructions.

Then we kept looking underneath them.

We explored:

- registers and datapaths,
- memory,
- caches,
- interrupts,
- ISA extensions,
- combinational and sequential hardware,
- physical timing,
- multiple execution resources,
- scheduling,
- and instruction-level parallelism.

Each step revealed another reason modern CPUs are remarkably capable machines.

In HW6, we saw a CPU exploit independent instructions:

```text
              Scheduler

           /      |      \

        INT0     INT1    MUL0
```

Instead of forcing every instruction to wait for the previous one to finish, the processor could find independent work and overlap execution.

That raises an interesting question.

What if a workload doesn't contain just:

```text
2 or 3
```

independent operations?

What if it contains:

```text
thousands

or

millions
```

of similar pieces of work that could potentially happen at the same time?

Would we still want to build the machine the same way?

For the final homework, we're going to step outside the CPU architecture we've studied all semester.

Not because CPUs are obsolete.

Quite the opposite.

A modern CPU is an extraordinarily fast and flexible general-purpose machine.

But it represents **one set of architectural tradeoffs**.

Other workloads have encouraged computer architects to make very different choices.

And modern AI is making those choices increasingly important.


# Confront

Consider matrix multiplication:

```text
A × B = C
```

A straightforward implementation looks like:

```text
for row = 0 to n-1:

    for column = 0 to n-1:

        sum = 0

        for j = 0 to n-1:

            sum += A[row][j] * B[j][column]

        C[row][column] = sum
```

From the software perspective, this looks like a large amount of repetitive work.

But there is another way to look at it.

Each output element:

```text
C[row][column]
```

can be calculated independently of the other output elements.

A `1024 × 1024` result contains:

```text
1,048,576 output cells
```

That's more than a million pieces of work with enormous potential for parallel execution.

HW6 showed us a CPU finding a few independent instructions.

Now we have a workload with parallelism on a completely different scale.


Before watching the demonstration, make a prediction:

> **As matrix multiplication becomes larger, which architecture do you expect to perform better?**

- ☐ The CPU should remain faster because CPUs are more capable general-purpose processors.
- ☐ The GPU should always be faster because it has more parallel hardware.
- ☐ Which architecture performs better may depend on the size and structure of the workload.
- ☐ They should perform about the same because they perform the same mathematical computation.
- ☐ I'm not sure yet.


### Instructor Demo

The instructor will run the HW7 matrix multiplication demonstration.

The same mathematical operation is performed using two very different execution approaches.

The experiment begins with very small matrices:

```text
16 × 16
32 × 32
```

and grows through:

```text
64 × 64
128 × 128
256 × 256
512 × 512
1024 × 1024
```

Watch the relationship between the two machines.

In the sample run, the CPU dominated the smallest workload:

```text
16 × 16

CPU:   0.331 ms
GPU: 185.128 ms

CPU faster: 558.5×
```

At `32 × 32`, the CPU still won.

Then something changed.

At:

```text
64 × 64
```

the GPU became faster.

As the amount of work continued to grow, the difference became dramatic.

At:

```text
1024 × 1024
```

the sample run produced:

```text
CPU: 97,119.235 ms
GPU:      4.474 ms
```

Be careful with that result.

The demonstration intentionally uses a straightforward three-loop Python implementation on the CPU and a GPU-oriented PyTorch implementation on the GPU. It is **not** an optimized CPU-versus-GPU benchmark and does not establish that GPUs are generally thousands of times faster than CPUs.

That's not the interesting part anyway.

The interesting part is this:

> **The same computation can behave radically differently when mapped onto different execution approaches and architectures.**

And the smallest problems gave us another clue:

> **The architecture with massive parallel capability was not automatically the fastest architecture.**

So here's our final deliberate gap:

> **If there is no universally "fastest" architecture, what characteristics of a workload determine what kind of machine we should build to execute it?**

The demo source and README are available in `HW/DEMOS/HW7` if you'd like to explore them yourself, but **running the demo yourself is not required for this homework**.


# Concept

Throughout this course, we have mostly studied a **general-purpose CPU**.

That phrase matters.


### General-purpose CPUs make a particular architectural bet

A CPU needs to execute an enormous variety of software:

```text
operating systems
databases
compilers
web browsers
games
servers
control-heavy programs
irregular algorithms
and applications that haven't even been invented yet
```

That requires flexibility.

Modern CPU cores therefore contain sophisticated hardware for things such as:

- instruction scheduling,
- branch handling,
- caches,
- speculation,
- multiple execution resources,
- complex control flow,
- and extracting useful parallelism from programs that still present a sequential programming model.

The result is a relatively small number of extremely capable execution cores.


### But not every workload looks like that

Matrix multiplication has a different structure.

There can be enormous amounts of similar mathematical work operating on different pieces of data.

Conceptually:

```text
work  work  work  work  work  work  work
work  work  work  work  work  work  work
work  work  work  work  work  work  work
work  work  work  work  work  work  work
```

That creates a different opportunity.

Instead of spending as much hardware making a small number of execution cores extremely flexible, an architecture can devote much more of its resources to **throughput**.


### CPUs and GPUs make different tradeoffs

At a very high level, you can begin with this mental model:

```text
CPU

fewer
more sophisticated
general-purpose execution resources


GPU

many more
more throughput-oriented
execution resources
```

That is deliberately simplified.

A GPU is **not** just a CPU with thousands of smaller cores.

Its execution model, scheduling, memory system, and programming model also reflect its architectural goals.

That's what you're going to investigate.


### More parallel hardware doesn't automatically mean faster

The smallest matrix in the demo is important.

The GPU lost badly.

Using specialized hardware can introduce costs such as:

- preparing work,
- launching work,
- scheduling,
- synchronization,
- data movement,
- and other fixed overhead.

If the workload is tiny, there may not be enough useful work to justify those costs.

As the workload grows, the economics can change.

This should remind you of something we've encountered repeatedly throughout the course:

> **Architecture is about tradeoffs.**


### Workload matters

A CPU is extraordinarily good at workloads requiring flexibility, complex decisions, irregular control flow, and strong single-thread performance.

A GPU makes different choices because it expects large amounts of parallel work.

Neither statement means:

```text
CPU good
GPU bad
```

or:

```text
GPU good
CPU bad
```

The more useful question is:

> **What does the workload need?**


### And specialization can go further

Modern AI workloads contain enormous amounts of:

- matrix computation,
- vector computation,
- tensor operations.

GPUs turned out to be extremely effective for many of these workloads.

But architects can specialize even further.

If a machine is expected to perform particular mathematical operations repeatedly, hardware can be designed specifically around those operations.

That leads toward:

- tensor execution hardware,
- neural processing units,
- tensor processing units,
- matrix accelerators,
- and other domain-specific architectures.

The architectural spectrum begins to look something like:

```text
more general                              more specialized

     CPU  ---------------- GPU ---------------- AI accelerator

flexibility                                  specialization
complex control                              targeted throughput
many workloads                               narrower workload class
```

Don't treat that diagram as a strict ranking.

Treat it as a question about architectural priorities.


### That's enough of the model

You now need to investigate:

- what actually makes a GPU architecturally different,
- how massive amounts of parallel work are organized,
- what GPUs give up to gain throughput,
- why memory becomes such an important problem,
- how AI workloads pushed specialization further,
- and when a CPU, GPU, or specialized accelerator is the right architectural choice.


# Construct

Use any AI assistant for this investigation.

The prompts below are **starting points**, not questions you need to copy word-for-word.

Follow the investigation where your understanding requires it.

Ask follow-up questions when something is unclear, surprising, incomplete, or worth checking.

At least once, you must stop and verify or challenge something the AI tells you. You'll document that moment in Confirm.


### Step 1 — CPU versus GPU: what actually changed?

Start with the architectural question raised by the demonstration:

> **Why can a GPU become extremely effective when a workload contains enormous amounts of similar independent work?**

Don't settle for:

> "Because GPUs have more cores."

Push deeper.

Investigate differences such as:

- general-purpose CPU cores versus GPU execution resources,
- latency-oriented versus throughput-oriented design,
- control hardware,
- scheduling,
- parallel execution,
- and the amount of hardware devoted to computation.

Try to develop a better explanation for:

> **What does a GPU give up or simplify in order to devote more hardware to parallel throughput?**


### Step 2 — How does all that parallel work actually execute?

The phrase:

> "Run thousands of things at once"

sounds simple.

Hardware has to make it real.

Investigate how GPU work is organized.

Depending on the GPU architecture you explore, you may encounter ideas such as:

- kernels,
- threads,
- thread blocks / workgroups,
- grids,
- warps / wavefronts,
- SIMT execution,
- streaming multiprocessors / compute units.

Do not turn this into a vocabulary exercise.

Instead, keep asking:

> **What architectural problem is this concept solving?**

For example:

- How can the programmer describe enormous amounts of parallel work?
- Does every GPU thread have a completely independent CPU-like core?
- How does the hardware group and schedule work?
- What happens when different workers want to follow different control paths?


### Step 3 — Thousands of workers need data too

Execution resources are only useful if they can get data.

Imagine thousands of operations all requesting memory.

Investigate how the GPU memory system helps support high-throughput execution.

You might encounter:

- registers,
- shared/local memory,
- caches,
- global/device memory,
- memory bandwidth,
- coalescing,
- synchronization.

Connect this back to earlier work in the course.

You've already learned that memory behavior can dominate processor performance.

Ask:

> **How does the memory problem change when an architecture is trying to keep enormous numbers of parallel operations busy?**


### Step 4 — Why did AI make these architectures so important?

Now connect the architecture to modern AI.

Investigate why machine-learning workloads map so well onto GPUs.

Focus on the computation itself.

Why do:

- matrix multiplication,
- vector operations,
- and tensor operations

appear so frequently?

Then push beyond GPUs.

Investigate one architecture or execution technology designed specifically for AI or tensor workloads.

Examples might include:

- tensor cores,
- Google's TPU,
- Apple's Neural Engine,
- other NPUs,
- matrix engines,
- systolic arrays,
- or another AI accelerator you find interesting.

Ask:

> **What does this hardware specialize that a general-purpose CPU does not?**

Then ask:

> **What does that specialization buy us, and what flexibility does it potentially give up?**


### Step 5 — Choose the architecture

Now imagine you are the architect.

Consider these workloads:

**Workload A**

A command-line compiler processing source code with complex parsing, branches, operating-system interaction, and many irregular data structures.

**Workload B**

Applying the same image-processing operation independently to millions of pixels.

**Workload C**

Training a large neural network dominated by matrix and tensor operations.

Investigate which architectural model is likely to fit each workload best:

```text
CPU
GPU
specialized AI accelerator
```

There may not be one absolute answer.

What matters is your reasoning.

For each workload, ask:

> **What characteristics of this computation match the strengths of the architecture?**


### Step 6 — Catch the AI

During Steps 1–5, identify **one technical claim that deserves checking**.

The AI does not have to be wrong.

It might give you:

- a GPU core count,
- an explanation of SIMT,
- a memory-bandwidth number,
- a claim about CPU versus GPU execution,
- a tensor-core capability,
- a TPU architectural claim,
- or a statement that sounds more universal than you think it should.

Push back.

Ask for evidence.

Look for architecture documentation, vendor documentation, technical references, or another credible source.

The important skill is recognizing:

> **"That sounds plausible, but what evidence should make me believe it?"**


### Step 7 — We only scratched the surface

Finish by stepping back from the details.

Ask your AI assistant something like:

> **If a student finished a computer architecture course focused mostly on a RISC-V CPU, what major architecture ideas would still be left to explore?**

Follow at least one direction that interests you.

You might encounter:

- heterogeneous computing,
- FPGAs,
- ASICs,
- many-core processors,
- chiplets,
- distributed accelerators,
- neuromorphic computing,
- quantum architectures,
- or something else entirely.

This final step is intentionally open-ended.

The goal is to leave this course understanding:

> **Computer architecture is not one solved design. It is an evolving set of answers to the question: what machine should we build for the computation we need to perform?**


# Confirm

## Part A: Multiple Choice (5 pts each, 20 pts total)

Circle one.


**MC1.** What is the most important conclusion to draw from the HW7 demo?

- A. GPUs are always faster than CPUs.
- B. CPUs should no longer be used for mathematical computation.
- C. Different workloads and problem sizes can reward different architectural choices.
- D. Matrix multiplication can only be performed efficiently on GPUs.


**MC2.** Why can a CPU outperform a GPU for a very small parallel workload?

- A. GPUs cannot perform small calculations.
- B. The overhead of using the GPU can outweigh the benefit of its parallel resources when there is too little work.
- C. CPUs contain more GPU cores for small problems.
- D. GPUs disable parallel execution for small matrices.


**MC3.** Which statement best captures the architectural difference explored in this homework?

- A. CPUs and GPUs perform different mathematics.
- B. CPUs emphasize flexible general-purpose execution, while GPUs make different tradeoffs to support high parallel throughput.
- C. GPUs are CPUs running at a higher clock frequency.
- D. CPUs cannot execute instructions in parallel.


**MC4.** Why are specialized AI accelerators useful for some machine-learning workloads?

- A. They can dedicate hardware to computational patterns that occur frequently in those workloads.
- B. They can execute every possible program more efficiently than a CPU.
- C. They eliminate the need for memory.
- D. They make algorithms independent of hardware architecture.


## Part B: Show What You Learned


### N1 — Correct the model (15 pts)

Correct this statement:

> **"A GPU is basically a faster CPU with thousands of smaller CPU cores."**

In 2–4 sentences, explain why that description is incomplete.

Your answer should reference **architectural tradeoffs, throughput, and workload characteristics**.


### N2 — Explain the crossover (15 pts)

In the demonstration, the CPU dominated the smallest matrices while the GPU became much more effective as the workload grew.

Explain why that pattern is more useful than simply saying:

> "The GPU is faster."

Your answer should discuss:

- available parallel work,
- fixed or setup overhead,
- and why workload size matters.


### N3 — Choose the architecture (15 pts)

For each workload below, choose the architecture you would investigate first and explain why.

You may choose:

```text
CPU
GPU
specialized AI accelerator
```

There is not necessarily one universally correct choice. Your reasoning matters.


**A. A compiler processing source code**

**Architecture:**

**Why:**


**B. Applying the same operation independently to millions of pixels**

**Architecture:**

**Why:**


**C. Large-scale neural-network training dominated by matrix operations**

**Architecture:**

**Why:**


### N4 — Make specialization concrete (10 pts)

Choose one real GPU feature or AI accelerator you investigated.

Examples include a GPU streaming multiprocessor, tensor core, TPU, NPU, Neural Engine, matrix engine, or another relevant architecture.

Record:

- **Architecture / feature:**
- **What workload or operation it is designed to accelerate:**
- **What architectural specialization you found:**
- **Why that specialization helps:**
- **Source:**


### N5 — Catch the AI (15 pts)

Identify one claim from your AI investigation that you did not simply accept.

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

The AI does not have to be wrong.

The goal is to demonstrate that you can recognize when a technical claim deserves evidence.


### N6 — Your best follow-up (5 pts)

Look back through your AI conversation.

**What follow-up question most improved your understanding?**

Write the question:

> ________________________________________________________________

In 1–2 sentences, explain **why it was useful or how it changed your understanding.**


### N7 — The course in one architectural question (5 pts)

Complete this statement in your own words:

> **Before this course, I mostly thought of a processor as ____________________. Now I think the more useful architectural question is ____________________.**

Then briefly explain why.


## Appendix — AI Conversation

Paste your full AI chat export.

No cleanup is required.

The transcript is not graded for writing quality. It is included as evidence of the investigation you performed.


---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment.

There are no right or wrong answers. All items below are graded on **completion only**, never on the response selected.

Selecting **Prefer not to answer** counts as complete.


### B1 — Before

Before this assignment, how well could you explain why different kinds of processors might be better suited to different kinds of workloads?

1. I could not explain this topic at all; it was new to me.
2. I knew CPUs and GPUs were different but could not explain the architectural reasons.
3. I could explain some differences between CPUs and GPUs at a high level but not how workload characteristics connect to them.
4. I had some previous knowledge and could explain why different workloads might favor different architectures.
5. I had a working understanding of CPUs, GPUs, and specialized accelerators and could explain their major architectural tradeoffs.

- ☐ Prefer not to answer


### P1 — After

After this assignment, how well could you explain why different kinds of processors might be better suited to different kinds of workloads?

1. I still do not feel I could explain this comfortably yet.
2. I could describe some CPU/GPU differences but would need more help connecting them to workload behavior.
3. I could explain the major CPU/GPU architectural tradeoffs and give examples of workloads that favor each.
4. I am confident I could explain why workload characteristics influence architecture selection to another student.
5. I could confidently compare CPU, GPU, and specialized accelerator tradeoffs in a technical discussion.

- ☐ Prefer not to answer


### INV — What drove your investigation?

Thinking about your AI investigation on this assignment, which statement best describes what **primarily drove your approach**?

Pick the one that fits best.

- ☐ I mainly wanted to complete the required assignment efficiently.
- ☐ I mainly wanted to understand enough to answer the assignment questions correctly.
- ☐ I mainly wanted to understand why the CPU and GPU behaved so differently in the demonstration.
- ☐ I mainly wanted to understand how workload characteristics influence architectural design.
- ☐ The demo made me curious about architectures beyond the ones required by the assignment.
- ☐ Something else. *(Optional: tell us what.)*
- ☐ Prefer not to answer


### FAV — What helped most?

Which part of this homework most changed or expanded how you think about computer architecture?

Pick one.

- ☐ Seeing the CPU/GPU crossover in the in-class demonstration
- ☐ Connecting HW6's execution resources to the much larger parallelism in HW7
- ☐ Reading the Concept section
- ☐ Investigating how GPU execution actually works
- ☐ Investigating GPU memory and data movement
- ☐ Investigating AI accelerators / tensor hardware
- ☐ Challenging or verifying something the AI told me
- ☐ Choosing architectures for different workloads
- ☐ The open-ended "we only scratched the surface" investigation
- ☐ Prefer not to answer


### DEMO — Did the demonstration create a useful question?

After seeing the demonstration, how strongly did you want to understand **why the CPU and GPU behaved differently as the workload grew**?

1. Not at all — the result did not make me curious about the reason.
2. Slightly — I noticed the difference but was not particularly motivated to investigate it.
3. Moderately — I wanted to understand the basic explanation.
4. Strongly — the result made me want to understand the architecture behind it.
5. Very strongly — the result made me want to investigate beyond what the assignment required.

- ☐ Prefer not to answer


### PRO — Professional relevance

How much do you agree with this statement?

> **Understanding how workload characteristics interact with CPU, GPU, and accelerator architecture will be useful to me when designing or evaluating software systems.**

1. Strongly disagree
2. Disagree
3. Neither agree nor disagree
4. Agree
5. Strongly agree

- ☐ Prefer not to answer


### SCA — What should we do with this format?

Thinking about the topic and the process overall, what should we do with this homework format going forward?

- ☐ **Continue as is.** *Optional: any suggestions to make it even better?*
- ☐ **Adjust something.** *Optional: what would you change?*
- ☐ **Stop, and go back to a traditional homework model.** *Optional: what didn't work for you?*
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
| MC1–MC4 | Correctly identifies the central architectural ideas behind workload-dependent performance and specialization | 20 |
| N1 | Corrects the "GPU = faster CPU" model using architectural tradeoffs, throughput, and workload characteristics | 15 |
| N2 | Explains the CPU/GPU crossover using parallel work, overhead, and workload scale | 15 |
| N3 | Selects defensible architectures for three different workloads and supports each choice with architectural reasoning | 15 |
| N4 | Investigates a real GPU/AI architecture or feature, identifies its specialization, and provides a credible source | 10 |
| N5 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 15 |
| N6 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 5 |
| N7 | Demonstrates a broader architectural perspective connecting the course's CPU focus to workload-driven architecture | 5 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; “Prefer not to answer” counts as complete | 5 |

**Total: 100 points.**