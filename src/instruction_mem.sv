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
            /* R test scenario in asm code
            ; Regfle is initialized w/ 0x32, 0x33, 0x34 ... from x0
            ; add, sub, xor, or, and
            add   x5,  x3,  x4      ; 0 (x5 <= 0x35 + 0x36)
            sub   x6,  x3,  x4      ; 4 (x6 <= 0x35 - 0x36) 
            xor   x7,  x3,  x4      ; 8 (x7 <= 0x35 ^ 0x36) -> 0x3
            or    x8,  x3,  x4      ; c (x8 <= 0x35 | 0x36)
            and   x9,  x3,  x4      ; 10 (x9 <= 0x35 & 0x36)

            ; shift
            sll   x10, x3,  x7      ; 14 (x10 <= 0x35 << 3)
            srl   x11, x3,  x7      ; 18 (x11 <= 0x35 >> 3)
            sra   x12, x3,  x7      ; 1c (x12 <= 0x35 >>> 3)

            ; slt
            slt   x13, x3,  x6     ; 20 (x13 <= 0), (0x35 < 0xFFFF_FFFF)
            sltu  x14, x3,  x6     ; 24 (x14 <= 1), (0x35 <u 0xFFFF_FFFF)
            */
            mem[0] = ADD(5'd5, 5'd3, 5'd4);
            mem[1] = SUB(5'd6, 5'd3, 5'd4);
            mem[2] = XOR(5'd7, 5'd3, 5'd4);
            mem[3] = OR(5'd8, 5'd3, 5'd4);
            mem[4] = AND(5'd9, 5'd3, 5'd4);

            mem[5] = SLL(5'd10, 5'd3, 5'd7);
            mem[6] = SRL(5'd11, 5'd3, 5'd7);
            mem[7] = SRA(5'd12, 5'd3, 5'd7);

            mem[8] = SLT(5'd13, 5'd3, 5'd6);
            mem[9] = SLTU(5'd14, 5'd3, 5'd6);
        end

        /* I-type arithmetic test instructions */
        if (0) begin
            /* I_arith test scenario in asm code
                ; add, xor, or, and immediate
                addi   x5,  x3,  4      ; 0 (x5 <= 35+4)
                xori   x6,  x3,  5      ; 4 (x6 <= 35^5)
                ori    x7,  x3,  6      ; 8 (x7 <= 35|6)
                andi   x8,  x3,  7      ; c (x8 <= 35&7)

                ; shift immediate
                slli   x9,  x3,  1      ; 10 (x9 <= 35<<1)
                srli   x10, x3,  2      ; 14 (x10 <= 35>>2)
                srai   x11, x3,  3      ; 18 (x11 <= 35>>>3)

                ; slt immediate
                slti   x12, x3,  8      ; 1c (x12 <= 0), (35 < 8)
                sltiu  x13, x3,  9      ; 20 (x13 <= 0), (35 <u 9)

                ; slt w/ negative immediate value
                slti   x14, x3, 0xFF    ; 24 (x14 <= 1), (35 < 255)
                slti   x15, x3, 0xFFF   ; 28 (x15 <= 0), (35 < -1)
                sltiu  x16, x3, 0xFFF   ; 2c (x16 <= 1), (35 < 4095)

                ; sra w/ negative immediate value
                addi   x4,  x3, 0x800   ; 30 (x4 <= 0xFFFF_F835), (53-2048 = -1995, 0xFFFF_F835)
                srai   x17, x4,  3      ; 34 (x17 <= 0xFFFF_FF06), (0xFFFF_F835 >>> 3)
            */
            mem[0] = ADDI(5'd5, 5'd3, 12'd4);
            mem[1] = XORI(5'd6, 5'd3, 12'd5);
            mem[2] = ORI(5'd7, 5'd3, 12'd6);
            mem[3] = ANDI(5'd8, 5'd3, 12'd7);

            mem[4] = SLLI(5'd9, 5'd3, 5'd1);
            mem[5] = SRLI(5'd10, 5'd3, 5'd2);
            mem[6] = SRAI(5'd11, 5'd3, 5'd3);

            mem[7] = SLTI(5'd12, 5'd3, 12'd8);
            mem[8] = SLTIU(5'd13, 5'd3, 12'd9);

            mem[9] = SLTI(5'd14, 5'd3, 12'h0FF);
            mem[10] = SLTI(5'd15, 5'd3, 12'hFFF);
            mem[11] = SLTIU(5'd16, 5'd3, 12'hFFF);

            mem[12] = ADDI(5'd4, 5'd3, 12'h800); // x4 = 50 - 2048 = -1998
            mem[13] = SRAI(5'd17, 5'd4, 5'd3); // 0xFFFF_F835 >> 3 = 0xFFFF_FF06
        end

        /* S-type and I-type (load) test instructions */
        if (0) begin
            /* S, I_load test scenario in asm code
                ; S-type (store)
                li  x1, 0x12345678  ; 0,4 (x1 <= 0x1234_5678)
                sb  x1, 4(x0)       ; 8 (RAM[0x4] <= 0x78)
                sh  x1, 8(x0)       ; c (RAM[0x8] <= 0x5678)
                sw  x1, 12(x0)      ; 10 (RAM[0xC] <= 0x1234_5678)

                ; I-type (load)
                lb  x4, 4(x0)       ; 14 (x4 <= RAM[0x4] = 0x78)
                lh  x5, 8(x0)       ; 18 (x5 <= RAM[0x8] = 0x5678)
                lw  x6, 12(x0)      ; 1c (x6 <= RAM[0xc] = 0x1234_5678)


                ; lbu, lhu test
                li  x1, 0xFFFF_FF80 ; 20, 24 (x1 <= 0xFFFF_FF80)
                li  x2, 0xc         ; 28 (x2 <= 0xc, base RAM addr)

                sb  x1, 4(x2)       ; 2c (RAM[0x10] <= 0x80)
                lb  x7, 4(x2)       ; 30 (x7 <= 0xFFFF_FF80, -128)
                lbu x8, 4(x2)       ; 34 (x8 <= 0x0000_0080, +128)

                li  x1, 0xFFFF_8000 ; 38 (x1 <= 0xFFFF_8000)

                sh  x1, 8(x2)       ; 3c (RAM[0x14] <= 0x8000)
                lh  x9, 8(x2)       ; 40 (x9 <= 0xFFFF8000, -32768)
                lhu x10, 8(x2)      ; 44 (x9 <= 0x8000, +32768)
            */
            mem[0] = LUI(5'd1, 20'h12345);
            mem[1] = ADDI(5'd1, 5'd0, 12'h678);
            mem[2] = SB(5'd1, 5'd0, 12'd4);
            mem[3] = SH(5'd1, 5'd0, 12'd8);
            mem[4] = SW(5'd1, 5'd0, 12'd12);

            mem[5] = LB(5'd4, 5'd0, 12'd4);
            mem[6] = LH(5'd5, 5'd0, 12'd8);
            mem[7] = LW(5'd6, 5'd0, 12'd12);

            mem[8] = LUI(5'd1, 20'hFFFFF);
            mem[9] = ADDI(5'd1, 5'd0, 12'hF80);
            mem[10] = ADDI(5'd2, 5'd0, 12'hC);

            mem[11] = SB(5'd1, 5'd2, 12'd4);
            mem[12] = LB(5'd7, 5'd2, 12'd4);
            mem[13] = LBU(5'd8, 5'd2, 12'd4);

            mem[14] = LUI(5'd1, 20'hFFFF8);
            mem[15] = SH(5'd1, 5'd2, 12'd8);
            mem[16] = LH(5'd9, 5'd2, 12'd8);
            mem[17] = LHU(5'd10, 5'd2, 12'd8);
        end

        /* B-type test instructions */
        if (0) begin
            /* B test scenario in asm code
                ; initialize registers
                li   x5,  x0,  10        ; 0 (x5 <= 10)
                li   x6,  x0,  15        ; 4 (x6 <= 15)
                li   x7,  x0,  -1        ; 8 (x7 <= -1 (0xFFFF_FFFF))

                ; beq test
                beq  x5,  x5,  8         ; c (branch taken (10=10), pc <= pc+8 (0x14))
                li   x10, x0,  1         ; 10 (skipped)
                li   x10, x0,  2         ; 14 (branch target, x10 <= 2)

                ; bne test
                bne  x5,  x5,  999       ; 18 (branch not taken (10==10))
                bne  x5,  x7,  8         ; 1c (branch taken (10!=-1), pc <= pc+8 (0x24))
                li   x11, x0,  3         ; 20 (skipped)
                li   x11, x0,  4         ; 24 (branch target, x11 <= 4)

                ; blt test
                blt  x6,  x5,  999       ; 28 (branch not taken (15!<10))
                blt  x7,  x5,  8         ; 2c (branch taken (-1<10), pc <= pc+8 (0x34))
                li   x12, x0,  5         ; 30 (skipped)
                li   x12, x0,  6         ; 34 (branch target, x12 <= 6)

                ; bge test
                bge  x7,  x6,  999       ; 38 (branch not taken (-1!>=15))                
                bge  x6,  x7,  8         ; 3c (branch taken (15>=-1), pc <= pc+8 (0x44))
                li   x13, x0,  7         ; 40 (skipped)
                li   x13, x0,  8         ; 44 (branch target, x13 <= 8)


                ; bltu test
                bltu  x7,  x5, 999       ; 48 (branch not taken (4294967295!<10))
                bltu  x5,  x7, 8         ; 4c (branch taken (10<4294967295), pc <= pc+8 (0x54))
                li    x14, x0, 9         ; 50 (skipped)
                li    x14, x0, 10        ; 54 (branch target, x14 <= 10)

                ; bgeu test
                bgeu  x6,  x7, 999       ; 58 (branch not taken (15!>=4294967295))                
                bgeu  x7,  x6, 8         ; 5c (branch taken (4294967295>=15), pc <= pc+8 (0x64))
                li    x15, x0, 11        ; 60 (skipped)
                li    x15, x0, 12        ; 64 (branch target, x15 <= 12)
            */

            // initialize registers
            mem[0] = ADDI(5'd5, 5'd0, 12'd10);
            mem[1] = ADDI(5'd6, 5'd0, 12'd15);
            mem[2] = LUI(5'd7, 20'hFFFFF);  // load -1

            // branch instructions start
            // beq test
            mem[3] = BEQ(5'd5, 5'd5, 13'd8); // -> branch taken
            mem[4] = ADDI(5'd10, 5'd0, 12'd1); // skipped
            mem[5] = ADDI(5'd10, 5'd0, 12'd2); // *target of branch*

            // bne test
            mem[6] = BNE(5'd5, 5'd5, 13'd999);
            mem[7] = BNE(5'd5, 5'd7, 13'd8); // -> branch taken
            mem[8] = ADDI(5'd11, 5'd0, 12'd3); // skipped
            mem[9] = ADDI(5'd11, 5'd0, 12'd4); // *target of branch*

            // blt test
            mem[10] = BLT(5'd6, 5'd5, 13'd999);
            mem[11] = BLT(5'd7, 5'd5, 13'd8); // -> branch taken
            mem[12] = ADDI(5'd12, 5'd0, 12'd5); // skipped
            mem[13] = ADDI(5'd12, 5'd0, 12'd6); // *target of branch*

            // bge test
            mem[14] = BGE(5'd7, 5'd6, 13'd999);
            mem[15] = BGE(5'd6, 5'd7, 13'd8); // -> branch taken
            mem[16] = ADDI(5'd13, 5'd0, 12'd7); // skipped
            mem[17] = ADDI(5'd13, 5'd0, 12'd8); // *target of branch*
            
            // bltu test
            mem[18] = BLTU(5'd7, 5'd5, 13'd999);
            mem[19] = BLTU(5'd5, 5'd7, 13'd8); // -> branch taken
            mem[20] = ADDI(5'd14, 5'd0, 12'd9); // skipped
            mem[21] = ADDI(5'd14, 5'd0, 12'd10); // *target of branch*

            // bgeu test
            mem[22] = BGEU(5'd6, 5'd7, 13'd999);
            mem[23] = BGEU(5'd7, 5'd6, 13'd8); // -> branch taken
            mem[24] = ADDI(5'd15, 5'd0, 12'd11); // skipped
            mem[25] = ADDI(5'd15, 5'd0, 12'd12); // *target of branch*
        end

        /* U-type and J-type test instructions */
        if (0) begin
            /* U, J test scenario in asm code
                lui     x0, 0x0         ; 0 (x0 <= 0)
                lui     x5, 0x12345     ; 4 (x5 <= 0x1234_5000)
                auipc   x6, 0x1         ; 8 (x6 <= 0x1000 + pc(8))

                jal     x1, 8           ; c (x1 <= pc+4 (10), pc <= pc+8 (14))
                addi    x3, x0, 0x222   ; 10 (skipped)
                addi    x1, x0, 30      ; 14 (jal target, x1 <= 30)

                jalr    x2, x1, 6       ; 18 (x2 <= pc+4(1c), pc <= x1+imm(36, 0x24))
                addi    x3, x0, 0x333   ; 1c (skipped)
                addi    x3, x0, 0x444   ; 20 (skipped)
                addi    x3, x0, 0x555   ; 24 (jalr target)
            
            /* U-type test instructions */
            mem[0] = LUI(5'd0, 20'h0);
            mem[1] = LUI(5'd5, 20'h12345);
            mem[2] = AUIPC(5'd6, 20'h1);

            /* J-type test instructions */
            mem[3] = JAL(5'd1, 21'd8);
            mem[4] = ADDI(5'd3, 5'd0, 12'h222); // skipped
            mem[5] = ADDI(5'd1, 5'd0, 12'd30);  // jal target
            
            mem[6] = JALR(5'd2, 5'd1, 12'd6);
            mem[7] = ADDI(5'd3, 5'd0, 12'h333); // skipped
            mem[8] = ADDI(5'd3, 5'd0, 12'h444); // skipped
            mem[9] = ADDI(5'd3, 5'd0, 12'h555); // jalr target
        end

        /* read hex code with memory dump */
        if (0) begin
            $readmemh("./0929.mem", mem);
        end
    end

endmodule