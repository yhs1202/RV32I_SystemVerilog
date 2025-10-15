`timescale 1ns/1ps
module RV32I_core (
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_code,

    input logic [31:0] RAM_r_data,
    
    output logic [31:0] PC,
    output logic MemRead,
    output logic MemWrite,
    output logic [31:0] ALU_result,
    output logic [31:0] RAM_w_data,
    output logic [3:0] byte_enable
);

    // control signals
    logic ALUSrc_A;            // 0-> rs1, 1-> pc (for auipc)
    logic ALUSrc_B;            // 0-> rs2, 1-> imm
    logic [1:0] MemtoReg;          // 0-> ALU result, 1-> memory data, 2-> PC+4 (for JAL), 3-> imm (for LUI)
    logic RegWrite;
    logic Branch;            // 0-> no branch, 1-> branch
    logic [4:0] ALUControl;  // see define.sv
    logic branch_taken;
    logic [1:0] PCSrc;

    control_unit U_CONTROL_UNIT (
        .instruction_code(instruction_code),
        .branch_taken(branch_taken),

        .ALUSrc_A(ALUSrc_A),
        .ALUSrc_B(ALUSrc_B),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl)
    );

    datapath U_DATAPATH (
        .clk(clk),
        .rst(rst),
        .instruction_code(instruction_code),
        .ALUSrc_A(ALUSrc_A),
        .ALUSrc_B(ALUSrc_B),
        .RegWrite(RegWrite),
        .RAM_r_data(RAM_r_data),
        .Branch(Branch),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl),
        .MemtoReg(MemtoReg),

        .ALU_result(ALU_result),
        .RAM_w_data(RAM_w_data),
        .byte_enable(byte_enable),
        .branch_taken(branch_taken),
        .PC(PC)
    );



endmodule