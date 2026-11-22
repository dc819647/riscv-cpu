// Data Memory:
// Holds 256 larger 32-bit slots that the program reads from using load instructions (lw)
// and daves to using store instruction (sw). CPU's main storage (RAM) for data like array,
// list, or variable that don't fit inside the 32 registers.

module dmem(
    input logic clk,
    input logic mem_write,
    input logic [31:0] address,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] memory [0:255];

    assign read_data = memory[address[9:2]];        // Immediately outputs the 32-bit word stored at that memory location

    always @(posedge clk) begin
		if (mem_write)
			memory[address[9:2]] <= write_data;     // On rising edge, if mem_write = 1, save write_data at that memory location
	end

endmodule