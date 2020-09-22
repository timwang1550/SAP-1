/**
 * 4-bit multiplexer
 */

module mux_2x4 (
    input [3:0] i_address_a, // option 1 execution mode
    input [3:0] i_address_b, // option 0 program mode
    input i_select, // select signal
    output [3:0] o_address // selected result
);

    assign o_address = i_select ? i_address_a : i_address_b;

endmodule