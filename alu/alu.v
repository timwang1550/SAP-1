/**
 * 8-bit arithmetic logic unit
 * adder or subtractor using 2's complement
 */

module alu (
    input [7:0] i_a, // 8-bit value from accumulator
    input [7:0] i_b, // 8-bit value from b register
    input i_subtract, // 1 = subtract mode, 0 = add mode
    input i_send_enable, // send enable signal
    output [7:0] o_bus // 8-bit output
 );

    // initialization for internal registers
    reg [7:0] result;

    assign o_bus = i_send_enable ? result : 8'bzzzzzzzz;

    always @(posedge i_send_enable) begin
        // add or subtract depending on mode
        result = i_subtract ? (i_a - i_b) : (i_a + i_b);
    end
    
 endmodule