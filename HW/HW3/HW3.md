# HW3: Same Event, Different Power

## Connect

In Lab3 you built a busy-wait loop and an `ecall`-based button check.

In class, we're going to run two programs side by side. Both blink the same virtual LED the same 10 times, on the same schedule, and print the same `"loop N of 10"` lines.

From the outside, watching the output scroll by, you won't be able to tell which approach each program uses.

Keep what you already know about loops, waiting, and event handling in mind as you watch what happens next.


## Confront

Both programs accomplish the identical task: wait until something happens, then act on it. Neither is buggy. Neither misses the event. If you graded these programs purely on correctness—does the output match what's expected?—they would both receive full credit.

The first program uses **polling**. Watch its iteration count while it waits.

Before we run the second program, make a prediction:

**If the second program produces the same output on the same schedule, what do you expect its iteration count to look like while it waits?**

Write down your prediction before seeing the result:

**My prediction:** ________________________________________________

Now watch the second program.

Here's the assumption we're going to challenge:

> **If two programs accomplish the same task correctly and on the same schedule, it doesn't really matter which approach you use.**

Something about that model doesn't fit what you just watched.

One program executed millions of iterations just to blink an LED 10 times. The other has no iteration count to show between events.

And yet both programs are correct.

If one of these programs were running on a battery-powered sensor, that invisible difference could matter enormously even though a correctness test might never reveal it.

**Don't resolve the difference yet.** First, keep the contradiction in mind:

**Same event. Same visible result. Very different amount of CPU activity. Why should that matter?**


### Instructor Demo

Run both demos before assigning the homework, approximately 5–10 minutes:

```bash
make run-poll
make run-int
```

The runnable demo is in `HW/DEMOS/HW3`; see its `README.md`.

`poll_demo` prints a real running iteration count that climbs into the millions.

`interrupt_demo` has nothing to count between wakeups.

That absence is the point.


### Prerequisites (Ubuntu VM)

Two things are needed: a bare-metal RISC-V ELF toolchain and Renode, the simulator these programs run under.

**1. Bare-metal RISC-V toolchain**

```bash
sudo apt update
sudo apt install gcc-riscv64-unknown-elf
```

This installs binaries prefixed `riscv64-unknown-elf-`. The toolchain can still target the 32-bit ISA used by this demo.

**2. Renode**

```bash
wget https://github.com/renode/renode/releases/latest/download/renode_amd64.deb
sudo apt install ./renode_amd64.deb
```

If that asset name has changed, check Renode's official releases for the current `.deb` package. The demo README contains additional notes about Renode versions and the interrupt source used by this demo.

Verify both are available:

```bash
riscv64-unknown-elf-gcc --version
renode --version
```


## Concept

The difference you observed comes from what the CPU does **while nothing is happening**.

### Polling

A polling CPU repeatedly checks whether an event has occurred.

While it waits, the CPU continues fetching, decoding, and executing instructions. Every trip through that loop represents real instructions and real processor activity even when the answer to the check is still:

> No. Nothing happened yet.

That's what produced the iteration count you saw in the demonstration.


### Interrupt-driven waiting

RISC-V provides a `wfi` (**wait for interrupt**) instruction.

Instead of repeatedly checking for an event, software can arrange for hardware to signal the CPU when something requires attention. The CPU can execute `wfi` while it waits rather than continuously executing a polling loop.

When an enabled interrupt arrives, the processor can resume execution and transfer control to code that handles the event.

| Approach | What the CPU does while waiting |
|---|---|
| Polling | Continuously executes instructions checking for the event |
| Interrupt-driven (`wfi`) | Can remain idle until an interrupt requires attention |

That's enough of the model to begin the investigation.

You already know **what** differed in the demonstration.

Your job now is to figure out:

- why that difference matters physically,
- what hardware makes the interrupt-driven approach possible,
- how large the difference can become on a real device,
- and why engineers don't simply use interrupts for everything.


## Construct

Use any AI assistant for this investigation.

The prompts below are **starting points**, not questions you need to copy word-for-word. Follow the investigation where your understanding requires it.

You are expected to ask follow-up questions when something is unclear, incomplete, surprising, or worth checking.

At least once, you must stop and verify or challenge something the AI tells you. You'll document that moment in Confirm.


### Step 1 — Where does the extra energy go?

Start from what you observed:

A polling loop and an interrupt-driven wait can produce the same visible result, but one keeps the CPU executing while nothing is happening.

Investigate **why continuing to execute those instructions consumes additional power**.

What parts of the processor are still doing work during those millions of `"nothing happened yet"` iterations?

Don't stop at:

> "Polling uses more instructions."

Try to understand what physical activity those instructions cause inside the processor and why that requires energy.


### Step 2 — What makes interrupts possible?

Polling is conceptually simple: software keeps checking.

But if software stops checking, **something else has to notice that the event occurred**.

Investigate what hardware makes interrupt-driven waiting possible.

Among the questions you might explore:

- What is an interrupt controller responsible for?
- How does an event become an interrupt request?
- How does the processor know that it should wake?
- How does it know where to begin executing when an interrupt is accepted?
- What roles do `mtvec`, interrupt-enable state, and the trap handler play?

Follow up wherever the mechanism is still unclear to you.


### Step 3 — Put real numbers on the difference

Now find out whether this difference actually matters in real hardware.

Choose a **specific, named microcontroller** used in an embedded or IoT system—an STM32, ESP32, or another appropriate device.

Find published values for:

- active-mode current draw, and
- an appropriate sleep or low-power mode current draw.

Use a real manufacturer specification or another credible technical source.

Then determine approximately how many times greater the active-mode current is than the low-power value you found.

Don't just collect the numbers. Make sure you understand what operating conditions those numbers describe well enough that the comparison is meaningful.


### Step 4 — Catch the AI

During Steps 1–3, identify **one claim that deserves checking**.

The AI does **not** have to be wrong.

Maybe it gives you:

- a specific current-draw number,
- a claim about `wfi`,
- an explanation of an interrupt controller,
- a statement about what wakes a particular microcontroller,
- or something that simply sounds more certain than you think it should.

Push back.

Ask for more precision, request justification, compare the claim with documentation, inspect another source, or otherwise find evidence that helps you decide whether to accept it.

What matters is not catching the AI making a mistake.

What matters is **noticing when a technical claim deserves verification and knowing what to do next.**


### Step 5 — So why does polling still exist?

At this point, it would be easy to replace one oversimplified model with another:

> **Polling wastes power, so interrupts are always better.**

Don't stop there.

Investigate the other side of the engineering tradeoff.

What does interrupt handling cost?

What does waking from a low-power state cost?

Are there situations where response time, predictability, event frequency, hardware complexity, or some other constraint makes polling reasonable—or even preferable?

By the end of the investigation, you should be able to explain not simply which approach is "better," but:

> **What is the tradeoff, and what kind of system might reasonably choose each approach?**


# Confirm

## Part A: Multiple Choice (5 pts each, 20 pts total)

Circle one.

**MC1.** Why does a polling loop generally draw more power than an interrupt-driven equivalent while waiting?

- A. Polling requires a different arithmetic instruction
- B. The CPU continues fetching and executing check instructions even when nothing has happened, while an interrupt-driven CPU can remain idle
- C. Polling loops use a slower instruction encoding
- D. Interrupts are only available on newer processors


**MC2.** What does the RISC-V `wfi` instruction allow the processor to do?

- A. Check a condition faster
- B. Wait for an interrupt rather than continuously executing a polling loop
- C. Disable all interrupts permanently
- D. Increase its clock speed while waiting


**MC3.** What hardware component is responsible for receiving interrupt requests and signaling the CPU that an event requires attention?

- A. The compiler
- B. The interrupt controller
- C. The register file
- D. The cache hierarchy


**MC4.** Why might a real system deliberately choose polling despite its potential power cost?

- A. Polling is easier to type
- B. Interrupt handling and waking from low-power states have costs, and some applications may value predictable or very fast response enough to justify polling
- C. Interrupts are not supported on RISC-V
- D. Polling always uses less power in practice


## Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement:

> **"Polling and interrupts accomplish the same thing, so it doesn't really matter which one you use."**

Explain what the CPU is doing while waiting in each approach and why that difference matters for power.


### N2 — Put real numbers on it (15 pts)

Give the real active-mode versus sleep/low-power comparison you investigated.

- **Microcontroller:**
- **Active mode:**
- **Sleep/low-power mode:**
- **Active current is approximately _____ times the low-power current:**
- **Source:**


### N3 — Catch the AI (20 pts)

Identify one claim from your AI investigation that you did not simply accept.

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

Remember: there is no requirement that the AI actually be wrong. Good technical investigation means recognizing which claims deserve checking and finding evidence before deciding whether to trust them.


### N4 — Your best follow-up (10 pts)

Look back through your AI conversation.

**What follow-up question most improved your understanding?**

Write the question:

> ________________________________________________________________

In 1–2 sentences, explain **why that question was useful or how it changed/refined your understanding.**


### N5 — Connect back (10 pts)

Check the **two** lecture concepts that most directly explain the engineering tradeoff you investigated.

Write one sentence for each explaining the connection.

- ☐ Interrupt controller
- ☐ `wfi` / low-power wait states
- ☐ Trap vectors and handler dispatch
- ☐ Wake-up latency
- ☐ Privilege mode transitions on interrupt entry


## Appendix — AI Conversation

Paste your full AI chat export.

No cleanup is required. The transcript is not graded for writing quality. It is included as evidence of the investigation you performed.


---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment.

There are no right or wrong answers. All items below are graded on **completion only**, never on the response selected. Selecting **Prefer not to answer** counts as complete.


### B1 — Before

Before this assignment, how well could you explain why a polling loop and an interrupt-driven wait can produce the same outcome but cost very different amounts of power?

1. I could not explain this topic at all; it's new to me and something I'm here to learn.
2. I could name some of the related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not in detail.
4. I had some previous knowledge of this topic and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could effectively explain it coming in.

- ☐ Prefer not to answer


### P1 — After

After this assignment, how well could you explain why a polling loop and an interrupt-driven wait can produce the same outcome but cost very different amounts of power?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to this topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts, but not fully how they connect.
4. I am confident that I could explain this topic well enough to help a fellow classmate understand it.
5. I could explain this topic confidently in a technical discussion with someone knowledgeable about the subject.

- ☐ Prefer not to answer


### INV — What drove your investigation?

Thinking about your AI investigation on this assignment, which statement best describes what **primarily drove your approach**?

Pick the one that fits best.

- ☐ I mainly wanted to complete the required assignment efficiently.
- ☐ I mainly wanted to understand enough to answer the assignment questions correctly.
- ☐ I mainly wanted to resolve something from the demonstration or assignment that didn't make sense to me.
- ☐ I mainly wanted to understand the technical issue well enough that I could explain or apply it beyond this assignment.
- ☐ Something else. *(Optional: tell us what.)*
- ☐ Prefer not to answer


### FAV — What helped most?

Which part of this homework helped you **understand the topic the most**?

Pick one.

- ☐ The in-class demonstration / hook
- ☐ Reading the Concept section
- ☐ The AI investigation
- ☐ Challenging or verifying something the AI told me
- ☐ Answering the Confirm questions
- ☐ Prefer not to answer


### SCA — What should we do with this format?

Thinking about the topic and the process overall, what should we do with this homework format going forward?

- ☐ **Continue as is.** *Tell us more (optional): any suggestions to make it even better?*
- ☐ **Adjust something.** *Tell us more (optional): what would you change?*
- ☐ **Stop, and go back to a traditional homework model.** *Tell us more (optional): what didn't work for you?*
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

*The AI Investigation Skills items may appear only at selected points during the semester rather than on every homework.*


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
| Feedback | Completes the required feedback items; “Prefer not to answer” counts as complete | 5 |

**Total: 100 points.**