/**
 * 8-bit accumulator
 */

module accumulator (
    input i_debug, // design visibility
    input i_reset, // reset register  
    input i_load_enable, // load enable signal
    input i_send_enable, // send enable signal
    input [7:0] i_bus, // 8-bit input line
    output [7:0] o_bus, // 8-bit output line
    output [7:0] o_unbuffered_out // unbuffered output
);

    // initialize values
    reg [7:0] data;

    // if send enable signal is low assign data to floating values
    assign o_bus = i_send_enable ? data : 8'bzzzzzzzz;
    assign o_unbuffered_out = data;
    

    // load values whenever bus is updated or load signal enabled
    always @(i_bus or posedge i_load_enable) begin
        if (i_load_enable) begin
            data <= i_bus;
            if (i_debug) $display("\taccumulator loaded: %b", i_bus);
        end
    end

    // reset values
    always @(posedge i_reset) begin
        data <= 8'bzzzzzzzz;
        if (i_debug) $display("\taccumulator reset: %b", 8'bzzzzzzzz);
    end

 endmodule