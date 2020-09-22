/**
 * 16x8 RAM 
 */

module ram_16x8 (
    input i_debug, // design visibility
    input i_program_mode, // 0 == program mode, 1 == execution mode
    input [7:0] i_program_data, // data programmed before execution
    input [3:0] i_address, // address to read / write
    input i_enable, // enable signal
    output [7:0] o_bus // 8-bit output to main bus
);

    // internal registers
    reg [7:0] ram[0:15];

    // if read enable low assign output to floating values
    assign o_bus = i_enable ? ram[i_address] : 8'bzzzzzzzz;

    // only 16B of memory to simplify 
    // initialize every address of RAM with dont cares
    integer index;
    initial begin
        for(index = 0; index < 16; index=index+1) begin
            ram[index] = 8'bxxxxxxxx;
        end
    end

    // whenever address is updated
    always @(i_address) begin
        // if program mode is 0, write to address data from program_data bus
        if (!i_program_mode) begin
            ram[i_address] <= i_program_data;  
            if (i_debug) $display("\tRAM address: %b programmed with: %b",i_address, i_program_data);
        end
    end

    // whenever ram enable signal is high
    always @(posedge i_enable) begin
        if (i_debug) $display("\tRAM address: %b data to bus: %b",i_address, ram[i_address]);
    end

endmodule