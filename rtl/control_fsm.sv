`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2026 01:35:41 AM
// Design Name: 
// Module Name: control_fsm
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


module control_fsm #(parameter depth =37)(
input logic clk, rst, sample_valid, 
output logic shift_en, acc_enb, clear, out_enb, 
output logic [$clog2(depth)-1:0] cycle_cnt
);

typedef enum logic [2:0] {
    IDLE,
    LOAD,
    COMPUTE,
    ROUNDING,
    OUTPUT_READY
} state_t;

state_t state, next_state;

// State register
always @(posedge clk) begin
    if (!rst) 
        state <= IDLE;
    else
         state <= next_state;
end

// Next-state logic
always@(*) begin
    shift_en   = 1'b0;
    clear      = 1'b0;
    acc_enb    = 1'b0;
    out_enb    = 1'b0;
    next_state = state;
    case (state)
        IDLE:
            
            if (sample_valid) begin
                next_state = LOAD;
            end
        LOAD: begin
            shift_en   = 1'b1;
            clear      = 1'b1;
            next_state = COMPUTE;
        end

        COMPUTE: begin
            acc_enb = 1'b1;
            if (cycle_cnt == 6'd36)begin
                next_state = ROUNDING;
            end
        end

        ROUNDING:
            next_state = OUTPUT_READY;

        OUTPUT_READY: begin
            out_enb    = 1'b1;
            next_state = IDLE;
        end
        default:
            next_state = IDLE;
    endcase
end

// Cycle counter / addresses (counters sequential)
always @(posedge clk) begin
    if (!rst)
        cycle_cnt <= '0;
    else if (state == LOAD)
        cycle_cnt <= '0;
    else if (state == COMPUTE)
        cycle_cnt <= cycle_cnt + 1'b1;
end

  
    
endmodule
