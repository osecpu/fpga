`timescale 1ns / 1ps

module Memory(clk, addr, data, wdata, we);
	// we: Write Enable
	input clk, we;
	input [15:0]addr;
	input [31:0]wdata;
	output [31:0]data;

	reg [31:0] rom[15:0];	// 左が要素の幅、右がアドレスの幅

	assign data = rom[addr];

	always @ (posedge clk)
		begin
			if(we == 1) begin
				rom[addr] = wdata;
			end
		end

	initial
		begin
			$readmemh("rom.hex", rom);
		end

endmodule

`timescale 1ns / 1ps
// timescale [単位時間] / [丸め精度]
/*
module testbench_memory();
	reg clk;

	// regは値を保持してくれる。
	// wireは値を保持してくれない。
	reg [15:0] counter;

	reg [31:0] wdata;
	reg we;
	reg PCinc;

	wire [31:0] data;

	memory mem(clk, counter, data, wdata, we);

	initial
	begin
		// 初期化ブロック。
		// 出力する波形ファイルをここで指定する。
		$dumpfile("memory.vcd");
		$dumpvars(0, testbench_memory);
		PCinc = 0;
		#1;
		counter = 0;
		#3;
		PCinc = 1;
	end

	always	// 常に実行される。
	begin
		// クロックを生成する。
		// #1; は、1クロック待機する。
		clk <= 1; #1;
		clk <= 0; #1;
	end

	always @ (posedge clk)
	begin
		if(PCinc == 1) begin
			counter = counter + 1;
		end
		if(counter === 1000) begin
			$display ("Simulation end");
			$finish;
		end
	end

endmodule
*/
