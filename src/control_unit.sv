`timescale 1ns/1ps
`include "define.svh"

module control_unit (
    input logic [31:0] instruction_code,
    input logic branch_taken,

    // control signals
    output logic ALUSrc,            // 0-> rs2, 1-> imm
    output logic MemtoReg,          // 0-> ALU result, 1-> memory data
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic Branch,            // 0-> no branch, 1-> branch
    output logic [1:0] PCSrc,       // 0-> PC+4, 1-> branch target, 2-> JAL target, 3-> JALR target
    output logic [4:0] ALUControl

);

    wire [6:0] func7 = instruction_code[31:25];
    wire [2:0] func3 = instruction_code[14:12];
    wire [6:0] opcode = instruction_code[6:0];

    // Decode instruction
    always_comb begin : ALU_decoder
        case (opcode)
        `OP_R: begin // R-type
            case ({func7, func3})
                10'b0000000_000: ALUControl = `ALU_ADD; // ADD
                10'b0100000_000: ALUControl = `ALU_SUB; // SUB
                10'b0000000_100: ALUControl = `ALU_XOR; // XOR
                10'b0000000_110: ALUControl = `ALU_OR;  // OR
                10'b0000000_111: ALUControl = `ALU_AND; // AND
                10'b0000000_001: ALUControl = `ALU_SLL; // SLL
                10'b0000000_101: ALUControl = `ALU_SRL; // SRL
                10'b0100000_101: ALUControl = `ALU_SRA; // SRA
                10'b0000000_010: ALUControl = `ALU_SLT; // SLT
                10'b0000000_011: ALUControl = `ALU_SLTU; // SLTU
                default:         ALUControl = `ALU_NOP; // Default to NOP
            endcase
        end

        `OP_I_ARITH: begin // I-type arithmetic
            casez ({func7, func3})  // casez: x, z -> don't care
                10'b???????_000: ALUControl = `ALU_ADD; // ADDI
                10'b???????_100: ALUControl = `ALU_XOR; // XORI
                10'b???????_110: ALUControl = `ALU_OR;  // ORI
                10'b???????_111: ALUControl = `ALU_AND; // ANDI
                10'b0000000_001: ALUControl = `ALU_SLL; // SLLI
                10'b0?00000_101: ALUControl = func7[5] ? `ALU_SRA : `ALU_SRL; // SRLI, SRAI
                10'b???????_010: ALUControl = `ALU_SLT; // SLTI
                10'b???????_011: ALUControl = `ALU_SLTU; // SLTIU
                default:         ALUControl = `ALU_NOP; // Default to NOP
            endcase
        end

        `OP_I_LOAD,
        `OP_S,
        `OP_U_LUI,
        `OP_U_AUIPC,
        `OP_I_JALR: ALUControl = `ALU_ADD; // Use ADD for address calculation or immediate loading // I-type Load, S-type, U-type LUI/AUIPC

        `OP_B: ALUControl = `ALU_SUB; // Use SUB for branch comparisons

        `OP_J_JAL: ALUControl = `ALU_NOP; // JAL does not require ALU operation (PC is handled in datapath)
        default: ALUControl = `ALU_NOP;

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

    // ALUSrc (0-> rs2, 1-> imm)
    always_comb begin : ALUSrc_decoder
        case (opcode)
        `OP_R, `OP_B: 
            ALUSrc = 1'b0; // Use rs2
        default: 
        // `OP_I_ARITH, `OP_I_LOAD, `OP_I_JALR, `OP_S, `OP_U_LUI, `OP_U_AUIPC, `OP_J_JAL: 
            ALUSrc = 1'b1; // Use immediate -> decoded in extend.sv
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
            MemtoReg = 1'b1; // Load from memory
        default: 
            MemtoReg = 1'b0; // Default to ALU result
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