`timescale 1ns / 1ps
`include "def.v"
module MemoryCtrl(clk, base, ofs, count, lbType, reqType, addr, valid);
	input clk;
	input [15:0] base;
	input [15:0] ofs;
	input [15:0] count;
	input [7:0] lbType;
	input [7:0] reqType;
	input [15:0] addr;
	input we;
	output valid;
	//
	assign addr = base + ofs;

endmodule

`timescale 1ns / 1ps
// timescale [単位時間] / [丸め精度]

module testbench_memctrl();
	reg clk;
	//
	reg [11:0] lbid, lbidw;
	wire [7:0] typ;
	reg [7:0] typw;
	wire [15:0] base;
	reg [15:0] basew;
	wire [15:0] count;
	reg [15:0] countw;
	reg lbt_we;

	reg [5:0] p0, p1, pw;
	wire [11:0] lbid0, lbid1;
	reg [11:0] preg_lbidw;
	wire [15:0] ofs0, ofs1;
	reg [15:0] ofsw;
	reg preg_we;

	wire [7:0] reqType;
	wire [15:0] addr;
	wire valid;

	MemoryCtrl mem(clk,
		base, ofs0, count, typ, reqType, addr, valid);

	LabelTable lbt(clk, 
		lbid, lbidw, 
		typ, typw, 
		base, basew, 
		count, countw, 
		lbt_we);

	PointerRegister preg(clk, 
		p0, p1, pw, 
		lbid0, lbid1, preg_lbidw, 
		ofs0, ofs1, ofsw, 
		preg_we);

	initial begin
		$dumpfile("memctrl.vcd");
		$dumpvars(0, testbench_memctrl);
		// set label table
		lbidw = 3;
		typw = `LBTYPE_CODE;
		basew = 2;
		countw = 6;
		lbt_we = 1;
		#2;
		lbt_we = 0;
		#1;
		lbid = 0;
		#1;
		lbid = 3;
		#1;
		// set pointer reg
		pw = 4;
		preg_lbidw = 3;
		ofsw = 2;
		preg_we = 1;
		#2;
		preg_we = 0;
		#1;
		// check memory unit
		p0 = 4;
		#4

		$display ("Simulation end");
		$finish;
	end
	always begin
		// クロックを生成する。
		// #1; は、1クロック待機する。
		clk <= 0; #1;
		clk <= 1; #1;
	end

	always @ (posedge clk)
	begin

	end

endmodule

