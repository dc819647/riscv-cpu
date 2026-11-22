// ALU Decoder:
// Tells the ALU which exact math or logic operation to perform

module alu_decoder (
    input logic [1:0] alu_type,
    input logic [2:0] funct3,
    input logic funct7_5,
    output logic [1:0] alu_op
);

    always @(*) begin
        case(alu_type)
            2'b00: alu_op = 2'b00;              // add
            2'b01: alu_op = 2'b01;              // subtract
            2'b10: begin                        // R-type
                case(funct3)
                    3'b000: begin
                        if (funct7_5)
                            alu_op = 2'b01;     // subtract
                        else
                            alu_op = 2'b00;     // add   
                    end
                    3'b111: alu_op = 2'b10;     // and
                    3'b110: alu_op = 2'b11;     // or
                    default: alu_op = 2'b00;
                endcase
            end
            default: alu_op = 2'b00;
        endcase
    end
endmodule