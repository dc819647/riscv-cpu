// Register File:
// Stores 32 registers (x0 - x31). Looks up the data values needed for current
// instruction and sends them to ALU, then saves the final result back into a register. 

module regfile( 
    input logic clk,                                // On rising edge, writes final result for current instruction then move to next instruction
    input logic [4:0] read_reg1,                    // First input number of instruction
    input logic [4:0] read_reg2,                    // Second input number of instruction
    input logic [4:0] write_reg,                    // Where the final result is saved
    input logic [31:0] write_data,                  // The actual 32-but final result
    input logic write_enable,                       // Whether to save (1) or not save (0) final result
    output logic [31:0] read_data1,                 // The 32-bit number stored inside reg1
    output logic [31:0] read_data2                  // The 32-bit number stored inside reg2
); 

    logic [31:0] registers [0:31];                  // Declare 32 registers holding 32-but number

    //Clock Write
    always @(posedge clk) begin                     // Waits for rising edge
        if (write_enable)
            registers[write_reg] <= write_data;     // Saves the 32 bit data to wherever write_reg is
    end

    //Combinational Reads + x0-always-zero rule
    assign read_data1 = (read_reg1 == 0) ? 32'b0 : registers[read_reg1];    //Port 1
    assign read_data2 = (read_reg2 == 0) ? 32'b0 : registers[read_reg2];    //Port 2

endmodule