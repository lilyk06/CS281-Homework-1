# HW7 — Submission Template

This is the only file you need to fill out and submit for HW7. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW7.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** What is the most important conclusion to draw from the HW7 demo?

- [ ] A. GPUs are always faster than CPUs.
- [ ] B. CPUs should no longer be used for mathematical computation.
- [ ] C. Different workloads and problem sizes can reward different architectural choices.
- [ ] D. Matrix multiplication can only be performed efficiently on GPUs.

**MC2.** Why can a CPU outperform a GPU for a very small parallel workload?

- [ ] A. GPUs cannot perform small calculations.
- [ ] B. The overhead of using the GPU can outweigh the benefit of its parallel resources when there is too little work.
- [ ] C. CPUs contain more GPU cores for small problems.
- [ ] D. GPUs disable parallel execution for small matrices.

**MC3.** Which statement best captures the architectural difference explored in this homework?

- [ ] A. CPUs and GPUs perform different mathematics.
- [ ] B. CPUs emphasize flexible general-purpose execution, while GPUs make different tradeoffs to support high parallel throughput.
- [ ] C. GPUs are CPUs running at a higher clock frequency.
- [ ] D. CPUs cannot execute instructions in parallel.

**MC4.** Why are specialized AI accelerators useful for some machine-learning workloads?

- [ ] A. They can dedicate hardware to computational patterns that occur frequently in those workloads.
- [ ] B. They can execute every possible program more efficiently than a CPU.
- [ ] C. They eliminate the need for memory.
- [ ] D. They make algorithms independent of hardware architecture.

---

# Part B: Show What You Learned

### N1 — Correct the model (15 pts)

Correct this statement: "A GPU is basically a faster CPU with thousands of smaller CPU cores." In 2–4 sentences, explain why that description is incomplete, referencing architectural tradeoffs, throughput, and workload characteristics.

> Your answer:
>
>
>

### N2 — Explain the crossover (15 pts)

The CPU dominated the smallest matrices while the GPU became much more effective as the workload grew. Explain why that pattern is more useful than simply saying "the GPU is faster." Discuss available parallel work, fixed/setup overhead, and why workload size matters.

> Your answer:
>
>
>

### N3 — Choose the architecture (15 pts)

For each workload, choose the architecture you would investigate first (CPU, GPU, or specialized AI accelerator) and explain why.

**A. A compiler processing source code**

- **Architecture:**
- **Why:**

**B. Applying the same operation independently to millions of pixels**

- **Architecture:**
- **Why:**

**C. Large-scale neural-network training dominated by matrix operations**

- **Architecture:**
- **Why:**

### N4 — Make specialization concrete (10 pts)

- **Architecture / feature:**
- **What workload or operation it is designed to accelerate:**
- **What architectural specialization you found:**
- **Why that specialization helps:**
- **Source:**

### N5 — Catch the AI (15 pts)

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

### N6 — Your best follow-up (5 pts)

**Your follow-up question:**

>

**Why it was useful, or how it changed your understanding (1–2 sentences):**

>

### N7 — The course in one architectural question (5 pts)

Complete in your own words: "Before this course, I mostly thought of a processor as ____________________. Now I think the more useful architectural question is ____________________." Then briefly explain why.

> Your answer:
>
>
>

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

>

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why different kinds of processors might be better suited to different kinds of workloads?

1. I could not explain this topic at all; it was new to me.
2. I knew CPUs and GPUs were different but could not explain the architectural reasons.
3. I could explain some differences between CPUs and GPUs at a high level but not how workload characteristics connect to them.
4. I had some previous knowledge and could explain why different workloads might favor different architectures.
5. I had a working understanding of CPUs, GPUs, and specialized accelerators and could explain their major architectural tradeoffs.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### P1 — After

After this assignment, how well could you explain why different kinds of processors might be better suited to different kinds of workloads?

1. I still do not feel I could explain this comfortably yet.
2. I could describe some CPU/GPU differences but would need more help connecting them to workload behavior.
3. I could explain the major CPU/GPU architectural tradeoffs and give examples of workloads that favor each.
4. I am confident I could explain why workload characteristics influence architecture selection to another student.
5. I could confidently compare CPU, GPU, and specialized accelerator tradeoffs in a technical discussion.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to understand why the CPU and GPU behaved so differently in the demonstration.
- [ ] I mainly wanted to understand how workload characteristics influence architectural design.
- [ ] The demo made me curious about architectures beyond the ones required by the assignment.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] Seeing the CPU/GPU crossover in the in-class demonstration
- [ ] Connecting HW6's execution resources to the much larger parallelism in HW7
- [ ] Reading the Concept section
- [ ] Investigating how GPU execution actually works
- [ ] Investigating GPU memory and data movement
- [ ] Investigating AI accelerators / tensor hardware
- [ ] Challenging or verifying something the AI told me
- [ ] Choosing architectures for different workloads
- [ ] The open-ended "we only scratched the surface" investigation
- [ ] Prefer not to answer

### DEMO — Did the demonstration create a useful question?

After seeing the demonstration, how strongly did you want to understand why the CPU and GPU behaved differently as the workload grew?

1. Not at all — the result did not make me curious about the reason.
2. Slightly — I noticed the difference but was not particularly motivated to investigate it.
3. Moderately — I wanted to understand the basic explanation.
4. Strongly — the result made me want to understand the architecture behind it.
5. Very strongly — the result made me want to investigate beyond what the assignment required.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### PRO — Professional relevance

How much do you agree: "Understanding how workload characteristics interact with CPU, GPU, and accelerator architecture will be useful to me when designing or evaluating software systems."

1. Strongly disagree
2. Disagree
3. Neither agree nor disagree
4. Agree
5. Strongly agree
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

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
| MC1–MC4 | Correctly identifies the central architectural ideas behind workload-dependent performance and specialization | 20 |
| N1 | Corrects the "GPU = faster CPU" model using architectural tradeoffs, throughput, and workload characteristics | 15 |
| N2 | Explains the CPU/GPU crossover using parallel work, overhead, and workload scale | 15 |
| N3 | Selects defensible architectures for three different workloads and supports each choice with architectural reasoning | 15 |
| N4 | Investigates a real GPU/AI architecture or feature, identifies its specialization, and provides a credible source | 10 |
| N5 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 15 |
| N6 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 5 |
| N7 | Demonstrates a broader architectural perspective connecting the course's CPU focus to workload-driven architecture | 5 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
