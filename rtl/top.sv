`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2026 10:41:42 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
//=================== FOR SIMULATION =============
module top #(parameter samples = 100, parameter width = 16, parameter depth = 73)(
input logic clk, rst, start_bit,
input logic signed  [width-1:0] x_in,
output logic signed [width-1:0] y_out,
output logic out_valid
);

//block1: shift register
logic signed [width-1:0] shift_reg_mem [0: depth-1];

//block2: muxes
logic signed [width-1:0] tap1;
logic signed [width-1:0] tap2;

//block3: adder
logic signed [width-1:0] sum;


//block4: coeffecient rom
logic signed [width-1:0] coeff;
localparam rom_depth = (depth+1)/2;    //half coeff

//block5: multiplier
localparam pro_width = 2*width;
logic signed [pro_width-1:0] product;

//block6: accumulator
localparam acc_width = 2*width+6;  //6 bit extra due to 37 time addidtions(every 2 time addition require 1 extra bit, for 4 times it require 2 extra bits and so on)
logic signed [acc_width-1:0] acc_out; 

//block7: rounding
localparam shift = 11;

//block8: control fsm
logic shift_en, acc_enb, clear, out_enb;
logic [$clog2(depth)-2:0] cycle_cnt; //because coeffecients are syetrical and we are taking half of it which can be fit into 6 bits only


//============ instentiation ================

//1. shift register
shift_reg #(width,depth) fir_shift(
.clk(clk), 
.rst(rst), 
.shift_en(shift_en),
.x_in(x_in), 
.shift_out(shift_reg_mem) 
);

//2. Muxes
tap_pair #(width,depth) fir_tap_pair(        //depth=taps=73
.sel(cycle_cnt), 
.tap(shift_reg_mem),
.mux_high(tap1), 
.mux_low(tap2)   
);

//3. adder
tap_adder#(width) fir_adder(
.tap1(tap1),
.tap2(tap2),
.sum(sum) 
);

//4. Coeffecient Rom 
coeff_rom #(width,rom_depth, depth) fir_coeff(
.addr(cycle_cnt),
.coeff(coeff)
);

//5. multiplier
multiplier #(width , pro_width) fir_multiplier(
.sum(sum),
.coeff(coeff),
.product(product)
);
   
//6. Accumulator
accumulator #(pro_width , acc_width ) fir_acc(
.clk(clk), 
.rst(rst), 
.clear(clear), 
.acc_enb(acc_enb),
.product(product),
.acc_out(acc_out)
);

//7. Rounding
rounding #(acc_width, shift, width) fir_rounding(
.clk(clk), 
.rst(rst), 
.out_enb(out_enb),
.acc_out(acc_out), // accumulator's output is input of rounding block
.valid(out_valid),
.y_out(y_out)
);

//8. Control FSM
control_fsm #(rom_depth) fir_fsm(
.clk(clk), 
.rst(rst), 
.sample_valid(start_bit || out_valid), 
.shift_en(shift_en), 
.acc_enb(acc_enb), 
.clear(clear), 
.out_enb(out_enb), 
.cycle_cnt(cycle_cnt)
);

endmodule
*/

//============================UPDATED CODE FOR FPGA==============================
module top #(parameter samples = 100, parameter width = 16, parameter depth = 73)(
input logic clk, rst, btn_start,
input logic [$clog2(samples)-1:0] sw,
output logic signed [width-1:0] led,
output logic out_valid
);
 
//input module
logic start_bit;
logic done;
 
logic signed  [width-1:0] x_in;
logic [$clog2(samples)-1:0] rd_addr;
 
//Output logic
logic signed [width-1:0]  y_out;
 
//block1: shift register
logic signed [width-1:0] shift_reg_mem [0: depth-1];
 
//block2: muxes
logic signed [width-1:0] tap1;
logic signed [width-1:0] tap2;
 
//block3: adder
logic signed [width-1:0] sum;
 
 
//block4: coeffecient rom
logic signed [width-1:0] coeff;
localparam rom_depth = (depth+1)/2;    //half coeff
 
//block5: multiplier
localparam pro_width = 2*width;
logic signed [pro_width-1:0] product;
 
//block6: accumulator
localparam acc_width = 2*width+6;  //6 bit extra due to 37 time addidtions(every 2 time addition require 1 extra bit, for 4 times it require 2 extra bits and so on)
logic signed [acc_width-1:0] acc_out;
 

//block7: rounding
localparam shift = 11;
 
//block8: control fsm
logic shift_en, acc_enb, clear, out_enb;
logic [$clog2(depth)-2:0] cycle_cnt; //because coeffecients are syetrical and we are taking half of it which can be fit into 6 bits only
 
//registers to sync
logic signed [width-1:0] sum_reg, coeff_reg;
logic acc_enb_reg;
always @(posedge clk) begin
    sum_reg      <= sum;
    coeff_reg    <= coeff;
    acc_enb_reg <= acc_enb;
end
 
 
//============ instentiation ================
 
//-----DEBOUNCER---------
localparam DEBOUNCE = 200000;
logic [17:0] count = 0;
logic state = 0;
logic state_d;
always@(posedge clk)begin
    if (!rst) begin
        count <= 0;
        state <= 0;
    end
    else if(btn_start != state) begin
        count <= count + 1'b1;
        if(count >= DEBOUNCE) begin
            state <= btn_start;
            count <= 0;
        end
 
     end
     else begin
        count <= 0;
    end
    state_d <= state;
end
assign start_bit = state & ~state_d;
 
always @(posedge clk) begin
    if (!rst) begin
        rd_addr <= '0;
        done    <= '0;
        end
    else if (start_bit)begin
        rd_addr <= '0;
        done    <= '0;
        end
    else if (out_valid && (rd_addr < samples-1))
        rd_addr <= rd_addr + 1'b1;
 
    else if (out_valid && (rd_addr == samples-1))
        done    <= 1'b1;
end
 
 
//input module
input_rom #( width , samples)fir_input_rom(
.addr(rd_addr),
.sample(x_in)
);
 
 
//1. shift register
shift_reg #(width,depth) fir_shift(
.clk(clk),
.rst(rst),
.shift_en(shift_en),
.x_in(x_in),
.shift_out(shift_reg_mem)
);
 
//2. Muxes
tap_pair #(width,depth) fir_tap_pair(        //depth=taps=73
.sel(cycle_cnt),
.tap(shift_reg_mem),
.mux_high(tap1),
.mux_low(tap2)
);
 
//3. adder
tap_adder#(width) fir_adder(
.tap1(tap1),
.tap2(tap2),
.sum(sum)
);
 
//4. Coeffecient Rom
coeff_rom #(width,rom_depth, depth) fir_coeff(
.addr(cycle_cnt),
.coeff(coeff)
);
 
//5. multiplier
multiplier #(width , pro_width) fir_multiplier(
.sum(sum_reg),
.coeff(coeff_reg),
.product(product)
);
 
//6. Accumulator
accumulator #(pro_width , acc_width ) fir_acc(
.clk(clk),
.rst(rst),
.clear(clear),
.acc_enb(acc_enb_reg),
.product(product),
.acc_out(acc_out)
);
 
//7. Rounding
rounding #(acc_width, shift, width) fir_rounding(
.clk(clk),
.rst(rst),
.out_enb(out_enb),
.acc_out(acc_out), // accumulator's output is input of rounding block
.valid(out_valid),
.y_out(y_out)
);
 
//8. Control FSM
control_fsm #(rom_depth) fir_fsm(
.clk(clk),
.rst(rst),
.sample_valid(start_bit || (out_valid && (rd_addr != samples-1))),
.shift_en(shift_en),
.acc_enb(acc_enb),
.clear(clear),
.out_enb(out_enb),
.cycle_cnt(cycle_cnt)
);
 
//OUTPUT LOGIC ---- Output RAM
logic signed [width-1:0] out_ram [0:samples-1];
logic [$clog2(samples)-1:0] wr_ptr;
logic clearing;
always @(posedge clk) begin
   if (!rst) begin
        wr_ptr   <= '0;
        clearing <= 1'b1;
        end
    else if (clearing) begin
        out_ram[wr_ptr] <= '0;
        wr_ptr <= wr_ptr + 1'b1;
        if (wr_ptr == samples-1)
            clearing <= 1'b0;
    end
    else if (start_bit)
        wr_ptr <= '0;
    else if (out_valid) begin
        wr_ptr <= wr_ptr + 1'b1;
        out_ram[wr_ptr] <= y_out;
    end
end

//LED logic
assign led = (sw < samples) ? out_ram[sw] : '0;
 
endmodule