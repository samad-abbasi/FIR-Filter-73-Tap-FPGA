`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// 
// 
// Create Date: 09/08/2026 02:25:45 PM
// Design Name: FIR Filter
// Module Name: tap_adder
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


module tap_adder#(parameter width = 16)(
input logic [width-1:0] tap1,
input logic [width-1:0] tap2,
output logic [width-1:0] sum );

always@(*) begin
    sum = tap1+tap2;
end



endmodule
