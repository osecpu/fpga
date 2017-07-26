`timescale 1ns / 1ps
`include "def.v"

module MMU(clk,
	reqType, ofs, lbid, addr, invalid,
	lbidw, lbTypew, basew, countw, we);
	input clk;
	//
	input [7:0] reqType;
	input [15:0] ofs;
	input [11:0] lbid;
	//
	output [15:0] addr;
	output invalid;
	//
	input [11:0] lbidw;
	input [7:0] lbTypew;
	input [15:0] basew;
	input [15:0] countw;
	input we;
	//
	wire [15:0] base;
	wire [15:0] count;
	wire [7:0] lbType;
	//
	wire [11:0] lbt_lbid, lbt_lbidw;
	wire [7:0] lbt_typ, lbt_typw;
	wire [15:0] lbt_base, lbt_basew;
	wire [15:0] lbt_count, lbt_countw;
	wire lbt_we;
	//
	LabelTable lbt(clk, 
		lbid, lbidw, 
		lbType, lbTypew, 
		base, basew, 
		count, countw, 
		we);
	AddrDecoder addrdec(reqType, ofs, base, count, lbType, addr, invalid);

endmodule

module testbench_mmu();
	reg clk;
	//
	reg [7:0] reqType;
	reg [15:0] ofs;
	reg [11:0] lbid;
	//
	wire [15:0] addr;
	wire invalid;
	//
	reg [11:0] lbidw;
	reg [7:0] lbTypew;
	reg [15:0] basew;
	reg [15:0] countw;
	reg we;
	//
	MMU mmu(clk, 
		reqType, ofs, lbid, addr, invalid,
		lbidw, lbTypew, basew, countw, we);

	initial begin
		$dumpfile("mmu.vcd");
		$dumpvars(0, testbench_mmu);
		//
		lbid = 0;
		#1;
		lbidw = 0;
		lbTypew = `LBTYPE_CODE;
		basew = 0;
		countw = 32;
		we = 1;
		#2;
		we = 0;
		ofs = 1;
		reqType = `LBTYPE_CODE;
		#2;
		//
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

