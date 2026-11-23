//


module cpu(
    input logic clk, 
    input logic reset
);

    logic [31:0] pc_next;
    logic [31:0] pc_addr;
    logic [31:0] pc_plus4;
    logic [31:0] instr;

    pc u_pc(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_out(pc_addr)
    );

    assign pc_plus4 = pc_addr + 4;

    // TODO: replace with branch mux
    assign pc_next = pc_plus4;

    imem u_imem(
        .address_from_pc(pc_addr),
        .instructions(instr)
    );

endmodule
