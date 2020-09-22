/**
 * 4-bit memory address register
 */

module memory_address_register (
    input i_debug, // design visiblity
    input i_reset, // reset count to 0000
    input i_load_enable, // load enable signal
    input [3:0] i_address, // 4-bit address input
    output [3:0] o_address // 4-bit address output
);

    // initialization for internal register
    reg [3:0] address = 4'b0000;
    assign o_address = address;

    // load values whenever load signal enabled
    always @(i_address or posedge i_load_enable) begin
        if (i_load_enable) begin
            address <= i_address;
            if (i_debug) $display("\tMAR loaded: %b", i_address);
        end
    end

    //reset values
    always @(posedge i_reset) begin
        address = 4'b0000;
        if (i_debug) $display("\tMAR reset: %b", 4'b0000);
    end

endmodule