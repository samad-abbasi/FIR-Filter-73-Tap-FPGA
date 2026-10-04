`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2026 12:35:46 AM
// Design Name: 
// Module Name: accumulator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module accumulator #(parameter pro_width = 32, parameter acc_width = 38)(
input logic clk, rst, clear, acc_enb,
input logic [pro_width-1:0] product,
output logic [acc_width-1:0] acc_out
    );

always@(posedge clk) begin
    if(!rst || clear) begin
        acc_out <= '0;
    end
    else if(acc_enb)begin
        acc_out <= acc_out + product;
    end
    else 
        acc_out <= acc_out;
end    
    
    
endmodule
