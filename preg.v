`timescale 1ns / 1ps

module PointerRegister(clk, 
	p0, p1, pw, 
	lbid0, lbid1, lbidw, 
	ofs0, ofs1, ofsw, 
	we, pc_update_req);
	input clk, we;
	input [5:0] p0, p1, pw;
	output reg [11:0] lbid0, lbid1;
	input [11:0] lbidw;
	output reg [15:0] ofs0, ofs1;
	input [15:0] ofsw;
	output pc_update_req;

	reg [11:0] lbidfile[63:0];	// 左が要素の幅、右が添字範囲
	reg [15:0] ofsfile[63:0];
	
	wire [5:0] rwp0;
/*
	assign lbid0 = lbidfile[p0];
	assign lbid1 = lbidfile[p1];

	assign ofs0 = ofsfile[p0];
	assign ofs1 = ofsfile[p1];
*/
	assign pc_update_req = (we == 1 && pw == 6'h3f) ? 1 : 0;
	// p0 and pw
	
	assign rwp0 = (we == 1) ? pw : p0;
	
	always @ (posedge clk)
		begin
			if(we == 1) begin
				lbidfile[rwp0] <= lbidw;
				ofsfile[rwp0]  <= ofsw;
			end
			else begin
				lbid0 <= lbidfile[rwp0];
				ofs0  <= ofsfile[rwp0];
			end
		end
	// p1
	always @ (posedge clk)
		begin
			lbid1 <= lbidfile[p1];
			ofs1  <= ofsfile[p1];
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
