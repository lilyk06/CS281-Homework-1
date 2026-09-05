# HW2 — Submission Template

This is the only file you need to fill out and submit for HW2. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW2.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** Why can column-major traversal of a row-major-stored array run much slower even when it performs the same number of arithmetic operations and logical loads?

- [ ] A. Column-major traversal uses a slower addition instruction
- [ ] B. Its access pattern makes much poorer use of data brought into the cache, causing more costly interaction with the memory hierarchy
- [ ] C. The CPU has to execute every column-major instruction twice
- [ ] D. Row-major traversal skips some array elements

**MC2.** What is a cache line?

- [ ] A. A single variable stored in a CPU register
- [ ] B. A contiguous block of memory transferred and cached together
- [ ] C. A dedicated wire connecting the CPU directly to RAM
- [ ] D. A compiler-generated marker identifying loops

**MC3.** What does **spatial locality** describe?

- [ ] A. A program repeatedly executing the same arithmetic instruction
- [ ] B. A program being likely to access memory locations near one it recently accessed
- [ ] C. A processor keeping frequently used variables only in registers
- [ ] D. Two processors accessing memory at the same time

**MC4.** Why can't a compiler safely reorder every column-major loop into a row-major loop?

- [ ] A. Compilers aren't allowed to change loops
- [ ] B. Changing iteration order can change program behavior when dependencies, aliasing, data layout, or other constraints are present
- [ ] C. Compilers don't know that caches exist
- [ ] D. Row-major traversal is only valid in assembly language

---

# Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement: "If two programs perform the same operations the same number of times, they should take roughly the same amount of time."

> Your answer:
>
>
>

### N2 — Put real numbers on it (15 pts)

- **Processor / processor family:**
- **Fastest cache level you investigated:**
- **Approximate access cost:**
- **Slower cache level or main memory:**
- **Approximate access cost:**
- **What surprised you about the comparison:**
- **Source:**

### N3 — Catch the AI (20 pts)

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

### N4 — Your best follow-up (10 pts)

**Your follow-up question:**

>

**Why that question was useful, or how it changed/refined your understanding (1–2 sentences):**

>

### N5 — Connect back (10 pts)

Check the **two** architecture concepts from lecture that most directly explain the performance difference you investigated, and explain each in one sentence.

- [ ] Cache lines / block-based memory transfers — explanation:
- [ ] Spatial locality — explanation:
- [ ] Temporal locality — explanation:
- [ ] Cache hierarchy (L1/L2/L3) — explanation:
- [ ] Cache-miss penalty / memory latency — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

>

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why two programs that perform the same number of operations can have very different runtimes because of their memory access patterns?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge of this topic and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the performance effect to someone else.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### P1 — After

After this assignment, how well could you explain why two programs that perform the same number of operations can have very different runtimes because of their memory access patterns?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts but not fully how they connect to the observed performance difference.
4. I am confident I could explain the effect well enough to help a fellow classmate understand it.
5. I could confidently explain and defend the relationship between access pattern, locality, and performance in a technical discussion.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to resolve why the two traversals behaved differently even though they appeared to perform the same work.
- [ ] I mainly wanted to understand memory locality well enough that I could recognize or apply it in other programs.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] The in-class demonstration / prediction
- [ ] Reading the Concept section
- [ ] The AI investigation
- [ ] Challenging or verifying something the AI told me
- [ ] Answering the Confirm questions
- [ ] Prefer not to answer

### SCA — What should we do with this format?

- [ ] Continue as is. *Tell us more (optional): any suggestions to make it even better?*
- [ ] Adjust something. *Tell us more (optional): what would you change?*
- [ ] Stop, and go back to a traditional homework model. *Tell us more (optional): what didn't work for you?*
- [ ] Prefer not to answer

---

# Grading Rubric

| # | What's being evaluated | Points |
|---|---|---:|
| MC1–MC4 | Correctly identifies the core memory-hierarchy and locality concepts | 20 |
| N1 | States the corrected model: explains why memory access pattern and spatial locality can make operation count alone a poor predictor of runtime | 20 |
| N2 | Provides a specific memory-hierarchy latency comparison for a named processor/family with a credible source | 15 |
| N3 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N4 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N5 | Selects two defensible architecture concepts and correctly explains their connection to the observed performance difference | 10 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
