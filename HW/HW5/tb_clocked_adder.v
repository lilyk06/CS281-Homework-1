// tb_clocked_adder.v
//
// Demos 2 and 3: the same full_adder (reused exactly as-is, no
// changes) driven by a real clock, sampled by a real D flip-flop
// (q_sum/q_cout below), instead of the fixed-offset reads
// tb_single_adder.v (Demo 1) used. Only CLK_PERIOD differs between
// the two demos this file builds:
//
//   CLK_PERIOD_FAST: shorter than the adder's worst-case settle time.
//   The clock's rising edge can land WHILE sum/cout are still
//   settling, and the flip-flop captures whatever they happen to be
//   at that exact instant, right or wrong, with total confidence
//   either way.
//
//   CLK_PERIOD_OK: longer than the worst-case settle time, with real
//   margin (same derivation as tb_single_adder.v's SAFE_DELAY). Every
//   rising edge lands after the adder has had enough time to finish,
//   so the flip-flop always captures the correct answer.
//
// This is the actual point of a clock, made provable rather than
// asserted: a clock does not make a circuit faster, it defines a
// pattern of moments to look, and whether that pattern is safe is a
// direct comparison between CLK_PERIOD and the circuit's propagation
// delay, nothing else.
//
// Each new input vector is applied CLK_TO_Q ns after a rising edge,
// mimicking how a's/cin's real source would be another register
// clocked on the same clk, not a hand-waved "change whenever." This
// is the standard picture of one pipeline stage: register -> some
// combinational logic -> register, and it's exactly what makes "did
// the combinational logic finish before the NEXT edge" the right
// question to ask, the same question Lab5's clocked counter answers
// by construction and this testbench answers by measurement.
//
// b is held at 0 for the entire simulation, same reason as
// tb_single_adder.v: keeps every transition's critical path
// unambiguous, no a&b=1 shortcut through the OR gate.
//
// How "correct" is checked, without hand-typing any predicted value:
// a small retriggerable timer (settle_id / the `always @(settle_id)`
// block below) watches a/b/cin and, SAFE_DELAY ns after the LAST
// change with no further change in between, latches whatever sum/cout
// actually are into expected_sum/expected_cout. That's the real,
// simulator-computed correct answer for whatever vector is currently
// applied, not a guess. Every posedge then compares the LIVE sum/cout
// against that ground truth: if they match, the clock caught a
// settled answer; if they don't, the clock looked too early, and
// this line proves it, whatever the actual bit values happen to be
// this run.
//
// One honest limit worth naming: a real too-fast clock's failure mode
// is often metastability, a flip-flop's output hovering at an invalid
// analog voltage that can resolve to either 0 or 1 unpredictably.
// Digital gate-level Verilog can't represent that, same limitation as
// full_adder.v's rise/fall delays not being an actual voltage ramp,
// see README.md. What this testbench proves instead is the more
// basic, still-real failure underneath metastability: sampling before
// a signal has settled captures a value that may not match either the
// old or the new correct answer, with no indication anything is
// wrong. In this exact simulation that outcome is repeatable (same
// delays every run), but on real silicon the same bad timing margin
// would be at the mercy of jitter, temperature, and voltage, and
// could go either way, which is why "too fast" is a design error even
// on a run where it happens not to bite.

`timescale 1ns/1ps

module tb_clocked_adder;

    parameter GATE_DELAY_RISE = 7;
    parameter GATE_DELAY_FALL = 3;
    parameter CLK_PERIOD      = 10;
    parameter CLK_TO_Q        = 1;

    // Overridable so run_clk_fast and run_clk_ok, which both compile
    // this same file with only CLK_PERIOD differing, don't silently
    // overwrite each other's waveform. See Makefile.
    parameter DUMPFILE = "clocked_adder.vcd";

    localparam integer WORST_GATE_DELAY =
        (GATE_DELAY_RISE > GATE_DELAY_FALL) ? GATE_DELAY_RISE : GATE_DELAY_FALL;
    localparam integer SAFE_DELAY = 4 * WORST_GATE_DELAY;

    reg  a, b, cin;
    wire sum, cout;
    reg  clk;
    reg  q_sum, q_cout;

    full_adder #(
        .GATE_DELAY_RISE(GATE_DELAY_RISE),
        .GATE_DELAY_FALL(GATE_DELAY_FALL)
    ) dut (
        .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)
    );

    initial clk = 1'b0;
    always #(CLK_PERIOD / 2.0) clk = ~clk;

    // --- ground truth, computed live, not hand-typed (see header) ---
    reg [31:0] settle_id = 0;
    reg        expected_sum  = 1'b0;
    reg        expected_cout = 1'b0;

    always @(a or b or cin) settle_id = settle_id + 1;

    always @(settle_id) begin : settle_wait
        reg [31:0] my_id;
        my_id = settle_id;
        #(SAFE_DELAY);
        if (my_id == settle_id) begin
            expected_sum  = sum;
            expected_cout = cout;
        end
    end

    // --- the actual clocked register under test ---
    always @(posedge clk) begin
        $display("t=%0t: CLK RISE - sampled sum=%b cout=%b | ground truth sum=%b cout=%b -> %s",
                  $time, sum, cout, expected_sum, expected_cout,
                  ((sum === expected_sum) && (cout === expected_cout))
                      ? "MATCH"
                      : "MISMATCH -- clock looked mid-flight!");
        q_sum  <= sum;
        q_cout <= cout;
    end

    // Live trace of every real change, same as the other testbenches,
    // for cross-checking against the CLK RISE lines above.
    always @(sum)  $display("    [trace] t=%0t: sum  changed to %b", $time, sum);
    always @(cout) $display("    [trace] t=%0t: cout changed to %b", $time, cout);

    initial begin
        $timeformat(-9, 0, " ns", 0);
        $dumpfile(DUMPFILE);
        $dumpvars(0, tb_clocked_adder);

        $display("=========================================================");
        $display("CLK_PERIOD=%0d ns, worst-case settle from an edge is up to", CLK_PERIOD);
        $display("%0d ns (%0d ns register delay + %0d ns worst combinational",
                  CLK_TO_Q + 3*WORST_GATE_DELAY, CLK_TO_Q, 3*WORST_GATE_DELAY);
        $display("path). Watch for MISMATCH lines below if CLK_PERIOD is");
        $display("shorter than that.");
        $display("=========================================================");

        b = 1'b0; a = 1'b0; cin = 1'b0;
        #(SAFE_DELAY);

        // Cycle 1: a 0->1 (cin stays 0), a one-bit change.
        @(posedge clk); #(CLK_TO_Q) begin
            a = 1'b1; cin = 1'b0;
            $display("---------------------------------------------------------");
            $display("t=%0t: new vector applied: a=1 cin=0 (one bit changed)", $time);
        end

        // Cycle 2: cin 0->1 (a stays 1), a one-bit change.
        @(posedge clk); #(CLK_TO_Q) begin
            a = 1'b1; cin = 1'b1;
            $display("---------------------------------------------------------");
            $display("t=%0t: new vector applied: a=1 cin=1 (one bit changed)", $time);
        end

        // Cycle 3: both fall together, a two-bit change.
        @(posedge clk); #(CLK_TO_Q) begin
            a = 1'b0; cin = 1'b0;
            $display("---------------------------------------------------------");
            $display("t=%0t: new vector applied: a=0 cin=0 (two bits changed)", $time);
        end

        // Cycle 4: both rise together, a two-bit change AND the
        // slowest possible transition (both gates settling via
        // GATE_DELAY_RISE, the worst case this testbench's timing
        // budget above was sized against).
        @(posedge clk); #(CLK_TO_Q) begin
            a = 1'b1; cin = 1'b1;
            $display("---------------------------------------------------------");
            $display("t=%0t: new vector applied: a=1 cin=1 (two bits changed, worst case)", $time);
        end

        @(posedge clk);
        @(posedge clk);

        $display("=========================================================");
        $display("Done. Count the MISMATCH lines above: CLK_PERIOD_FAST should");
        $display("show real ones, CLK_PERIOD_OK should show none.");
        $display("=========================================================");
        $finish;
    end

endmodule
