# HW4 — Submission Template

This is the only file you need to fill out and submit for HW4. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW4.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** Why does RISC-V make most extensions optional rather than putting every capability into the mandatory base ISA?

- [ ] A. The extensions were unfinished
- [ ] B. Different processors can implement only the capabilities that provide value for their target products
- [ ] C. Optional extensions execute faster than mandatory instructions
- [ ] D. RISC-V prevents different processors from using different hardware

**MC2.** Which is a real cost of adding hardware floating point to a small processor?

- [ ] A. Only the software compiler becomes more complicated
- [ ] B. Hardware area, verification effort, power, and manufacturing cost
- [ ] C. Floating-point instructions become incompatible with integer instructions
- [ ] D. There is no meaningful cost after the ISA is defined

**MC3.** Which processor is most likely to omit the F extension?

- [ ] A. A low-cost, high-volume microcontroller that performs mostly integer control work
- [ ] B. A processor designed for computation-heavy scientific workloads
- [ ] C. A high-end application processor intended to run a full OS and graphics workloads
- [ ] D. All processors are equally likely to omit F

**MC4.** What is the main architectural tradeoff behind optional extensions?

- [ ] A. Faster instructions are always better, so every extension should be mandatory
- [ ] B. A capability can provide significant benefits for some workloads while imposing costs on every implementation that supports it
- [ ] C. Optional extensions exist mainly to make assembly programming harder
- [ ] D. Hardware extensions matter only when software is poorly optimized

---

# Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement: "If hardware support makes an operation much faster, every processor should include that hardware."

> Your answer:
>
>
>

### N2 — Make the hardware cost real (15 pts)

- **Extension / hardware feature:**
- **Processor or core:**
- **Cost you investigated:**
- **Reported value:**
- **What the number means:**
- **Source:**

### N3 — Find the design decision in the real world (10 pts)

- **Processor/core without F/D:**
- **Processor/core with F/D:**
- **What each is designed for:**
- **Why the extension choice makes sense for each:**

### N4 — Catch the AI (20 pts)

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

### N5 — Your best follow-up (10 pts)

**Your follow-up question:**

>

**Why that question was useful, or how it changed/refined your understanding (1–2 sentences):**

>

### N6 — Connect back (5 pts)

Check the **two** lecture concepts that most directly explain the design decision you investigated, and explain each in one sentence.

- [ ] ISA extensions and modular instruction-set design — explanation:
- [ ] Hardware versus software implementation of an operation — explanation:
- [ ] Die area / transistor budget — explanation:
- [ ] IEEE-754 floating-point representation — explanation:
- [ ] Hardware verification as an engineering constraint — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

>

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why a useful hardware capability such as floating point might be optional rather than mandatory in a processor architecture?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the reasoning behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the design tradeoff coming in.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### P1 — After

After this assignment, how well could you explain why a useful hardware capability such as floating point might be optional rather than mandatory in a processor architecture?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts but not fully how they connect into a design tradeoff.
4. I am confident I could explain the tradeoff well enough to help a fellow classmate understand it.
5. I could confidently explain and defend the tradeoff in a technical discussion with someone knowledgeable about processor architecture.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to understand why a processor designer might deliberately leave useful hardware out.
- [ ] I mainly wanted to understand the design tradeoff well enough that I could explain or apply it to other processors or systems.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] The in-class demonstration / prediction
- [ ] Reading the Concept section
- [ ] The AI investigation
- [ ] Challenging or verifying something the AI told me
- [ ] Looking at real processors and their design choices
- [ ] Answering the Confirm questions
- [ ] Prefer not to answer

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
| MC1–MC4 | Correctly identifies the core concepts behind modular ISA design and extension tradeoffs | 20 |
| N1 | States the corrected model: identifies a concrete extension cost and explains why the tradeoff differs between products | 20 |
| N2 | Provides a specific quantitative hardware-cost figure for a named processor/core with a credible source | 15 |
| N3 | Compares real processors/cores with different extension choices and explains why those choices fit their intended products | 10 |
| N4 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N5 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N6 | Selects two defensible lecture concepts and correctly explains their connection to the investigated design choice | 5 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
