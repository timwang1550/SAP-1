`timescale 1s / 100ms
`include "ram_16x8.v"

module ram_16x8_tb ();

    reg debug = 1'b1;
    reg program_mode;
    reg [7:0] program_data;
    reg [3:0] address;
    reg enable;
    wire [7:0] bus;

    ram_16x8 ram (
        debug, program_mode, program_data, address, enable, bus
    );

    initial begin
        // input data before program run
        program_mode = 0; #10;
        address = 4'b0001; program_data = 8'b11110000; #10;
        address = 4'b0010; program_data = 8'b10011110; #10;
        address = 4'b0011; program_data = 8'b10110010; #10;

        // run program
        // ram is readble on positive edge of enable signal
        program_mode = 1; #10;
        enable = 0; #10; enable = 1; 
        address = 4'b1000; #10;
        enable = 0; #10; enable = 1;
        address = 4'b0001; #10;
        enable = 0; #10; enable = 1;
        address = 4'b0010; #10;
        enable = 0; #10; enable = 1;
        address = 4'b0011; #10;

        $finish;
    end

endmodule