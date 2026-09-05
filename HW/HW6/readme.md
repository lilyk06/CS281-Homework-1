# HW6 Demo: Why Sequential Code Can Execute in Parallel

## Overview

This demo explores a fundamental difference between how programmers think about programs and how modern processors execute instructions.

When writing software, we naturally think sequentially:

```text
Instruction 1
Instruction 2
Instruction 3
```

A common assumption is:

> If instructions appear one after another in a program, they must execute one after another in hardware.

Modern processors challenge this assumption.

A processor may contain multiple execution resources that can operate at the same time. A scheduler examines instructions and determines which execution resource should handle each operation and whether the instruction can safely begin execution.

This demo models a simplified processor with three execution resources:

```text
                Instruction Stream

                       |
                       v

                   Scheduler

              /        |        \

             v         v         v

           INT0      INT1      MUL0
```

The processor contains:

- Two integer execution units:
  - `INT0`
  - `INT1`

- One multiply execution unit:
  - `MUL0`

The goal is not to model a complete CPU. Instead, the goal is to observe two important processor concepts:

1. Independent instructions can execute simultaneously.
2. Data dependencies can prevent instructions from executing even when hardware is available.

---

## Files

- `hw6_scheduler.v`: the scheduler and three execution units (`INT0`,
  `INT1`, `MUL0`), driven directly by a fixed instruction stream rather
  than a full fetch/decode pipeline.
- `hw6_scheduler_tb.v`: testbench that runs both scenarios (independent
  instructions, then a data hazard into the multiply unit) back to
  back and dumps `hw6_scheduler.vcd`.
- `makefile`: builds and runs the simulation (`make`, `make run`,
  `make clean`).
- `hw6_scheduler.json`: a saved VaporView session (signal selection,
  zoom, marker position) for `hw6_scheduler.vcd`, so the waveform
  reopens with the right signals already displayed.
- `hw6_execution_analysis.png`: annotated waveform screenshot used in
  the Post-Demo Analysis section below.
- [`output.md`](./output.md):  Sample output from the HW6 demo.

---

# Scenario 0: Independent Instructions

The processor receives these RISC-V instructions:

```asm
add t0, t1, t2      # t0 = t1 + t2

add t3, t4, t5      # t3 = t4 + t5

mul t6, t7, t8      # t6 = t7 * t8
```

The instructions are independent.

The first instruction produces `t0`.

The second instruction produces `t3`.

The third instruction uses `t7` and `t8`.

None of the instructions requires the result of another instruction.

The scheduler can assign the instructions to different execution resources:

```text
add t0, t1, t2  ---> INT0

add t3, t4, t5  ---> INT1

mul t6, t7, t8  ---> MUL0
```

The instruction stream is still sequential:

```text
add
add
mul
```

However, the execution hardware overlaps:

```text
INT0:
add t0, t1, t2
=================

INT1:
       add t3, t4, t5
       =================

MUL0:
              mul t6, t7, t8
              =====================
```

The important observation:

> The processor did not make the individual operations faster. It increased throughput by allowing independent operations to execute at the same time.

---

# Scenario 1: Data Dependency

The processor receives these RISC-V instructions:

```asm
add t0, t1, t2      # t0 = t1 + t2

add t3, t4, t5      # t3 = t4 + t5

mul t6, t3, t8      # t6 = t3 * t8
```

At first glance, this looks similar to Scenario 0.

However, there is an important dependency:

```text
add t3, t4, t5

        |
        v

mul t6, t3, t8
```

The multiply instruction requires the value of `t3`.

The processor cannot begin:

```asm
mul t6, t3, t8
```

until:

```asm
add t3, t4, t5
```

has completed and produced the required value.

The execution resources are:

```text
add t0, t1, t2  ---> INT0

add t3, t4, t5  ---> INT1

mul t6, t3, t8  ---> MUL0
```

The scheduler can still execute the independent integer addition:

```text
INT0:
add t0, t1, t2
=================

INT1:
       add t3, t4, t5
       =================

MUL0:
       waiting for t3
       waiting for t3
       waiting for t3

                    mul t6, t3, t8
                    =====================
```

The important observation:

> The multiply hardware exists and is available, but the instruction cannot execute because its required input data is not ready.

---

# What to Observe in the Waveform

Open:

```text
hw6_scheduler.vcd
```

using VaporView.

The recommended signals are:

## Scheduler decisions

```text
dispatch_int0
dispatch_int1
dispatch_mul
```

These show where each instruction is sent.

---

## Execution resources

```text
int0_busy
int1_busy
mul_busy
```

These show which hardware resources are actively executing.

---

## Current operations

```text
int0_current_op
int1_current_op
mul_current_op
```

These show which instruction is currently using each execution resource.

---

## Dependency behavior

```text
mul_waiting_for_operand
```

This signal highlights Scenario 1.

The multiply unit is not waiting because the multiply hardware is busy.

It is waiting because the input value it needs has not been produced yet.

---

# Post-Demo Analysis

After observing the waveform and discussing the two scenarios, review the annotated execution analysis:

[View HW6 execution analysis](hw6_execution_analysis.png)

This analysis highlights:

- How independent instructions allow multiple execution resources to remain active at the same time.
- How data dependencies prevent instructions from executing even when the required hardware resource is available.
- How scheduling decisions influence total execution time.

---

# Questions to Consider

After observing the demo:

1. Why can the three instructions in Scenario 0 overlap execution?

2. Why must the multiply instruction wait in Scenario 1?

3. How does a real processor determine whether instruction operands are ready?

4. If more execution hardware can improve performance, why don't processors simply add unlimited execution units?

5. Why might a processor contain multiple integer execution units but fewer multiply, floating-point, or vector execution units?

6. What additional challenges appear when a processor attempts to execute many instructions at the same time?

These questions are the starting point for the investigation.