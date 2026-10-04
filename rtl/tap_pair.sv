`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ABDUR REHMAN and ABDUL SAMAD
// 
// Create Date: 09/07/2026 11:17:37 AM
// Design Name: FIR Filter
// Module Name: tap_pair
// Project Name: FIR Filter
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


module tap_pair #(parameter width = 16, parameter taps = 73)(
input logic [$clog2(taps)-2:0]sel, 
input logic signed [width-1:0] tap [0:taps-1],
output logic signed[width-1:0] mux_high, 
output logic signed[width-1:0] mux_low   
);

always @(*) begin
    
    case(sel)
    0: begin mux_low = tap[0]; mux_high = tap[72]; end
    1: begin mux_low = tap[1]; mux_high = tap[71]; end
    2: begin mux_low = tap[2]; mux_high = tap[70]; end
    3: begin mux_low = tap[3]; mux_high = tap[69]; end
    4: begin mux_low = tap[4]; mux_high = tap[68]; end
    5: begin mux_low = tap[5]; mux_high = tap[67]; end
    6: begin mux_low = tap[6]; mux_high = tap[66]; end
    7: begin mux_low = tap[7]; mux_high = tap[65]; end
    8: begin mux_low = tap[8]; mux_high = tap[64]; end
    9: begin mux_low = tap[9]; mux_high = tap[63]; end
    10: begin mux_low = tap[10]; mux_high = tap[62]; end
    11: begin mux_low = tap[11]; mux_high = tap[61]; end
    12: begin mux_low = tap[12]; mux_high = tap[60]; end
    13: begin mux_low = tap[13]; mux_high = tap[59]; end
    14: begin mux_low = tap[14]; mux_high = tap[58]; end
    15: begin mux_low = tap[15]; mux_high = tap[57]; end
    16: begin mux_low = tap[16]; mux_high = tap[56]; end
    17: begin mux_low = tap[17]; mux_high = tap[55]; end
    18: begin mux_low = tap[18]; mux_high = tap[54]; end
    19: begin mux_low = tap[19]; mux_high = tap[53]; end
    20: begin mux_low = tap[20]; mux_high = tap[52]; end
    21: begin mux_low = tap[21]; mux_high = tap[51]; end
    22: begin mux_low = tap[22]; mux_high = tap[50]; end
    23: begin mux_low = tap[23]; mux_high = tap[49]; end
    24: begin mux_low = tap[24]; mux_high = tap[48]; end
    25: begin mux_low = tap[25]; mux_high = tap[47]; end
    26: begin mux_low = tap[26]; mux_high = tap[46]; end
    27: begin mux_low = tap[27]; mux_high = tap[45]; end
    28: begin mux_low = tap[28]; mux_high = tap[44]; end
    29: begin mux_low = tap[29]; mux_high = tap[43]; end
    30: begin mux_low = tap[30]; mux_high = tap[42]; end
    31: begin mux_low = tap[31]; mux_high = tap[41]; end
    32: begin mux_low = tap[32]; mux_high = tap[40]; end
    33: begin mux_low = tap[33]; mux_high = tap[39]; end
    34: begin mux_low = tap[34]; mux_high = tap[38]; end
    35: begin mux_low = tap[35]; mux_high = tap[37]; end
    36: begin mux_low = tap[36]; mux_high = '0; end
    default: begin mux_low = '0; mux_high = '0; end

    endcase 
    
end

endmodule
