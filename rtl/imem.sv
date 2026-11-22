// Instruction Memory:
// Gets the instruction from the Program Counter and outputs it.

module imem (
    input logic [31:0] address_from_pc,     // Address of instruction
    output logic [31:0] instructions        // instruction output
);
    logic [31:0] memory_array [0:255];      // Storage for 256 bit instruction

    initial begin
        memory_array[0] = 32'h00500093;     // addi x1, x0, 5
        memory_array[1] = 32'h00A00113;     // addi x2, x0, 10
        memory_array[2] = 32'h002081B3;     // add  x3, x1, x2
    end

    assign instructions = memory_array[address_from_pc[9:2]];

endmodule
