# HW5 Demos: Propagation Delay, Made Concrete

## The mental model this demo is built to break

Ask a CS student to trace this:

```c
int a = 1;
int b = 0;
int c = a + b;
```

They'll say: line 1 happens, then line 2, then line 3, then `c` is 3.
One thing at a time, in order, each one finished and correct before
the next begins, and a bit is just a 0 or a 1, nothing in between.
That model is right enough for software that it never gets
questioned, and it is exactly backwards for the hardware underneath
it.

Open Logisim, wire up `a + b`, and it will confirm the software model
instead of correcting it: change an input, and the output updates,
instantly and correctly, as far as you can see. That's not because
hardware actually works that way, it's because Logisim isn't a
timing-accurate simulator, it settles a circuit's logic values without
modeling how long real gates take to actually produce them. A student
walks out of Lab5 having built real gates with their own hands and
still holding the software mental model, because nothing they saw
contradicted it.

The Verilog demos here are built specifically to contradict it, on the
same circuit, gate for gate. Change an input and the output does not
update instantly: `sum` and `cout` sit at their old, wrong values for a
real, measurable stretch of time, then update, one gate's worth of
delay at a time, not all at once. Two inputs changing "at the same
time" genuinely race each other through the circuit instead of both
being simply true simultaneously. And the reason a real bit isn't just
"0 or 1" is physical, not philosophical: a wire has real resistance,
driving a real load capacitance, and that RC combination cannot change
voltage instantly, it charges and discharges along a curve, spending
real time at voltages that are neither a clean 0 nor a clean 1. That's
the actual, physical reason the demos below show garbage reads, settle
windows, and asymmetric rise/fall edges, not a simulator quirk layered
on top for effect.

This is the "ah-ha" this homework is built around: the moment a
student notices that `int c = a + b;` and a Verilog full adder are
running the exact same arithmetic on the exact same logic, and only
one of those two worlds gets to treat it as instantaneous and ordered.
Everything below, no clock, clock too fast, clock done right, is a
different angle on that same single fact.

## Three demos, meant to be shown in order

**Demo 1** is a single, unchained full adder (the exact circuit Lab5
Part 2 has you build by hand), run with deliberately inflated gate
delays. It compares reading its output on a fast, arbitrary schedule
(a "naive" sampler, no idea whether the circuit has settled) against
reading it only after a known safe delay (a "coordinated" sampler, a
clock, in miniature). The naive column shows real wrong answers, not
implied ones. The coordinated column is always right.

**Demo 2** puts a real clock on the same circuit: a D flip-flop
samples `sum`/`cout` on every rising edge, with `CLK_PERIOD` set
shorter than the adder's worst-case settle time. The clock's edge can
land while the answer is still settling, and the flip-flop captures
whatever it happens to be at that exact instant, right or wrong, with
total confidence either way.

**Demo 3** is identical to Demo 2 except `CLK_PERIOD` has real margin
above the worst-case settle time. Every edge lands after the adder has
had enough time to finish, so every sample is correct. Demos 2 and 3
together are the actual point of a clock, made provable rather than
asserted: a clock doesn't make a circuit faster, it defines a pattern
of moments to look, and whether that pattern is safe is a direct,
measurable comparison between `CLK_PERIOD` and the circuit's
propagation delay, nothing else.

Logisim shows you the final, correct answer instantly in every one of
these scenarios, because it isn't a timing-accurate simulator, it
settles a circuit's logic values without modeling how long real gates
take to actually produce them. All three demos use the same gate-level
design (structural, built from XOR/AND/OR primitives, not a shortcut
`a + b`) Lab5 uses, just simulated with real, if idealized, per-gate
delays.

Lab5 also has you build a D flip-flop out of cross-coupled NAND gates,
and the directions describe seeing red error lines right after wiring
it, an indeterminate state, before you force it to a known value with
the set bit. That moment and all three demos here are the same
underlying fact about hardware, viewed from different angles: a
circuit doesn't have a single well-defined "current output" the
instant its inputs change, it settles, over real time, and until it
does, what you're looking at is meaningfully undefined. Lab5's counter
at the end works correctly specifically because its clock only samples
state at defined edges, after everything downstream of the previous
edge has had time to settle, hiding exactly the kind of transient
chaos the D latch's red lines, Demo 1, and Demo 2 all expose in
different ways. Demo 3 is that same clocked counter's discipline, in
miniature, made to work correctly on purpose instead of by luck.

## Files

- `full_adder.v`: gate-level full adder (XOR/AND/OR primitives, each
  with a real, separately timed rise/fall delay), mirroring Lab5 Part
  2's circuit. Used by all three demos.
- `tb_single_adder.v`: Demo 1's testbench, one unchained `full_adder`,
  naive vs. coordinated sampling across four rounds of input changes
  (the last one deliberately overlapping two changes to show real
  chaos, not just slowness), plus a fifth round comparing a one-bit
  input change against a two-bit input change on the same circuit.
- `tb_clocked_adder.v`: Demos 2 and 3's testbench, the same
  `full_adder`, now sampled by a real clocked D flip-flop. Only
  `CLK_PERIOD` differs between the two demos this file builds, see
  Section 2 below.
- `Makefile`: builds and runs all three demos.
- `ripple_adder.v` / `tb_ripple_adder.v`: an earlier, `WIDTH`-bit
  ripple-carry adder demo (Lab5 Part 3's `FullAdder4Bit`, generated at
  whatever width you ask for), showing settle time getting worse as a
  circuit scales. Still in this folder and still works, but it's no
  longer part of the main three-demo story below, run it manually if
  you want the scaling point on its own: `iverilog -o sim8.vvp
  -Ptb_ripple_adder.WIDTH=8 full_adder.v ripple_adder.v
  tb_ripple_adder.v && vvp sim8.vvp`.
- [`output.md`](./output.md):  Sample output from the HW5 demo. 

## 0. Prerequisites (Ubuntu)

```
sudo apt update
sudo apt install iverilog gtkwave
```

- `iverilog` (Icarus Verilog) compiles and runs both simulations.
- `gtkwave` opens the waveforms they produce. If you're working over
  SSH with no display, skip `gtkwave` and use the `run_*` targets
  instead, which print the same settling information as text, see
  Section 1 and Section 2 below.

**If you're using VS Code** (including over Remote-SSH into a VM,
which is where `gtkwave`'s native window can get complicated, see
below), two extensions cover everything above without leaving the
editor:

- **Verilog-HDL/SystemVerilog** (`mshr-h.VerilogHDL`): syntax
  highlighting and linting for all the `.v` files here, can lint
  directly through `iverilog` once it's on your `PATH`, catching
  errors before you even run `make`.
- **VaporView** (`lramseyer.vaporview`): opens a `.vcd` file directly
  in a VS Code tab. This is the recommended way to view either
  waveform if you're working inside a VM (OrbStack or otherwise):
  `gtkwave` is a separate native GUI application and getting its
  window to actually appear on your host machine requires X11
  forwarding, which isn't set up by default in most VM setups.
  VaporView sidesteps that entirely, since it renders inside VS
  Code's own window, which Remote-SSH already handles for you. If you
  install VaporView, you can skip `gtkwave` from the apt install above
  and just use the `run_*` Makefile targets to produce the `.vcd`
  files, then open them from VS Code's file explorer.

Verify both CLI tools are on the `PATH`:

```
iverilog -V
gtkwave --version
```

Note: this demo was first built without a working Verilog simulator on
hand to test it against, and running it for real surfaced one real
bug: `full_adder.v` was missing a `` `timescale `` directive that its
testbench had, so Icarus applied a coarse default time unit to its
gate delays instead of the intended 1ns, and the circuit never
finished settling within the simulation window. Fixed by adding
`` `timescale 1ns/1ps `` to `full_adder.v`. If you pull a fresh copy of
this demo, you already have the fix.

## 1. Demo 1: A Single Adder, Naive Reads vs. a Clock

```
make run_single
```

This runs four rounds, each one changing one or two of the adder's
inputs and then reading the output on two different schedules, plus a
fifth round comparing a one-bit change against a two-bit change. Trace
shaped roughly like this (exact values will match, timing labels will
match, this has been reasoned through by hand, see Section 3, but
paste back your real output if anything looks off):

```
=========================================================
Round 1 (t=20 ns): a 0 -> 1, cin stays 0
  NAIVE read at +1 ns : sum=0 cout=0  <-- mid-settle
  NAIVE read at +5 ns : sum=0 cout=0  <-- mid-settle
  NAIVE read at +9 ns : sum=0 cout=0  <-- mid-settle
  COORD read at +28 ns: sum=1 cout=0  <-- correct, waited the safe delay
=========================================================
Round 2 (t=48 ns): cin 0 -> 1, a stays 1
  ...
=========================================================
Round 3 (t=76 ns): a 1 -> 0, cin stays 1
  ...
=========================================================
Round 4, CHAOS (t=104 ns): a 0 -> 1, then cin 1 -> 0
only 3 ns later, before Round 4's own first change has
finished settling. Two transitions overlapping, no clock,
no coordination, this is the round with no safe moment to
look until you deliberately wait for one.
  NAIVE read: sum=? cout=?  <-- two changes mid-flight at once
  NAIVE read: sum=? cout=?  <-- still not trustworthy
  NAIVE read: sum=? cout=?  <-- still not trustworthy
  COORD read, waited 28 ns after the LAST change: sum=1 cout=0  <-- correct, because it waited for the real last change, not the first one
=========================================================
Round 5: does it matter how MANY bits change at once?
=========================================================
---------------------------------------------------------
Round 5a: ONE bit flips, cin 0 -> 1 (a already sitting at 1)
    [trace] t=...: sum  changed to 0
    [trace] t=...: cout changed to 1
  settled by t=+28 ns: sum=0 cout=1
---------------------------------------------------------
Round 5b: TWO bits flip at once, a 0->1 AND cin 0->1 together
    [trace] t=...: sum  changed to 1
    [trace] t=...: cout changed to 1
  settled by t=+28 ns: sum=1 cout=1
---------------------------------------------------------
```

(Exact `[trace]` timestamps depend on where Round 5 lands in the run;
what to actually check is the *gap* between each `[trace]` line and
its round's start timestamp, 5b's gap should be one real gate-delay
bigger than 5a's for both `sum` and `cout`.)

Look at Round 1 specifically: the three NAIVE reads all show `sum=0`,
the *old* answer, even though `a` has already changed to 1. That's not
a glitch or a display bug, it's a real, would-be-wrong read: if
something downstream had used that value, it would have used a stale
answer with total confidence. The COORD read, which waited, gets it
right every single time, across all four rounds, including the
deliberately messy Round 4. That's the entire case for a clock in one
side-by-side comparison: not "hardware is slow", "reading at the wrong
moment gives you a wrong answer with no indication anything is wrong."

**Watch it in the waveform:**

```
make run_single
```

(`make wave_single` also works if `gtkwave` is installed and your
display supports it, see the VS Code note in Section 0.) Open
`single_adder.vcd` (VaporView: click it in VS Code's file explorer).
Add these signals, in this order, expanding into the `dut` scope for
the internal ones:

1. `a`, `b`, `cin` (top-level): the causes.
2. `dut.axorb`: the shared intermediate signal both `sum` and `cout`
   depend on, watch it settle first, a few ns after `a` or `b` changes.
3. `dut.a_and_b` and `dut.cin_and_axorb`: the two paths feeding the
   final OR gate, watch them settle at different times depending on
   which round you're in.
4. `dut.sum` and `dut.cout`: the final answers, always the last things
   to settle.

Zoom in around each `Round N` timestamp from the text output. Round 4
is the one worth lingering on: you'll see `a` and `cin` each kick off
their own cascade through `axorb`/`a_and_b`/`cin_and_axorb`, overlapping
in time, genuinely ambiguous which one "wins" at any given moment until
everything finally settles. That overlap, visible directly in the
waveform, is what "no coordination" actually looks like, not an
analogy for it.

**A note on seeing the rise/fall skew specifically:** a waveform
viewer can't draw it as a slanted or curved edge, VCD only stores
discrete 0/1 value-change events, there's no voltage ramp in the file
to render, regardless of how the delay was modeled. What the skew
actually looks like on a digital waveform is a difference in *gap
width* between a cause and its effect. The cleanest place to see it is
`dut.axorb` against `a`: in Round 1, `a` goes 0->1 and `axorb` follows
it `GATE_DELAY_RISE` ns later; in Round 3, `a` goes 1->0 and `axorb`
follows it `GATE_DELAY_FALL` ns later. Zoom into both gaps and compare
them side by side, the Round 1 gap is visibly wider. That gap-width
difference is the real, physical rise/fall asymmetry, not the shape of
the edge itself.

Round 4's overlap and Round 5's comparison are both also proven by a
running `[trace]` log: two `always` blocks in the testbench print the
exact simulated time `sum` and `cout` actually change, for the whole
run. Those lines are live simulator output, not something typed in
ahead of time as a prediction, so whatever your terminal prints there
is the real answer.

**Asymmetric rise/fall delay.** Every gate in this demo settles slower
going 0->1 (`GATE_DELAY_RISE`, 7ns by default) than going 1->0
(`GATE_DELAY_FALL`, 3ns by default), instead of one flat number in
both directions. Verilog's gate primitives support this directly with
a two-value delay, `xor #(rise_delay, fall_delay) g (...)`, `and #(...)`
and `or #(...)` work the same way, see `full_adder.v`. It's a small
change but a real one, grounded in actual circuit physics rather than
picked for effect: a gate's output is a wire with real resistance
driving a real load capacitance, an RC circuit, and RC circuits don't
snap between voltages, they charge and discharge along a curve, which
is the physical origin of propagation delay in the first place. On top
of that, a CMOS gate's pull-up network (driving toward 1) and
pull-down network (driving toward 0) are different transistors with
different resistance, not a mirror image of each other, so the two
RC curves genuinely run at different rates, and a real gate rarely has
identical rise and fall times. Zoomed into the waveform, you can see
this directly: 0->1 edges are visibly wider than 1->0 edges on the
same signal.

**Round 5: does the number of bits that change matter?** Rounds 1-4
all ask "was this read taken at a safe moment." Round 5 holds the
sampling discipline fixed (always waits `SAFE_DELAY`) and instead asks
whether the input change itself was small or large. 5a flips only
`cin` (with `a` already sitting at 1, settled). 5b flips `a` and `cin`
in the same instant. Both are legal, single-instant input changes, the
kind a student's "it just updates" mental model treats as
interchangeable. They aren't: 5a's `cin`-only change reaches `cout`
through 2 gate-stages, because `axorb` was already sitting there
computed and stable. 5b's simultaneous change reaches `cout` through 3
gate-stages, because `axorb` has to be recomputed from scratch first,
before the `cin`-dependent path can even begin. Read the `[trace]`
lines around each `Round 5a`/`Round 5b` timestamp: 5b's `sum` and
`cout` each land one real gate-delay later than 5a's, a difference you
can point at in the printed timestamps, not just assert.

## 2. Demos 2 and 3: A Real Clock, Too Fast and Then Right

```
make run_clk_fast
make run_clk_ok
```

Same `full_adder`, now behind a real D flip-flop clocked at
`CLK_PERIOD`. Four new input vectors are applied, one per clock cycle,
`CLK_TO_Q` ns after each rising edge (standing in for the vector's real
source: another register clocked on the same `clk`, exactly the
"register -> combinational logic -> register" shape a real synchronous
design uses). At every rising edge, the testbench compares the flip-
flop's live sample against a ground truth it computes for itself (see
`tb_clocked_adder.v`'s header comment for exactly how, no value here
is hand-typed) and prints `MATCH` or `MISMATCH`:

```
=========================================================
CLK_PERIOD=10 ns, worst-case settle from an edge is up to
22 ns (1 ns register delay + 21 ns worst combinational
path). Watch for MISMATCH lines below if CLK_PERIOD is
shorter than that.
=========================================================
t=... CLK RISE - sampled sum=... cout=... | ground truth sum=... cout=... -> MATCH
---------------------------------------------------------
t=...: new vector applied: a=1 cin=0 (one bit changed)
t=... CLK RISE - sampled sum=... cout=... | ground truth sum=... cout=... -> MISMATCH -- clock looked mid-flight!
---------------------------------------------------------
...
```

Run `make run_clk_fast` (`CLK_PERIOD=10`, well under the ~22ns worst
case) and you should see real `MISMATCH` lines, not implied ones, the
flip-flop caught the adder mid-transition and latched whatever it
found. Run `make run_clk_ok` (`CLK_PERIOD=32`, with margin above the
worst case) against the identical input sequence and every single line
should read `MATCH`. Same circuit, same inputs, same timing budget
math from Section 3, the only thing that changed is how fast the clock
asks.

One thing worth pointing out explicitly: a `MATCH` on the fast run is
possible too, if a given edge happens to land on the flat part of the
waveform between two vectors rather than inside a settling window.
That's not a contradiction, it's the honest picture: whether a
too-fast clock produces a wrong answer depends on exactly where its
edge falls relative to the signal it's sampling, which on real silicon
is at the mercy of jitter, temperature, and voltage, not something you
can rely on going your way. This simulation's delays are fixed, so its
specific `MISMATCH`es are repeatable, but the design error is the same
either way: a clock period with no margin over the worst-case
propagation delay is a bet, not a guarantee, whether or not this
particular run happened to lose it.

**Watch it in the waveform:** add `clk` alongside `a`, `b`, `cin`,
`dut.sum`, `dut.cout` (and `dut.axorb` if you want the intermediate
story too, same as Demo 1). `clk` is itself a series of vertical edges
by construction, a digital signal has no other shape, so lining up a
`clk` rising edge against a `sum`/`cout` edge is the direct visual
version of "did the clock look before or after the answer was ready."
Open `clocked_adder_fast.vcd` (from `make run_clk_fast`) and find a
`clk` edge that lands strictly between an input change and the later
`sum`/`cout` edge it caused, that gap is a `MISMATCH` you can see, not
just read in the log. Then open `clocked_adder_ok.vcd` (from
`make run_clk_ok`), a separate file, so both can stay open side by
side, and look for the same shape: every `clk` edge should land
strictly after its `sum`/`cout` has already settled. Both `gtkwave`
and VaporView support dropping a cursor/marker at a specific timestamp
if you want an explicit line drawn for a screenshot, on top of just
eyeballing the edges.

**An honest limit on what this demo can show.** A real too-fast clock's
most notorious failure mode is metastability: a flip-flop's output
hovering at an invalid analog voltage that can resolve to either 0 or
1 unpredictably, sometimes taking extra time to resolve at all. Gate-
level Verilog can't represent that, same limitation as `full_adder.v`'s
rise/fall delays not being an actual voltage ramp (Section 1). What
this demo proves instead is the more basic, still entirely real fact
underneath metastability: sampling before a signal has settled gives
you an answer with no guarantee it's the old value, the new value, or
either, and the flip-flop reports it with the same confidence as a
correct read. That's the part worth teaching either way, metastability
is a refinement on top of it, not a different problem.

## 3. Where the settle-time numbers come from

Each full adder computes:

```
sum  = a ^ b ^ cin
cout = (a & b) | (cin & (a ^ b))
```

`a ^ b` is computed once and shared by both outputs. Both demos here
hold `b` at 0 the whole time specifically to keep this analysis clean:
with `b = 0`, `a & b` is always 0, so `cout`'s path always runs through
`cin`, never through the alternate `a & b = 1` shortcut an earlier
version of this demo's ripple-adder testbench accidentally exercised
(see the comment at the top of `tb_ripple_adder.v` if you're curious,
that shortcut let one specific bit resolve a gate-delay faster than
the rest of a chain, an artifact of that input choice, not a real
effect worth explaining to students).

With `b = 0`: a change to `cin` alone, with `a` already settled, takes
one AND-gate delay plus one OR-gate delay to reach `cout`, 2
gate-delays, since `a^b` doesn't need to be recomputed. A change to `a`
itself, or `a` and `cin` changing together, is one gate-delay slower,
since `a^b` has to be recomputed first: one XOR delay, then one AND,
then one OR, 3 gate-delays. `sum` settles one gate-delay before `cout`
in either case, one XOR away once its inputs are ready. With the
default asymmetric delays (`GATE_DELAY_RISE=7`, `GATE_DELAY_FALL=3`),
the worst case is a 3-gate-delay chain where every stage happens to be
a RISE transition, 21ns.

Demo 1's `SAFE_DELAY` (4x the worse of `GATE_DELAY_RISE`/
`GATE_DELAY_FALL`, 28ns by default) is chosen with real margin above
that 21ns worst case. Demo 2/3's timing budget adds `CLK_TO_Q` (1ns,
the delay before a new vector is actually applied after a clock edge)
on top: worst case from a rising edge to a fully settled answer is
22ns. `CLK_PERIOD_FAST` (10ns) is well under that; `CLK_PERIOD_OK`
(32ns) has 10ns of margin above it.

## 4. What this has to do with the D latch's red error lines

Lab5's D flip-flop is built from two cross-coupled NAND gates. Wire it
up and, before you set it to a known state, Logisim shows red error
lines: the circuit's output is genuinely undefined, because right after
being drawn, each NAND gate's output depends on the other's output,
and neither has settled yet. The lab has you fix this by forcing the
`set` bit, which is correct, but it never says what that redline moment
actually was: a live example of a circuit not having a single
well-defined current state.

Demo 1's NAIVE reads are the same fact, played out somewhere less
visually alarming than red error lines: for a window of real time after
an input changes, `sum` and `cout` are not yet correct, and nothing
tells you that just by looking, you have to already know the timing to
know not to trust what you're reading. Demo 2's `MISMATCH` lines are
the same fact again, now happening to an actual clocked register
instead of an ad hoc read, which is exactly what makes it dangerous in
a real design: the flip-flop doesn't know it sampled garbage, it just
reports whatever it captured as if it were correct, forever, until the
next edge.

Lab5's clocked counter (Part 5) is the answer to this problem, not a
different topic, and Demo 3 is that same answer, isolated down to one
gate's worth of logic. A clock doesn't make propagation delay
disappear, it makes it irrelevant, by only ever sampling a flip-flop's
`D` input at a defined edge, and by design, that edge only comes after
enough time has passed for everything upstream to have settled. That's
not automatic, it's a real constraint on the clock's own period, which
is exactly what separates Demo 2 from Demo 3: same circuit, same
inputs, only the clock's speed relative to the propagation delay
changed. If the clock period is shorter than the worst-case delay
through the logic feeding a flip-flop, you sample mid-flight, a wrong,
transient value, captured and latched as if it were correct. That
failure mode, not an abstract timing rule, is why a real chip's
maximum clock frequency is bounded by its longest combinational path.

## 5. An honest caveat about the numbers

`GATE_DELAY_RISE=7`/`GATE_DELAY_FALL=3` nanoseconds per gate, and
`CLK_PERIOD_FAST=10`/`CLK_PERIOD_OK=32` nanoseconds, are not real
transistor or clock numbers, real logic gates in modern silicon
operate on the order of tens of picoseconds, and real clocks run in
the hundreds of megahertz to multiple gigahertz, not tens of
nanoseconds per cycle. The specific 7/3 rise/fall split isn't measured
from any real process either, it's chosen to be clearly visible in a
waveform, not to claim rise is always slower than fall in real silicon
(it depends on the process and how the gate is sized). These numbers
are chosen to be easy to reason about and to see clearly in a waveform
viewer, not to match any real fabrication process or clock spec. What's
real and not idealized is the *structure* of the result: propagation
delay is additive along a chain, reading a circuit before it settles
gives you a wrong answer with no warning, a clocked register inherits
that same risk if its period doesn't leave real margin over the logic
feeding it, and a synchronous design's maximum clock speed is bounded
by its longest such chain. Those facts hold on real silicon exactly as
they hold here, only the absolute numbers differ.
