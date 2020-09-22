/**
 * control sequencer
 */

module controller (
    input i_debug, // design visiblity
    input i_clk, // clock signal
    input i_reset, // reset signal
    input [3:0] i_opcode, // opcode from instruction register
    input i_program_mode, // 0 == program mode, 1 == execution mode
    // control signals
    output o_program_counter_incr,
    output o_program_counter_enable,
    output o_mar_load,
    output o_ram_enable,
    output o_instruction_load,
    output o_instruction_send,
    output o_alu_subtract,
    output o_alu_send,
    output o_accumulator_load,
    output o_accumulator_send,
    output o_register_b_load,
    output o_register_out_load //
    );

    // opcodes
    reg[3:0] LDA = 4'b0000; // load the accumulator
    reg[3:0] ADD = 4'b0001; // add
    reg[3:0] SUB = 4'b0010; // subtract
    reg[3:0] OUT = 4'b1110; // output
    reg[3:0] HLT = 4'b1111; // halt

    // initialize control bits
    reg [11:0] control_bits = 12'b0000_0000_0000;

    assign o_program_counter_incr = control_bits[11];
    assign o_program_counter_enable = control_bits[10];
    assign o_mar_load = control_bits[9];
    assign o_ram_enable = control_bits[8];

    assign o_instruction_load = control_bits[7];
    assign o_instruction_send = control_bits[6];
    assign o_alu_subtract = control_bits[5];
    assign o_alu_send = control_bits[4];

    assign o_accumulator_load = control_bits[3];
    assign o_accumulator_send = control_bits[2];
    assign o_register_b_load = control_bits[1];
    assign o_register_out_load = control_bits[0];

    // "ring counter" 6 step counter
    integer step = 1;

    // halt flag to end execution
    reg halt = 0;

    always @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            //reset step back to 1
            step <= 1;
            //reset halt flag
            halt <= 0;
        end 

        // step cycle only when halt flag is not raised
        if (!halt) begin
            // fetch cycle step 1 
            if (step == 1) begin
                if (i_debug) $display("\nT1: address state");
                // enable program_counter
                // enable mar load
                control_bits <= 12'b0110_0000_0000;
                step <= step + 1;
            end

            // fetch cycle step 2
            else if (step == 2) begin
                if (i_debug) $display("T2: increment state");
                // program_incr
                control_bits <= 12'b1000_0000_0000; 
                step <= step + 1; 
            end

            // fetch cycle step 3
            else if (step == 3) begin
                if (i_debug) $display("T3: memory state");
                // enable ram
                // enable instruction load
                control_bits <= 12'b0001_1000_0000;
                step <= step + 1;
            end

            // instruction cycle 
            case (i_opcode)
                LDA: begin
                    case (step)
                        4: begin
                            if (i_debug) $display("T4: load MAR state");
                            // enable mar load
                            // enable intruction send
                            control_bits <= 12'b0010_0100_0000;
                            step <= step + 1;
                        end

                        5: begin
                            if (i_debug) $display("T5: load accumulator state");
                            // enable ram 
                            // enable accumulator load
                            control_bits <= 12'b0001_0000_1000;
                            step <= step + 1;
                        end

                        6: begin
                            if (i_debug) $display("T6: no op state");
                            control_bits <= 12'b0000_0000_0000;
                            step <= 1; // reset step counter
                        end
                    endcase
                end

                ADD, // ADD and SUB opcode perform same routine
                SUB: begin
                    case (step)
                        4: begin
                            if (i_debug) $display("T4: load MAR state");
                            // enable mar load
                            // enable intruction send
                            control_bits <= 12'b0010_0100_0000;
                            step <= step + 1;
                        end

                        5: begin
                            if (i_debug) $display("T5: load B register state");
                            // enable ram
                            // enable B register load
                            control_bits <= 12'b0001_0000_0010;
                            step <= step + 1;
                        end

                        6: begin 
                            // enable alu send and accumulator load

                            // subtract bit set low
                            if (i_opcode == ADD) begin
                                if (i_debug) $display("T6: add B to A state");
                                control_bits <= 12'b0000_0001_1000;
                            // subtract bit set high
                            end else begin
                                if (i_debug) $display("T6: subtract B from A state");
                                control_bits <= 12'b0000_0011_1000;
                            end
                            step <= 1; // reset step counter
                        end
                    endcase
                end

                OUT: begin
                    case (step)
                        4: begin
                            if (i_debug) $display("T4: load out register state");
                            // enable accumulator send
                            // enable out register load
                            control_bits <= 12'b0000_0000_0101;
                            step <= step + 1;
                        end

                        5: begin
                            if (i_debug) $display("T5: no op state");
                            control_bits <= 12'b0000_0000_0000;
                            step <= step + 1;
                        end

                        6: begin 
                            if (i_debug) $display("T6: no op state");
                            control_bits <= 12'b0000_0000_0000;
                            step <= 1; // reset step counter
                        end
                    endcase
                end

                HLT: begin
                    if (i_debug) $display("T4: halt state");  
                    control_bits <= 12'b0000_0000_0000;
                    halt = 1; // program is done, raise halt flag
                end

            endcase
        
        end

    end

    always @(i_opcode) begin
        if (i_debug) $display("\tnew opcode: %b", i_opcode);
    end

    /* debugging control sequence
    always @(control_bits) begin
        if (i_debug) $display("\tnew control sequence: %b", control_bits);
    end */

    // if program mode (0), halt flag is up
    // if execution mode (1), halt flag is down
    always @(i_program_mode) begin
        halt <= !i_program_mode;
    end

endmodule