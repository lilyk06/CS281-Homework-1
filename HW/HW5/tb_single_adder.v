// tb_single_adder.v
//
// A single, unchained full adder (reuses full_adder.v exactly as-is,
// the same circuit built by hand in Lab5 Part 2), run with deliberately
// inflated, and deliberately asymmetric, gate delays: GATE_DELAY_RISE
// for a gate settling to 1, GATE_DELAY_FALL for a gate settling to 0.
// This asymmetry is standing in for a real physical fact, not just an
// extra knob: every gate's output is a wire with resistance driving a
// load capacitance, an RC circuit that charges and discharges along a
// curve rather than jumping instantly, and a CMOS gate's pull-up
// (toward 1) and pull-down (toward 0) paths are physically different
// transistors with different resistance, so the two directions
// genuinely take different real time. Watch the waveform and you'll
// see 0->1 edges lean noticeably slower than 1->0 edges, on purpose,
// not a rendering artifact. See full_adder.v for the longer version
// of this and README.md for the "why does this even matter" framing.
//
// Rounds 1-4 do the same NAIVE-vs-COORDINATED comparison as before:
//   1. A NAIVE sampling burst: reads sum/cout on a fast, fixed
//      schedule with no idea whether the adder has settled, exactly
//      what "just read the variable" looks like translated into
//      hardware terms. Several of these reads will be wrong, some
//      genuinely garbage, not just "the old answer."
//   2. One COORDINATED read, taken only after waiting the known
//      worst-case settle time. Always correct, every round, including
//      the deliberately chaotic Round 4. This is what a clock
//      actually buys you: not faster hardware, a guarantee about
//      *when* it's safe to look.
//
// Round 5 asks a different question: does it matter how MANY input
// bits change at once, even holding the sampling discipline fixed?
// It compares a minimal one-bit change (cin flips, a is already
// settled) against a two-bit change (a and cin flip at the same
// instant, forcing a longer dependency chain: a^b has to be
// recomputed before the cin-dependent path can even start). Both
// settle times below are read directly off the simulator via the
// always blocks at the bottom of this file, not hand-typed
// predictions, so whatever your run prints is the real answer, not
// an asserted one.
//
// b is held at 0 for the entire simulation. This keeps every round's
// critical path unambiguous: with b=0, a&b is always 0, so cout's
// path always runs through cin, and the settle-time math in
// README.md Section 3 applies directly without the a&b=1 shortcut
// that complicated an earlier version of this demo's wider adder
// testbench (see the comment near the top of tb_ripple_adder.v).

`timescale 1ns/1ps

module tb_single_adder;

    // Deliberately asymmetric: a gate settling to 1 (RISE) takes
    // longer than one settling to 0 (FALL) here. Real fabrication
    // processes vary on which direction is actually slower; these
    // values are chosen to make the asymmetry obvious in a waveform,
    // not to match any specific real process, same honesty caveat as
    // GATE_DELAY elsewhere in this demo, see README.md Section 5.
    parameter GATE_DELAY_RISE = 7;
    parameter GATE_DELAY_FALL = 3;

    reg  a, b, cin;
    wire sum, cout;

    full_adder #(
        .GATE_DELAY_RISE(GATE_DELAY_RISE),
        .GATE_DELAY_FALL(GATE_DELAY_FALL)
    ) dut (
        .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)
    );

    // Worst case for one unchained stage is 3 gate-stages deep
    // (a change -> axorb -> cin_and_axorb -> cout), and since a
    // RISE transition (7ns) is slower than a FALL transition (3ns)
    // here, the true worst case is 3 RISE-heavy stages. SAFE_DELAY
    // is sized with real margin above that, using whichever of
    // RISE/FALL is larger so this stays safe even if those
    // parameters are overridden from the Makefile.
    localparam integer WORST_GATE_DELAY =
        (GATE_DELAY_RISE > GATE_DELAY_FALL) ? GATE_DELAY_RISE : GATE_DELAY_FALL;
    localparam integer SAFE_DELAY = 4 * WORST_GATE_DELAY;

    initial begin
        $timeformat(-9, 0, " ns", 0);
        $dumpfile("single_adder.vcd");
        $dumpvars(0, tb_single_adder);

        b   = 1'b0;
        a   = 1'b0;
        cin = 1'b0;
        #20;

        $display("=========================================================");
        $display("Round 1 (t=%0t): a 0 -> 1, cin stays 0", $time);
        a = 1'b1;
        #1                        $display("  NAIVE read at +1 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #4                        $display("  NAIVE read at +5 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #4                        $display("  NAIVE read at +9 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #(SAFE_DELAY - 9)         $display("  COORD read at +%0d ns: sum=%b cout=%b  <-- correct, waited the safe delay", SAFE_DELAY, sum, cout);

        $display("=========================================================");
        $display("Round 2 (t=%0t): cin 0 -> 1, a stays 1", $time);
        cin = 1'b1;
        #1                        $display("  NAIVE read at +1 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #4                        $display("  NAIVE read at +5 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #4                        $display("  NAIVE read at +9 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #(SAFE_DELAY - 9)         $display("  COORD read at +%0d ns: sum=%b cout=%b  <-- correct, waited the safe delay", SAFE_DELAY, sum, cout);

        $display("=========================================================");
        $display("Round 3 (t=%0t): a 1 -> 0, cin stays 1", $time);
        a = 1'b0;
        #1                        $display("  NAIVE read at +1 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #4                        $display("  NAIVE read at +5 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #4                        $display("  NAIVE read at +9 ns : sum=%b cout=%b  <-- mid-settle", sum, cout);
        #(SAFE_DELAY - 9)         $display("  COORD read at +%0d ns: sum=%b cout=%b  <-- correct, waited the safe delay", SAFE_DELAY, sum, cout);

        $display("=========================================================");
        $display("Round 4, CHAOS (t=%0t): a 0 -> 1, then cin 1 -> 0", $time);
        $display("only %0d ns later, before Round 4's own first change has", GATE_DELAY_FALL);
        $display("finished settling. Two transitions overlapping, no clock,");
        $display("no coordination, this is the round with no safe moment to");
        $display("look until you deliberately wait for one.");
        a = 1'b1;
        #(GATE_DELAY_FALL)        // partway in, nowhere near settled
        cin = 1'b0;
        #1                        $display("  NAIVE read: sum=%b cout=%b  <-- two changes mid-flight at once", sum, cout);
        #4                        $display("  NAIVE read: sum=%b cout=%b  <-- still not trustworthy", sum, cout);
        #4                        $display("  NAIVE read: sum=%b cout=%b  <-- still not trustworthy", sum, cout);
        #(SAFE_DELAY)             $display("  COORD read, waited %0d ns after the LAST change: sum=%b cout=%b  <-- correct, because it waited for the real last change, not the first one", SAFE_DELAY, sum, cout);

        $display("=========================================================");
        $display("Round 5: does it matter how MANY bits change at once?");
        $display("=========================================================");

        // --- 5a: minimal, one-bit change ---
        // Reset to a known baseline, let it fully settle, then bring
        // a to 1 and let THAT settle too, so the only thing left to
        // change is cin.
        b = 1'b0; a = 1'b0; cin = 1'b0;
        #(SAFE_DELAY);
        a = 1'b1;
        #(SAFE_DELAY);
        $display("---------------------------------------------------------");
        $display("Round 5a (t=%0t): ONE bit flips, cin 0 -> 1 (a already sitting at 1)", $time);
        r5a_start = $time;
        cin = 1'b1;
        #(SAFE_DELAY)             $display("  settled by t=+%0d ns: sum=%b cout=%b", SAFE_DELAY, sum, cout);

        // --- 5b: two bits at once ---
        // Reset to the same baseline, let it fully settle, then flip
        // a AND cin in the same instant: axorb now has to be
        // recomputed from scratch before the cin-dependent path can
        // even begin, one extra gate-stage compared to 5a.
        b = 1'b0; a = 1'b0; cin = 1'b0;
        #(SAFE_DELAY);
        $display("---------------------------------------------------------");
        $display("Round 5b (t=%0t): TWO bits flip at once, a 0->1 AND cin 0->1 together", $time);
        r5b_start = $time;
        a   = 1'b1;
        cin = 1'b1;
        #(SAFE_DELAY)             $display("  settled by t=+%0d ns: sum=%b cout=%b", SAFE_DELAY, sum, cout);

        $display("---------------------------------------------------------");
        $display("Compare the 'changed to' timestamps printed above against");
        $display("r5a_start=%0t and r5b_start=%0t: 5b's sum and cout each", r5a_start, r5b_start);
        $display("settle one gate-stage later than 5a's, because flipping a");
        $display("forces axorb to be recomputed before the cin-dependent");
        $display("path can even start. Two bits changing isn't just 'twice");
        $display("as much change happening', it's a longer dependency chain");
        $display("to wait out, and that shows up directly as more time.");

        $display("=========================================================");
        $display("Final settled state: a=%b b=%b cin=%b -> sum=%b cout=%b", a, b, cin, sum, cout);
        $display("=========================================================");
        $finish;
    end

    // r5a_start / r5b_start mark when each Round 5 sub-test's input
    // change was applied, so the automatic settle-time trace below
    // can be read relative to it, not just as an absolute timestamp.
    time r5a_start, r5b_start;

    // Print the exact simulated time of every real change to the
    // final outputs, for the whole run, not just Round 5. This is
    // live simulator output, not a hand-typed prediction: whatever
    // your run prints here is the real answer, not an asserted one.
    always @(sum)  $display("    [trace] t=%0t: sum  changed to %b", $time, sum);
    always @(cout) $display("    [trace] t=%0t: cout changed to %b", $time, cout);

endmodule
