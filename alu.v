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

	input signed [31:0] d0, d1;
	output signed [31:0] dout;
	input[3:0] op;

	assign dout = calcALUResult(op, d0, d1);
	function signed [31:0] calcALUResult(input [3:0] op, input signed [31:0] d0, input signed [31:0] d1);
		case (op)
			4'h0:	calcALUResult = d0 | d1;
			4'h1:	calcALUResult = d0 ^ d1;
			4'h2:	calcALUResult = d0 & d1;
			//
			4'h4:	calcALUResult = d0 + d1;
			4'h5:	calcALUResult = d0 - d1;
			4'h8:	calcALUResult = d0 << d1;
			4'h9:	calcALUResult = d0 >>> d1;
			default:	calcALUResult = 0;
		endcase
	endfunction
	
endmodule


// timescale [単位時間] / [丸め精度]
module testbench_alu();
	reg signed [31:0] d0, d1;
	reg signed [3:0] op;
	wire signed [31:0] dout;
	ALUController alu(d0, d1, dout, op);
	
	initial begin
		d0 = 3;
		d1 = 7;
		op = 4;	//add
		#2;
		d0 = 3;
		d1 = 7;
		op = 8;	//SHL
		#2;
		d0 = -1024;
		d1 = 8;
		op = 9;	//SAR
		#2;
	end

endmodule

