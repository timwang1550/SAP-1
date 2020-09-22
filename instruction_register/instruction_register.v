/**
 * instruction register with two 4-bit registers,
 * opcode register and address register
 */
 
module instruction_register (
    input i_debug, // design visibility
    input i_reset, // reset register 
    input i_load_enable, // load enable signal
    input i_send_enable, // send enable signal
    input [7:0] i_bus, // 8-bit instruction set
    output [3:0] o_opcode, // 4-bit opcode unbuffered output
    output [3:0] o_address // 4-bit address output
);

    // initialization for internal registers
    reg [3:0] opcode;
    reg [3:0] address;

    // if send enable signal low assign address to floating values
    assign o_opcode = opcode; //unbuffered output to controller
    assign o_address = i_send_enable ? address : 4'bzzzz;

    // load values whenever bus is updated or load signal enabled
    always @(i_bus or posedge i_load_enable) begin
        if (i_load_enable) begin
            opcode = i_bus[7:4];
            address = i_bus[3:0];
            if (i_debug) $display("\tIR loaded: %b", i_bus);
        end
    end

    // reset values
    always @(posedge i_reset) begin
        opcode <= 4'b0000;
        address <= 4'b0000;
      if (i_debug) $display("\tIR reset: %b", 8'b00000000);
   end

endmodule
