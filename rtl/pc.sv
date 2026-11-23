// Program Counter:
// Holds the byte address of the current instruction.
// Loads the next instruction address chosen by the CPU (PC+4 or branch target).

module pc (
	input logic clk,			// Rising edge updates PC to the next instruction address
	input logic reset,			// Sets PC back to 0x0
	input logic [31:0] pc_next,
	output logic [31:0] pc_out	// Instructions
);

	always @(posedge clk) begin
		if (reset)
			pc_out <= 32'b0;	  // Reset PC to starting address (0x00000000)
		else
			pc_out <= pc_next; // next address (PC+4 or branch target), computed by the CPU.
	end
endmodule
