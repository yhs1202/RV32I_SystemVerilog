`timescale 1ns/1ps
module alu_32bit (
    input logic [2:0] ALUOp,
    input logic [31:0] a,
    input logic [31:0] b,

    output logic N, Z, C, V,
    output logic [31:0] result
);

    enum logic [2:0] {
        ADD, SUB, AND, OR, SLT
      } operation;

    assign N = result[31];
    assign Z = (result == 32'b0);
    // assign V = 

    always_comb begin
        case (ALUOp)
            ADD: {C, result} = a + b;
            SUB: {C, result} = a - b;
            AND: result = a & b;
            OR: result = a | b;
            SLT: result = {31'b0, a < b};
            default: result = 32'bx;    // NO OPERATION
        endcase
        
    end

endmodule