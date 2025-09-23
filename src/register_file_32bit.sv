`timescale 1ns/1ps
module register_file_32bit (
    input logic clk,
    input logic [4:0] r_addr_0,
    input logic [4:0] r_addr_1,
    input logic w_en,
    input logic [4:0] w_addr,
    input logic [31:0] w_data,

    output logic [31:0] r_data_0,
    output logic [31:0] r_data_1
);

    logic [31:0] mem [0:31];


    always_ff @( posedge clk ) begin : blockName
        if (w_en) begin
            mem[w_addr] <= w_data;
        end
    end

    always_comb begin
        r_data_0 = (r_addr_0 != 0) ? mem[r_addr_0] : 32'b0;
        r_data_1 = (r_addr_1 != 0) ? mem[r_addr_1] : 32'b0;
    end

    // Initialize registers for simulation
    initial begin
        for (int i = 0; i < 32; i++) begin
            mem[i] = i + 32'd50;
        end
    end
endmodule