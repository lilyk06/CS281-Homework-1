`timescale 1ns/1ps

// ============================================================
// HW6 Scheduler Demonstration Testbench
//
// The testbench is intentionally separate from the hardware
// model.
//
// It simply runs the two classroom scenarios and produces a
// curated VCD containing only the signals students need.
// ============================================================

module hw6_scheduler_tb;

    reg clk;
    reg reset;
    reg scenario;


    // ========================================================
    // Clock
    // ========================================================

    always #5 clk = ~clk;


    // ========================================================
    // DUT outputs
    // ========================================================

    wire dispatch_int0;
    wire dispatch_int1;
    wire dispatch_mul;

    wire mul_waiting_for_operand;

    wire [7:0] int0_dispatch_id;
    wire [7:0] int1_dispatch_id;
    wire [7:0] mul_dispatch_id;

    wire [7:0] int0_current_op;
    wire [7:0] int1_current_op;
    wire [7:0] mul_current_op;

    wire int0_busy;
    wire int1_busy;
    wire mul_busy;

    wire [3:0] phase;


    // ========================================================
    // DUT
    // ========================================================

    demo_scheduler DUT (

        .clk(clk),
        .reset(reset),

        .scenario(scenario),

        .dispatch_int0(dispatch_int0),
        .dispatch_int1(dispatch_int1),
        .dispatch_mul(dispatch_mul),

        .mul_waiting_for_operand(mul_waiting_for_operand),

        .int0_dispatch_id(int0_dispatch_id),
        .int1_dispatch_id(int1_dispatch_id),
        .mul_dispatch_id(mul_dispatch_id),

        .int0_current_op(int0_current_op),
        .int1_current_op(int1_current_op),
        .mul_current_op(mul_current_op),

        .int0_busy(int0_busy),
        .int1_busy(int1_busy),
        .mul_busy(mul_busy),

        .phase(phase)

    );


    // ========================================================
    // Reset helper
    // ========================================================

    task reset_demo;

        begin

            reset = 1'b1;

            repeat (2)
                @(posedge clk);

            reset = 1'b0;

        end

    endtask


    // ========================================================
    // Simulation
    // ========================================================

    initial begin

        // ----------------------------------------------------
        // Curated VCD.
        //
        // These are the only signals students need to see.
        // ----------------------------------------------------

        $dumpfile("hw6_scheduler.vcd");

        $dumpvars(0,
            hw6_scheduler_tb.clk,
            hw6_scheduler_tb.scenario,

            hw6_scheduler_tb.phase,

            hw6_scheduler_tb.dispatch_int0,
            hw6_scheduler_tb.dispatch_int1,
            hw6_scheduler_tb.dispatch_mul,

            hw6_scheduler_tb.int0_busy,
            hw6_scheduler_tb.int1_busy,
            hw6_scheduler_tb.mul_busy,

            hw6_scheduler_tb.int0_current_op,
            hw6_scheduler_tb.int1_current_op,
            hw6_scheduler_tb.mul_current_op,

            hw6_scheduler_tb.mul_waiting_for_operand
        );


        // ----------------------------------------------------
        // Initial state
        // ----------------------------------------------------

        clk = 1'b0;
        reset = 1'b0;
        scenario = 1'b0;


        // ====================================================
        // SCENARIO 0
        //
        // Three independent instructions.
        // ====================================================

        $display("");
        $display("==========================================");
        $display("SCENARIO 0: INDEPENDENT");
        $display("==========================================");

        scenario = 1'b0;

        reset_demo();

        repeat (10)
            @(posedge clk);


        // ====================================================
        // SCENARIO 1
        //
        // One instruction depends on another.
        // ====================================================

        $display("");
        $display("==========================================");
        $display("SCENARIO 1: DATA DEPENDENCY");
        $display("==========================================");

        scenario = 1'b1;

        reset_demo();

        repeat (12)
            @(posedge clk);


        $display("");
        $display("Simulation complete.");
        $display("Open hw6_scheduler.vcd in VaporView.");
        $display("");


        $finish;

    end

endmodule