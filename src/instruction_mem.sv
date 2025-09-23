`timescale 1ns/1ps
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
            mem[0] = 32'h0041_82B3;  // 32'b0000_000 0_0100 _0001_1 000 _0010_1 011_0011
            // sub rd(x7), rs1(x8), rs2(x9)
            mem[1] = 32'h4094_03B3;  // 32'b0100_000 0_1001 _0100_0 000 _0011_1 011_0011

            // xor rd(x8), rs1(x3), rs2(x4)
            mem[2] = 32'h0041_C433;  // 32'b0000_000 0_0100 _0001_1 100 _0100_0 011_0011
            // or rd(x8), rs1(x3), rs2(x4)
            mem[3] = 32'h0041_E433;  // 32'b0000_000 0_0100 _0001_1 110 _0100_0 011_0011
            // and rd(x2), rs1(x5), rs2(x4)
            mem[4] = 32'h0042_F133;  // 32'b0000_000 0_0100 _0010_1 111 _0001_0 011_0011
            // sll rd(x8), rs1(x5), rs2(x4)
            mem[5] = 32'h0042_9433;  // 32'b0000_000 0_0100 _0010_1 001 _0100_0 011_0011
            // srl rd(x3), rs1(x5), rs2(x4)
            mem[6] = 32'h0042_D1B3;  // 32'b0000_000 0_0100 _0010_1 101 _0001_1 011_0011
            // sra rd(x4), rs1(x5), rs2(x4)
            mem[7] = 32'h4042_D233;  // 32'b0100_000 0_0100 _0010_1 101 _0010_0 011_0011
            // slt rd(x5), rs1(x5), rs2(x4)
            mem[8] = 32'h0042_A2B3;  // 32'b0000_000 0_0100 _0010_1 010 _0010_1 011_0011
            // sltu rd(x6), rs1(x5), rs2(x4)
            mem[9] = 32'h0042_B333;  // 32'b0000_000 0_0100 _0010_1 011 _0011_0 011_0011
            // nop
            mem[10] = 32'h0000_0013; // 32'b0000_000 0_0000 _0000_0 000 _0000_0 001_0011
        end
        /* I-type arithmetic instructions */

        /* S-type instructions */
        if (1) begin
            // sb x14, 4(x0)
            mem[0] = 32'h00E0_0223;
            // sh x23, 8(x0)
            mem[1] = 32'h0170_1423;
            // sw x24, 12(x0)
            mem[2] = 32'h0180_2623;

            /* I-type load instructions */
            // lb x14, 4(x0)
            mem[3] = 32'h0040_0703;
            // lh x23, 8(x0)
            mem[4] = 32'h0080_1B83;
            // lw x5, 12(x2)
            mem[5] = 32'h00C1_2283;
        end


    end

    assign instruction_code = mem[addr[31:2]]; // word aligned
endmodule