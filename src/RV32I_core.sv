`timescale 1ns/1ps
module RV32I_core (
    input logic clk,
    input logic rst,
    
    input logic [31:0] instruction_code,
    output logic [31:0] result,  // Output for now
    output logic [31:0] PC
);

    logic Reg_write;

    // logic [2:0] ALUOp;
    logic [4:0] ALUControl;   

    control_unit U_CONTROL_UNIT (
        .instruction_code(instruction_code),

        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
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
        .Branch(Branch),
        // .ALUOp(ALUOp),
        .ALUControl(ALUControl),

        .PC(PC),
        .MEM_result(result)
    );

endmodule