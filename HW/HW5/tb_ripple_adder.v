// tb_ripple_adder.v
//
// Testbench for ripple_adder. Applies a worst-case input pattern
// (all-ones plus 1, delivered via carry-in, the classic "counter
// rollover" case: 1111...1 + 1 = 0000...0 with a carry out) that
// forces the carry to ripple through every single bit, from bit 0 all
// the way to the top bit, the same worst case that motivates "a wider
// adder means a longer chain."
//
// The "+1" is delivered through cin rather than through b's low bit
// on purpose: with b = 0 for every bit, every stage's carry-out
// depends on its incoming cin the same way, including bit 0. An
// earlier version delivered the +1 through b instead (a = 0111...1,
// b = 0000...01), which gave bit 0 a different input pattern
// (a0=1, b0=1) than every other bit (a=1, b=0), letting its carry
// resolve one gate-delay faster via an a&b=1 shortcut through the OR
// gate, an artifact of that specific input choice, not something
// worth explaining to students. It also meant the top bit never
// carried out (a=0, b=0 there forces cout=0 no matter what), so the
// final `cout` never actually changed value in the simulation, only
// `sum` did. This version's top bit is a=1, b=0 like every other bit,
// so `cout` genuinely flips from 0 to 1 once the carry reaches it,
// an observable transition, not just a predicted number.
//
// Dumps a VCD waveform for gtkwave, and separately reports, via
// $display, the exact simulated time each output actually settles,
// compared against the delay predicted by hand (see README.md
// Section 3 for the derivation). WIDTH and GATE_DELAY are overridable
// from the Makefile via -P.

`timescale 1ns/1ps

module tb_ripple_adder;

    parameter WIDTH = 8;
    parameter GATE_DELAY = 1;

    reg  [WIDTH-1:0] a, b;
    reg              cin;
    wire [WIDTH-1:0] sum;
    wire             cout;
    wire [WIDTH-1:0] carry_chain;

    ripple_adder #(.WIDTH(WIDTH), .GATE_DELAY(GATE_DELAY)) dut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout), .carry_chain(carry_chain)
    );

    // Worst-case ripple: a = 1111...1, b = 0000...0, the "+1" arrives
    // via cin (driven to 1 in the same instant a and b change, see
    // the initial block below). Every bit of the sum has to wait for
    // a carry that started at bit 0 and rippled all the way to the
    // top.
    localparam [WIDTH-1:0] WORST_A = {WIDTH{1'b1}};
    localparam [WIDTH-1:0] WORST_B = {WIDTH{1'b0}};

    // Derived by hand in README.md Section 3: the first stage costs
    // one XOR delay (for a^b) plus one AND delay plus one OR delay;
    // every stage after that adds one AND delay plus one OR delay to
    // the carry chain (a^b for that bit is already sitting there
    // waiting, computed in parallel). So:
    //   cout settles at  (3 + 2*(WIDTH-1)) * GATE_DELAY
    //   sum  settles at  (2 * WIDTH)       * GATE_DELAY
    // Verified against an independent Python event-timing model before
    // this file was written; both agree at WIDTH = 4, 8, 16, 32.
    localparam integer PREDICTED_COUT_DELAY = (3 + 2*(WIDTH-1)) * GATE_DELAY;
    localparam integer PREDICTED_SUM_DELAY  = (2 * WIDTH) * GATE_DELAY;

    integer t_apply;

    initial begin
        // Print $time in whole nanoseconds (matching the 1ns unit this
        // testbench and GATE_DELAY both use) instead of the raw
        // simulation-precision ticks (1ps) %t would otherwise show, so
        // "t=10" prints as "t=10", not "t=10000".
        $timeformat(-9, 0, " ns", 0);

        $dumpfile("ripple_adder.vcd");
        $dumpvars(0, tb_ripple_adder);

        a = 0; b = 0; cin = 0;
        #10;

        $display("---------------------------------------------------------");
        $display("WIDTH=%0d GATE_DELAY=%0d", WIDTH, GATE_DELAY);
        $display("Applying worst-case ripple input at t=%0t", $time);
        t_apply = $time;
        a = WORST_A;
        b = WORST_B;
        cin = 1'b1;

        #(PREDICTED_COUT_DELAY + 20);

        $display("---------------------------------------------------------");
        $display("Predicted final sum  settle time: t=%0d ns (delay = %0d)",
                  t_apply + PREDICTED_SUM_DELAY, PREDICTED_SUM_DELAY);
        $display("Predicted final cout settle time: t=%0d ns (delay = %0d)",
                  t_apply + PREDICTED_COUT_DELAY, PREDICTED_COUT_DELAY);
        $display("Final sum  = %b", sum);
        $display("Final cout = %b", cout);
        $display("---------------------------------------------------------");
        $finish;
    end

    // Print the exact simulated time of every change to the final
    // outputs, so the "predicted" numbers above can be checked against
    // what the simulator actually did, not just asserted. This also
    // shows the outputs settling from the unknown power-up state at
    // the very start, before the #10 delay, a small echo of the same
    // "the circuit doesn't have a defined value yet" moment from
    // Lab5's D flip-flop.
    always @(cout) begin
        $display("t=%0t: cout changed to %b", $time, cout);
    end

    always @(sum) begin
        $display("t=%0t: sum  changed to %b", $time, sum);
    end

endmodule
