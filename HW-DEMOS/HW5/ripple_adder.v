// ripple_adder.v
//
// WIDTH-bit ripple-carry adder built by chaining WIDTH full_adder
// instances, cout of each stage wired directly to cin of the next.
// This is exactly the wiring done by hand in Lab5 Part 3, just there
// it was 4 stages dragged and wired in the Logisim GUI (FullAdder4Bit),
// here it's a generate loop doing the identical thing, at whatever
// width WIDTH is set to.
//
// carry_chain exposes every intermediate carry bit as a real output,
// specifically so a waveform viewer (gtkwave) can show each one
// settling at a different simulated time, the part a static schematic
// diagram can't show, no matter how it's drawn.
//
// `timescale set explicitly here too, see full_adder.v for why.

`timescale 1ns/1ps

module ripple_adder #(
    parameter WIDTH = 8,
    parameter GATE_DELAY = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             cin,
    output wire [WIDTH-1:0] sum,
    output wire             cout,
    output wire [WIDTH-1:0] carry_chain
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : stage
            if (i == 0) begin : first_stage
                full_adder #(.GATE_DELAY(GATE_DELAY)) fa (
                    .a(a[i]), .b(b[i]), .cin(cin),
                    .sum(sum[i]), .cout(carry_chain[i])
                );
            end else begin : later_stage
                full_adder #(.GATE_DELAY(GATE_DELAY)) fa (
                    .a(a[i]), .b(b[i]), .cin(carry_chain[i-1]),
                    .sum(sum[i]), .cout(carry_chain[i])
                );
            end
        end
    endgenerate

    assign cout = carry_chain[WIDTH-1];

endmodule
