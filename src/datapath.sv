`timescale 1ns/1ps

module datapath (
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_code,
    input logic [2:0] ALUOp,
    input logic [3:0] ALUControl,
    input logic Reg_write,

    output logic [31:0] PC,
    output logic N, Z, C, V,
    output logic [31:0] ALU_result

);
    logic [31:0] r_data_0, r_data_1;

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
        .b(r_data_1),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V),
        .result(ALU_result)
    );

endmodule