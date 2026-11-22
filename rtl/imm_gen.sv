// Immediate Generator:


module imm_gen(
    input logic [31:0] instructions,
    input logic [1:0] imm_src,
    output logic [31:0] imm_ext
);

    always @(*) begin
        case(imm_src)
            2'b00:      imm_ext = {{20{instructions[31]}}, instructions[31:20]};                        // I-type instruction: one immediate @ instructions[32:20]
            2'b01:      imm_ext = {{20{instructions[31]}}, instructions[31:25], instructions[11:7]};    // S-type instructions: 2 immediates @ instuctions[31:25] & instructions[11:7]
            2'b10:      imm_ext = {{20{instructions[31]}}, instructions[7], instructions[30:25], instructions[11:8], 1'b0};       // B-type instructions:
            default:    imm_ext = 32'b0;
        endcase
    end

endmodule