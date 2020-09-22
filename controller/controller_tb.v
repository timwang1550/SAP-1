`timescale 1s / 100ms
`include "controller.v"

module controller_tb ();

    reg debug = 1'b1;
    reg clk;
    reg reset;
    reg [3:0] opcode;

    wire pc_incr;
    wire pc_enable;
    wire mar_load;
    wire ram_enable;
    wire ir_load;
    wire ir_send;
    wire alu_send;
    wire alu_sub;
    wire acc_load;
    wire acc_send;
    wire b_load;
    wire out_load;

    controller control (
        debug, clk, reset, opcode,
        pc_incr,
        pc_enable,
        mar_load,
        ram_enable,
        ir_load,
        ir_send,
        alu_send,
        alu_sub,
        acc_load,
        acc_send,
        b_load,
        out_load
    );

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        reset = 1; #10;
        reset = 0; #10;

        opcode = 4'b0000; #10;
        #10; #10; #10; #10; 
    
        opcode = 4'b0001; 
        #10; #10; #10; #10;

        $finish;
    end

endmodule
