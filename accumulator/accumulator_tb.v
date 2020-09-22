`timescale 1s / 100ms
`include "accumulator.v"

module accumulator_tb ();

    reg debug = 1'b1;
    reg reset;
    reg i_load;
    reg i_send;
    reg [7:0] i_bus;
    wire [7:0] o_bus;
    wire [7:0] unbuffered_out;

    accumulator acc (
        debug, reset, i_load, i_send, i_bus, o_bus, unbuffered_out
    );

    initial begin
        
        $monitor ("unbuffered output: %b", unbuffered_out);
        $monitor ("output: %b", o_bus);

        // register should output 8'bzzzzzzzz on reset;
        reset = 1; #10;
        reset = 0; #10;

        // register should not load and unbuffered output on low enable signal
        i_bus = 8'b11111111; #10;

        // register should load and unbuffered output when high signal
        i_bus = 8'b10101010; #10;
        i_load = 1; #10;

        // register should output also on high send signal
        i_send = 1; #10;
        i_send = 0; #10;

        // edge cases
        i_bus = 8'b00000000; #10;
        i_load = 1; #10;

        i_send = 1; #10;
        i_send = 0; #10;

        i_load = 0; #10;

        i_bus = 8'b11111111; #10;
        i_load = 1; #10;

        i_send = 1; #10;
        i_send = 0; #10;

        $finish;

    end

endmodule