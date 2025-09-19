`timescale 1ns/1ps

module control_unit (
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_code,

    output logic Reg_write,
    output logic [2:0] ALUOp
);

    logic [6:0] func7;
    logic [2:0] func3;
    logic [6:0] opcode;
    assign func7 = instruction_code[31:25];
    assign func3 = instruction_code[14:12];
    assign opcode = instruction_code[6:0];

    always_comb begin : blockName
        case (opcode)
            7'b011_0011: begin // R-type
                case ({func7, func3})
                    10'b0000000_000: ALUOp = 3'b000; // ADD
                    10'b0100000_000: ALUOp = 3'b001; // SUB
                    10'b0000000_111: ALUOp = 3'b010; // AND
                    10'b0000000_110: ALUOp = 3'b011; // OR
                    10'b0000000_010: ALUOp = 3'b100; // SLT
                    default: ALUOp = 3'bxxx; // Default to ADD
                endcase
                Reg_write = 1'b1;
            end
            /*
            7'b0000_011: begin // Load
                Reg_write = 1'b1;
                ALUOp = 3'b000;
            end
            7'b0100_011: begin // Store
                Reg_write = 1'b0;
                ALUOp = 3'b000;
            end
            default: begin
                Reg_write = 1'b0;
                ALUOp = 3'b000;
            end
            */
            default: begin
                Reg_write = 1'b0;
                ALUOp = 3'b111;
            end
        endcase
    end
endmodule