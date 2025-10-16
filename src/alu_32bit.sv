`timescale 1ns/1ps
`include "define.svh"

module alu_32bit (
    input logic [3:0] ALUControl,
    input logic signed [31:0] a,
    input logic signed [31:0] b,

    output logic N, Z, C, V,
    /*
    N -> Negative flag
    Z -> Zero flag
    C -> Carry flag
    V -> Overflow flag
    
    when adding or subtracting two numbers which have the same sign, 
    the ALU_result has the opposite sign if overflow occurs.
    ex) 0111 + 0100 = 1011 (overflow)
        1000 - 0100 = 1100 (overflow)
    */
    output logic [31:0] ALU_result
);

    assign N = ALU_result[31];
    assign Z = (ALU_result == 32'b0);

    always_comb begin : ALU_operations
        C = 1'b0; V = 1'b0;
        case (ALUControl)
            `ALU_ADD: begin
                {C, ALU_result} = a + b;
                V = (~(a[31]^b[31]) & (a[31]^ALU_result[31]));
            end
            `ALU_SUB: begin
                {C, ALU_result} = a - b;    // C = ~borrow
                V = ((a[31]^b[31]) & (a[31]^ALU_result[31]));
            end
            `ALU_XOR: ALU_result = a ^ b;
            `ALU_OR: ALU_result = a | b;
            `ALU_AND: ALU_result = a & b;
            `ALU_SLL: ALU_result = a << b[4:0];
            `ALU_SRL: ALU_result = a >> b[4:0];
            `ALU_SRA: ALU_result = $signed(a) >>> b[4:0];
            `ALU_SLT: ALU_result = {31'b0, $signed(a) < $signed(b)};
            `ALU_SLTU: ALU_result = {31'b0, $unsigned(a) < $unsigned(b)};
            default: ALU_result = 32'b0;    // NO OPERATION
        endcase
    end
endmodule