`timescale 1s / 100ms
`include "instruction_register.v"

module instruction_register_tb();

    reg debug = 1'b1;
    reg reset;
    reg i_load;
    reg i_send;
    reg [7:0] i_bus;
    wire [3:0] opcode;
    wire [3:0] address;

    instruction_register instruct_regtest (
        debug, reset, i_load, i_send, i_bus, opcode, address
    );

    initial begin

        // register should output floating value when send enable is low
        i_send = 0; #10;
        i_load = 1; #10;
        i_bus = 8'b11001100; #10;

        // enable send and disable load
        i_send = 1; #10;
        i_load = 0; #10;
        i_bus = 8'b10101001; #10;

        // register should update when load enable turns high
        i_load = 1; #10;

        // register should update when bus is updated
        i_bus = 8'b00010111; #10;

        reset = 1; #10;

        $finish;
    end

endmodule