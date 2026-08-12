module pc (
	input logic clk,
	input logic reset,
	output logic [31:0] pc_out
);

	always @(posedge clk) begin
		if (reset)
			pc_out <= 32'b0;
		else
			pc_out <= pc_out + 4; // Increment by 4 beause RISC-V are 4 bytes.
	end
endmodule
