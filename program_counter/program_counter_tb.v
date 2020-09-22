`timescale 1s / 100ms
`include "program_counter.v"

module program_counter_tb ();

    reg debug = 1'b1;
    reg reset;
    reg incr;
    reg enable;
    wire [7:0] w_bus;

    program_counter p_count (debug, reset, incr, enable, w_bus);

    initial begin

        reset = 1; #10;
        reset = 0; #10;

        enable = 1; #10;
        enable = 0; #10;
       
        incr = 1; #10;
        incr = 0; #10;

        incr = 1; #10;
        incr = 0; #10;

        incr = 1; #10;
        incr = 0; #10;
        
        incr = 1; #10;
        incr = 0; #10;

        enable = 1; #10;

        incr = 1; #10;
        incr = 0; #10;
        
        $finish;
    end

endmodule