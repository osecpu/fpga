//`define CLK_BIT 0
`define CLK_BIT 24	// for debug on hardware

`timescale 1ns / 1ps
// timescale [単位時間] / [丸め精度] 

module top(clk_org, seg, segsel);
	input clk_org;
	output [7:0] seg;
	output [3:0] segsel;
	//
	wire [31:0] osecpu_dr;
	wire [15:0] osecpu_pc;
	reg reset;
	reg [`CLK_BIT:0] clk_counter = 0;
	wire clk, clk_cpu;
	assign clk = clk_counter[`CLK_BIT];

	LED7Seg led7seg(clk_org, seg, segsel, {osecpu_dr[7:0], osecpu_pc[7:0]});
	OSECPU osecpu(clk_cpu, reset, osecpu_dr, osecpu_pc);

	initial begin
		reset = 1;
		#20;
		reset = 0;
	end
	always @(posedge clk_org) begin
		clk_counter = clk_counter + 1'b1;
	end
endmodule

