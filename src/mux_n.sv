`timescale 1ns/1ps
module mux_n #(parameter N = 2, parameter WIDTH = 32) (
    input logic [$clog2(N)-1:0] sel,
    input logic [WIDTH-1:0] in [0:N-1],
    output logic [WIDTH-1:0] out
);
    assign out = in[sel];
endmodule