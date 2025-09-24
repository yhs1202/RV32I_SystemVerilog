`include "define.svh"

// RV32I Instruction Macros
// Use: `INSTRUCTION_MACRO_NAME( rd,  rs1,  rs2 / imm /  shamt)

// ---------- R-type ----------
`define ADD(rd, rs1, rs2)   {7'b0000000, rs2, rs1, 3'b000, rd, `OP_R}
`define SUB(rd, rs1, rs2)   {7'b0100000, rs2, rs1, 3'b000, rd, `OP_R}
`define XOR(rd, rs1, rs2)   {7'b0000000, rs2, rs1, 3'b100, rd, `OP_R}
`define OR(rd,  rs1, rs2)   {7'b0000000, rs2, rs1, 3'b110, rd, `OP_R}
`define AND(rd, rs1, rs2)   {7'b0000000, rs2, rs1, 3'b111, rd, `OP_R}
`define SLL(rd, rs1, rs2)   {7'b0000000, rs2, rs1, 3'b001, rd, `OP_R}
`define SRL(rd, rs1, rs2)   {7'b0000000, rs2, rs1, 3'b101, rd, `OP_R}
`define SRA(rd, rs1, rs2)   {7'b0100000, rs2, rs1, 3'b101, rd, `OP_R}
`define SLT(rd, rs1, rs2)   {7'b0000000, rs2, rs1, 3'b010, rd, `OP_R}
`define SLTU(rd, rs1, rs2)  {7'b0000000, rs2, rs1, 3'b011, rd, `OP_R}

// ---------- I-type (arith) ----------
`define ADDI(rd, rs1, imm)  {imm, rs1, 3'b000, rd, `OP_I_ARITH}
`define XORI(rd, rs1, imm)  {imm, rs1, 3'b100, rd, `OP_I_ARITH}
`define ORI(rd,  rs1, imm)  {imm, rs1, 3'b110, rd, `OP_I_ARITH}
`define ANDI(rd, rs1, imm)  {imm, rs1, 3'b111, rd, `OP_I_ARITH}
`define SLLI(rd, rs1, shamt) {7'b0000000, shamt, rs1, 3'b001, rd, `OP_I_ARITH}
`define SRLI(rd, rs1, shamt) {7'b0000000, shamt, rs1, 3'b101, rd, `OP_I_ARITH}
`define SRAI(rd, rs1, shamt) {7'b0100000, shamt, rs1, 3'b101, rd, `OP_I_ARITH}
`define SLTI(rd, rs1, imm)   {imm, rs1, 3'b010, rd, `OP_I_ARITH}
`define SLTIU(rd, rs1, imm)  {imm, rs1, 3'b011, rd, `OP_I_ARITH}

// ---------- I-type (load) ----------
`define LB(rd, rs1, imm)   {imm, rs1, 3'b000, rd, `OP_I_LOAD}
`define LH(rd, rs1, imm)   {imm, rs1, 3'b001, rd, `OP_I_LOAD}
`define LW(rd, rs1, imm)   {imm, rs1, 3'b010, rd, `OP_I_LOAD}
`define LBU(rd, rs1, imm)  {imm, rs1, 3'b100, rd, `OP_I_LOAD}
`define LHU(rd, rs1, imm)  {imm, rs1, 3'b101, rd, `OP_I_LOAD}

// ---------- S-type (store) ----------
`define SB(rs2, rs1, imm)  {imm, rs2, rs1, 3'b000, imm, `OP_S}
`define SH(rs2, rs1, imm)  {imm, rs2, rs1, 3'b001, imm, `OP_S}
`define SW(rs2, rs1, imm)  {imm, rs2, rs1, 3'b010, imm, `OP_S}

// ---------- B-type (branch) ----------
`define BEQ(rs1, rs2, imm)  {imm, imm, rs2, rs1, 3'b000, imm, imm, `OP_B}
`define BNE(rs1, rs2, imm)  {imm, imm, rs2, rs1, 3'b001, imm, imm, `OP_B}
`define BLT(rs1, rs2, imm)  {imm, imm, rs2, rs1, 3'b100, imm, imm, `OP_B}
`define BGE(rs1, rs2, imm)  {imm, imm, rs2, rs1, 3'b101, imm, imm, `OP_B}
`define BLTU(rs1, rs2, imm) {imm, imm, rs2, rs1, 3'b110, imm, imm, `OP_B}
`define BGEU(rs1, rs2, imm) {imm, imm, rs2, rs1, 3'b111, imm, imm, `OP_B}

// ---------- U-type ----------
`define LUI(rd, imm)    {imm, rd, `OP_U_LUI}
`define AUIPC(rd, imm)  {imm, rd, `OP_U_AUIPC}

// ---------- J-type ----------
`define JAL(rd, imm)    {imm, imm, imm, imm, rd, `OP_J_JAL}
`define JALR(rd, rs1, imm) {imm, rs1, 3'b000, rd, `OP_I_JALR}

// ---------- SYSTEM ----------
`define ECALL   {12'h000, 5'd0, 3'b000, 5'd0, 7'b1110011}
`define EBREAK  {12'h001, 5'd0, 3'b000, 5'd0, 7'b1110011}

