`timescale 1ns/1ps
`include "define.svh"

module control_unit (
    input logic [31:0] instruction_code,
    input logic branch_taken,

    // control signals
    output logic ALUSrc_A,            // 0-> rs1, 1-> pc (for auipc)
    output logic ALUSrc_B,            // 0-> rs2, 1-> imm
    output logic [1:0] MemtoReg,          // 0-> ALU result, 1-> memory data, 2-> PC+4 (for JAL)
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic Branch,            // 0-> no branch, 1-> branch
    output logic [1:0] PCSrc,       // 0-> PC+4, 1-> branch target, 2-> JAL target, 3-> JALR target
    output logic [3:0] ALUControl

);

    wire instr30 = instruction_code[30];
    wire [2:0] func3 = instruction_code[14:12];
    wire [6:0] opcode = instruction_code[6:0];

    wire [4:0] operator = {instr30, func3}; // {instr[30], instr[14:12]}
    wire flag = (func3 == 3'b101) ? instr30 : 1'b0; // for SRLI, SRAI

    /* Decode instruction */
    // ALUControl
    always_comb begin : ALU_decoder
        case (opcode)
        `OP_R: // R-type
            ALUControl = operator;
        `OP_I_ARITH: // I-type arithmetic
            ALUControl = {flag, operator[2:0]};
        `OP_I_LOAD, `OP_S, `OP_U_AUIPC, `OP_I_JALR:
            ALUControl = `ALU_ADD; // Use ADD for address calculation or immediate loading // I-type Load, S-type, U-type LUI/AUIPC
        `OP_B:
            ALUControl = `ALU_SUB; // Use SUB for branch comparisons
        default: 
        // `OP_U_LUI, `OP_J_JAL: 
            ALUControl = `ALU_NOP; // JAL does not require ALU operation (PC is handled in datapath)
        endcase
    end

    // RegWrite
    always_comb begin : RegWrite_decoder
        case (opcode)
        `OP_R, `OP_I_ARITH, `OP_I_LOAD, `OP_I_JALR, `OP_U_LUI, `OP_U_AUIPC, `OP_J_JAL: 
            RegWrite = 1'b1;
        `OP_S, `OP_B: 
            RegWrite = 1'b0;
        default: 
            RegWrite = 1'b0; // Default to no write
        endcase
    end

    // ALUSrc_A (0-> rs1, 1-> pc (for auipc))
    always_comb begin : ALUSrc_A_decoder
        case (opcode)
        `OP_U_AUIPC: 
            ALUSrc_A = 1'b1; // Use PC
        default: 
            ALUSrc_A = 1'b0; // Use rs1
        endcase
    end

    // ALUSrc_B (0-> rs2, 1-> imm)
    always_comb begin : ALUSrc_B_decoder
        case (opcode)
        `OP_R, `OP_B: 
            ALUSrc_B = 1'b0; // Use rs2
        default: 
        // `OP_I_ARITH, `OP_I_LOAD, `OP_I_JALR, `OP_S, `OP_U_LUI, `OP_U_AUIPC, `OP_J_JAL: 
            ALUSrc_B = 1'b1; // Use immediate -> decoded in extend.sv
        endcase
    end

    // MemWrite
    always_comb begin : MemWrite_decoder
        unique case (opcode)
        `OP_S: begin
            MemWrite = 1'b1; // Store to memory
        end
        default: 
            MemWrite = 1'b0; // Default to no write
        endcase
    end

    // MemRead
    always_comb begin : MemRead_decoder
        unique case (opcode)
        `OP_I_LOAD: begin 
            MemRead = 1'b1; // Load from memory
        end
        default: 
            MemRead = 1'b0; // Default to no read
        endcase
    end


    // MemtoReg (0-> ALU result, 1-> memory data)
    always_comb begin : MemtoReg_decoder
        case (opcode)
        `OP_I_LOAD:
            MemtoReg = 2'b01; // Load from memory
        `OP_J_JAL, `OP_I_JALR:
            MemtoReg = 2'b10; // PC + 4 for JAL and JALR
        `OP_U_LUI:
            MemtoReg = 2'b11; // immediate for LUI
        default: 
            MemtoReg = 2'b00; // Default to ALU result
        endcase
    end

    // Branch
    always_comb begin : Branch_decoder
        case (opcode)
        `OP_B: 
            Branch = 1'b1; // Branch instruction
        default: 
            Branch = 1'b0; // Default to no branch
        endcase
    end

    // PCSrc
    always_comb begin : PCSrc_decoder
        case (opcode)
            `OP_B:      PCSrc = (branch_taken) ? 2'b01 : 2'b00; // Branch target or next instruction
            `OP_J_JAL:  PCSrc = 2'b10; // JAL target
            `OP_I_JALR: PCSrc = 2'b11; // JALR target
            default:    PCSrc = 2'b00; // Default to next sequential instruction (PC + 4)
        endcase
    end
endmodule