`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  
// 
// 
// Create Date: 09/07/2026 09:20:55 AM
// Design Name: FIR FIlter
// Module Name: shift_reg
// Project Name: FIR FIlter
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_reg #(parameter width = 16, parameter taps = 73)(
input logic  clk, rst, shift_en,
input logic  [width-1:0] x_in,
output logic [width-1:0] shift_out [0:taps-1] 
);

integer i;
always @(posedge clk) begin
    if(rst) begin
        for (i = 0; i < taps; i++) begin
            shift_out[i] <= '0;      // initializing all values to 0
        end
    
    end
    else if(shift_en) begin
        shift_out[0] <= x_in;         //Recent Entry goes to first output
    
        for (i = 1; i < taps; i++) begin
                shift_out[i] <= shift_out[i-1]; //shift recent entry to next place
        end
    end
    else 
        shift_out <= shift_out;

end


endmodule
