# HW3 — Submission Template

This is the only file you need to fill out and submit for HW3. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW3.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** Why does a polling loop generally draw more power than an interrupt-driven equivalent while waiting?

- [ ] A. Polling requires a different arithmetic instruction
- [ ] B. The CPU continues fetching and executing check instructions even when nothing has happened, while an interrupt-driven CPU can remain idle
- [ ] C. Polling loops use a slower instruction encoding
- [ ] D. Interrupts are only available on newer processors

**MC2.** What does the RISC-V `wfi` instruction allow the processor to do?

- [ ] A. Check a condition faster
- [ ] B. Wait for an interrupt rather than continuously executing a polling loop
- [ ] C. Disable all interrupts permanently
- [ ] D. Increase its clock speed while waiting

**MC3.** What hardware component is responsible for receiving interrupt requests and signaling the CPU that an event requires attention?

- [ ] A. The compiler
- [ ] B. The interrupt controller
- [ ] C. The register file
- [ ] D. The cache hierarchy

**MC4.** Why might a real system deliberately choose polling despite its potential power cost?

- [ ] A. Polling is easier to type
- [ ] B. Interrupt handling and waking from low-power states have costs, and some applications may value predictable or very fast response enough to justify polling
- [ ] C. Interrupts are not supported on RISC-V
- [ ] D. Polling always uses less power in practice

---

# Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement: "Polling and interrupts accomplish the same thing, so it doesn't really matter which one you use."

> Your answer:
>
>
>

### N2 — Put real numbers on it (15 pts)

- **Microcontroller:**
- **Active mode:**
- **Sleep/low-power mode:**
- **Active current is approximately _____ times the low-power current:**
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

Check the **two** lecture concepts that most directly explain the engineering tradeoff you investigated, and explain each in one sentence.

- [ ] Interrupt controller — explanation:
- [ ] `wfi` / low-power wait states — explanation:
- [ ] Trap vectors and handler dispatch — explanation:
- [ ] Wake-up latency — explanation:
- [ ] Privilege mode transitions on interrupt entry — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

>

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why a polling loop and an interrupt-driven wait can produce the same outcome but cost very different amounts of power?

1. I could not explain this topic at all; it's new to me and something I'm here to learn.
2. I could name some of the related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not in detail.
4. I had some previous knowledge of this topic and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could effectively explain it coming in.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### P1 — After

After this assignment, how well could you explain why a polling loop and an interrupt-driven wait can produce the same outcome but cost very different amounts of power?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to this topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts, but not fully how they connect.
4. I am confident that I could explain this topic well enough to help a fellow classmate understand it.
5. I could explain this topic confidently in a technical discussion with someone knowledgeable about the subject.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to resolve something from the demonstration or assignment that didn't make sense to me.
- [ ] I mainly wanted to understand the technical issue well enough that I could explain or apply it beyond this assignment.
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

---

# Grading Rubric

| # | What's being evaluated | Points |
|---|---|---:|
| MC1–MC4 | Correctly identifies the four core concepts covered in this homework | 20 |
| N1 | States the corrected model: explains what the CPU is or isn't doing while waiting and why that matters for power | 20 |
| N2 | Provides a real, specific active-mode vs. sleep/low-power current comparison with a credible source | 15 |
| N3 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N4 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N5 | Selects two defensible lecture concepts and correctly explains their connection to the investigated tradeoff | 10 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
