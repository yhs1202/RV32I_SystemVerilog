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

    // assign mem[0] = 32'b0;  // $0

    assign r_data_0 = mem[r_addr_0];
    assign r_data_1 = mem[r_addr_1];

    always_ff @( posedge clk ) begin : blockName
        if (w_en) begin
            mem[w_addr] <= w_data;
        end
    end

endmodule