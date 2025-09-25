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
                Signed less than: if N and V are different, it means branch is taken. (see below)
                   ex)  rs1         rs2       branch_taken      rs1-rs2       N     V    N^V
                   ------------   -------    --------------  -------------  ----- ----- ------
                        10          20        should be 1       -10           1     0     1
                        20          10        should be 0        10           0     0     0
                       -10         -20        should be 1        10           0     1     1
                       -20         -10        should be 0       -10           1     1     0
                    0x7FFF_FFFF  0xFFFF_FFFF  should be 0    0x8000_0000     "1"    1     0 (overflow)
                   (+2147483647)   (-1)                     (-2147483648)    // the reason branch_taken for blt is N^V, not just N
                */
                `F3_BGE: branch_taken = ~(N ^ V);
                `F3_BLTU: branch_taken = ~C;
                /*
                Unsigned less than: if there is borrow (~C) in rs1 - rs2, it means rs1 < rs2, so branch is taken.
                borrow -> occurs when the minuend (rs1) is less than the subtrahend (rs2), 
                rs1 - rs2 = rs1 + (~rs2 + 1), 
                   ex)  rs1         rs2       branch_taken      rs1-rs2      C    ~C
                   ------------   -------    --------------  -------------  ---- -----
                        10          20        should be 1       -10          0     1
                        20          10        should be 0        10          1     0
                       -10         -20        should be 0        10          1     0
                       -20         -10        should be 1       -10          0     1
                    0x0000_0000  0xFFFF_FFFF  should be 1    0x0000_0001     0     1 (borrow)
                       (0)      (4294967295)  should be 1   (-4294967295)   "0"    1 (borrow)
                */
                `F3_BGEU: branch_taken = C;
                default: branch_taken = 1'b0;
            endcase
        end else begin
            branch_taken = 1'b0; // No branch
        end
    end
endmodule