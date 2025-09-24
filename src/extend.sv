`timescale 1ns/1ps
`include "define.svh"

module extend (
    input logic [31:0] instruction_code,
    output logic [31:0] imm_ext
);

    wire [6:0] opcode = instruction_code[6:0];
    wire [2:0] func3 = instruction_code[14:12];

    always_comb begin
        case (opcode)
            `OP_I_LOAD, `OP_I_JALR: begin // I-type (000)
                imm_ext = {{20{instruction_code[31]}}, instruction_code[31:20]};
            end
            `OP_I_ARITH: begin
                case (func3)
                    3'b001, 3'b101: begin // SLLI, SRLI, SRAI
                        imm_ext = {27'b0, instruction_code[24:20]}; // zero-extend for shift amount
                    end 
                    default: imm_ext = {{20{instruction_code[31]}}, instruction_code[31:20]}; // sign-extend for other I-type
                endcase
            end
            `OP_S: begin // S-type (001)
                imm_ext = {{20{instruction_code[31]}}, instruction_code[31:25], instruction_code[11:7]};
            end
            `OP_B: begin // B-type (010)
                imm_ext = {{19{instruction_code[31]}}, instruction_code[31], instruction_code[7], instruction_code[30:25], instruction_code[11:8], 1'b0};
            end
            `OP_U_LUI, `OP_U_AUIPC: begin // U-type (100)
                imm_ext = {instruction_code[31:12], 12'b0};
            end
            `OP_J_JAL: begin // J-type (011)
                imm_ext = {{11{instruction_code[31]}}, instruction_code[31], instruction_code[19:12], instruction_code[20], instruction_code[30:21], 1'b0};
            end
            default: begin
                imm_ext = 32'b0; // Default case to avoid latches
            end
        endcase
    end
endmodule