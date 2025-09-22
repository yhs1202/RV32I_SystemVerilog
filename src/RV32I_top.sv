`timescale 1ns/1ps
module RV32I_top (
    input logic clk,
    input logic rst,
    output logic [31:0] result
);
    logic [31:0] PC;
    logic [31:0] instruction_code;

    instruction_mem U_INSTRUCTION_MEM (
        .addr(PC),
        .instruction_code(instruction_code)
    );

    RV32I_core U_RV32I_CORE (
        .clk(clk),
        .rst(rst),
        .instruction_code(instruction_code),

        .result(result),
        .PC(PC)
    );

endmodule