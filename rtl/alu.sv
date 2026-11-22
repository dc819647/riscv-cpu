// ALU:
// Does the arithmetics

module alu (
    input logic [31:0] input_1,
    input logic [31:0] input_2,
    input logic [1:0] alu_op,
    output logic [31:0] result,
    output logic zero
);

    always @(*) begin
        case (alu_op)
            2'b00:      result = input_1 + input_2;
            2'b01:      result = input_1 - input_2;
            2'b10:      result = input_1 & input_2;
            2'b11:      result = input_1 | input_2;
            default:    result = 32'b0;
        endcase
    end

    assign zero = (result == 0);

endmodule