`timescale 1ns / 1ps
`include "define.svh"

module byte_enable_logic (
    input logic [2:0] func3,
    input logic [31:0] addr,
    input logic [31:0] w_data,  // to memory (store)
    input logic [31:0] r_data,  // from memory (load)
    output logic [31:0] BE_w_data,
    output logic [31:0] BE_r_data,
    output logic [3:0] byte_enable
);
    wire [1:0] Addr_Last2 = addr[1:0]; // address last 2 bits for byte enable

    always_comb begin : Byte_enable_Decoding
        case(func3)
            // byte
            `F3_BYTE, `F3_UBYTE: byte_enable = (Addr_Last2 == 2'b00) ? 4'b0001 :
                                  (Addr_Last2 == 2'b01) ? 4'b0010 :
                                  (Addr_Last2 == 2'b10) ? 4'b0100 :
                                  (Addr_Last2 == 2'b11) ? 4'b1000 : 4'b0000;
            // halfword
            `F3_HALF, `F3_UHALF: byte_enable = (Addr_Last2 == 2'b00) ? 4'b0011 :
                                  (Addr_Last2 == 2'b10) ? 4'b1100 :  4'b0000;
            // word
            `F3_WORD: byte_enable = 4'b1111;
            default: byte_enable = 4'b0000;
        endcase
    end

    always_comb begin : Byte_enable_Extension
         case(byte_enable)
            // word
            4'b1111: begin  // for lw, sw
                BE_r_data = r_data[31:0];
                BE_w_data = w_data[31:0];
            end

            // halfword
            4'b0011: begin  // for lh, sh
                BE_r_data = (func3 == `F3_HALF) ? {{16{r_data[15]}}, r_data[15:0]} : // sign-extend
                                                     {16'b0, r_data[15:0]}; // zero-extend
                BE_w_data = {16'h0, w_data[15:0]};
            end
            4'b1100: begin  // for lh, sh
                BE_r_data = (func3 == `F3_HALF) ? {{16{r_data[31]}}, r_data[31:16]} : // sign-extend
                                                     {16'b0, r_data[31:16]}; // zero-extend
                BE_w_data = {w_data[15:0], 16'h0};
            end

            // byte
            4'b0001: begin
                BE_r_data = (func3 == `F3_BYTE) ? {{24{r_data[7]}}, r_data[7:0]} : // sign-extend
                                                     {24'b0, r_data[7:0]}; // zero-extend
                BE_w_data = {24'h0, w_data[7:0]};
            end
            4'b0010: begin
                BE_r_data = (func3 == `F3_BYTE) ? {{24{r_data[15]}}, r_data[15:8]} : // sign-extend
                                                     {24'b0, r_data[15:8]}; // zero-extend
                BE_w_data = {16'h0, w_data[7:0], 8'h0};
            end
            4'b0100: begin
                BE_r_data = (func3 == `F3_BYTE) ? {{24{r_data[23]}}, r_data[23:16]} : // sign-extend
                                                     {24'b0, r_data[23:16]}; // zero-extend
                BE_w_data = {8'h0, w_data[7:0], 16'h0};
            end
            4'b1000: begin
                BE_r_data = (func3 == `F3_BYTE) ? {{24{r_data[31]}}, r_data[31:24]} : // sign-extend
                                                     {24'b0, r_data[31:24]}; // zero-extend
                BE_w_data = {w_data[7:0], 24'h0};
            end
            default: begin
                BE_r_data = 32'b0;
                BE_w_data = 32'b0;
            end
        endcase
    end
endmodule