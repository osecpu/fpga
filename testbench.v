`timescale 1ns / 1ps
`include "def.v"

module testbench();
	reg [7:0] seg;
	reg [3:0] segsel;
	//
	reg clk, reset;
	wire [31:0] osecpu_dr;
	wire [15:0] osecpu_pc;
	wire [7:0] osecpu_cr;
	//
	OSECPU osecpu(clk, reset, osecpu_dr, osecpu_cr, osecpu_pc);

	initial begin
		$dumpfile("testbench.vcd");
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
		if(osecpu_cr[`BIT_CR_HLT]) begin
			if(osecpu_dr == -4)
				$display ("Simulation PASS");
			else begin 
				$display ("Simulation **** FAILED ****");
				$display ("%x", osecpu_dr);
			end
			$finish;
		end
	end
endmodule

