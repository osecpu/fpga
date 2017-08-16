`timescale 1ns / 1ps

module IntegerRegister(clk, r0, r1, rw, d0, d1, dw, we);
	input clk, we;
	input [5:0] r0, r1, rw;
	input [31:0] dw;
	output reg [31:0] d0, d1;
	
	wire [5:0] rwr0;
	reg [31:0] iregfile[63:0];	// 左が要素の幅、右が添字範囲

	
	//r0 and rw
	assign rwr0 = (we == 1) ? rw : r0;
	always @ (posedge clk)
		begin
			if(we == 1) begin
				iregfile[rwr0] <= dw;
			end
			else begin
				d0 <= iregfile[rwr0];
			end
		end
	// r1 read
	always @ (posedge clk)
		begin
			d1 <= iregfile[r1];
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
