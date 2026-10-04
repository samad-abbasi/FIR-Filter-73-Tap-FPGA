`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 12:06:08 PM
// Design Name: 
// Module Name: tap_pair_test
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


module tap_pair_tb();

parameter width = 16;
parameter taps = 73;
logic  [$clog2(taps)-1:0]sel;
logic  [width-1:0] tap [0:taps-1];
logic [width-1:0] mux_high;
logic [width-1:0] mux_low; 

tap_pair #(width ,taps) tap_Pair_select(sel,  tap, mux_high, mux_low );
int x;

initial begin
    for(int i = 0; i < taps; i++) begin
        tap[i] = '0;
    end
    sel = 0;
    #20; 
    for(int j=0; j <30 ; j++)begin
    
    for(int i=0; i < taps ; i++) begin
        x = 10+i+j;
        tap[i] = x;

        sel = i;
        #10;
    end
    end
end

endmodule