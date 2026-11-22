// Main Decoder:
// Looks at instructions opcode (6:0) to set up the overall path data takes through the CPU.

module main_decoder(
    input logic [6:0] opcode,
    output logic reg_write,
    output logic [1:0] imm_src,
    output logic alu_src,
    output logic mem_write,
    output logic result_src,
    output logic branch,
    output logic [1:0] alu_type
);

    always @(*) begin
        reg_write = 0; alu_src = 0; mem_write = 0; result_src = 0; branch = 0; imm_src = 2'b00; alu_type = 2'b00;
        case(opcode)
            7'b0110011: begin
                reg_write = 1; alu_type = 2'b10;                // R-type
            end
            7'b0010011: begin
                reg_write = 1; alu_src = 1;                     // addi
            end
            7'b0000011: begin
                reg_write = 1; alu_src = 1; result_src = 1;     // lw
            end
            7'b0100011: begin
                alu_src = 1; mem_write = 1; imm_src = 2'b01;    // sw
            end
            7'b1100011: begin
                branch = 1; alu_type = 2'b01; imm_src = 2'b10;  // beq
            end
            default: ;
        endcase
    end

endmodule