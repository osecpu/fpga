`timescale 1ns / 1ps

module LabelTable(clk, lbid, lbidw, typ, typw, base, basew, count, countw, we);
	/*
	typ(8bit):
		0x00	Undefined
		0x01	VPtr
		0x02	SINT8
		0x03	UINT8
		0x04	SINT16
		0x05	UINT16
		0x06	SINT32
		0x07	(UINT32)
		0x08	SINT4
		0x09	UINT4
		0x0A	SINT2
		0x0B	UINT2
		0x0C	SINT1
		0x0D	UINT1
		0x86  	Code   
	LBID(12bit)
	base(16bit)
	count(16bit)	
	*/
	input clk, we;
	input [11:0] lbid, lbidw;
	output [7:0] typ;
	input [7:0] typw;
	output [15:0] base;
	input [15:0] basew;
	output [15:0] count;
	input [15:0] countw;
	//
	reg [7:0] typefile[12:0];	// 左が要素の幅、右がアドレスの幅
	reg [15:0] basefile[12:0];	// 左が要素の幅、右がアドレスの幅
	reg [15:0] countfile[12:0];	// 左が要素の幅、右がアドレスの幅

	assign type = typefile[lbid];
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

`timescale 1ns / 1ps
// timescale [単位時間] / [丸め精度]
/*
module testbench();
	reg clk;

	reg [10:0] counter;

	// regは値を保持してくれる。
	// wireは値を保持してくれない。
	reg [5:0] r0, r1, rw;
	reg we;

	reg [31:0] dw;

	wire [31:0] d0, d1;

	ireg ir(clk, r0, r1, rw, d0, d1, dw, we);

	initial
	begin
		// 初期化ブロック。
		// 出力する波形ファイルをここで指定する。
		$dumpfile("ireg.vcd");
		$dumpvars(0, testbench);

		we = 1; rw = 0; dw = 3; #2

		r0 = 0; #1;
		r0 = 1; #1;
		r0 = 2; #1;
		r0 = 3; #1;
		r0 = 4; #1;
		r0 = 5; #1;

		$display ("Simulation end");
		$finish;
	end

	always	// 常に実行される。
	begin
		// クロックを生成する。
		// #1; は、1クロック待機する。
		clk <= 0; #1;
		clk <= 1; #1;
	end

	always @ (posedge clk)
	begin

	end

endmodule
*/
