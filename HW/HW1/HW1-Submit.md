# HW1 - Lillian Kager

This is the only file you need to fill out and submit for HW1. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW1.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** Why could a richer instruction set be attractive to a programmer writing assembly directly?

- [x] A. It can express some operations with fewer architectural instructions and less hand-written code
- [ ] B. It guarantees every program will execute faster
- [ ] C. It eliminates the need for registers
- [ ] D. It guarantees lower processor power

**MC2.** What is a micro-operation (µop)?

- [x] A. A simplified internal operation used by modern processors when executing decoded architectural instructions
- [ ] B. A separate 16-bit RISC-V instruction
- [ ] C. A compiler optimization pass
- [ ] D. A type of cache miss

**MC3.** What changed that reduced the importance of designing an ISA primarily for humans writing assembly directly?

- [ ] A. Instruction count stopped mattering completely
- [x] B. Optimizing compilers became capable of automatically performing much of the instruction selection, register allocation, scheduling, and optimization work
- [ ] C. Modern processors stopped executing machine code
- [ ] D. RISC architectures added x86-compatible instructions

**MC4.** What is one consequence of supporting a variable-length, highly expressive architectural instruction set such as x86-64?

- [x] A. The processor may require substantial front-end hardware to identify, decode, and translate instructions into operations the execution machinery can handle efficiently
- [ ] B. Every instruction must take exactly the same number of cycles
- [ ] C. Memory operands require no internal memory access
- [ ] D. Compilers are no longer useful

---

# Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement: "RISC is just better because simpler instructions make a simpler processor."

> Your answer:
>
>
>

### N2 — Make the tradeoff real (15 pts)

- **Processor, product, or workload:**
- **Architecture involved:**
- **Design consideration you investigated:**
- **What the architecture buys in this example:**
- **What it costs or trades away:**
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

Check the **two** RISC-V design choices from lecture that most directly connect to the architectural tradeoff you investigated, and explain each in one sentence.

- [ ] Fixed 32-bit base instruction width — explanation:
- [ ] Load/store model — explanation:
- [ ] Register-only ALU operations — explanation:
- [ ] 32 general-purpose registers — explanation:
- [ ] Regular/separated instruction formats such as R-type and I-type — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

>

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why x86-64 and RISC-V make such different choices about instruction complexity?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge of this topic and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the architectural tradeoff to someone else.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### P1 — After

After this assignment, how well could you explain why x86-64 and RISC-V make such different choices about instruction complexity?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts but not fully how they connect into an architectural tradeoff.
4. I am confident I could explain the tradeoff well enough to help a fellow classmate understand it.
5. I could confidently explain and defend the tradeoff in a technical discussion with someone knowledgeable about processor architecture.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to resolve something from the demonstration or assignment that didn't make sense to me.
- [ ] I mainly wanted to understand the architectural tradeoff well enough that I could explain or apply it beyond this assignment.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] The in-class demonstration / hook
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
| MC1–MC4 | Correctly identifies the four core concepts covered in this homework | 20 |
| N1 | States the corrected model: explains what richer and simpler ISA approaches buy and how compiler-generated code changed the tradeoff | 20 |
| N2 | Provides a specific modern example, identifies the architectural consideration, and explains both what it buys and what it trades away with a credible source | 15 |
| N3 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N4 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N5 | Selects two defensible RISC-V design choices and correctly explains their connection to the investigated tradeoff | 10 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
