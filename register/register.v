/**
 * default 8-bit register with unbuffered output
 * used for B register and output register
 */

module register (
    input i_debug, // design visibility
    input i_reset, // reset register
    input i_load_enable, // load enable signal
    input [7:0] i_bus, // 8-bit input line
    output [7:0] o_unbuffered_out // unbuffered output to alu
);

    // initialize internal registers
    reg [7:0] data;

    assign o_unbuffered_out = data;

    // load values whenever bus is updated or load signal enabled
    always @(i_bus or posedge i_load_enable) begin
        if (i_load_enable) begin
            data <= i_bus;
            if (i_debug) $display("\tregister loaded: %b", i_bus);
        end
    end

    // reset values
    always @(posedge i_reset) begin
        data <= 8'bzzzzzzzz;
        if (i_debug) $display("\tregister reset: %b", 8'bzzzzzzzz);
    end

endmodule