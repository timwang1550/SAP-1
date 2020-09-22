/**
 * program counter that counters from 0000 to 1111 then loops
 */

module program_counter (
    input i_debug, // design visiblity
    input i_reset, // reset count to 0000
    input i_incr, // increments on pos incr signal
    input i_enable, //tri-state output
    output [3:0] o_count // 4 bit output to 8 bit 
);

    // intialize internal registers
    reg[3:0] counter = 4'b0000;
    reg[7:0] counter_buffer = 4'bzzzz;
    assign o_count = counter_buffer;

    // increment counter
    always @ (posedge i_incr) begin
        // if counter reaches 1111 then reset, otherwise plus 1
        counter <= ((counter == 4'b1111) ? 4'b0000 : counter + 4'b0001);
        // pc seems to output debug message before increment occurs
        if (i_debug) $display("\tPC value incremented: %b", counter + 4'b0001);
    end 

    // output 
    always @ (i_enable) begin
        if (i_enable) begin
            counter_buffer <= counter;
            if (i_debug) $display("\tPC output to bus: %b", counter);
        end else begin
            counter_buffer <= 4'bzzzz;
        end
    end

    // reset
    always @ (posedge i_reset) begin
        counter <= 4'b0000;
        if (i_debug) $display("\tPC reset: %b", counter);
    end

endmodule