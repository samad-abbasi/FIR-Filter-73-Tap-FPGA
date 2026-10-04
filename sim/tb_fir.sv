`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2026 01:53:08 PM
// Design Name: 
// Module Name: tb_fir
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

module tb_fir();
parameter samples = 100;
parameter width   = 16;
parameter depth   = 73;
logic clk, rst, start_bit;
logic signed [width-1:0] x_in;
logic signed [width-1:0] y_out;
logic        out_valid;

top #(samples, width, depth) fir_top(
clk, rst, start_bit, x_in, y_out, out_valid
);

initial clk = 1'b0;
always #5 clk = ~clk;

//expected output memory  
logic signed [width-1:0] expected_out [0: samples-1];
logic signed [width-1:0] inputs       [0: samples-1];
integer pass_count;
integer fail_count;

initial begin
    $readmemh("input_samples.txt", inputs);
    $readmemh("golden_output.txt", expected_out);

    // Reset
    rst          = 1'b0;
    start_bit    = 1'b0;
    x_in         = '0;
    pass_count   = 0;
    fail_count   = 0;

    repeat (3) @(posedge clk);
    rst = 1'b1;
  //  @(posedge clk); 
    start_bit = 1'b1;
    for (int i = 0; i < samples; i++) begin
        x_in = inputs[i];       
        @(posedge clk);
        start_bit = 1'b0;
        wait(out_valid);
            
        if (y_out == expected_out[i]) begin
            $display("Sample %0d: PASS  (y_out = %0d)", i, y_out);
            pass_count++;
        end 
        else begin
            $display("Sample %0d: FAIL  (y_out = %0d, expected = %0d)", i, y_out, expected_out[i]);
            fail_count++;
        end
        
    
        @(posedge clk);
    end
    
    $display("TEST DONE: %0d passed, %0d failed", pass_count, fail_count);
    $finish;
    
    
end
endmodule
