/** 
 * SAP-1 Computer simulated in Verilog
 */

`include "accumulator/accumulator.v"
`include "alu/alu.v"
`include "controller/controller.v"
`include "instruction_register/instruction_register.v"
`include "memory_address_register/memory_address_register.v"
`include "mux_2x4/mux_2x4.v"
`include "program_counter/program_counter.v"
`include "ram_16x8/ram_16x8.v"
`include "register/register.v"

module sap (
    input i_debug, // 1 debug flag for all modules for simplicity
    input i_clk, // clock signal
    input i_reset, // send reset signal before every run
    input i_program_mode, // 0 == program mode, 1 == execution mode
    input [7:0] i_program_data, // data to program
    input [3:0] i_program_address, // address to program to
    output [7:0] o_display // can be sent to seven segment display 
);

    // initialize controller signal bits
    wire program_counter_incr;
    wire program_counter_enable;
    wire mar_load;
    wire ram_enable;
    wire instruction_load;
    wire instruction_send;
    wire alu_subtract;
    wire alu_send;
    wire accumulator_load;
    wire accumulator_send;
    wire register_b_load;
    wire register_out_load;

    // initialize main components and connectors
    wire [7:0] bus; // main 8-bit bus 
    wire [3:0] opcode; // connects IR to controller
    wire [7:0] alu_a_in; // connects accumulator to alu
    wire [7:0] alu_b_in; // connects B register to alu
    wire [3:0] mar_to_mux; // connects mar to mux 
    wire [3:0] mux_to_ram; // connects mux to ram 

    // initialize modules
    program_counter pc (
        .i_debug(i_debug), 
        .i_reset(i_reset), 
        .i_incr(program_counter_incr), 
        .i_enable(program_counter_enable),
        .o_count(bus[3:0])
    );

    memory_address_register mar (
        .i_debug(i_debug),
        .i_reset(i_reset),
        .i_load_enable(mar_load),
        .i_address(bus[3:0]),
        .o_address(mar_to_mux)
    );  

    mux_2x4 mux (
        .i_address_a(mar_to_mux),
        .i_address_b(i_program_address),
        .i_select(i_program_mode),
        .o_address(mux_to_ram)
    );

    ram_16x8 ram (
        .i_debug(i_debug),
        .i_program_mode(i_program_mode),
        .i_program_data(i_program_data),
        .i_address(mux_to_ram),
        .i_enable(ram_enable),
        .o_bus(bus)
    );

    instruction_register ir (
        .i_debug(i_debug),
        .i_reset(i_reset),
        .i_load_enable(instruction_load),
        .i_send_enable(instruction_send),
        .i_bus(bus[7:0]),
        .o_opcode(opcode),
        .o_address(bus[3:0]) // bus[3:0]
    );

    alu adder_subtracter (
        .i_a(alu_a_in),
        .i_b(alu_b_in),
        .i_subtract(alu_substract),
        .i_send_enable(alu_send),
        .o_bus(bus)
    );

    accumulator acc (
        .i_debug(i_debug),
        .i_reset(i_reset),
        .i_load_enable(accumulator_load),
        .i_send_enable(accumulator_send),
        .i_bus(bus), 
        .o_bus(bus), 
        .o_unbuffered_out(alu_a_in)
    );

    register buffer (
        .i_debug(i_debug),
        .i_reset(i_reset),
        .i_load_enable(register_b_load),
        .i_bus(bus),
        .o_unbuffered_out(alu_b_in)
    );

    register out (
        .i_debug(i_debug),
        .i_reset(i_reset),
        .i_load_enable(register_out_load),
        .i_bus(bus),
        .o_unbuffered_out(o_display)
    );

    controller control (
        .i_debug(i_debug),
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_opcode(opcode),
        .i_program_mode(i_program_mode),
        .o_program_counter_incr(program_counter_incr),
        .o_program_counter_enable(program_counter_enable),
        .o_mar_load(mar_load),
        .o_ram_enable(ram_enable),
        .o_instruction_load(instruction_load),
        .o_instruction_send(instruction_send),
        .o_alu_subtract(alu_substract),
        .o_alu_send(alu_send),
        .o_accumulator_load(accumulator_load),
        .o_accumulator_send(accumulator_send),
        .o_register_b_load(register_b_load),
        .o_register_out_load(register_out_load)
    );

    always @(posedge i_reset) begin
        if (i_debug) $display ("\nsystem reset:");
    end

    // reads bus contents
    always @(bus) begin
        if (i_debug) $display("\tbus updated: %b", bus);
    end

    // reads output of computer
    always @(o_display) begin
        $display("\toutput register displays: %b", o_display);
    end

endmodule