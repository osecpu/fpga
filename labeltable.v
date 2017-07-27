`timescale 1ns / 1ps

module LabelTable(clk, lbid, lbidw, typ, typw, base, basew, count, countw, we);
	input clk, we;
	input [11:0] lbid, lbidw;
	output [5:0] typ;
	input [5:0] typw;
	output [15:0] base;
	input [15:0] basew;
	output [15:0] count;
	input [15:0] countw;
	//
	reg [5:0] typefile[4095:0];	// 左が要素の幅、右が添字範囲
	reg [15:0] basefile[4095:0];
	reg [15:0] countfile[4095:0];

	assign typ = typefile[lbid];
	assign base = basefile[lbid];
	assign count = countfile[lbid];

	always @ (posedge clk)
		begin
			if(we == 1) begin
				typefile[lbidw] = typw;
				basefile[lbidw] = basew;
				countfile[lbidw] = countw;
			end
		end
endmodule

