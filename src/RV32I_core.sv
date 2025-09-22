`timescale 1ns/1ps
module RV32I_core (
    input logic clk,
    input logic rst,
    
    input logic [31:0] instruction_code,
    output logic N, Z, C, V,
    output logic [31:0] ALU_result,  // Output for now
    output logic [31:0] PC
);

    logic Reg_write;

    logic [2:0] ALUOp;
    logic [3:0] ALUControl;   

    control_unit U_CONTROL_UNIT (
        .clk(clk),
        .rst(rst),
        .instruction_code(instruction_code),

        .Reg_write(Reg_write),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    datapath U_DATAPATH (
        .clk(clk),
        .rst(rst),
        .instruction_code(instruction_code),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl),
        .Reg_write(Reg_write),

        .PC(PC),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V),
        .ALU_result(ALU_result)
    );

endmodule