`timescale 1ns/1ps

// ============================================================
// HW6 Simple Execution Scheduling Demo
//
// Teaching model only.
//
// Demonstrates:
//
// 1) Independent instructions can execute simultaneously
//    using different execution resources.
//
// 2) Data dependencies can prevent execution even when
//    hardware is available.
//
// Hardware:
//
//    INT0  integer execution unit
//    INT1  integer execution unit
//    MUL0  multiply execution unit
//
// ============================================================


module exec_engine #(
    parameter LATENCY = 3
)(
    input clk,
    input reset,

    input start,
    input [7:0] operation_id,

    output reg busy,
    output reg [7:0] active_operation_id
);


    integer remaining;


    always @(posedge clk) begin

        if (reset) begin

            busy <= 1'b0;
            active_operation_id <= 8'd0;
            remaining <= 0;

        end

        else begin

            if (start && !busy) begin

                busy <= 1'b1;
                active_operation_id <= operation_id;
                remaining <= LATENCY;

            end

            else if (busy) begin

                if (remaining > 1) begin

                    remaining <= remaining - 1;

                end

                else begin

                    busy <= 1'b0;
                    remaining <= 0;

                end

            end

        end

    end

endmodule



// ============================================================
// Demo scheduler
//
// This intentionally models the scheduling decision only.
// It is not a full CPU scheduler.
//
// Scenario 0:
//
//   ADD1 -> INT0
//   ADD2 -> INT1
//   MUL3 -> MUL0
//
// Scenario 1:
//
//   ADD1 -> INT0
//   ADD3 -> INT1
//   MUL2 waits for dependency
//   MUL2 -> MUL0
//
// ============================================================


module demo_scheduler (

    input clk,
    input reset,

    input scenario,


    output reg dispatch_int0,
    output reg dispatch_int1,
    output reg dispatch_mul,


    output reg mul_waiting_for_operand,


    output reg [7:0] int0_dispatch_id,
    output reg [7:0] int1_dispatch_id,
    output reg [7:0] mul_dispatch_id,


    output int0_busy,
    output int1_busy,
    output mul_busy,


    output [7:0] int0_current_op,
    output [7:0] int1_current_op,
    output [7:0] mul_current_op,


    output reg [3:0] phase

);


    wire start_int0;
    wire start_int1;
    wire start_mul;


    assign start_int0 = dispatch_int0;
    assign start_int1 = dispatch_int1;
    assign start_mul  = dispatch_mul;



    exec_engine #(.LATENCY(3)) INT0 (

        .clk(clk),
        .reset(reset),

        .start(start_int0),
        .operation_id(int0_dispatch_id),

        .busy(int0_busy),
        .active_operation_id(int0_current_op)

    );



    exec_engine #(.LATENCY(3)) INT1 (

        .clk(clk),
        .reset(reset),

        .start(start_int1),
        .operation_id(int1_dispatch_id),

        .busy(int1_busy),
        .active_operation_id(int1_current_op)

    );



    exec_engine #(.LATENCY(5)) MUL0 (

        .clk(clk),
        .reset(reset),

        .start(start_mul),
        .operation_id(mul_dispatch_id),

        .busy(mul_busy),
        .active_operation_id(mul_current_op)

    );



    // --------------------------------------------------------
    // Phase counter
    //
    // Advances through the scripted instruction stream.
    // --------------------------------------------------------

    always @(posedge clk) begin

        if (reset)

            phase <= 0;

        else if (phase < 15)

            phase <= phase + 1;

    end



    // --------------------------------------------------------
    // Scheduler decisions
    // --------------------------------------------------------

    always @(*) begin


        // Defaults

        dispatch_int0 = 1'b0;
        dispatch_int1 = 1'b0;
        dispatch_mul  = 1'b0;

        mul_waiting_for_operand = 1'b0;


        int0_dispatch_id = 8'd0;
        int1_dispatch_id = 8'd0;
        mul_dispatch_id  = 8'd0;



        // No dispatch while resetting

        if (!reset) begin


            // =================================================
            // Scenario 0
            //
            // Independent operations
            //
            // =================================================

            if (scenario == 1'b0) begin


                case (phase)


                    4'd0: begin

                        dispatch_int0 = 1'b1;
                        int0_dispatch_id = 8'd1;

                    end


                    4'd1: begin

                        dispatch_int1 = 1'b1;
                        int1_dispatch_id = 8'd2;

                    end


                    4'd2: begin

                        dispatch_mul = 1'b1;
                        mul_dispatch_id = 8'd3;

                    end


                    default: begin

                    end


                endcase

            end



            // =================================================
            // Scenario 1
            //
            // Data dependency
            //
            // =================================================

            else begin


                case (phase)


                    4'd0: begin

                        dispatch_int0 = 1'b1;
                        int0_dispatch_id = 8'd1;

                    end


                    4'd1: begin

                        dispatch_int1 = 1'b1;
                        int1_dispatch_id = 8'd3;

                    end


                    4'd2,
                    4'd3,
                    4'd4: begin

                        mul_waiting_for_operand = 1'b1;

                    end


                    4'd5: begin

                        dispatch_mul = 1'b1;
                        mul_dispatch_id = 8'd2;

                    end


                    default: begin

                    end


                endcase

            end

        end


    end


endmodule