`timescale 1ns/1ps
module register_32bit (
    input logic clk,
    input logic rst,
    input logic w_en,
    input logic [31:0] d,
    output logic [31:0] q
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 32'b0;
        end else if (w_en) begin
            q <= d;
        end
    end
endmodule