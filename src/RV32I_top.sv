`timescale 1ns/1ps
module RV32I_top (
    input logic clk,
    input logic rst
);
    logic [31:0] PC;
    logic [31:0] instruction_code;

    logic MemRead;
    logic MemWrite;
    logic [31:0] ALU_result;
    logic [31:0] RAM_r_data;
    logic [31:0] RAM_w_data;
    logic [3:0] byte_enable;


    ROM U_ROM (
        .addr(PC),
        .instruction_code(instruction_code)
    );

    RV32I_core U_RV32I_CORE (
        .clk(clk),
        .rst(rst),
        .instruction_code(instruction_code),
        .RAM_r_data(RAM_r_data),

        .PC(PC),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALU_result(ALU_result),
        .RAM_w_data(RAM_w_data),
        .byte_enable(byte_enable)
    );

    RAM_with_BE U_RAM (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .byte_enable(byte_enable),
        .addr(ALU_result),
        .w_data(RAM_w_data),

        .r_data(RAM_r_data)
    );

endmodule