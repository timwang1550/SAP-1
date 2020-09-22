`timescale 1s / 100ms
`include "register.v"

module register_tb ();

    reg debug = 1'b1;
    reg reset;
    reg i_load;
    reg [7:0] i_bus;
    wire [7:0] unbuffered_out;

    register regtest (
        debug, reset, i_load, i_bus, unbuffered_out
    );

    initial begin
        
        $monitor ("output: %b", unbuffered_out);

        // register should output 8'bzzzzzzzz on reset;
        reset = 1; #10;
        reset = 0; #10;

        // register should not load and output on low enable signal
        i_bus = 8'b11111111; #10;

        // register should load and output when high signal
        i_bus = 8'b10101010; #10;
        i_load = 1; #10;

        // edge cases
        i_bus = 8'b00000000; #10;
        i_load = 1; #10;

        i_load = 0; #10;

        i_bus = 8'b11111111; #10;
        i_load = 1; #10;

        $finish;
    end

endmodule