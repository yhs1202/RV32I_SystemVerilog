`timescale 1ns/1ps
module RV32I_core (
    input logic clk,
    input logic rst,
    
    input logic [31:0] instruction_code,
    output logic [31:0] PC
);

    // control signals
    logic ALUSrc;            // 0-> rs2, 1-> imm
    logic MemtoReg;          // 0-> ALU result, 1-> memory data
    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic [2:0] MemUnit;     // see define.sv
    logic Branch;            // 0-> no branch, 1-> branch
    logic [4:0] ALUControl;  // see define.sv


    // logic [2:0] ALUOp;

    control_unit U_CONTROL_UNIT (
        .instruction_code(instruction_code),

        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemUnit(MemUnit),
        .Branch(Branch),
        // .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    datapath U_DATAPATH (
        .clk(clk),
        .rst(rst),
        .instruction_code(instruction_code),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemUnit(MemUnit),
        .Branch(Branch),
        // .ALUOp(ALUOp),
        .ALUControl(ALUControl),

        .PC(PC)
    );

endmodule