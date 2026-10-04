`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2026 11:58:48 PM
// Design Name: 
// Module Name: multiplier
// Project Name: FIR Project
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


module multiplier #(parameter in_width = 16, parameter out_width = 32)(
input logic [in_width-1:0]sum,
input logic [in_width-1:0]coeff,
output logic [out_width-1:0]product
    );
    
always@(*) begin
    product = sum * coeff;    
end
endmodule
