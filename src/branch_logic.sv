`timescale 1ns/1ps
`include "define.svh"

module branch_logic (
    input logic Branch,
    input logic N, Z, C, V, // from ALU flags with rs1 - rs2
    input logic [2:0] func3,

    output logic branch_taken
);
    always_comb begin
        if (Branch) begin
            case (func3)
                `F3_BEQ: branch_taken = Z;
                `F3_BNE: branch_taken = ~Z;
                `F3_BLT: branch_taken = N ^ V;
                `F3_BGE: branch_taken = ~(N ^ V);
                `F3_BLTU: branch_taken = ~C;
                `F3_BGEU: branch_taken = C;
                default: branch_taken = 1'b0;
            endcase
        end else begin
            branch_taken = 1'b0; // No branch
        end
    end
endmodule