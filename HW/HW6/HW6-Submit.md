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
- [ ] B. The instructions are independent and can use different execution resources.
- [ ] C. The compiler changes the instruction order automatically.
- [ ] D. The processor executes every instruction twice.

**MC2.** Why does the multiply instruction wait in Scenario 1?

- [ ] A. The multiply unit is already being used by another instruction.
- [ ] B. The processor does not support multiplication.
- [ ] C. The multiply instruction requires a value produced by the previous add instruction.
- [ ] D. Multiplication instructions always execute after additions.

**MC3.** What is the difference between latency and throughput?

- [ ] A. Latency measures chip cost, while throughput measures software complexity.
- [ ] B. Latency describes how long one operation takes, while throughput describes how much work completes over time.
- [ ] C. Latency and throughput describe the same measurement.
- [ ] D. Latency only applies to memory operations.

**MC4.** Why don't processors simply add unlimited execution units?

- [ ] A. Additional execution hardware has costs and programs may not contain enough parallel work to use it.
- [ ] B. Multiple execution units cannot operate at the same time.
- [ ] C. Software cannot benefit from faster hardware.
- [ ] D. Additional hardware always reduces performance.

---

# Part B: Show What You Learned

### N1 — Correct the sequential execution model (20 pts)

Correct this statement: "Because a program is written sequentially, the processor must execute each instruction completely before beginning the next instruction." Your answer should reference multiple execution resources, instruction independence, and data dependencies.

> Your answer:
>
>
>

### N2 — Explain the Scenario 1 dependency (15 pts)

Using the Scenario 1 instructions (`add t0, t1, t2` / `add t3, t4, t5` / `mul t6, t3, t8`), explain why the multiply instruction must wait.

- **Which instruction produces the required value:**
- **Which instruction consumes that value:**
- **Why the processor cannot safely execute the multiply early:**

### N3 — Investigate a real processor (15 pts)

- **Processor / processor family:**
- **Execution resources identified:**
- **Specialized hardware you found:**
- **Why those resources exist:**
- **Source:**

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

>

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
