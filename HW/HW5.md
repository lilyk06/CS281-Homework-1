# HW5: Your Code Runs One Line at a Time. Your Circuit Doesn't.

## Connect

For the first half of this course, we've mostly looked downward from software.

You wrote instructions.

You followed loads and stores.

You compared instruction sets.

You investigated caches, interrupts, and ISA extensions.

Even when the hardware underneath became complicated, the programming model remained comfortable:

```c
int a = 1;
int b = 0;
int c = a + b;
```

You know how to trace this.

First `a` gets a value.

Then `b`.

Then the addition happens.

Then `c` contains the answer.

That sequential model is so natural to a programmer that you probably don't even think of it as a model anymore.

Now we're going to cross an important boundary in this course:

> **We're going underneath the instructions and looking at the hardware that makes them possible.**

And some of the assumptions that worked extremely well for software are about to stop working.


# Confront

Put yourself back in the software world:

```c
int a = 1;
int b = 0;
int c = a + b;
```

After the last statement executes, what is `c`?

Obviously:

```text
1
```

Now replace the software addition with the full-adder circuit you built in Lab5.

Same idea:

**inputs go in → addition happens → answer comes out.**

So let's change an input.

Before watching the circuit, make a prediction:

> **Once the input changes, when is the new output safe to use?**

- ☐ Immediately
- ☐ After a tiny but predictable amount of time
- ☐ Only after we know the circuit has had enough time to settle
- ☐ I'm not sure yet

Now watch Demo 1.

The input has already changed.

But when we read the output shortly afterward, the circuit can still report the **old answer**.

Nothing is broken.

Wait longer.

Now the answer becomes correct.

That's strange enough.

Now let's make it worse.

We'll put a flip-flop after the same circuit and give it a real clock.

Run the clock too fast.

The flip-flop can capture a value **before the circuit has finished producing the correct answer**.

The register doesn't know it captured something wrong.

It simply stores what was present when the clock edge arrived.

Now run the exact same circuit with the exact same inputs again.

Change only the clock period.

Every result is correct.

So here's the software assumption we're going to challenge:

> **Computation happens in a sequence of completed steps, and once an operation happens, its result is immediately available and correct.**

That's a useful abstraction for software.

It is not how physical combinational logic behaves.

In hardware:

**everything is active at once, signals take time to move through logic, and when you look can matter just as much as what computation you're performing.**

That's the gap we're going to investigate.


### Instructor Demo

The instructor will run three demonstrations in class using the same gate-level full adder.

**Demo 1 — No coordination**

The inputs change and the circuit is sampled at several arbitrary times.

Some reads happen before the circuit has settled and return stale or transient results.

**Demo 2 — Clock too fast**

A flip-flop samples the adder using a clock whose period is shorter than the circuit's safe timing requirement.

Some samples are incorrect.

**Demo 3 — Clock with enough time**

Same circuit.

Same inputs.

Only the clock timing changes.

Every sample is now correct.

The demo source, Verilog, waveforms, and instructions for running it yourself are available in `HW/DEMOS/HW5` if you'd like to explore them, but **running the demo yourself is not required for this homework**.


# Concept

The first major difference between software reasoning and hardware reasoning is simple:

> **Hardware exists in physical time.**


### Gates don't change instantaneously

A logic gate is built from physical transistors connected by physical conductors.

Those circuits have electrical properties such as resistance and capacitance.

Changing an input therefore doesn't cause the output voltage to teleport instantaneously from one valid value to another.

It takes time.

That time is called **propagation delay**.


### Delays accumulate through logic

Now consider the full adder from the demonstration:

```text
sum  = a ^ b ^ cin

cout = (a & b) | (cin & (a ^ b))
```

An input change may have to travel through multiple gates before reaching an output.

One gate takes some time.

Then the next gate reacts.

Then another.

A signal path containing several dependent gates can therefore take longer to settle than a shorter path.


### Everything isn't waiting its turn

This is another major break from software intuition.

In a program, we usually reason about:

```text
statement 1
then statement 2
then statement 3
```

Combinational hardware doesn't execute its gates in source-code order.

Every gate is continuously responding to its current inputs.

Different signals can therefore be moving through different parts of the circuit **at the same time**.

That's parallelism at the physical level.

It also means different paths through the same circuit can finish at different times.


### So what does the clock do?

A clock does **not** make the combinational logic instantaneous.

It gives the system agreed-upon moments when state is allowed to be captured.

A simplified synchronous path looks like:

```text
register
    |
    v
combinational logic
    |
    v
register
```

The first register changes its output.

The combinational logic begins reacting.

Signals propagate through different paths.

Eventually the result settles.

Then—and only then—should the next register capture it.

The clock period must therefore provide enough time for the relevant logic path to complete safely.


### The critical path

Not every path through a circuit takes the same amount of time.

The longest timing-sensitive combinational path between state elements is called the **critical path**.

That path places a fundamental limit on how quickly the design can safely be clocked.

A shorter clock period can increase performance.

But if the next clock edge arrives before the required signals are safely ready, the design is no longer guaranteed to work correctly.


### And real chips aren't perfectly identical

Our classroom simulation assigns fixed delays to gates so the behavior is easy to see and repeat.

Real silicon is messier.

Timing can be affected by things such as:

- manufacturing variation,
- supply voltage,
- temperature,
- capacitive load,
- transistor characteristics,
- and the exact path a signal travels.

Two physical chips built from the same design therefore aren't assumed to have one magically identical propagation delay for every path under every condition.

Digital designers handle this by designing against timing requirements and bounds with appropriate margin—not by assuming every operation always physically settles after one exact universal amount of time.

That's enough of the model to begin investigating.

Now you need to figure out:

- what is physically happening while a signal propagates,
- why hardware naturally operates in parallel,
- how designers determine a safe clock period,
- what happens when timing assumptions are violated,
- and why the clocked counter from Lab5 worked even though the uninitialized latch briefly showed an undefined state.


# Construct

Use any AI assistant for this investigation.

The prompts below are **starting points**, not questions you need to copy word-for-word.

Follow the investigation where your understanding requires it.

Ask follow-up questions when something is unclear, incomplete, surprising, or worth checking.

At least once, you must stop and verify or challenge something the AI tells you. You'll document that moment in Confirm.


### Step 1 — What is happening during propagation delay?

Start with the most basic physical question:

> **Why can't the output of a real logic gate change instantaneously when its input changes?**

Investigate what is physically happening inside the circuit during propagation delay.

You might explore:

- transistor switching,
- capacitance,
- resistance,
- charging and discharging nodes,
- voltage thresholds,
- rise time and fall time.

Don't worry about becoming an analog circuit designer.

The goal is to understand why propagation delay is a **physical consequence of real hardware**, not an inconvenience invented by a simulator.


### Step 2 — What does "everything happens in parallel" actually mean?

Software trains us to think sequentially.

Hardware description languages can even look sequential when written as text.

But combinational hardware is physically active all at once.

Investigate what engineers mean when they say hardware operates **concurrently or in parallel**.

Ask yourself:

- If two independent gates have their inputs change at the same time, which gate runs first?
- If two paths through a circuit have different numbers or kinds of gates, must their outputs become valid at the same time?
- What happens when one downstream gate depends on signals arriving through two paths with different delays?
- How is this different from executing two lines of software one after another?

Try to build a mental model of the circuit as a network of things reacting simultaneously rather than a list of operations waiting their turn.


### Step 3 — How fast can the clock safely run?

Now connect propagation delay to the clock.

Investigate how a synchronous digital designer determines a safe clock period.

You should encounter ideas such as:

- combinational delay,
- critical path,
- clock-to-Q delay,
- setup time,
- timing margin.

You don't need to memorize a timing equation.

Instead, be able to explain the logic behind it:

> **What must finish happening between one clock edge and the next?**

Then push the tradeoff in both directions:

**What happens if the clock is too fast?**

and

**What is the downside of making it much slower than necessary?**


### Step 4 — Is the timing always exactly the same?

Our Verilog demonstration deliberately uses fixed gate delays so we can reproduce the same waveform every time.

Real hardware doesn't operate under one perfectly fixed condition.

Investigate why propagation delay can vary.

Consider:

- manufacturing/process variation,
- voltage,
- temperature,
- load,
- different signal paths,
- rise versus fall behavior.

Then answer a deeper question:

> **If physical timing varies, how can engineers build processors that behave reliably?**

Look for concepts such as worst-case timing, timing analysis, design margin, or PVT corners.

The important insight is not that digital hardware is random.

It's that **reliable digital behavior is engineered on top of physical components whose timing is not perfectly identical under every condition.**


### Step 5 — Catch the AI

During Steps 1–4, identify **one claim that deserves checking**.

The AI does **not** have to be wrong.

It might give you:

- a propagation-delay number,
- an explanation of setup time,
- a claim about transistor switching,
- a statement about maximum clock frequency,
- a claim about process/voltage/temperature variation,
- or something that sounds more universal than you think it should.

Push back.

Ask for more precision, request evidence, compare the explanation with a credible source, or otherwise investigate whether the claim deserves your confidence.

What matters isn't proving the AI wrong.

What matters is recognizing:

> **"This explanation sounds reasonable, but hardware depends on details. What evidence supports it?"**


### Step 6 — Why did the Lab5 circuits behave so differently?

Return to something you've already built.

In Lab5, your cross-coupled NAND circuit could initially show an undefined state before you forced it into a known condition.

Later, you built a clocked counter that behaved predictably.

Investigate how those observations connect to what you've learned here.

Ask:

- Why can feedback make initialization tricky?
- Why does a state element need a known starting condition?
- What role does the clock play once the counter is operating?
- Why doesn't the clock eliminate propagation delay?
- What timing assumption allows the counter to work correctly anyway?

By the end of the investigation, you should be able to explain:

> **Why does hardware need explicit coordination when software usually lets us pretend each operation simply finishes before the next one begins?**


# Confirm

## Part A: Multiple Choice (5 pts each, 20 pts total)

Circle one.


**MC1.** Why isn't a real digital circuit's output instantly correct when an input changes?

- A. Digital circuits occasionally stop executing
- B. Physical signals require nonzero time to propagate through transistors, gates, and interconnect
- C. The processor waits for software permission before changing the output
- D. Propagation delay exists only in simulators


**MC2.** What does it mean to say that combinational hardware operates in parallel?

- A. Every gate waits for the previous gate in the schematic to finish
- B. Gates throughout the circuit continuously respond to their inputs, so activity can occur in many parts of the circuit simultaneously
- C. Every signal in the circuit becomes valid at exactly the same time
- D. Hardware executes one Verilog statement per clock cycle


**MC3.** Why does the critical path limit a synchronous circuit's maximum safe clock frequency?

- A. It is the path containing the most lines of Verilog
- B. The clock period must leave enough time for the slowest required combinational path to produce a safely usable result before it is captured
- C. The critical path determines how much memory the program uses
- D. The clock automatically waits whenever the critical path is slow


**MC4.** Why do designers use timing margins rather than assuming every physical chip has exactly the same propagation delay?

- A. Gate timing can vary with process, voltage, temperature, load, and other physical conditions
- B. Digital logic has no predictable timing behavior at all
- C. Each instruction uses a randomly selected clock frequency
- D. Timing margins are needed only in simulations


## Part B: Show What You Learned


### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement:

> **"Hardware performs a computation the same way I trace software: one operation finishes, its answer becomes immediately correct, and then the next operation begins."**

Your answer should reference **parallel hardware activity, propagation delay, and the role of the clock**.


### N2 — Make the timing real (15 pts)

Find one real quantitative example related to digital timing.

This might be:

- propagation delay for a real logic device,
- setup time for a real flip-flop,
- clock-to-Q delay,
- a timing specification from a processor or FPGA technology,
- or another directly relevant hardware timing value.

Record:

- **Device / technology:**
- **Timing quantity:**
- **Reported value or range:**
- **Conditions, if given:**
- **Why this number matters to a designer:**
- **Source:**


### N3 — Timing isn't one exact number (10 pts)

Based on your Step 4 investigation:

Name **two physical factors** that can change propagation delay in real hardware.

For each, briefly explain why a digital designer must account for it.

**Factor 1:**

**Why it matters:**


**Factor 2:**

**Why it matters:**


### N4 — Catch the AI (20 pts)

Identify one claim from your AI investigation that you did not simply accept.

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

Remember: there is no requirement that the AI actually be wrong. Good technical investigation means recognizing which claims deserve checking and finding evidence before deciding whether to trust them.


### N5 — Your best follow-up (10 pts)

Look back through your AI conversation.

**What follow-up question most improved your understanding?**

Write the question:

> ________________________________________________________________

In 1–2 sentences, explain **why that question was useful or how it changed or refined your understanding.**


### N6 — Connect back (5 pts)

Check the **two** concepts that most directly changed how you think about the difference between software and hardware.

Write one sentence for each explaining the connection.

- ☐ Propagation delay
- ☐ Parallel / concurrent hardware behavior
- ☐ Critical path / worst-case timing
- ☐ Clock period and synchronous sampling
- ☐ Process / voltage / temperature variation
- ☐ Combinational versus sequential logic


## Appendix — AI Conversation

Paste your full AI chat export.

No cleanup is required. The transcript is not graded for writing quality. It is included as evidence of the investigation you performed.


---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment.

There are no right or wrong answers. All items below are graded on **completion only**, never on the response selected. Selecting **Prefer not to answer** counts as complete.


### B1 — Before

Before this assignment, how well could you explain why hardware cannot simply be understood as software operations happening directly in physical circuits?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the software-to-hardware difference coming in.

- ☐ Prefer not to answer


### P1 — After

After this assignment, how well could you explain why hardware cannot simply be understood as software operations happening directly in physical circuits?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain propagation delay, parallel behavior, and clocks individually but not fully how they connect.
4. I am confident I could explain the software-to-hardware transition well enough to help a fellow classmate understand it.
5. I could confidently explain and defend how physical timing changes the way hardware must be designed in a technical discussion.

- ☐ Prefer not to answer


### INV — What drove your investigation?

Thinking about your AI investigation on this assignment, which statement best describes what **primarily drove your approach**?

Pick the one that fits best.

- ☐ I mainly wanted to complete the required assignment efficiently.
- ☐ I mainly wanted to understand enough to answer the assignment questions correctly.
- ☐ I mainly wanted to resolve why the hardware behaved differently from the sequential software model I was used to.
- ☐ I mainly wanted to understand hardware timing well enough that I could reason about circuits beyond this assignment.
- ☐ Something else. *(Optional: tell us what.)*
- ☐ Prefer not to answer


### DEMO — Did the demonstration create a useful question?

After seeing the propagation-delay and clock-timing demonstrations, how strongly did you want to understand **why the same circuit could produce incorrect or correct sampled results depending only on when its output was observed?**

1. Not at all — the result did not make me curious about the reason.
2. Slightly — I noticed the behavior but was not particularly motivated to investigate it.
3. Moderately — I wanted to understand the basic explanation.
4. Strongly — the result made me want to understand what was physically happening inside the hardware.
5. Very strongly — the result made me want to investigate beyond what the assignment required.

- ☐ Prefer not to answer


### FAV — What helped most?

Which part of this homework helped you **understand the software-to-hardware transition the most**?

Pick one.

- ☐ Comparing the software model with the in-class hardware demonstration
- ☐ Seeing the arbitrary / too-fast / safe sampling demonstrations
- ☐ Reading the Concept section
- ☐ The AI investigation
- ☐ Challenging or verifying something the AI told me
- ☐ Connecting the investigation back to circuits I built in Lab5
- ☐ Answering the Confirm questions
- ☐ Prefer not to answer


### SCA — What should we do with this format?

Thinking about the topic and the process overall, what should we do with this homework format going forward?

- ☐ **Continue as is.** *Tell us more (optional): any suggestions to make it even better?*
- ☐ **Adjust something.** *Tell us more (optional): what would you change?*
- ☐ **Stop, and go back to a traditional homework model.** *Tell us more (optional): what didn't work for you?*
- ☐ Prefer not to answer


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

**Assignment Total: 100 points**

**Feedback: +5 free points**