`timescale 1ns/1ps

module datapath (
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_code,

    // control signals
    input logic ALUSrc_A,            // 0-> rs1, 1-> pc (for auipc)
    input logic ALUSrc_B,            // 0-> rs2, 1-> imm
    input logic RegWrite,
    input logic [31:0] REG_w_data,
    input logic Branch,            // 0-> no branch, 1-> branch
    input logic [1:0] PCSrc,       // 0-> PC+4, 1-> branch target, 2-> JAL target, 3-> JALR target
    // input logic [2:0] ALUOp,
    input logic [4:0] ALUControl,

    output logic [31:0] ALU_result,  // mem_addr
    output logic [31:0] MEM_w_data,  // mem_w_data
    output logic branch_taken,
    output logic [31:0] PC,
    output logic [31:0] PC_Plus4
    output logic [31:0] imm_ext;
);

    logic [31:0] r_data_0, r_data_1;
    logic [31:0] alu_a, alu_b;
    logic [31:0] mem2reg_mux_out;

    logic N, Z, C, V;
    logic 

    assign MEM_w_data = r_data_1;

    // assign REG_w_data = MemtoReg ? MEM_r_data:
                        // ((jal | jalr) ? PC_Plus4 : ALU_result);

    /* PC register (subtitute for PC logic) */
    // register_nbit #(
    //     .WIDTH(32)
    // ) U_PC (
    //     .clk(clk),
    //     .rst(rst),
    //     .w_en(1'b1),
    //     .d(PC + 32'd4),
    //     .q(PC)
    // );

    register_file_32bit U_REGFILE_32BIT (
        .clk(clk),
        .r_addr_1(instruction_code[24:20]),
        .r_addr_0(instruction_code[19:15]),
        .w_en(RegWrite),
        .w_addr(instruction_code[11:7]),
        .w_data(REG_w_data),

        .r_data_1(r_data_1),
        .r_data_0(r_data_0)
    );

    alu_32bit U_ALU_32BIT (
        .a(alu_a),
        .b(alu_b),
        // .ALUOp(ALUOp),
        .ALUControl(ALUControl),

        .N(N),
        .Z(Z),
        .C(C),
        .V(V),
        .result(ALU_result)
    );

    extend U_EXTEND (
        .instruction_code(instruction_code),
        .imm_ext(imm_ext)
    );

    mux_n #(
        .N(2),
        .WIDTH(32)
    ) U_MUX_ALU_SRC_A (
        .sel(ALUSrc_A),
        .in('{r_data_0, PC}),
        .out(alu_a)
    );

    mux_n #(
        .N(2),
        .WIDTH(32)
    ) U_MUX_ALU_SRC_B (
        .sel(ALUSrc_B),
        .in('{r_data_1, imm_ext}),
        .out(alu_b)
    );

    branch_logic U_BRANCH_LOGIC (
        .Branch(Branch),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V),
        .func3(instruction_code[14:12]),

        .branch_taken(branch_taken)
    );

    pc_logic U_PC_LOGIC (
        .clk(clk),
        .rst(rst),
        .PC_branch_offset(imm_ext),
        .ALU_result(ALU_result),
        .PCSrc(PCSrc),    // 00: PC+4, 01: branch, 10: jump, 11: jalr

        .PC_Plus4(PC_Plus4),    // for jal, will be used in the future
        .PC_reg(PC)
    );

endmodule