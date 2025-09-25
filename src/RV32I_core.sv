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
    logic Branch;            // 0-> no branch, 1-> branch
    logic [4:0] ALUControl;  // see define.sv
    logic [31:0] ALU_result;
    logic MemRead;
    logic MemWrite;
    logic [31:0] MEM_w_data;
    logic [31:0] MEM_r_data;
    logic [31:0] mem2reg_mux_out;
    logic branch_taken;
    logic [1:0] PCSrc;


    // logic [2:0] ALUOp;

    control_unit U_CONTROL_UNIT (
        .instruction_code(instruction_code),
        .branch_taken(branch_taken),

        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .PCSrc(PCSrc),
        // .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    datapath U_DATAPATH (
        .clk(clk),
        .rst(rst),
        .instruction_code(instruction_code),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .REG_w_data(mem2reg_mux_out),
        .Branch(Branch),
        .PCSrc(PCSrc),
        // .ALUOp(ALUOp),
        .ALUControl(ALUControl),

        .ALU_result(ALU_result),
        .MEM_w_data(MEM_w_data),
        .branch_taken(branch_taken),
        .PC(PC)
    );

    mux_n #(
        .N(2),
        .WIDTH(32)
    ) U_MUX_MEM_TO_REG (
        .sel(MemtoReg),
        .in('{ALU_result, MEM_r_data}),
        .out(mem2reg_mux_out)
    );

    data_memory U_DATA_MEMORY (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .func3(instruction_code[14:12]),  // 0-> b, 1-> h, 2-> w, 4-> ub, 5-> uh
        .addr(ALU_result),
        .w_data(MEM_w_data),

        .r_data(MEM_r_data)
    );

endmodule