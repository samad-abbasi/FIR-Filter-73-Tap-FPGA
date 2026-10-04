`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 09:53:21 AM
// Design Name: 
// Module Name: shift_reg_test
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


module shift_reg_tb();


parameter width = 16;
parameter taps = 73;
logic  clk, rst, shift_en;
logic  [width-1:0] x_in;
logic [width-1:0] shift_out [0:taps-1];

shift_reg #(width,taps) shift_test(clk, rst, shift_en, x_in, shift_out );

always #5 clk = ~clk;
integer x;
initial begin
clk = 0;
rst = 1;
#20;
rst = 0;
shift_en = 1'b1;
for(int i=0; i < taps ; i++) begin
x = 10+i;
x_in = x;
#10;
end

//x_in = 16'habcd;
//#10;
//x_in = 16'habcd;
//#10;
//x_in = 16'habcd;
//#10;
//x_in = 16'habcd;
//#10;
//x_in = 16'habcd;
//#10;
//x_in = 16'habcd;
//#10;
//x_in = 16'habcd;
//#10;

end



endmodule
