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
                /* 
                Signed less than: if N and V are different, it means overflow occurred
                   ex)  rs1         rs2       branch_taken      rs1-rs2       N     V    N^V
                   ------------   -------    --------------  -------------  ----- ----- ------
                        10          20        should be 1       -10           1     0     1
                        20          10        should be 0        10           0     0     0
                       -10         -20        should be 1        10           0     1     1
                       -20         -10        should be 0       -10           1     1     0
                    0x7FFF_FFFF  0xFFFF_FFFF  should be 0    0x8000_0000     "1"    1     0 (overflow)
                   (+2147483647)   (-1)       should be 0   (-2147483648)    "1"    1     0 (overflow)
                */
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