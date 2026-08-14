module regfile( 
    input logic clk, 
    input logic [4:0] read_reg1, 
    input logic [4:0] read_reg2, 
    input logic [4:0] write_reg, 
    input logic [31:0] write_data, 
    input logic write_enable, 
    output logic [31:0] read_data1, 
    output logic [31:0] read_data2 
); 

    logic [31:0] registers [0:31]; 

    //Clock Write
    always @(posedge clk) begin
        if (write_enable)
            registers[write_reg] <= write_data;
    end

    //Combinational Reads + x0-always-zero rule
    assign read_data1 = (read_reg1 == 0) ? 32'b0 : registers[read_reg1];    //Port 1
    assign read_data2 = (read_reg2 == 0) ? 32'b0 : registers[read_reg2];    //Port 2

endmodule