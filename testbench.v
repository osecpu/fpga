`timescale 1ns / 1ps

module testbench(seg, segsel);
	output [7:0] seg;
	output [3:0] segsel;
	//
	reg clk, reset;
	wire [31:0] osecpu_dr;
	wire [15:0] osecpu_pc;
	//
	OSECPU osecpu(clk, reset, osecpu_dr, osecpu_pc);

	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, testbench);
		//
		reset <= 1;
		#20;
		reset <= 0;
	end

	always begin
		// gen 50MHz clock
		clk <= 1; #20;
		clk <= 0; #20;
	end

	always @(posedge clk) begin
		if(osecpu_pc == 6) begin
			if(osecpu_dr == -4)
				$display ("Simulation PASS");
			else begin 
				$display ("Simulation **** FAILED ****");
			end
			$finish;
		end
	end
endmodule

