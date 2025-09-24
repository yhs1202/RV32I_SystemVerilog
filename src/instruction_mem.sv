`timescale 1ns/1ps
`include "asm2hex_macro.svh"

module instruction_mem (
    input logic [31:0] addr,
    output logic [31:0] instruction_code
);

    logic [31:0] mem [0:31];

    initial begin
        #10;
                                        //      func7     rs2    rs1  func3   rd    opcode
        /* R-type instructions */
        if (0) begin
            // add rd(x5), rs1(x3), rs2(x4)
            // mem[0] = 32'h0041_82B3;  // 32'b0000_000 0_0100 _0001_1 000 _0010_1 011_0011
            mem[0] = ADD(5'd5, 5'd3, 5'd4);
            // sub rd(x7), rs1(x8), rs2(x9)
            // mem[1] = 32'h4094_03B3;  // 32'b0100_000 0_1001 _0100_0 000 _0011_1 011_0011
            mem[1] = SUB(5'd7, 5'd8, 5'd9);
            // xor rd(x8), rs1(x3), rs2(x4)
            // mem[2] = 32'h0041_C433;  // 32'b0000_000 0_0100 _0001_1 100 _0100_0 011_0011
            mem[2] = XOR(5'd8, 5'd3, 5'd4);
            // or rd(x8), rs1(x3), rs2(x4)
            // mem[3] = 32'h0041_E433;  // 32'b0000_000 0_0100 _0001_1 110 _0100_0 011_0011
            mem[3] = OR(5'd8, 5'd3, 5'd4);
            // and rd(x2), rs1(x5), rs2(x4)
            // mem[4] = 32'h0042_F133;  // 32'b0000_000 0_0100 _0010_1 111 _0001_0 011_0011
            mem[4] = AND(5'd2, 5'd5, 5'd4);
            // sll rd(x8), rs1(x5), rs2(x4)
            // mem[5] = 32'h0042_9433;  // 32'b0000_000 0_0100 _0010_1 001 _0100_0 011_0011
            mem[5] = SLL(5'd8, 5'd5, 5'd4);
            // srl rd(x3), rs1(x5), rs2(x4)
            // mem[6] = 32'h0042_D1B3;  // 32'b0000_000 0_0100 _0010_1 101 _0001_1 011_0011
            mem[6] = SRL(5'd3, 5'd5, 5'd4);
            // sra rd(x4), rs1(x5), rs2(x4)
            // mem[7] = 32'h4042_D233;  // 32'b0100_000 0_0100 _0010_1 101 _0010_0 011_0011
            mem[7] = SRA(5'd4, 5'd5, 5'd4);
            // slt rd(x5), rs1(x5), rs2(x4)
            // mem[8] = 32'h0042_A2B3;  // 32'b0000_000 0_0100 _0010_1 010 _0010_1 011_0011
            mem[8] = SLT(5'd5, 5'd5, 5'd4);
            // sltu rd(x6), rs1(x5), rs2(x4)
            // mem[9] = 32'h0042_B333;  // 32'b0000_000 0_0100 _0010_1 011 _0011_0 011_0011
            mem[9] = SLTU(5'd6, 5'd5, 5'd4);
            // nop
            mem[10] = 32'h0000_0013; // 32'b0000_000 0_0000 _0000_0 000 _0000_0 001_0011
        end

        /* I-type arithmetic instructions */
        if (0) begin
            // addi rd(x5), rs1(x3), imm(4)
            mem[0] = ADDI(5'd5, 5'd3, 12'd4);
            // xori rd(x6), rs1(x3), imm(5)
            mem[1] = XORI(5'd6, 5'd3, 12'd5);
            // ori rd(x7), rs1(x3), imm(6)
            mem[2] = ORI(5'd7, 5'd3, 12'd6);
            // andi rd(x8), rs1(x3), imm(7)
            mem[3] = ANDI(5'd8, 5'd3, 12'd7);
            // slli rd(x9), rs1(x3), shamt(1)
            mem[4] = SLLI(5'd9, 5'd3, 5'd1);
            // srli rd(x10), rs1(x3), shamt(2)
            mem[5] = SRLI(5'd10, 5'd3, 5'd2);
            // srai rd(x11), rs1(x3), shamt(3)
            mem[6] = SRAI(5'd11, 5'd3, 5'd3);
            // slti rd(x12), rs1(x3), imm(8)
            mem[7] = SLTI(5'd12, 5'd3, 12'd8);
            // sltiu rd(x13), rs1(x3), imm(9)
            mem[8] = SLTIU(5'd13, 5'd3, 12'd9);
        end


        if (1) begin
            /* S-type instructions */
            // sb x14, 4(x0)
            mem[0] = SB(5'd14, 5'd0, 12'd4);
            // sh x23, 8(x0)
            mem[1] = SH(5'd23, 5'd0, 12'd8);
            // sw x24, 12(x0)
            mem[2] = SW(5'd24, 5'd0, 12'd12);

            /* I-type load instructions */
            // lb x14, 4(x0)
            mem[3] = LB(5'd14, 5'd0, 12'd4);
            // lh x23, 8(x0)
            mem[4] = LH(5'd23, 5'd0, 12'd8);
            // lw x24, 12(x0)
            mem[5] = LW(5'd24, 5'd0, 12'd12);
            // lw x24, 12(x2)
            mem[6] = LW(5'd24, 5'd2, 12'd12);
        end

        /* B-type instructions */
        if (0) begin
            // beq x5, x6, 16
            mem[0] = BEQ(5'd5, 5'd6, 13'd16);
            // bne x5, x6, 20
            mem[1] = BNE(5'd5, 5'd6, 13'd20);
            // blt x5, x6, 24
            mem[2] = BLT(5'd5, 5'd6, 13'd24);
            // bge x5, x6, 28
            mem[3] = BGE(5'd5, 5'd6, 13'd28);
            // bltu x5, x6, 32
            mem[4] = BLTU(5'd5, 5'd6, 13'd32);
            // bgeu x5, x6, 36
            mem[5] = BGEU(5'd5, 5'd6, 13'd36);
        end

        if (0) begin
            /* U-type instructions */
            // lui x5, 0x12345
            mem[0] = LUI(5'd5, 32'h12345_000);
            // auipc x6, 0x12345
            mem[1] = AUIPC(5'd6, 32'h12345_000);

            /* J-type instructions */
            // jal x1, 256
            mem[2] = JAL(5'd1, 21'd256);
            // jalr x1, x2, 4
            mem[3] = JALR(5'd1, 5'd2, 12'd4);
        end

    end

    assign instruction_code = mem[addr[31:2]]; // word aligned
endmodule