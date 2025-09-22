`timescale 1ns/1ps
module RV32I_top (
    input logic clk,
    input logic rst,
    output logic N, Z, C, V,
    output logic [31:0] ALU_result  // Output for now

);
    logic [31:0] PC;
    logic [31:0] instruction_code;

    logic Reg_write;

    logic [2:0] ALUOp;
    logic [3:0] ALUControl;
    // logic [31:0] ALU_result;    


    instruction_mem U_INSTRUCTION_MEM (
        .addr(PC),
        .instruction_code(instruction_code)
    );

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