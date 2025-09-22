`timescale 1ns/1ps

module datapath (
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_code,

    // control signals
    input logic ALUSrc,            // 0-> rs2, 1-> imm
    input logic MemtoReg,          // 0-> ALU result, 1-> memory data
    input logic RegWrite,
    input logic MemRead,
    input logic MemWrite,
    input logic Branch,            // 0-> no branch, 1-> branch
    // input logic [2:0] ALUOp,
    input logic [4:0] ALUControl,

    output logic [31:0] PC,
    output logic [31:0] MEM_result

);
    logic N, Z, C, V;

    logic [31:0] r_data_0, r_data_1, alu_b;
    logic [31:0] imm_ext;

    register_nbit #(
        .WIDTH(32)
    ) U_PC (
        .clk(clk),
        .rst(rst),
        .w_en(1'b1),
        .d(PC + 32'd4),
        .q(PC)
    );

    register_file_32bit U_REGFILE_32BIT (
        .clk(clk),
        .r_addr_1(instruction_code[24:20]),
        .r_addr_0(instruction_code[19:15]),
        .w_en(Reg_write),
        .w_addr(instruction_code[11:7]),
        .w_data(ALU_result),
        .r_data_1(r_data_1),
        .r_data_0(r_data_0)
    );

    alu_32bit U_ALU_32BIT (
        .a(r_data_0),
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
    ) U_MUX_ALU_SRC (
        .sel(ALUSrc),
        .in('{r_data_1, imm_ext}),
        .out(alu_b)
    );


    data_memory U_DATA_MEMORY (
        .clk(clk),
        .addr(ALU_result),
        .w_data(r_data_1),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .r_data(MEM_result)
    );


endmodule