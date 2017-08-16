`timescale 1ns / 1ps

module LabelTable(clk, lbid, lbidw, typ, typw, base, basew, count, countw, we);
	parameter LBIDWidth = 8;
	input clk, we;
	input [LBIDWidth-1:0] lbid, lbidw;
	output reg [5:0] typ;
	input [5:0] typw;
	output reg [15:0] base;
	input [15:0] basew;
	output reg [15:0] count;
	input [15:0] countw;
	//
	wire [LBIDWidth-1:0] lbidrw;
	reg [5:0] typefile[2**LBIDWidth-1:0];	// 左が要素の幅、右が添字範囲
	reg [15:0] basefile[2*LBIDWidth-1:0];
	reg [15:0] countfile[2*LBIDWidth-1:0];

	
	assign lbidrw = (we == 1) ? lbidw : lbid;
	always @ (posedge clk)
		begin
			if(we == 1) begin
				typefile[lbidrw]  <= typw;
				basefile[lbidrw]  <= basew;
				countfile[lbidrw] <= countw;
			end
			else begin
				typ   <= typefile[lbidrw];
				base  <= basefile[lbidrw];
				count <= countfile[lbidrw];
			end
		end
endmodule

