# HW5 — Submission Template

This is the only file you need to fill out and submit for HW5. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW5.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** Why isn't a real digital circuit's output instantly correct when an input changes?

- [ ] A. Digital circuits occasionally stop executing
- [ ] B. Physical signals require nonzero time to propagate through transistors, gates, and interconnect
- [ ] C. The processor waits for software permission before changing the output
- [ ] D. Propagation delay exists only in simulators

**MC2.** What does it mean to say that combinational hardware operates in parallel?

- [ ] A. Every gate waits for the previous gate in the schematic to finish
- [ ] B. Gates throughout the circuit continuously respond to their inputs, so activity can occur in many parts of the circuit simultaneously
- [ ] C. Every signal in the circuit becomes valid at exactly the same time
- [ ] D. Hardware executes one Verilog statement per clock cycle

**MC3.** Why does the critical path limit a synchronous circuit's maximum safe clock frequency?

- [ ] A. It is the path containing the most lines of Verilog
- [ ] B. The clock period must leave enough time for the slowest required combinational path to produce a safely usable result before it is captured
- [ ] C. The critical path determines how much memory the program uses
- [ ] D. The clock automatically waits whenever the critical path is slow

**MC4.** Why do designers use timing margins rather than assuming every physical chip has exactly the same propagation delay?

- [ ] A. Gate timing can vary with process, voltage, temperature, load, and other physical conditions
- [ ] B. Digital logic has no predictable timing behavior at all
- [ ] C. Each instruction uses a randomly selected clock frequency
- [ ] D. Timing margins are needed only in simulations

---

# Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement: "Hardware performs a computation the same way I trace software: one operation finishes, its answer becomes immediately correct, and then the next operation begins."

> Your answer:
>
>
>

### N2 — Make the timing real (15 pts)

- **Device / technology:**
- **Timing quantity:**
- **Reported value or range:**
- **Conditions, if given:**
- **Why this number matters to a designer:**
- **Source:**

### N3 — Timing isn't one exact number (10 pts)

**Factor 1:**

**Why it matters:**

**Factor 2:**

**Why it matters:**

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

Check the **two** concepts that most directly changed how you think about the difference between software and hardware, and explain each in one sentence.

- [ ] Propagation delay — explanation:
- [ ] Parallel / concurrent hardware behavior — explanation:
- [ ] Critical path / worst-case timing — explanation:
- [ ] Clock period and synchronous sampling — explanation:
- [ ] Process / voltage / temperature variation — explanation:
- [ ] Combinational versus sequential logic — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

>

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why hardware cannot simply be understood as software operations happening directly in physical circuits?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the software-to-hardware difference coming in.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### P1 — After

After this assignment, how well could you explain why hardware cannot simply be understood as software operations happening directly in physical circuits?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain propagation delay, parallel behavior, and clocks individually but not fully how they connect.
4. I am confident I could explain the software-to-hardware transition well enough to help a fellow classmate understand it.
5. I could confidently explain and defend how physical timing changes the way hardware must be designed in a technical discussion.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** ___

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to resolve why the hardware behaved differently from the software model I was used to.
- [ ] I mainly wanted to understand hardware timing well enough that I could reason about circuits beyond this assignment.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] Comparing the software model with the in-class hardware demonstration
- [ ] Seeing the arbitrary / too-fast / safe sampling demonstrations
- [ ] Reading the Concept section
- [ ] The AI investigation
- [ ] Challenging or verifying something the AI told me
- [ ] Connecting the investigation back to circuits I built in Lab5
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
| MC1–MC4 | Correctly identifies the core concepts behind physical hardware timing | 20 |
| N1 | Corrects the software mental model using parallel hardware behavior, propagation delay, and synchronous sampling | 20 |
| N2 | Provides a specific real hardware timing quantity with a credible source and explains its significance | 15 |
| N3 | Identifies two real sources of timing variation and explains why designers must account for them | 10 |
| N4 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N5 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N6 | Selects two defensible concepts and correctly connects them to the software-to-hardware transition | 5 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
