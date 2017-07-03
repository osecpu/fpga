`timescale 1ns / 1ps

module ALUController(d0, d1, dout, op);
	// dout = d0 op d1	(cmp == 0)
	// op:	0: OR
	//		1: XOR
	//		2: AND

	//		4: ADD
	//		5: SUB

	//		6: MUL

	//		8: SHL
	//		9: SAR

	//		A: DIV
	//		B: MOD

	input [31:0] d0, d1;
	output [31:0] dout;
	input[3:0] op;

	reg [31:0] iregfile[5:0];	// 左が要素の幅、右がアドレスの幅

	assign dout = calcALUResult(op, d0, d1);
	function [31:0] calcALUResult(input [3:0] op, input [31:0] d0, input [31:0] d1);
		case (op)
			4'h0:	calcALUResult = d0 | d1;
			4'h1:	calcALUResult = d0 ^ d1;
			4'h2:	calcALUResult = d0 & d1;
			//
			4'h4:	calcALUResult = d0 + d1;
			4'h5:	calcALUResult = d0 - d1;
			default:	calcALUResult = 0;
		endcase
	endfunction
	
endmodule


// timescale [単位時間] / [丸め精度]
module testbench_alu();
	reg [31:0] d0, d1;
	reg [3:0] op;
	wire [31:0] dout;
	ALUController alu(d0, d1, dout, op);
	
	initial begin
		d0 = 3;
		d1 = 7;
		op = 4;	//add
		#2;
	end

endmodule

