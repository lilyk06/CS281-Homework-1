# HW7 Demo — Beyond the CPU

## Overview

Throughout this course, we have explored how software becomes execution through the lens of a **general-purpose CPU**.

RISC-V gave us a concrete architecture to work with.

Along the way, we have seen many of the architectural ideas that make modern CPUs effective:

- instructions and registers,
- memory and caches,
- ISA extensions,
- clocks and physical timing,
- multiple execution resources,
- scheduling,
- and opportunities for parallel execution.

HW6 pushed that last idea further.

A CPU can find independent instructions and overlap their execution using multiple execution resources.

But consider a very different kind of problem.

What if instead of finding:

```text
2 or 3 independent operations
```

we had:

```text
thousands
or
millions
```

of pieces of work that could potentially happen at the same time?

Would we still want to build the machine the same way?

That's where this demo begins.

---

# The Computation

We will use **matrix multiplication**.

You do not need to know linear algebra beyond what is shown here.

Suppose we multiply two matrices:

```text
A × B = C
```

Each element of the output matrix `C` is calculated from a row of `A` and a column of `B`.

A straightforward implementation looks like:

```text
for row = 0 to n-1:

    for column = 0 to n-1:

        sum = 0

        for j = 0 to n-1:

            sum += A[row][j] * B[j][column]

        C[row][column] = sum
```

There are:

```text
n² output cells
```

and each output cell requires approximately:

```text
n multiply/add steps
```

So the amount of work grows roughly as:

```text
n³
```

But there is something interesting about those output cells.

Consider:

```text
C[0][0]     C[0][1]     C[0][2]     ...

C[1][0]     C[1][1]     C[1][2]     ...

C[2][0]     C[2][1]     C[2][2]     ...

   .           .           .
   .           .           .
   .           .           .
```

Calculating `C[0][0]` does not require us to first calculate `C[0][1]`.

Calculating `C[100][200]` does not require `C[500][600]` to finish.

The output cells represent a large amount of **independent work**.

That should sound familiar.

---

# Connect Back to HW6

In HW6, we saw a CPU overlap independent instructions using different execution resources:

```text
              Scheduler

           /      |      \

        INT0     INT1    MUL0
```

Independent work gave the CPU opportunities to execute multiple instructions at the same time.

Now imagine a `1024 × 1024` output matrix.

It contains:

```text
1,048,576 output cells
```

Conceptually, that gives us an enormous amount of independent work.

So here is the question:

> **What kind of processor would you build if your workload regularly contained enormous amounts of parallel work?**

Would you keep making a conventional CPU larger and more complicated?

Or might you make very different architectural choices?

---

# Before the Demo

We are going to perform the same mathematical computation using two very different execution approaches.

Before seeing the results, make a prediction.

As the matrix becomes larger, what do you expect?

- The CPU should remain faster because CPUs are general-purpose processors.
- The GPU should always be faster, even for tiny problems.
- The relative performance may change as the amount of available parallel work grows.
- There should be little difference because both machines perform the same mathematics.
- I'm not sure yet.

Keep your prediction in mind.

---

# The Demo

Run:

```bash
python gpu_demo.py
```

The program performs matrix multiplication using two different execution approaches.  ** NOTE:  That in order to run this you must have access to a machine with a GPU - on my machine I need to run on MAC OS becasue `pytorch` supports Apple Silicone GPUs. **. I was unable to run this on a local VM because of lack of suport for GPU passthrough. 

## CPU

The CPU implementation directly executes the three nested loops:

```text
row
  column
    multiply/add
```

This deliberately exposes the straightforward computational structure.

## GPU

The GPU performs the same matrix multiplication using software designed to map the operation onto GPU hardware.

The mathematics is still:

```text
A × B = C
```

What changes is **how the work is mapped onto the machine**.

---

# What to Watch

The demo begins with very small matrices and progressively increases the amount of work:

```text
16 × 16

32 × 32

64 × 64

128 × 128

256 × 256

512 × 512

1024 × 1024
```

Do not focus only on which machine wins.

Watch how the relationship changes as the problem becomes larger.

A sample run on an Apple Silicon GPU produced:

```text
==============================================================================
FINAL RESULTS
==============================================================================
        Matrix        CPU (ms)        GPU (ms)                    Result
------------------------------------------------------------------------------
     16 x 16               0.331         185.128        CPU faster: 558.5x
     32 x 32               2.384          54.388         CPU faster: 22.8x
     64 x 64              17.925           4.899          GPU faster: 3.7x
    128 x 128            140.567           3.246         GPU faster: 43.3x
    256 x 256          1,132.972           4.066        GPU faster: 278.7x
    512 x 512          9,810.527           5.784      GPU faster: 1,696.0x
   1024 x 1024        97,119.235           4.474     GPU faster: 21,705.2x
==============================================================================
```

Your results will vary depending on your hardware and software environment.

The exact numbers are **not** the lesson.

The pattern is.

---

# The First Surprise

Look at the smallest matrix:

```text
16 × 16
```

In the sample run:

```text
CPU:   0.331 ms
GPU: 185.128 ms
```

The CPU wins by more than `500×`.

At:

```text
32 × 32
```

the CPU still wins:

```text
CPU:  2.384 ms
GPU: 54.388 ms
```

If a GPU were simply a "faster CPU," these results would be difficult to explain.

Something about using this different execution architecture has a cost.

For a small workload, that cost can dominate.

---

# Then Something Changes

Increase the matrix to:

```text
64 × 64
```

Now the sample result reverses:

```text
CPU: 17.925 ms
GPU:  4.899 ms
```

The GPU is now faster.

Increase the workload again.

At:

```text
128 × 128
```

the difference becomes much larger:

```text
CPU: 140.567 ms
GPU:   3.246 ms
```

Keep going.

At:

```text
1024 × 1024
```

there are:

```text
1,048,576 output cells

1,024 multiply/add steps per output cell

~1.07 billion multiply/add steps
```

The sample run produced:

```text
CPU: 97,119.235 ms

GPU:      4.474 ms
```

The relative behavior has changed dramatically as the amount of work increased.

That should raise a question:

> **Why does increasing the size of the problem change which architecture is effective?**

---

# Be Careful With the Numbers

This demonstration is intentionally designed to expose two very different execution approaches.

The CPU side directly executes the straightforward nested-loop implementation in Python.

The GPU side uses PyTorch to map matrix multiplication onto GPU hardware.

Therefore:

> **This is not a production benchmark comparing an optimized CPU implementation against an optimized GPU implementation.**

Do not interpret:

```text
GPU faster: 21,705.2x
```

as:

> "GPUs are generally 21,705 times faster than CPUs."

That is not what this experiment establishes.

Instead, the result tells us that the straightforward execution model scales very differently from an implementation running on hardware designed to exploit this type of parallel workload.

The question we care about is:

> **Why can the same mathematical problem behave so differently when mapped onto different architectures?**

---

# One More Detail About the Timing

The GPU must receive the matrices before it can perform the computation.

The demo prints:

```text
transferring matrices to GPU...
launching parallel matrix multiplication...
```

The reported GPU timing measures the matrix multiplication after the matrices have been placed on the GPU.

It does **not** include the host-to-GPU transfer time.

That is intentional for this demonstration because we want to focus on the execution behavior of the architecture.

But it raises another important question:

> **If using specialized hardware requires moving data to it, when does the benefit outweigh that cost?**

That is another architectural tradeoff worth investigating.

---

# What Changed?

The mathematics did not change.

Both approaches calculate:

```text
C = A × B
```

The answer did not change.

The amount of mathematical work did not change.

But something about the way that work is executed changed dramatically.

Recall the structure of the output:

```text
C[0][0]     C[0][1]     C[0][2]     ...

C[1][0]     C[1][1]     C[1][2]     ...

C[2][0]     C[2][1]     C[2][2]     ...

   .           .           .
   .           .           .
   .           .           .
```

There can be an enormous amount of independent work.

In HW6, a few independent instructions allowed a CPU to use several execution resources.

Here we potentially have **millions of opportunities for parallel work**.

So ask yourself:

> **What would an architecture look like if it were designed around workloads like this?**

---

# Don't Answer That Yet

The purpose of this demo is **not** to teach GPU architecture.

You do not yet need to know:

- how GPU execution resources are organized,
- how large numbers of operations are scheduled,
- how GPU memory differs from CPU memory,
- how thousands of pieces of work are coordinated,
- why GPUs make different control-flow tradeoffs,
- or why matrix operations are especially important to modern accelerators.

Those are exactly the questions HW7 will investigate.

For now, keep the observation:

> **Different workloads can reward very different architectural choices.**

---

# The Architecture We Have Studied

For most of this course, we have explored how a general-purpose CPU executes software.

A modern CPU is extraordinarily capable.

It is designed to execute:

```text
operating systems

compilers

web browsers

databases

games

control-heavy programs

irregular algorithms

and almost anything else we ask it to run
```

To accomplish that, CPUs devote significant hardware to making a relatively small number of powerful execution cores extremely capable.

Throughout the course, we have encountered some of those techniques:

```text
caches

ISA extensions

careful timing

multiple execution resources

instruction scheduling

parallel execution
```

Those architectural choices help make general-purpose CPUs extraordinarily fast and flexible.

But they are still **choices**.

---

# A Different Architectural Bet

Now imagine that your workload looks less like:

```text
do this complicated thing

then make a decision

then do something different
```

and more like:

```text
perform this relatively simple operation

again

and again

and again

across an enormous amount of independent data
```

Would you build the same processor?

Maybe not.

An architecture designed for throughput can make different tradeoffs.

Instead of concentrating silicon on a small number of extremely capable general-purpose cores, it can devote much more of the machine to performing large amounts of similar work concurrently.

That does not make one architecture universally better.

It means the architectures are optimized around **different assumptions about the workload**.

---

# Why This Matters Now

This architectural idea is not new.

But modern artificial intelligence has made it especially important.

Machine-learning workloads contain enormous amounts of:

```text
matrix operations

vector operations

tensor operations
```

Those workloads create opportunities for architectures optimized around highly parallel numerical computation.

GPUs became extremely important for AI because their architectural choices happen to align well with many of these workloads.

But GPUs are not the end of the story.

If we know that a workload will repeatedly perform certain kinds of matrix or tensor operations, we can ask an even more aggressive architectural question:

> **Why stop at a GPU?**

Hardware can specialize further.

That leads toward architectures and execution resources designed specifically for AI workloads.

---

# The Bigger Question

For most of this course, our architectural question has effectively been:

> **How can we build a general-purpose CPU that executes software efficiently?**

HW7 opens a larger question:

> **How should the workload influence the architecture of the machine that executes it?**

A CPU represents one set of tradeoffs.

A GPU represents another.

Tensor processors and other AI accelerators make different tradeoffs again.

The same principles we have studied all semester still matter:

```text
execution

parallelism

memory

data movement

hardware resources

latency

throughput

cost
```

But different architectures balance those concerns differently.

---

# Questions to Carry Into HW7

Do not try to answer all of these from the demo.

These questions identify the gaps we are about to investigate.

- Why can the CPU dominate tiny workloads while the GPU becomes dramatically more effective as the workload grows?

- What architectural choices make CPUs good at general-purpose computation?

- What does a GPU give up in order to support much greater parallel throughput?

- How does GPU hardware organize large numbers of execution resources?

- How does a GPU schedule enormous amounts of parallel work?

- Why doesn't a CPU simply contain thousands of execution units?

- What happens when a workload does not contain enough parallel work?

- How important is memory bandwidth when thousands of operations need data?

- Why are matrix and tensor operations particularly important for modern AI?

- What is a tensor processor or AI accelerator?

- How far can specialization go before losing general-purpose flexibility becomes a problem?

- How should a computer architect decide whether a workload belongs on a CPU, GPU, or specialized accelerator?

---

# One Last Perspective

This course has used RISC-V to give you a hardware vantage point on a question every computer scientist should understand:

> **What actually happens underneath the software I write?**

We followed that question from instructions into the hardware that executes them.

That model matters.

But it is not the only possible model.

> **A CPU is not what a computer has to look like. It is one set of architectural tradeoffs.**

GPUs make different tradeoffs.

AI accelerators make different ones again.

Future workloads will continue creating reasons to build machines differently.

We have spent the semester looking deeply at one important part of computer architecture.

HW7 is designed to leave you with one final realization:

> **We have only scratched the surface.**