`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2026 01:19:34 AM
// Design Name: 
// Module Name: coeff_rom
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


module coeff_rom #(parameter width = 16, parameter depth = 37)(
input logic [$clog2(depth)-1:0] addr,
output logic [width-1:0] coeff
    );
logic signed [width-1:0] rom [0:depth-1];

always@(*) begin
    $readmemh("coeffs_fixed.txt", rom);
end

assign coeff = rom[addr];

endmodule
