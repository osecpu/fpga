module OSECPU(
	clk, reset,
	seg, segsel
);

input clk, reset;
output [7:0] seg;
output [3:0] segsel;

reg [15:0] data = 16'h1246;
LED7Seg led7seg(clk, seg, segsel, data);

reg [5:0] ireg_r0, ireg_r1, ireg_rw;
wire [31:0] ireg_d0, ireg_d1, ireg_dw;
reg ireg_we;
IntegerRegister ireg(clk, ireg_r0, ireg_r1, ireg_rw, ireg_d0, ireg_d1, ireg_dw, ireg_we);

reg [3:0] state;

always @ (posedge clk) begin
	if (reset == 1) begin
		ireg_rw = 6'h3F;
	end
end

endmodule

`timescale 1ns / 1ps
// timescale [単位時間] / [丸め精度] 

module testbench_top(seg, segsel);
	output [7:0] seg;
	output [3:0] segsel;
	reg clk, reset;

	reg [15:0] sim_count;

	OSECPU top(clk, reset, seg, segsel);

	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, testbench_top);
		sim_count = 0;
		//
		reset = 1; #4;
		reset = 0;
	end

	always begin
		// gen clock
		clk <= 1; #20;
		clk <= 0; #20;
	end

	always @(posedge clk) begin
		sim_count = sim_count + 1;
		if(sim_count == 100) begin
			$display ("Simulation end");
			$finish;
		end
	end

endmodule
