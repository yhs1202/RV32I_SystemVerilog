`timescale 1ns/1ps
`include "asm2hex_macro.svh"

module instruction_mem (
    input logic [31:0] addr,
    output logic [31:0] instruction_code
);

    logic [31:0] mem [0:63];    // 64 words of instruction memory (256 bytes)
    assign instruction_code = mem[addr[31:2]]; // word aligned

    initial begin
        // initialize instruction memory
        for (int i = 0; i < 64; i = i + 1) 
            mem[i] = 32'b0;
        #10;

        /* R-type test instructions */
        if (0) begin
                                        //      func7     rs2    rs1  func3   rd    opcode
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
            mem[10] = 32'hdead_beef;
        end

        /* I-type arithmetic test instructions */
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

            /* test for negative immediate and overflow */
            // slti rd(x14), rs1(x3), imm(255)
            // imm = 255 -> 0x0FF, slti = 0x35 < 255 -> True(1)
            mem[9] = SLTI(5'd14, 5'd3, 12'h0FF);

            // slti rd(x15), rs1(x3), imm(-1)
            // imm = -1 -> 0xFFF, slti = 0x35 < -1 -> False(0)
            mem[10] = SLTI(5'd15, 5'd3, 12'hFFF);

            // sltiu rd(x16), rs1(x3), imm(4095)
            // imm = 4095 -> 0xFFF, sltiu = 0x35 < 4095 -> True(1)
            mem[11] = SLTIU(5'd16, 5'd3, 12'hFFF);

            // addi rd(x4), rs1(x3), imm(-2048)
            mem[12] = ADDI(5'd4, 5'd3, 12'h800); // x4 = 50 - 2048 = -1998

            // srai rd(x17), rs1(x3), shamt(3)
            mem[13] = SRAI(5'd17, 5'd4, 5'd3); // 0xFFFF_F835 >> 3 = 0xFFFF_FF06
        end

        /* S-type and I-type (load) test instructions */
        if (0) begin
            /* S-type instructions */
            // sb x14, 4(x0)
            // mem[0] = 32'h00E0_0223;
            mem[0] = SB(5'd14, 5'd0, 12'd4);
            // sh x23, 8(x0)
            // mem[1] = 32'h0170_1423;
            mem[1] = SH(5'd23, 5'd0, 12'd8);
            // sw x24, 12(x0)
            // mem[2] = 32'h0180_2623;
            mem[2] = SW(5'd24, 5'd0, 12'd12);

            /* I-type load instructions */
            // lb x14, 4(x0)
            // mem[3] = 32'h0040_0703;
            mem[3] = LB(5'd14, 5'd0, 12'd4);
            // lh x23, 8(x0)
            // mem[4] = 32'h0080_1B83;
            mem[4] = LH(5'd23, 5'd0, 12'd8);
            // lw x24, 12(x0)
            // mem[5] = 32'h00C0_2283;
            mem[5] = LW(5'd24, 5'd0, 12'd12);
            // lw x24, 12(x2)
            // mem[6] = 32'h00C1_2283;
            mem[6] = LW(5'd24, 5'd2, 12'd12);
        end

        /* B-type test instructions */
        if (0) begin
            // initialize registers
            // addi x5, x0, 10
            // addi x6, x0, 10
            // addi x7, x0, 20
            mem[0] = ADDI(5'd5, 5'd0, 12'd10);
            mem[1] = ADDI(5'd6, 5'd0, 12'd10);
            mem[2] = ADDI(5'd7, 5'd0, 12'd20);

            // branch instructions start
            // beq test
            mem[3] = BEQ(5'd5, 5'd6, 13'd20); // -> branch taken -> skip next instruction (jump to mem[8]
            mem[4] = ADDI(5'd10, 5'd0, 12'd1); // this instruction should be skipped
            mem[8] = ADDI(5'd11, 5'd0, 12'd2); // *target of branch*

            // bne test
            mem[9] = BNE(5'd5, 5'd6, 13'd20); // -> should be not taken
            mem[10] = BNE(5'd5, 5'd7, 13'd20); // -> branch taken -> skip next instruction (jump to mem[15])
            mem[11] = ADDI(5'd12, 5'd0, 3); // this instruction should be skipped
            mem[15] = ADDI(5'd13, 5'd0, 4); // *target of branch*

            // blt test
            mem[16] = BLT(5'd7, 5'd5, 13'd20); // -> should be not taken (20<10 -> False)
            mem[17] = BLT(5'd5, 5'd7, 13'd20); // -> branch taken (10<20 -> True) -> skip next instruction (jump to mem[22])
            mem[18] = ADDI(5'd14, 5'd0, 5); // this instruction should be skipped
            mem[22] = ADDI(5'd15, 5'd0, 6); // *target of branch*

            // bge test
            mem[23] = BGE(5'd5, 5'd7, 13'd20); // -> should be not taken (10>=20 -> False)
            mem[24] = BGE(5'd7, 5'd5, 13'd20); // -> branch taken (20>=10 -> True) -> skip next instruction (jump to mem[29])
            mem[25] = ADDI(5'd16, 5'd0, 7); // this instruction should be skipped
            mem[29] = ADDI(5'd17, 5'd0, 8); // *target of branch*
            
            // bltu test
            mem[30] = ADDI(5'd8, 5'd0, -1); // x8 = -1 (0xFFFF_FFFF)
            mem[31] = BLTU(5'd5, 5'd8, 13'd20); // -> should be not taken (10<-1 -> False)
            mem[32] = BLTU(5'd8, 5'd5, 13'd20); // -> branch taken (-1<10 -> True) -> skip next instruction (jump to mem[37])
            mem[33] = ADDI(5'd18, 5'd0, 9); // this instruction should be skipped
            mem[37] = ADDI(5'd19, 5'd0, 10); // *target of branch*

            // bgeu test
            mem[38] = BGEU(5'd8, 5'd5, 13'd20); // -> should be not taken (-1>=10 -> False)
            mem[39] = BGEU(5'd5, 5'd8, 13'd20); // -> branch taken (10>=-1 -> True) -> skip next instruction (jump to mem[44])
            mem[40] = ADDI(5'd20, 5'd0, 11); // this instruction should be skipped
            mem[44] = ADDI(5'd21, 5'd0, 12); // *target of branch*

            // overflow test
            // addi x9, x0, INT_MAX (0x7FFF_FFFF, +2147483647)
            mem[45] = ADDI(5'd9, 5'd0, 12'hFFF); // lower 12 bits
            // addi x10, x0, 1
            mem[46] = ADDI(5'd9, 5'd9, 12'd2048);   
            // addi x11, x0, INT_MIN (0x8000_0000, -2147483648)
        end

        /* U-type and J-type test instructions */
        if (1) begin
            /* U-type Instructions */
            // lui x5, 0x12345 -> x5 = 0x12345_000 (imm << 12 check)
            mem[0] = LUI(5'd5, 32'h12345_000);
            // auipc x6, 0x1 -> x6 = PC(4) + 0x1000 (pc+(imm<<12) check)
            mem[1] = AUIPC(5'd6, 32'h00001_000);

            /* J-type Instructions */
            // jal x1, 8 -> x1 = PC+4(12)->actual:0x14(?????), jump to PC+8(16) -> working
            mem[2] = JAL(5'd1, 21'd8);
            // addi x7, x0, 0x111 -> skipped
            mem[3] = ADDI(5'd7, 5'd0, 12'h111);
            // addi x7, x0, 0x222 -> jal target
            mem[4] = ADDI(5'd7, 5'd0, 12'h222);


            // lui x3, 0x0 -> x3 = 0x0
            mem[5] = LUI(5'd3, 32'h00000_000);
            // addi x3, x3, 50 -> x3 = 50 (for jalr test)
            mem[6] = ADDI(5'd3, 5'd3, 12'd50);
            // jalr x2, x3, 16 -> x2 = PC+4 (32'd28)->actual:0x46(?????(pc_plus4)), jump to x3+16 (50+16=66)
            mem[7] = JALR(5'd2, 5'd3, 12'd16);
            // addi x8, x0, 0x123 -> skipped
            mem[8] = ADDI(5'd8, 5'd0, 12'h123);
            // addi x8, x0, 0x456 -> skipped
            mem[9] = ADDI(5'd8, 5'd0, 12'h456);

            // addi x8, x0, 0x777 -> jalr target?
            mem[16] = ADDI(5'd8, 5'd0, 12'h777);
            // addi x8, x0, 999 -> jalr target?
            mem[17] = ADDI(5'd8, 5'd0, 12'h888);
        end
        // TODO: PCPlus4 check (Should be PC_reg +4, not PC_next +4)

    end

endmodule