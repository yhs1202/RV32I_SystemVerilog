`timescale 1ns/1ps
`include "define.sv"

module alu_32bit (
    // input logic [2:0] ALUOp,
    input logic [4:0] ALUControl,
    input logic [31:0] a,
    input logic [31:0] b,

    output logic N, Z, C, V,
    /*
    N -> Negative flag
    Z -> Zero flag
    C -> Carry flag
    V -> Overflow flag
    
    when adding or subtracting two numbers which have the same sign, 
    the result has the opposite sign if overflow occurs.
    ex) 0111 + 0100 = 1011 (overflow)
        1000 - 0100 = 1100 (overflow)
    */
    output logic [31:0] result
);

    assign N = result[31];
    assign Z = (result == 32'b0);

    always_comb begin : ALU_operations
        N = 1'b0; Z = 1'b1; C = 1'b0; V = 1'b0;
        case (ALUControl)
            `ALU_ADD: begin
                {C, result} = a + b;
                V = (~(a[31]^b[31]) & (a[31]^result[31]));
            end
            `ALU_SUB: begin
                {C, result} = a - b;
                V = ((a[31]^b[31]) & (a[31]^result[31]));
            end
            `ALU_XOR: result = a ^ b;
            `ALU_OR: result = a | b;
            `ALU_AND: result = a & b;
            `ALU_SLL: result = a << b[4:0];
            `ALU_SRL: result = a >> b[4:0];
            `ALU_SRA: result = $signed(a) >>> b[4:0];
            `ALU_SLT: result = {31'b0, a < b};
            `ALU_SLTU: result = {31'b0, $unsigned(a) < $unsigned(b)};
            default: result = 32'bx;    // NO OPERATION
        endcase
    end
endmodule