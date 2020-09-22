`timescale 1s / 100ms
`include "memory_address_register.v"

module memory_address_register_tb ();

    reg debug = 1'b1;
    reg reset;
    reg i_load;
    reg [3:0] i_address;
    wire [3:0] o_address;

    memory_address_register mar (
        debug, reset, i_load, i_address, o_address
    );

    initial begin
        // one reset mar should return to 0000
        reset = 1; #10;
        reset = 0; #10;

        // should not be loaded without enable signal
        i_address = 0010; #10;

        // should be loaded on load enable signal
        i_address = 1110; #10;
        i_load = 1; #10;

        // address should not change when load signal goes low
        i_load = 0; #10;

        // edge cases
        i_address = 1111; #10;
        i_load = 1; #10;

        i_load = 0; #10;
        
        i_address = 0000; #10;
        i_load = 1; #10;

        $finish;
    end

endmodule