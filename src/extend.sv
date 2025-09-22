`timescale 1ns/1ps
`include "define.sv"

module extend (
    input logic [31:0] instruction_code,
    output logic [31:0] imm_ext
);
    wire [6:0] opcode = instruction_code[6:0];
    wire [2:0] funct3 = instruction_code[14:12];
    wire [6:0] funct7 = instruction_code[31:25];

    always_comb begin
        case (opcode)
            `OP_I_LOAD, `OP_I_JALR, `OP_I_ARITH: begin // I-type
                imm_ext = {{20{instruction_code[31]}}, instruction_code[31:20]};
            end
            `OP_S: begin // S-type
                imm_ext = {{20{instruction_code[31]}}, instruction_code[31:25], instruction_code[11:7]};
            end
            /*
            `OP_B: begin // B-type
            end
            `OP_U_LUI, `OP_U_AUIPC: begin // U-type
            end
            `OP_J_JAL: begin // J-type
            end
            */
            default: begin
                imm_ext = 32'b0; // Default case to avoid latches
            end
        endcase
    end

endmodule