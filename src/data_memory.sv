`timescale 1ns/1ps
module data_memory (
    input logic clk,
    input logic MemRead,
    input logic MemWrite,
    input logic [31:0] addr,
    input logic [31:0] w_data,
    output logic [31:0] r_data
);

    logic [31:0] mem [0:15]; // 16 words of memory

    // Read operation
    assign r_data = (MemRead) ? mem[addr[9:2]] : 32'b0; // Word-aligned access

    // Write operation
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            mem[addr[9:2]] <= w_data; // Word-aligned access
        end
    end
endmodule