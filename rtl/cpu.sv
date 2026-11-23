//


module cpu(
    input logic clk, 
    input logic reset
);

    // Fetch
    logic [31:0] pc_next;
    logic [31:0] pc_addr;
    logic [31:0] pc_plus4;
    logic [31:0] instr;

    logic [31:0] pc_target;
    logic pc_src;

    pc u_pc(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_out(pc_addr)
    );

    assign pc_plus4 = pc_addr + 4;


    imem u_imem(
        .address_from_pc(pc_addr),
        .instructions(instr)
    );

    // Decode
    logic [31:0] read_data1;
    logic [31:0] read_data2;
    logic [31:0] imm_ext;
    logic [31:0] result;

    logic reg_write;
    logic alu_src;
    logic mem_write;
    logic result_src;
    logic branch;

    logic [1:0] imm_src;
    logic [1:0] alu_type;
    logic [1:0] alu_op;

    logic [31:0] src_b;
    logic [31:0] alu_result;
    logic [31:0] mem_data;
    logic zero;

    main_decoder u_main_decoder (
        .opcode(instr[6:0]),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .alu_type(alu_type),
        .branch(branch),
        .mem_write(mem_write),
        .result_src(result_src)
    );

    alu_decoder u_alu_decoder (
        .alu_type(alu_type),
        .funct3(instr[14:12]),
        .funct7_5(instr[30]),
        .alu_op(alu_op)
    );

    regfile u_regfile (
        .clk(clk),
        .read_reg1(instr[19:15]),
        .read_reg2(instr[24:20]),
        .write_reg(instr[11:7]),
        .write_data(result),
        .write_enable(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    imm_gen u_imm_gen (
        .instructions(instr),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    assign src_b = alu_src ? imm_ext : read_data2;

    alu u_alu (
        .input_1(read_data1),
        .input_2(src_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(zero)
    );

    assign pc_target = pc_addr + imm_ext;

    assign pc_next = pc_src ? pc_target : pc_plus4;

    assign pc_src = branch & zero;

    dmem u_dmem (
        .clk(clk),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(mem_data)
    );

    assign result = result_src ? mem_data : alu_result;

endmodule
