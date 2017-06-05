`timescale 1ns / 1ps
// timescale [単位時間] / [丸め精度]

module testbench();
	reg clk;
	reg out;

	// regは値を保持してくれる。
	// wireは値を保持してくれない。
	reg [15:0] counter;

	wire [3:0] data;

	memory mem(clk, counter, data);

	initial
	begin
		// 初期化ブロック。
		// 出力する波形ファイルをここで指定する。
		$dumpfile("testb.vcd");
		$dumpvars(0, testbench);
		counter = 0;
	end

	always	// 常に実行される。
	begin
		// クロックを生成する。
		// #1; は、1クロック待機する。
		clk <= 1; #1;
		clk <= 0; #1;
	end

	always @ (negedge clk)	// clk信号が1->0に変化する(negedge)ときに
							// 常に実行される
	begin
		counter = counter + 1;
		out = counter[0] & counter[1];
		if(counter === 1000) begin
			$display ("Simulation end");
			$finish;
		end
	end

endmodule
