`timescale 1ns/1ps
module instruction_mem (
    input logic [31:0] addr,
    output logic [31:0] instruction_code
);

    logic [31:0] mem [0:31];

    initial begin
                                //      func7     rs2    rs1  func3   rd    opcode
        /* R-type instructions */
        // add rd(x5), rs1(x3), rs2(x4)
        mem[0] = 32'h004182B3;  // 32'b0000_000 0_0100 _0001_1 000 _0010_1 011_0011
        // sub rd(x7), rs1(x8), rs2(x9)
        mem[1] = 32'h409403B3;  // 32'b0100_000 0_1001 _0100_0 000 _0011_1 011_0011

        // xor rd(x8), rs1(x3), rs2(x4)
        mem[2] = 32'h0041C433;  // 32'b0000_000 0_0100 _0001_1 100 _0100_0 011_0011
        // or rd(x8), rs1(x3), rs2(x4)
        mem[3] = 32'h0041E433;  // 32'b0000_000 0_0100 _0001_1 110 _0100_0 011_0011
        // and rd(x2), rs1(x5), rs2(x4)
        mem[4] = 32'h0042F133;  // 32'b0000_000 0_0100 _0010_1 111 _0001_0 011_0011
        // sll rd(x8), rs1(x5), rs2(x4)
        mem[5] = 32'h00429433;  // 32'b0000_000 0_0100 _0010_1 001 _0100_0 011_0011
        // srl rd(x3), rs1(x5), rs2(x4)
        mem[6] = 32'h0042D1B3;  // 32'b0000_000 0_0100 _0010_1 101 _0001_1 011_0011
        // sra rd(x4), rs1(x5), rs2(x4)
        mem[7] = 32'h4042D233;  // 32'b0100_000 0_0100 _0010_1 101 _0010_0 011_0011
        // slt rd(x5), rs1(x5), rs2(x4)
        mem[8] = 32'h0042A2B3;  // 32'b0000_000 0_0100 _0010_1 010 _0010_1 011_0011
        // sltu rd(x6), rs1(x5), rs2(x4)
        mem[9] = 32'h0042B333;  // 32'b0000_000 0_0100 _0010_1 011 _0011_0 011_0011
        // nop
        mem[10] = 32'h00000013; // 32'b0000_000 0_0000 _0000_0 000 _0000_0 001_0011

    end

    assign instruction_code = mem[addr[31:2]]; // word aligned
endmodule