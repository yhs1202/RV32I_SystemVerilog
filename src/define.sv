`timescale 1ns/1ps

/* Define ALU operation codes */
`define ALU_ADD 5'b0_0000
`define ALU_SUB 5'b0_0001
`define ALU_XOR 5'b0_0010
`define ALU_OR  5'b0_0011
`define ALU_AND 5'b0_0100
`define ALU_SLL 5'b0_0101
`define ALU_SRL 5'b0_0110
`define ALU_SRA 5'b0_0111
`define ALU_SLT 5'b0_1000
`define ALU_SLTU 5'b0_1001
`define ALU_NOP 5'b1_1111  // No operation

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
