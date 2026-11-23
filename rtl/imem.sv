// Instruction Memory:
// Gets the instruction from the Program Counter and outputs it.

module imem (
    input logic [31:0] address_from_pc,     // Address of instruction
    output logic [31:0] instructions        // instruction output
);
    logic [31:0] memory_array [0:255];      // Storage for 256 bit instruction

    initial begin
        memory_array[ 0] = 32'h00500093;  // 0x00: addi x1, x0, 5     x1 = 5
        memory_array[ 1] = 32'h00A00113;  // 0x04: addi x2, x0, 10    x2 = 10
        memory_array[ 2] = 32'h002081B3;  // 0x08: add  x3, x1, x2    x3 = 15
        memory_array[ 3] = 32'h40110233;  // 0x0C: sub  x4, x2, x1    x4 = 5
        memory_array[ 4] = 32'h0020F2B3;  // 0x10: and  x5, x1, x2    x5 = 0   (0101 & 1010)
        memory_array[ 5] = 32'h0020E333;  // 0x14: or   x6, x1, x2    x6 = 15  (0101 | 1010)
        memory_array[ 6] = 32'h00302023;  // 0x18: sw   x3, 0(x0)     mem[0] = 15
        memory_array[ 7] = 32'h00002383;  // 0x1C: lw   x7, 0(x0)     x7 = 15
        memory_array[ 8] = 32'h00718463;  // 0x20: beq  x3, x7, 8     equal -> jump to 0x28
        memory_array[ 9] = 32'h00100413;  // 0x24: addi x8, x0, 1     SKIPPED, x8 stays 0
        memory_array[10] = 32'h00700493;  // 0x28: addi x9, x0, 7     x9 = 7 (landed after branch)
        memory_array[11] = 32'h00000063;  // 0x2C: beq  x0, x0, 0     loop forever (halt)
    end

    assign instructions = memory_array[address_from_pc[9:2]];

endmodule
