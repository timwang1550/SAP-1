/**
 * SAP-1 test file
 */

 `timescale 1ns / 1ns
 `include "SAP.v"

 module sap_test();

    //debug messages are a look inconsistent due to timing
    // but end result is correct
    reg debug = 1'b1; 
    reg clk;
    reg reset;
    reg program_mode;
    reg [7:0] program_data;
    reg [3:0] program_address;
    wire [7:0] display;

    sap computer (
        debug,
        clk,
        reset,
        program_mode,
        program_data,
        program_address,
        display
    );

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin

        // dump file to view in gtkwave simulator
        $dumpfile("test.vcd");
        $dumpvars;

        // program instructions before execution
        program_mode = 0; #10;

        // LDA 9H
        program_data = 8'b0000_1001; program_address = 4'b0000; #10;
        // ADD AH
        program_data = 8'b0001_1010; program_address = 4'b0001; #10;
        // ADD BH
        program_data = 8'b0001_1011; program_address = 4'b0010; #10;
        // SUB CH
        program_data = 8'b0010_1100; program_address = 4'b0011; #10;
        // OUT
        program_data = 8'b1110_xxxx; program_address = 4'b0100; #10;
        // HLT
        program_data = 8'b1111_xxxx; program_address = 4'b0101; #10;
        // 9H - 14
        program_data = 8'b0000_1110; program_address = 4'b1001; #10;
        // AH - 21
        program_data = 8'b0001_0101; program_address = 4'b1010; #10;
        // BH - 1 
        program_data = 8'b0000_0001; program_address = 4'b1011; #10;
        // CH - 7
        program_data = 8'b0000_0111; program_address = 4'b1100; #10;

        // start every run with a reset
        reset = 1; #10;
        reset = 0; #10;

        // execution
        program_mode = 1; #5; 
        #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; 
        #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; 
        #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; 
        #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; 
        #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; #10; 

        $finish;
    end

 endmodule