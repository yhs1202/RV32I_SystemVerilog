`timescale 1ns/1ps
module pc_logic (
    input logic clk,
    input logic rst,
    input logic [31:0] PC_branch_offset,    // IMM extended
    input logic [31:0] ALU_result,
    input logic [1:0] PCSrc,    // 00: PC+4, 01: branch, 10: jump, 11: jalr
    
    output logic [31:0] PC_Plus4,   // for JAL
    output logic [31:0] PC_reg
);

    logic [31:0] PC_next;
    assign PC_Plus4 = PC_reg + 32'd4;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            PC_reg <= 32'h0000_0000;
        end else begin
            PC_reg <= PC_next;
        end
    end

    always_comb begin
        case (PCSrc)
            // PC + 4
            2'b00: PC_next = PC_reg + 32'd4;
            // branch -> PC + offset
            2'b01: PC_next = PC_reg + PC_branch_offset;
            // JAL -> PC + offset
            2'b10: PC_next = PC_reg + PC_branch_offset;
            // JALR -> ALU result
            2'b11: PC_next = ALU_result & 32'hFFFF_FFFE; // (rs1 + imm) & ~1
        endcase
    end
endmodule   