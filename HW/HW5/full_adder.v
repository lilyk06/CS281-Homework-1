// full_adder.v
//
// Gate-level (structural) full adder, mirroring the full adder built
// from primitive gates in Lab5's Logisim circuit (Part 2), not a
// behavioral `assign sum = a + b + cin` shortcut. Built from actual
// XOR/AND/OR primitives so each one has a real, separately timed gate
// delay, which is the entire point of this demo: watching those
// delays add up across a chain of these.
//
// sum  = a ^ b ^ cin
// cout = (a & b) | (cin & (a ^ b))
//
// axorb (a ^ b) is computed once and shared by both the sum and carry
// logic, exactly as it is in the classic full-adder gate diagram, and
// exactly as it ends up being in Lab5's version once drawn out.
//
// GATE_DELAY is a module parameter (default 1 time unit) rather than
// a hardcoded number, so every gate in the design shares one knob,
// see README.md for what a "time unit" means here and why the exact
// number doesn't matter for the point being made.
//
// GATE_DELAY_RISE and GATE_DELAY_FALL let a gate take a different
// amount of time depending on which way its output is moving (0->1
// vs. 1->0), not one symmetric delay in each direction. This isn't
// just a knob for realism, it's modeling a real physical cause: a
// gate's output is a wire with real resistance driving a real load
// capacitance (the input capacitance of whatever it's wired to, plus
// the wire itself), an RC circuit, and an RC circuit cannot change
// voltage instantly, it charges and discharges along a curve, which
// is where propagation delay physically comes from in the first
// place, not just "the gate takes a moment to think." The rise/fall
// split on top of that models a further real asymmetry: a CMOS
// gate's pull-up network (driving toward 1) and pull-down network
// (driving toward 0) are physically different transistors with
// different resistance, most commonly a stronger pull-down, so
// discharging toward 0 tends to be faster than charging toward 1 in
// a lot of real processes, which is why GATE_DELAY_RISE >
// GATE_DELAY_FALL here, not an arbitrary choice. Both parameters
// default to GATE_DELAY, so anything that only sets GATE_DELAY
// (ripple_adder.v, tb_ripple_adder.v) gets the old symmetric behavior
// unchanged; tb_single_adder.v is the one that overrides them to
// something asymmetric. Verilog's two-argument gate delay
// `#(rise, fall)` is what actually applies this per-direction, see
// each instantiation below.
//
// `timescale must be set here explicitly, matching tb_ripple_adder.v,
// rather than relying on this file to inherit one. Icarus applies a
// coarse builtin default to any file with no `timescale of its own,
// which silently made every gate delay here enormous relative to the
// testbench's simulation window (this was a real bug caught by
// running the demo, not something checked in advance).

`timescale 1ns/1ps

module full_adder #(
    parameter GATE_DELAY      = 1,
    parameter GATE_DELAY_RISE = GATE_DELAY,
    parameter GATE_DELAY_FALL = GATE_DELAY
) (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    wire axorb;
    wire a_and_b;
    wire cin_and_axorb;

    xor #(GATE_DELAY_RISE, GATE_DELAY_FALL) g_axorb  (axorb, a, b);
    xor #(GATE_DELAY_RISE, GATE_DELAY_FALL) g_sum    (sum, axorb, cin);

    and #(GATE_DELAY_RISE, GATE_DELAY_FALL) g_aandb  (a_and_b, a, b);
    and #(GATE_DELAY_RISE, GATE_DELAY_FALL) g_cinand (cin_and_axorb, cin, axorb);
    or  #(GATE_DELAY_RISE, GATE_DELAY_FALL) g_cout   (cout, a_and_b, cin_and_axorb);

endmodule
