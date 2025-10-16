`timescale 1ns/1ps

/* Define ALU operation codes */
// reorganized in 25.10.16
// ALUControl -> instr[30], instr[14:12] (func3)
`define ALU_ADD     4'b0_000
`define ALU_SUB     4'b1_000
`define ALU_SLL     4'b0_001
`define ALU_SRL     4'b0_101
`define ALU_SRA     4'b1_101
`define ALU_SLT     4'b0_010
`define ALU_SLTU    4'b0_011
`define ALU_XOR     4'b0_100
`define ALU_OR      4'b0_110
`define ALU_AND     4'b0_111
`define ALU_NOP     4'b1_111  // No operation

/* Define instruction opcodes */
`define OP_R		7'b011_0011     // R-type
`define OP_I_ARITH 	7'b001_0011     // I-type arithmetic
`define OP_I_LOAD	7'b000_0011     // I-type load
`define OP_I_JALR	7'b110_0111     // I-type JALR
`define OP_S		7'b010_0011     // S-type
`define OP_B		7'b110_0011     // B-type
`define OP_U_LUI	7'b011_0111     // U-type LUI
`define OP_U_AUIPC	7'b001_0111     // U-type AUIPC
`define OP_J_JAL	7'b110_1111     // J-type JAL


/* Define funct3 codes for memory */
`define F3_BYTE     3'b000
`define F3_HALF     3'b001
`define F3_WORD     3'b010
`define F3_UBYTE    3'b100
`define F3_UHALF    3'b101


/* Define funct3 codes for branch */
`define F3_BEQ      3'b000
`define F3_BNE      3'b001
`define F3_BLT      3'b100
`define F3_BGE      3'b101
`define F3_BLTU     3'b110
`define F3_BGEU     3'b111
