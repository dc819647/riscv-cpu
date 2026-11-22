// Program Counter:
// Holds the byte address of the current instruction.
// Advances sequenctially (+4 bytes) on each active cycle.

module pc (
	input logic clk,			// Rising edge updates PC to the next instruction address
	input logic reset,			// Sets PC back to 0x0
	output logic [31:0] pc_out	// Instructions
);

	always @(posedge clk) begin
		if (reset)
			pc_out <= 32'b0;	  // Reset PC to starting address (0x00000000)
		else
			pc_out <= pc_out + 4; // Advance by 4 bytes (each RISC-V instruction is 32 bits / 4 bytes)
	end
endmodule
