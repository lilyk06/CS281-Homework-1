# HW5 — Lillian Kager

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
- [x] B. Physical signals require nonzero time to propagate through transistors, gates, and interconnect
- [ ] C. The processor waits for software permission before changing the output
- [ ] D. Propagation delay exists only in simulators

**MC2.** What does it mean to say that combinational hardware operates in parallel?

- [ ] A. Every gate waits for the previous gate in the schematic to finish
- [x] B. Gates throughout the circuit continuously respond to their inputs, so activity can occur in many parts of the circuit simultaneously
- [ ] C. Every signal in the circuit becomes valid at exactly the same time
- [ ] D. Hardware executes one Verilog statement per clock cycle

**MC3.** Why does the critical path limit a synchronous circuit's maximum safe clock frequency?

- [ ] A. It is the path containing the most lines of Verilog
- [x] B. The clock period must leave enough time for the slowest required combinational path to produce a safely usable result before it is captured
- [ ] C. The critical path determines how much memory the program uses
- [ ] D. The clock automatically waits whenever the critical path is slow

**MC4.** Why do designers use timing margins rather than assuming every physical chip has exactly the same propagation delay?

- [x] A. Gate timing can vary with process, voltage, temperature, load, and other physical conditions
- [ ] B. Digital logic has no predictable timing behavior at all
- [ ] C. Each instruction uses a randomly selected clock frequency
- [ ] D. Timing margins are needed only in simulations

---

# Part B: Show What You Learned

### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement: "Hardware performs a computation the same way I trace software: one operation finishes, its answer becomes immediately correct, and then the next operation begins."

> Your answer: Hardware does not execute computations one operation at a time like a software trace. Instead, multiple gates operate concurrently as electrical signals propagate through the circuit. Their outputs take a finite amount of time to become stable because transistors must charge and discharge capacitance, therefore creating propagation delays. In synchronous circuits, a clock is what determines when results are sampled, which allows enough time for signals to settle before the next operation is captured.

### N2 — Make the timing real (15 pts)

- **Device / technology:** Texas Instruments SN74LVC74A, a dual positive-edge-triggered D-type flip-flop.
- **Timing quantity:** Clock-to-Q propagation delay (tpd) and data setup time (tsu).
- **Reported value or range:** At 3.3 V, clock-to-Q propagation delay is 5.2 ns maximum, and data setup time is 3 ns minimum.
- **Conditions, if given:** Vcc = 3.3 V += 0.3 V, operating temperature of -40°C to 125°C, with a 50 pF load and 500 Ω load resistance for the propagation delay measurement.
- **Why this number matters to a designer:** These values help to determine the minimum safe clock period, because a signal needs time to travel from the launching flip-flop through combinational logic and satisfy the receiving flip-flop's setup requirement before the next clock edge. Designers need to account for the maximum propagation delay and required setup time to avoid timing violations.
- **Source:** Texas Instruments, SN74LVC74A datasheet, revision SCAS287W, Sections 5.8 and 5.11, pages 7-8. Official TI datasheet. https://www.ti.com/lit/ds/symlink/sn74lvc74a.pdf

### N3 — Timing isn't one exact number (10 pts)

**Factor 1:** Supply voltage

**Why it matters:** Lower supply voltage generally reduces transistor drive current, therefore causing transistors to charge and discharge capacitance more slowly and increasing propagation delay. This can reduce the maximum safe clock frequency.

**Factor 2:** Temperature.

**Why it matters:** Temperature changes the transistor properties, including carrier mobility and threshold voltage, which can effect switching speed. Higher temperatures often increase delay, but the relationship is not always consistent because different physical effects can compete.

### N4 — Catch the AI (20 pts)

- **What the AI claimed:** The AI initially claimed that lowering the supply voltage generally increases propagation delay because transistors have less drive current.
- **Why you questioned it or wanted more precision:** I wanted to determine whether or not this was actually supported by real hardware specifications rather than assuming that a general physical trend simply applied to every device and operating condition.
- **What you did to check it:** I investigated the Texas Instruments SN74LVC74A datasheet and compared its clock-to-Q propagation delay and data setup time at 2.7 V and 3.3 V. I also examined the specifications at 1.8 V and 2.5 V to see whether or not the same pattern appeared across all the voltage levels.
- **What you concluded:** The datasheet supports the AI's claim when comparing 2.7 V and 3.3 V: clock-to-Q maximum delay increases from 5.2 ns to 6 ns, while minimum data setup time increases from 3 ns to 3.4 ns. However, the 2.5 V specifications do not follow the same pattern, demonstrating that these values cannot just establish a universal relationship between voltage and timing. I learned that it is important to distinguish general physical trends from guaranteed specifications for a particular device.

### N5 — Your best follow-up (10 pts)

**Your follow-up question:**

> Does increasing temperature always make a digital circuit slower? Explain how temperature affects transistor mobility, threshold voltage, and resistance. Why might the effect differ depending on supply voltage? Also explain why a designer needs to consider temperature when checking timing reliability.

**Why that question was useful, or how it changed/refined your understanding (1–2 sentences):**

> This question helped me to understand that physical factors do not always affect circuit timing in a straightforward or predictable way. I learned that increasing temperature can sometimes make a circuit faster depending on the relationship between transistor mobility, threshold voltage, and supply voltage, which is why designers need to evaluate different operating conditions rather than assume one universal timing trend.

### N6 — Connect back (5 pts)

Check the **two** concepts that most directly changed how you think about the difference between software and hardware, and explain each in one sentence.

- [x] Propagation delay — explanation: Physical signals do not change instantly because transistors need finite time to charge and discharge capacitance, meaning that hardware operations take time even when no software instruction is waiting.
- [x] Parallel / concurrent hardware behavior — explanation: Unlike software instructions that usually execute in a defined sequence, multiple hardware gates can operate simultaneously, with signals propagating through different paths at different speeds.
- [ ] Critical path / worst-case timing — explanation:
- [ ] Clock period and synchronous sampling — explanation:
- [ ] Process / voltage / temperature variation — explanation:
- [ ] Combinational versus sequential logic — explanation:

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

**I'm learning about the differences between software execution and physical hardware behavior. I understand how to trace software instructions sequentially, but I am trying to understand why that mental model doesn't fully apply to digital circuits. Starting with the basics: Why can't a real logic gate change its output instantaneously when its input changes? Can you explain what's physically happening inside the circuit during propagation delay? I would especially like to understand the roles of transistors, resistance, capacitance, and charging/discharging. Please explain it in an intuitive way, with a simple example.**

Your software mental model works because each instruction “finishes” before the next begins. A logic gate has no such notion of finishing. It’s a physical object whose output voltage is always moving toward whatever the inputs currently demand, and moving takes time.

The core idea: outputs are charged capacitors
Every wire and every transistor input has capacitance. Think of the output of a gate as a small bucket of charge:

Bucket full (voltage high) = logic 1
Bucket empty (voltage low) = logic 0
A voltage can’t jump, because changing it means moving charge into or out of that bucket, and charge moves through resistance at a finite rate. That’s the whole story. Everything else is detail.

Example: a CMOS inverter
An inverter has two transistors acting as switches:

A PMOS transistor connecting the output to the supply (VDD). It conducts when the input is low.
An NMOS transistor connecting the output to ground. It conducts when the input is high.
The output also connects to a load capacitance C. This is the sum of the wire’s capacitance and the input capacitance of whatever gates it feeds. Nobody drew it on the schematic, but it’s physically there.

Initial state: input = 0. The PMOS is on, the NMOS is off. The output sits at VDD, and the capacitor C is full.

Now the input switches to 1. Here is what happens in order:

The input itself isn’t instant. The input voltage ramps over some finite time because it comes from a previous gate that is also charging or discharging something.
The transistors respond only once the input crosses their threshold voltage. A MOSFET doesn’t flip like a light switch. The channel forms gradually as the gate voltage rises past roughly Vth, and conducts more strongly the further past it goes. Likewise, the PMOS channel fades out as the input rises.
The NMOS turns on, but it isn’t a perfect wire. An “on” transistor behaves like a resistor, call it R (typically hundreds of ohms to kilohms in a small transistor). It’s a good conductor compared to “off,” but not zero resistance.
The full capacitor now discharges through that resistance to ground. Charge drains from C through the NMOS, and the output voltage falls.
The discharge curve
Draining a capacitor through a resistor gives the classic exponential:

V(t) = VDD · e^(−t / RC)

The fall is fast at first, when there’s a big voltage pushing current, and slows as the voltage shrinks, because the driving force is smaller. The time constant RC sets the scale.

Intuition for each piece:

Larger R (weaker transistor, narrower channel) means a narrow drain pipe, so draining takes longer.
Larger C (longer wire, more gates attached, called fan-out) means a bigger bucket, so more charge to move and a longer wait.
Propagation delay is usually defined as the time from the input crossing 50% to the output crossing 50%. For a simple RC model that’s roughly 0.69 · RC.
The rising output transition is the mirror image. The PMOS turns on, and current flows from VDD through the PMOS’s resistance to fill the capacitor.

A water analogy
Picture a tank (the capacitance) with a pipe to a drain (ground) and another pipe to a reservoir (VDD). Each pipe has a valve (the transistor). Opening the drain valve doesn’t make the water level drop instantly. It drains at a rate set by pipe width (R) and tank size (C). The valve also takes a moment to open. Both effects add up to the delay you observe.

Why this breaks the sequential mental model
Some consequences that have no software analogue:

There is no “step.” The circuit is continuously evolving. A gate output is not a variable assigned once; it’s a quantity being driven toward a target at all times.
Different paths take different times. If one input of a gate arrives through a long chain of gates and another through a short one, the output sees them at different moments. For a brief window it may compute on inconsistent inputs and glitch. In software, all operands are ready when the instruction executes.
The clock exists because of this. Synchronous design is a deliberate trick: wait long enough for the slowest path to settle, then sample everything at once. The clock period must exceed the worst-case sum of propagation delays (plus setup time), which is why critical path analysis is a core design task.
Speed costs energy. Every transition moves charge C·VDD, dissipating roughly ½·C·VDD² per switch. Faster (smaller R, bigger transistors) means larger transistors, which adds capacitance to the previous stage. Designers constantly trade these off.
Summary
A gate’s output can’t change instantly because changing a voltage means changing the charge stored on capacitance, and charge can only flow through the finite resistance of transistors that are themselves switching gradually. Propagation delay is the time that RC charging or discharging takes to carry the output across the logic threshold.

If you want to go further, a good next step is to look at what happens when inputs of a gate change at slightly different times (hazards and glitches), or at how setup and hold times in flip-flops follow directly from this same RC behavior.

**That makes sense. I want to understand the parallel aspect more now. If combinational hardware doesn't execute one gate at a time, what actually determines when each gate responds to an input change? For example, if you had two independent gates receive changing inputs at the same time, but one feeds into a longer chain of gates than the other. Do both gates begin responding simultaneously? Does one gate have to wait for another? Why could signals traveling through different paths reach their destinations at different times? What happens if a downstream gate receives one updated input before another? Can you walk me through a simple example and compare it to how I would normally trace the equivalent software?**

Short answers first
Do both gates start responding simultaneously? Yes. Every gate is always reacting to its own inputs, with no scheduler deciding whose turn it is.
Does one gate wait for another? No. A gate never waits for anything. It only looks like waiting because a downstream gate’s input hasn’t changed yet.
Why do paths arrive at different times? Each gate along the way adds its own propagation delay (the RC behavior from before), so a longer chain accumulates more delay.
What if a gate sees one new input before the other? It computes its function on the mixture of new and old values, and its output may briefly show a result that no consistent input state would produce. That’s a glitch.
The mental shift
In software, ordering comes from the program: statement 2 runs after statement 1 because you wrote it that way.

In hardware, there is no program order. Ordering comes only from physical cause and effect along wires. A gate responds when its input voltage crosses its threshold, and that’s the only trigger. Gate B is “after” gate A only if A’s output wire is B’s input wire. If two gates have no wire between them, they’re unordered and run truly concurrently.

So the useful question isn’t “which gate runs next?” but “when does each input voltage change, and how long does each gate take to react?”

A worked example
Consider the function Out = A AND (NOT A). Logically that’s always 0.

          ┌──────────────── P ────────────┐
A ────────┤                               ├──► [AND] ──► Out
          └──► [NOT] ──── Q ──────────────┘
Assume each gate has a 1 ns propagation delay and wires are instant (a simplification, but it makes the logic clear).

Start: A = 0, so P = 0, Q = 1, Out = 0. Stable.

At t = 0, A rises to 1. Follow what each piece does:

Time	P (A directly)	Q (after inverter)	Out (AND)	What’s happening
0 ns	1	1	0	A changed. P follows immediately. The inverter starts reacting, but Q hasn’t moved yet.
0–1 ns	1	1	0	The AND sees (1, 1) and starts to respond.
1 ns	1	0	1	Q finally falls. Meanwhile the AND’s response to (1, 1) appears, so Out rises.
2 ns	1	0	0	The AND now responds to (1, 0), and Out falls back.
The output pulses to 1 for about 1 ns, even though the logic says it should stay 0. The AND gate didn’t malfunction. It correctly computed its function on the inputs it saw at each moment. Those inputs were briefly inconsistent because one copy of A traveled through an extra gate.

This directly answers your question: the AND received the “new A” on one input before the “new NOT A” arrived on the other, and for that window it computed on a state that never exists in the logical description.

Two independent gates, different chain lengths
Suppose A and B both change at t = 0. A feeds a chain of three gates, and B feeds one gate. Both chains feed a final gate G.

At t = 0, the first gate of each chain starts reacting at the same time.
B’s chain finishes at about 1 gate delay. A’s finishes at about 3.
G sees B’s new value at ~1 ns and A’s new value at ~3 ns. Between those, it computes on half-updated inputs.
G’s output is only trustworthy after the slowest arriving input has settled, around 3 ns plus G’s own delay.
That slowest path is the critical path, and it sets how fast the clock can run.

Real delays vary with more than gate count: wire length (more RC), fan-out (more load capacitance), transistor sizing, how sharply the input is ramping, rising vs. falling transitions, and even temperature and supply voltage.

Comparison with tracing the software
python
a = 1
q = not a
out = a and q   # always False
You trace it top to bottom. Each line completes before the next starts, a and q are consistent when out is computed, and the result is always False. There is no moment where out is True.

In hardware, all three “lines” exist simultaneously as physical circuitry, and each is continuously recomputing. When a changes, out is computed from whatever a and q voltages exist at that instant, not from a consistent snapshot.

There’s a neat bridge between the two worlds: hardware simulators (like those for Verilog/VHDL) are themselves software, and they model this with an event queue. Instead of running lines in order, they schedule “this signal changes at time T” events and propagate them forward. Tracing a circuit by hand means doing the same thing: write down when each signal changes, not what order lines execute.

What actually happens to a glitch
Two things can happen to a glitch, and both matter in practice:

It can be filtered out. A gate is an RC system, so a very short pulse may not give the output enough time to cross its threshold before the input reverses. Gates inherently ignore pulses much shorter than their own delay. Your 1 ns glitch only survives if it’s comparable to or longer than the gate’s response time.
It can be harmless or harmful depending on who’s listening. If the output goes into more combinational logic that settles before anyone looks, nobody cares. If it goes to something that reacts to any edge, like a flip-flop clock input, an asynchronous reset, or a latch enable, a glitch can cause a real error.
Why clocks fix this
This is the payoff for the whole idea. A synchronous design says: “Ignore everything until the clock edge. Make sure all paths have settled before then.” Glitches in the middle of a clock period are harmless because nothing samples the signals while they’re settling. The design rule becomes:

clock period ≥ slowest path delay + setup time of the capturing flip-flop

That inequality is the hardware replacement for “line 2 runs after line 1.” Instead of ordering by instruction sequence, you order by time: give the signals long enough to settle, then capture them together.

A good next step would be to look at what happens when the capture edge arrives too early (setup violation) and why that can produce metastability, which is the same RC physics showing up again at the flip-flop.

**Ok great. I think I understand that gates operate concurrently, but their outputs do not necessarily become valid at the same time because signals travel through paths with different propagation delays. I want to connect this to synchronous circuits and clocks, especially the flip-flops weve been working with. Can you explain how a designer determines the minimum safe clock period for a circuit? I want to understand: What exactly is the critical path, and why does the slowest path determine the clock speed? What are clock-to-Q delay and setup time, and how do they contribute to the timing requirement? What physically happens if a flip-flop captures an input before the combinational logic has settled? Why can't the clock just make the circuit operate faster? Is there a disadvantage to making the clock period a lot longer than necessary? Please use a simple register -> combinational logic -> register example, and connect it to clocked circuits. Explain the reasoning rather than just giving me a timing equation.**

Short answers first
Critical path: the register-to-register path with the longest total delay. It sets the clock period because the clock is shared, so it must be slow enough for the worst path.
Clock-to-Q and setup: two fixed costs paid on every path. Clock-to-Q is the delay before a flip-flop’s new output appears. Setup is how long the next flip-flop needs its input to be stable before the capturing edge.
Capturing too early: the flip-flop’s internal feedback loop gets an input that’s neither clearly 0 nor 1, and it may take an unpredictable time to resolve (metastability) or latch the wrong value.
Why not just run the clock faster? Because the clock doesn’t make signals travel faster. It only changes how long you wait.
Downside of a very long period? Nothing breaks logically, but you waste performance (and in some cases, hold-time and power concerns work differently; more below).
The example circuit
        ┌─────┐            ┌──────────────┐            ┌─────┐
 D1 ───►│ FF1 │──► Q1 ────►│ Combinational │──► D2 ───►│ FF2 │──► Q2
        └──▲──┘            │    logic      │            └──▲──┘
           │               └──────────────┘               │
CLK ───────┴──────────────────────────────────────────────┘
FF1 launches data, the combinational logic computes something from it, and FF2 captures the result. Both flip-flops share one clock.

What actually happens in one clock cycle
Follow one piece of data across the path:

Clock edge arrives at FF1 (t = 0). FF1 samples its input and begins updating its output. The new value of Q1 does not appear instantly. Inside the flip-flop, internal transistors must switch and charge or discharge capacitance, exactly the RC story from earlier. This delay is clock-to-Q (t_cq).
Q1 changes and ripples through the logic. Each gate adds its propagation delay, and the signal takes the slowest route through the logic. This total is t_logic.
The signal arrives at D2 and must sit there, stable, for a little while before the next clock edge. This is setup time (t_setup).
Next clock edge arrives at FF2 (t = T). FF2 captures whatever is at D2.
For FF2 to capture the correct new value, the data must have arrived and settled before the capturing edge:

t_cq + t_logic + t_setup ≤ T

You can read it as a timeline: launch delay, then computation, then a safety margin, all of which must fit inside one clock period. That’s the whole equation, and every term has a physical meaning.

Why setup time exists
A flip-flop is not a magic sampler. Internally it’s typically two latches (master and slave) built from cross-coupled gates, which is a circuit with feedback. When the clock edge arrives, the master stage must charge or discharge its internal node to a firm 0 or 1 based on D, and it needs a little time to do so.

If D is still changing right up to the edge, the internal node hasn’t had time to be pulled to a solid level. Setup time is the minimum stable time the internal circuitry needs to commit reliably. It’s another RC settling requirement, just inside the flip-flop.

Why the slowest path sets the clock
A real design has many register-to-register paths, some short (a few gates) and some long (an adder chain, say). All flip-flops typically share the same clock edge.

Suppose path X takes 2 ns total and path Y takes 5 ns. If you choose T = 3 ns, X is fine, but at the capturing edge Y’s result is still in transit. The capturing flip-flop grabs a half-settled value, which is a wrong answer, and nothing in the circuit warns you.

So the rule is simple: T must be at least the maximum of all path delays, because every path must make it. One slow path anywhere fixes the speed of the whole chip. That longest path is the critical path. This is why designers spend so much effort restructuring the critical path (splitting it with extra registers, which is pipelining, using faster adder structures, upsizing transistors) rather than optimizing paths that already have slack.

Slack is the term for the margin: slack = T − (t_cq + t_logic + t_setup). Positive slack means the path is safe. Negative slack means a timing violation.

What physically happens when you violate setup
There are two possible failure modes.

1. Wrong value captured. If the new data hasn’t arrived at all, FF2 simply latches the old value (or a glitchy intermediate one). The circuit behaves as if the computation never happened. This is a clean logical error.

2. Metastability. If D2 changes very close to the clock edge, inside the flip-flop’s decision window, the internal cross-coupled latch can be left at a voltage between the two valid levels. Picture a ball balanced on top of a hill between two valleys. The feedback loop will eventually push it toward 0 or 1, but how long that takes depends on how precisely balanced it was. Starting very near the balance point, resolution can take much longer than normal, and the output can sit at an invalid voltage for a while, which downstream gates may interpret inconsistently.

The key point is that this isn’t a logic bug you can reason around. It’s physics: a feedback circuit forced to decide on an input that arrived at the worst possible moment. Designers can’t eliminate it, only make the failure probability astronomically small (for example, with synchronizer chains at clock-domain boundaries).

Why you can’t simply speed up the clock
The clock is just a signal that says “capture now.” It does not accelerate any gate. Gate delay is set by transistor resistance and load capacitance, which the clock doesn’t change. Shortening T just means the capture edge arrives earlier, while the data is physically no faster, so you eventually cross into negative slack.

What actually raises the maximum clock rate is reducing t_cq + t_logic + t_setup: shorter logic depth per stage (pipelining), faster transistors (better process, higher voltage), lower capacitance (shorter wires, less fan-out), and so on. Each of these has costs. Higher voltage and faster switching raise power sharply (recall switching energy of roughly ½CV² per transition, so power scales with frequency and V²), and pipelining adds registers, area, and latency in cycles.

Is a longer clock period a problem?
Logically, setup is trivially satisfied, so the circuit works. The disadvantages:

Wasted performance. Most of the cycle is spent idle, waiting for a capture edge when the data settled long ago. Throughput is one result per cycle, so a slower clock means fewer results per second.
Hold-time is not fixed by a slower clock. This is a common misconception. Hold time is a separate requirement: the input must stay stable for a short time after the clock edge. It concerns whether the new data from FF1 races through a very fast path and reaches FF2 too soon after the same edge, corrupting the value FF2 is still capturing. That depends on the fastest path and clock skew, not on T. So a longer period doesn’t rescue a hold violation, which is why hold violations are fixed by adding delay on short paths, not by slowing the clock.
Dynamic power per operation doesn’t fall as you might hope. Slowing the clock lowers power per second (fewer transitions per second), but energy per useful operation stays about the same, and leakage current keeps flowing for the whole longer duration, so energy per operation can actually get worse.
(Lowering the clock deliberately is still a legitimate power-saving technique, for example in idle states, but that’s a trade-off made on purpose.)

Connecting back to software
In software you’d say each instruction takes some cycles and the CPU handles ordering. Here, the clock period is the budget for the slowest stage of work, and the designer’s job is to guarantee the budget is met on every path, under worst-case conditions. This is static timing analysis: tools sum delays along every path and report slack, without simulating any input values, because the guarantee must hold for all possible data.

A natural next step is hold time and clock skew, since they show the opposite failure: data arriving too early instead of too late.

**I definitely understand how a circuit's critical path determines its minimum safe clock period. But I'm still wondering how designers can make reliable timing guarantees when real chips don't all actually behave the same. Can you explain how manufacturing/process variation, supply voltage, temperature, and capacitive load affect propagation delay? I'd specifically like to understand: Why two chips built from the same design could have different delays? How does lower supply voltage affect transistor switching? Does higher temperature always make a circuit slower? What are PVT corners and worst-case timing analysis? How do designers use timing margins to ensure a processor or digital circuit works reliably? Please distinguish between general trends and actual rules, since I do not want to assume every physical condition effects every circuit in the same exact way. Give me a practical example if possible.**

Short answers first
Same design, different delays: manufacturing is never perfectly repeatable, so each transistor’s threshold voltage, channel length, and oxide thickness vary slightly, which changes its drive current and therefore the “R” in RC.
Lower supply voltage: transistors turn on less strongly, so they charge and discharge capacitance more slowly. Delay rises, and it rises steeply as VDD approaches the threshold voltage.
Hotter always slower? No. Heat usually slows circuits, but under some conditions it speeds them up (temperature inversion).
PVT corners: a set of deliberately extreme combinations of process, voltage, and temperature at which the design is checked, so that timing is guaranteed across the whole range rather than at one typical point.
Margins: designers sign off with positive slack at every required corner, then add extra safety for effects the corners don’t capture (clock jitter, local variation, aging, voltage droop).
1. Why identical designs behave differently
The layout is identical, but the physical devices aren’t. Variation comes in layers:

Lot-to-lot, wafer-to-wafer, die-to-die (global variation): across a whole die, transistors tend to be systematically a bit faster or slower. Doping, etching, and thickness drift slightly between wafers and across a wafer.
Within-die (local or on-chip variation): neighboring transistors differ from each other. Causes include random dopant fluctuation (a tiny channel contains only a handful of dopant atoms, so the count varies randomly), rough edges on printed features, and small differences in gate length.
Interconnect variation: metal width, thickness, and dielectric spacing vary too, so wire R and C change along with transistor behavior.
In the RC picture, these variations change the transistor’s effective on-resistance (through drive current) and the capacitances. A device with a slightly higher Vth has less overdrive, so it drives less current and the node charges more slowly.

This is why chips are speed-binned: after manufacturing, parts are tested and the fast ones are sold at higher clock ratings. One design produces a distribution of speeds, not a single speed.

Trend vs. rule: variation is a statistical trend. Which individual transistor is fast or slow is random, and the amount of variation depends heavily on the process node (smaller devices generally have larger relative variation).

2. Lower supply voltage
Switching a node means moving charge Q = C·VDD, supplied by the transistor’s current I. So a rough estimate of delay is:

delay ≈ C · VDD / I

Lower VDD helps the numerator a little, but it hurts the denominator much more. Drive current depends on the overdrive (VDD − Vth). A common approximation, the alpha-power law, says I ∝ (VDD − Vth)^α, with α somewhere between about 1 and 2 depending on the device (closer to 1 in modern short-channel transistors).

So if VDD drops from, say, 1.0 V to 0.8 V while Vth is about 0.35 V, the overdrive shrinks from 0.65 V to 0.45 V, which is a 30% drop in overdrive that shows up as an even larger drop in current. The delay increases noticeably.

Why designers accept this anyway: dynamic power scales roughly with V², so lowering voltage saves a lot of power. That’s the idea behind dynamic voltage and frequency scaling (DVFS). You trade speed for power deliberately.

Trend vs. rule: “lower V means slower” is dependable in the normal operating range. The exact exponent isn’t a universal rule. It depends on the device, and near threshold (close to Vth) delay becomes extremely sensitive to both voltage and variation.

3. Does higher temperature always slow things down?
No, because two effects compete:

Carrier mobility drops as temperature rises. Electrons and holes scatter more, so for a given overdrive the transistor conducts less current. This slows the circuit.
Threshold voltage drops as temperature rises. A lower Vth means more overdrive, so the transistor conducts more. This speeds the circuit up.
Which effect wins depends on the supply voltage:

At high VDD (large overdrive), the mobility loss dominates, so hot is slower. This is the classic expectation.
At low VDD (overdrive is small), the Vth reduction dominates, so hot can actually be faster. This is called temperature inversion, and it’s common in modern low-voltage processes.
Other temperature effects:

Wire resistance increases with temperature, so interconnect gets slower when hot regardless of the transistor behavior.
Leakage current rises steeply with temperature, which doesn’t directly change propagation delay but increases power, which raises temperature further.
Trend vs. rule: “hotter is slower” is a common trend, not a rule. This is exactly why modern signoff can’t assume the hot corner is always the slowest.

4. Capacitive load
Back to the earlier RC model: delay grows with load capacitance, to first order:

delay ≈ intrinsic delay + R · C_load

The load comes from:

Fan-out: every gate input attached to the output adds gate capacitance.
Wire capacitance: longer wires add more.
Coupling to neighboring wires (crosstalk): if a neighbor switches in the opposite direction at the same time, the effective coupling capacitance can appear up to about twice as large (the Miller effect), slowing your signal. If it switches in the same direction, it can appear smaller and speed you up. So even identical wires can have different delay depending on what the neighbors are doing.
Trend vs. rule: linear dependence on load is a good first-order model. Real delay also depends on the input slew (how sharply the input ramps), and long wires have distributed RC, where delay grows roughly with the square of length if unbuffered, which is why designers insert repeater buffers in long wires.

5. PVT corners and worst-case analysis
You can’t check every chip individually, so you check the edges of the expected range. A corner is one specific combination:

Process: slow (SS: both NMOS and PMOS slow), typical (TT), fast (FF), and skewed corners (SF, FS) where NMOS and PMOS differ.
Voltage: nominal, plus or minus a tolerance (say ±10%), covering regulator tolerance and expected droop.
Temperature: typically cold (e.g., −40 °C) and hot (e.g., 125 °C).
There are also interconnect corners (wires with the worst RC, or the worst capacitance) since wires vary independently of transistors.

The key idea is that setup and hold stress opposite corners:

Check	What fails	Worst-case corner
Setup (data arrives too late)	The longest path is too slow	Slow process, low voltage, and whichever temperature is slowest (hot or cold, given temperature inversion)
Hold (data changes too early)	The shortest path is too fast	Fast process, high voltage, and the temperature that makes things fastest
This ties back to your earlier question about hold time: fixing a hold violation means adding delay on short paths, and the design must be checked at the fast corner, where short paths are fastest.

Modern flows run multi-corner multi-mode (MCMM) analysis, checking many corner combinations and operating modes (functional, test, low-power) simultaneously.

An important caveat: corners are chosen boundaries, not physical limits. A typical corner might represent roughly “3σ slow” in process, chosen to give a target yield. A rare chip could still be slower than the slow corner, which is why it’s discarded or binned lower in testing.

6. Timing margins
Passing at each corner is the starting point. Designers then protect against effects that corners don’t fully capture:

Clock uncertainty: jitter (cycle-to-cycle timing noise on the clock) and skew (different arrival times at different flip-flops) are subtracted from the available period.
On-chip variation (OCV) derating: within one die, the launching path might be slightly faster and the capturing path slightly slower than the corner assumes. Analysis applies pessimistic factors, or more refined statistical methods (AOCV/POCV), to cover this.
Voltage droop and IR drop: when many gates switch at once, the local supply sags briefly, slowing nearby logic below what the nominal voltage predicts.
Aging: mechanisms like bias temperature instability slowly raise Vth over years of operation, so a chip that passes on day one must still pass after years. Designers reserve margin for it.
Crosstalk and signal-integrity effects discussed above.
Beyond design-time margin, there’s test-time and run-time adaptation:

Chips are tested at speed and binned, as mentioned.
Some processors use on-chip delay monitors (ring oscillators or replica critical paths) to adjust voltage or frequency dynamically, running fast chips faster or at lower voltage and slow chips safer.
Every margin costs something. More margin means a safer chip but a slower clock or higher power, so over-margining is a real design trade-off, not free safety.

A practical (illustrative) example
These numbers are invented to show the reasoning, not taken from a real process. Suppose a register-to-register path has these total delays (t_cq + t_logic + t_setup) at different corners:

Corner	Setup path delay
FF, 1.1 V, −40 °C (fast)	0.80 ns
TT, 1.0 V, 25 °C (typical)	1.00 ns
SS, 0.9 V, 125 °C (slow)	1.40 ns
For setup, the SS corner is the one that matters. Add 0.1 ns of clock uncertainty and OCV derating, and you need T ≥ about 1.5 ns, so roughly 667 MHz.

A typical chip could probably run at around 1.1 ns (about 900 MHz) at nominal conditions, but that’s not a guarantee for every chip under every condition. The ~1.5 ns clock is what lets the design be guaranteed across the whole range. The gap between 1.1 and 1.5 ns is the price of reliability. Speed binning, adaptive voltage, and tighter statistical analysis exist partly to win some of that gap back.

For hold, you’d check the shortest path at the FF corner. Suppose the shortest path is 0.10 ns there, and the flip-flop’s hold requirement plus skew totals 0.12 ns. That path fails hold, and no clock-period change fixes it. The fix is to insert delay (a buffer) on that short path, and you’d then re-check that this added delay doesn’t hurt setup elsewhere.

Summary of trends vs. rules
Dependable principles: delay is set by how fast transistors can move charge onto capacitance, and every PVT factor works by changing either the available current or the capacitance.
General trends (usually, not always): lower voltage slows circuits, higher temperature slows them (with exceptions), larger load slows them, and smaller devices vary more.
Not safe to assume: that the hot corner is the slowest, that all paths slow down by the same factor (different gates and wires respond differently), or that corners represent absolute physical limits.
A natural next step is statistical timing analysis (why treating every variation as worst-case simultaneously is too pessimistic, and how POCV models it), or clock distribution and skew, since the clock network itself is subject to all these same variations.

**Great, now I want to connect everything that i have learned to an actual piece of digital hardware. Can you find a real flip-flop or logic device and identify a numerical timing specification from its manufacturer's datasheet? I'm specifically interested in propagation delay or setup time because they connect directly to the critical path and clock timing that we just discussed.Please provide: Exact device name and manufacturer, the specific timing parameter being measured, the actual numerical value or range, the operating conditions, including supply voltage and temperature, (if possible), whether the value is typical, maximum, or minimum, the exact page or table in the manufacturer's datasheet, a direct link to the original datasheet, and why this specification matters when designing a synchronous circuit.Please use a real manufacturer's datasheet, and NOT a third-party summary. If you cant verify a value, say so rather than guessing.**

Looking up the datasheet figure.
I’ll look for a TI flip-flop datasheet, since TI publishes full timing tables, and read the values from the manufacturer’s PDF itself.

I used the Texas Instruments SN74LVC74A dual positive-edge-triggered D-type flip-flop, taken directly from TI’s own PDF (revision SCAS287W, December 2024).

Parameter 1: Clock-to-Q propagation delay (t_pd)
Field	Value
Device / manufacturer	SN74LVC74A, Texas Instruments
Parameter	t_pd, propagation delay from CLK to Q or Q̄
Value	5.2 ns maximum
Supply voltage	V_CC = 3.3 V ± 0.3 V (3.0 to 3.6 V)
Temperature	T_A = –40 °C to 125 °C
Load conditions	C_L = 50 pF, R_L = 500 Ω, measured at the 1.5 V (50%) point (Section 6, page 9)
Min / typ / max	Maximum. No typical value is given in this table.
Location	Section 5.11, “Switching Characteristics: SN74LVC74A, –40°C to 125°C and –40°C to 85°C,” page 8. The same 5.2 ns figure appears in the Features list on page 1.
For the narrower –40 °C to 85 °C range at 3.3 V, the same table gives 1 ns min / 5.2 ns max. At V_CC = 2.7 V it gives 6 ns max, so lower voltage is slower, as we discussed.

Parameter 2: Setup time (t_su)
Field	Value
Parameter	t_su, data setup time before CLK↑
Value	3 ns minimum
Conditions	V_CC = 3.3 V ± 0.3 V, T_A = –40 °C to 125 °C
Location	Section 5.8, “Timing Requirements: SN74LVC74A, –40°C to 125°C and –40°C to 85°C,” page 7
The same table gives t_su = 3.4 ns at V_CC = 2.7 V, and hold time t_h = 1 ns for 2.7 V and 3.3 V. Section 5.7 (page 6) lists setup of 2.3 ns at 2.5 V and 3.6 ns at 1.8 V, so setup time also grows as voltage drops.

Link: https://www.ti.com/lit/ds/symlink/sn74lvc74a.pdf (product page: https://www.ti.com/product/SN74LVC74A)

What I could and couldn’t verify
The text I read from the PDF lost its column positions, so I’m treating the setup and hold numbers as minimums because that’s what those parameters mean by definition. The only value in that table that is a maximum is the clock frequency.
In the 125 °C row for t_pd at 3.3 V, the extracted text shows only “5.2” with no minimum, while the neighboring rows show “1” and a max. I can’t tell from my copy whether the minimum was omitted or dropped in extraction. The 5.2 ns maximum is confirmed by the Features list.
The datasheet gives the limits but not how TI derived them. I can’t tell you how process variation was folded in.
Why this matters for a synchronous design
These two numbers are the fixed costs we put into the timing equation, t_cq + t_logic + t_su ≤ T.

Setup budget. If this flip-flop is both the launching and the capturing register, the worst-case fixed overhead is 5.2 + 3 = 8.2 ns (my arithmetic, not a datasheet value). At a 10 ns clock period (the 100 MHz limit in Section 5.8), only about 1.8 ns remains for combinational logic, before allowing for clock skew or jitter. This is the “price of reliability” idea in concrete numbers. The designer uses the guaranteed maximum, not a typical number.

Why one range: the datasheet gives a single guarantee across 3.0 to 3.6 V and –40 to 125 °C instead of separate corners. That is the datasheet-level version of worst-case analysis, where the slowest combination of voltage and temperature sets the limit.

Load matters: the 5.2 ns is only guaranteed at 50 pF. Figures 5-1 and 5-2 (page 8) show delay rising with load capacitance, which is the C in the RC picture. A heavier load than the test condition isn’t covered by the guarantee.

Hold check: the 1 ns minimum t_pd (valid in the –40 to 85 °C row) against the 1 ns hold requirement leaves zero margin if one of these flip-flops feeds another directly. Any clock skew that delays the capturing flip-flop’s clock would eat into that, which is why hold analysis uses the fast limit and is independent of clock period. That is my own arithmetic, and a real design would also account for skew and the actual path.

A caution about summing: adding 5.2 + 3 gives 8.2 ns, or about 122 MHz. But the datasheet lists 150 MHz for the –40 to 85 °C case, so you can’t derive f_max by adding the other limits. I can’t tell from the datasheet how f_max was measured, so use f_max as its own spec and treat the sum as a conservative design budget.

Sources:

TI SN74LVC74A datasheet (SCAS287W)
TI SN74LVC74A product page

**You explained earlier that lowering the supply voltage generally increases propagation delay because transistors have less drive current.
Now that we have identified / investigated the TI SN74LVC74A, I want to check that claim against its actual datasheet. Compare the clock-to-Q propagation delay at 2.7 V and 3.3 V. Compare the data setup time at those same voltages. Do the datasheet values actually support the claim that lower voltage increases delay? Are these guaranteed limits or typical measurements? What can we conclude from this one device, and what would be an overgeneralization?Please use the actual datasheet values and explain any limitations in the comparison.**

Short answer
Yes, for 2.7 V versus 3.3 V the datasheet supports the direction of the claim, but only as guaranteed limits, not measured behavior. The 1.8 V and 2.5 V rows show the table is not a clean voltage sweep.

1 and 2: The numbers you asked for (same datasheet, SCAS287W)
Both rows are for T_A = –40 °C to 125 °C and use the same test load (50 pF, 500 Ω, 1.5 V reference).

Parameter	2.7 V	3.3 V ± 0.3 V	Change
CLK→Q t_pd, max (Section 5.11, p. 8)	6 ns	5.2 ns	+0.8 ns (+15%)
PRE/CLR→Q t_pd, max (Section 5.11)	6.4 ns	5.4 ns	+1.0 ns (+19%)
Data setup t_su, min (Section 5.8, p. 7)	3.4 ns	3 ns	+0.4 ns (+13%)
PRE/CLR inactive setup, min (Section 5.8)	2.2 ns	2 ns	+0.2 ns (+10%)
The supply drop from 3.3 V to 2.7 V is about 18%. All four parameters move in the same direction, which is the pattern the earlier claim predicts.

3: Does this support the claim?
Directionally, yes. Four independent limits all get worse at the lower voltage, with identical load and temperature range.

It does not confirm the mechanism or the steepness. Two points can’t verify the alpha-power law or the “delay rises sharply near threshold” statement. A 15% rise for an 18% voltage drop looks modest, but this device is presumably operating well above threshold. The datasheet doesn’t give its threshold voltage, so I can’t check that.

4: Limits or typical values?
These are guaranteed limits: a maximum for t_pd and a minimum requirement for t_su, both stated “over recommended operating free-air temperature range.” There are no typical values in these tables. The only typical data in the datasheet are the load-capacitance curves in Section 5.13, taken at 3 V and 25 °C, which don’t show voltage dependence. The datasheet doesn’t say whether each limit comes from production test or characterization.

The rest of the table complicates the picture
Here are all four voltages from the same datasheet (Sections 5.7, 5.8, 5.10, 5.11; test conditions from Section 6, p. 9):

V_CC	t_pd max	t_su min	Test load
1.8 V ± 0.15 V	7.1 ns	3.6 ns	30 pF, 1 kΩ
2.5 V ± 0.2 V	4.4 ns	2.3 ns	30 pF, 500 Ω
2.7 V	6 ns	3.4 ns	50 pF, 500 Ω
3.3 V ± 0.3 V	5.2 ns	3 ns	50 pF, 500 Ω
The 2.5 V row has lower limits than 3.3 V, which contradicts a simple “lower voltage means slower” reading. The load difference (30 pF versus 50 pF) could plausibly explain part of the t_pd gap, but it can’t explain setup time, since setup is an internal flip-flop requirement and doesn’t depend on the output load. The datasheet doesn’t explain this. One observation, which is my inference: the 2.7 V and 3.3 V setup and hold limits in the SN74 table are numerically identical to those in the SN54LVC74A table (Section 5.6), so these limits may be shared across the two grades rather than measured separately for each voltage.

5: What we can and can’t conclude
Reasonable conclusions

On this device, TI guarantees slower clock-to-Q and larger setup requirements at 2.7 V than at 3.3 V.
A design that must work at 2.7 V has to budget about 0.8 ns more for clock-to-Q and 0.4 ns more for setup than one limited to 3.0 to 3.6 V.
Overgeneralizations to avoid

“Delay scales with voltage by about this ratio.” The ratio of limits is not the ratio of actual delays. Real parts are generally faster than their maximum, and the margin isn’t necessarily the same at each voltage.
“Every voltage step behaves this way.” The 2.5 V row breaks the pattern.
“This isolates the voltage effect.” The 3.3 V ± 0.3 V row covers 3.0 to 3.6 V, while 2.7 V is a single point, so the 3.3 V limit already includes the weakest case at 3.0 V. Also, the 1.5 V reference point is 56% of the supply at 2.7 V but 45% at 3.3 V, so the two delays aren’t measured to the same fraction of the swing.
“This validates the temperature discussion.” Both rows span the same –40 to 125 °C range. The datasheet doesn’t say which temperature produces the worst case at each voltage, so it can’t confirm or refute temperature inversion.
“All logic families or modern processes behave this way.” This is one 3.3 V-class CMOS family. The physical trend is general, but these numbers are not.
Sources:

TI SN74LVC74A datasheet (SCAS287W)

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

**Your answer (1–6):** _3_

### P1 — After

After this assignment, how well could you explain why hardware cannot simply be understood as software operations happening directly in physical circuits?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain propagation delay, parallel behavior, and clocks individually but not fully how they connect.
4. I am confident I could explain the software-to-hardware transition well enough to help a fellow classmate understand it.
5. I could confidently explain and defend how physical timing changes the way hardware must be designed in a technical discussion.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** _5_

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to resolve why the hardware behaved differently from the software model I was used to.
- [x] I mainly wanted to understand hardware timing well enough that I could reason about circuits beyond this assignment.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] Comparing the software model with the in-class hardware demonstration
- [ ] Seeing the arbitrary / too-fast / safe sampling demonstrations
- [ ] Reading the Concept section
- [x] The AI investigation
- [ ] Challenging or verifying something the AI told me
- [ ] Connecting the investigation back to circuits I built in Lab5
- [ ] Answering the Confirm questions
- [ ] Prefer not to answer

### SCA — What should we do with this format?

- [x] Continue as is. *Tell us more (optional): any suggestions to make it even better?*
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
