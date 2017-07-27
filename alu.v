`timescale 1ns / 1ps

module ALUController(d0, d1, dout, op, iscmp);
	// dout = d0 op d1
	input signed [31:0] d0, d1;
	output signed [31:0] dout;
	input[3:0] op;
	input iscmp;

	assign dout = calcALUResult(op, d0, d1);
	function signed [31:0] calcALUResult(input [3:0] op, input signed [31:0] d0, input signed [31:0] d1);
		if(iscmp == 0) begin
			case (op)
				`ALU_OP_OR:		calcALUResult = d0 | d1;
				`ALU_OP_XOR:	calcALUResult = d0 ^ d1;
				`ALU_OP_AND:	calcALUResult = d0 & d1;
				//
				`ALU_OP_ADD:	calcALUResult = d0 + d1;
				`ALU_OP_SUB:	calcALUResult = d0 - d1;
				`ALU_OP_SHL:	calcALUResult = d0 << d1;
				`ALU_OP_SAR:	calcALUResult = d0 >>> d1;
				default:		calcALUResult = 0;
			endcase
		end
		else begin
			case (op)
				`ALU_CC_E:		calcALUResult = d0 == d1;
				`ALU_CC_NE:		calcALUResult = d0 != d1;
				`ALU_CC_L:		calcALUResult = d0 < d1;
				`ALU_CC_GE:		calcALUResult = d0 >= d1;
				`ALU_CC_LE:		calcALUResult = d0 <= d1;
				`ALU_CC_G:		calcALUResult = d0 > d1;
				`ALU_CC_TSTZ:	calcALUResult = (d0 & d1) == 0;
				`ALU_CC_TSTNZ:	calcALUResult = (d0 & d1) != 0;
				default:		calcALUResult = 0;
			endcase
		end
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

