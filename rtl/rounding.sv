`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2026 12:56:46 AM
// Design Name: 
// Module Name: rounding
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


module rounding #(parameter acc_width = 38, parameter shift = 11,
parameter out = 16)(
input logic clk, rst, out_enb,
input logic signed [acc_width-1:0]acc_in,
output logic valid,
output logic signed [out-1:0]y_out
);

logic signed [acc_width-1:0] rounded;
logic signed [acc_width-1:0] shifted;
logic signed [out-1:0] y_temp;   

    // Steps 1-3: round, shift, saturate - same from Golden C model
always@(*) begin
    rounded = acc_in + (1 <<< (shift-1));
    shifted = rounded >>> shift;

    if (shifted > 38'sd32767)  //32767 is the maximum number that can be represented from a 15bit number (16th bit is reserved for signed numeber)
        y_temp = 16'sd32767;
    else if (shifted < -38'sd32768) //similarlt, //-32768 is the maximum number
        y_temp = -16'sd32768;
    else
        y_temp = shifted[15:0];
end


always_ff @(posedge clk) begin
    if (!rst) begin
        y_out <= '0;
        valid <= 1'b0;   // no result right after reset
    end
    else if (out_enb) begin
        y_out <= y_temp;
        valid <= 1'b1;
    end
    else begin
        valid <= 1'b0;
    end
end
    
    
    
endmodule
