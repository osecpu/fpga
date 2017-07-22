`timescale 1ns / 1ps
`include "def.v"
module AddrDecoder(reqType, ofs, base, count, lbType, addr, invalid);
	input [7:0] reqType;
	input [15:0] ofs;
	input [15:0] base;
	input [15:0] count;
	input [7:0] lbType;
	input [15:0] addr;
	output invalid;
	//
	assign addr = base + ofs;
	assign invalid = !(
		isValidLabelType(reqType) && 
		reqType == lbType &&
		ofs < count
	);
	function isValidLabelType(input [7:0] type);
		case(reqType)
			//`LBTYPE_UNDEFINED:;
			`LBTYPE_VPTR:	isValidLabelType = 1'd1;
			`LBTYPE_SINT8:	isValidLabelType = 1'd1;
			`LBTYPE_UINT8:	isValidLabelType = 1'd1;
			`LBTYPE_SINT16:	isValidLabelType = 1'd1;
			`LBTYPE_UINT16:	isValidLabelType = 1'd1;
			`LBTYPE_SINT32:	isValidLabelType = 1'd1;
			`LBTYPE_UINT32:	isValidLabelType = 1'd1;
			`LBTYPE_SINT4:	isValidLabelType = 1'd1;
			`LBTYPE_UINT4:	isValidLabelType = 1'd1;
			`LBTYPE_SINT2:	isValidLabelType = 1'd1;
			`LBTYPE_UINT2:	isValidLabelType = 1'd1;
			`LBTYPE_SINT1:	isValidLabelType = 1'd1;
			`LBTYPE_UINT1:	isValidLabelType = 1'd1;
			`LBTYPE_CODE:	isValidLabelType = 1'd1;
			default:	isValidLabelType = 1'd0;
		endcase
	endfunction
endmodule

module testbench_addrdec();
	reg clk;
	//
	reg [7:0] reqType;
	reg [15:0] ofs;
	reg [15:0] base;
	reg [15:0] count;
	reg [7:0] lbType;
	wire [15:0] addr;
	wire invalid;

	AddrDecoder addrdec(reqType, ofs, base, count, lbType, addr, invalid);

	initial begin
		$dumpfile("memctrl.vcd");
		$dumpvars(0, testbench_memctrl);
		// all invalid
		reqType = `LBTYPE_UNDEFINED;
		ofs = 4;
		base = 16'hffff;
		count = 0;
		lbType = `LBTYPE_UNDEFINED;
		//
		#1;
		$display ("addr: %X", addr);
		$display ("invalid: %X", invalid);
		if(invalid == 1) $display("PASS");
		else begin
			$display("FAILED");
			$finish;
		end
		// valid
		reqType = `LBTYPE_CODE;
		ofs 	= 4;
		base	= 16'hff00;
		count	= 16'h00ff;
		lbType	= `LBTYPE_CODE;
		//
		#1;
		$display ("addr: %X", addr);
		$display ("invalid: %X", invalid);
		if(invalid == 0 && addr == 16'hff04) $display("PASS");
		else begin
			$display("FAILED");
			$finish;
		end
		// type not matched
		reqType = `LBTYPE_VPTR;
		ofs 	= 4;
		base	= 16'hff00;
		count	= 16'h00ff;
		lbType	= `LBTYPE_CODE;
		//
		#1;
		$display ("addr: %X", addr);
		$display ("invalid: %X", invalid);
		if(invalid == 1) $display("PASS");
		else begin
			$display("FAILED");
			$finish;
		end
		// out of limit
		reqType = `LBTYPE_CODE;
		ofs 	= 4;
		base	= 16'hff00;
		count	= 16'h004;
		lbType	= `LBTYPE_CODE;
		//
		#1;
		$display ("addr: %X", addr);
		$display ("invalid: %X", invalid);
		if(invalid == 1) $display("PASS");
		else begin
			$display("FAILED");
			$finish;
		end
		// last element in bound
		reqType = `LBTYPE_CODE;
		ofs 	= 3;
		base	= 16'hff00;
		count	= 16'h004;
		lbType	= `LBTYPE_CODE;
		//
		#1;
		$display ("addr: %X", addr);
		$display ("invalid: %X", invalid);
		if(invalid == 0 && addr == 16'hff03) $display("PASS");
		else begin
			$display("FAILED");
			$finish;
		end
		//
		$display ("Simulation end");
		$finish;
	end
	always begin
		// クロックを生成する。
		// #1; は、1クロック待機する。
		clk <= 0; #1;
		clk <= 1; #1;
	end

	always @ (posedge clk)
	begin

	end

endmodule

/*
module testbench_memctrl();
	reg clk;
	//
	reg [11:0] lbid, lbidw;
	wire [7:0] typ;
	reg [7:0] typw;
	wire [15:0] base;
	reg [15:0] basew;
	wire [15:0] count;
	reg [15:0] countw;
	reg lbt_we;

	reg [5:0] p0, p1, pw;
	wire [11:0] lbid0, lbid1;
	reg [11:0] preg_lbidw;
	wire [15:0] ofs0, ofs1;
	reg [15:0] ofsw;
	reg preg_we;

	wire [7:0] reqType;
	wire [15:0] addr;
	wire valid;

	MemoryCtrl mem(clk,
		base, ofs0, count, typ, reqType, addr, valid);

	LabelTable lbt(clk, 
		lbid, lbidw, 
		typ, typw, 
		base, basew, 
		count, countw, 
		lbt_we);

	PointerRegister preg(clk, 
		p0, p1, pw, 
		lbid0, lbid1, preg_lbidw, 
		ofs0, ofs1, ofsw, 
		preg_we);

	initial begin
		$dumpfile("memctrl.vcd");
		$dumpvars(0, testbench_memctrl);
		// set label table
		lbidw = 3;
		typw = `LBTYPE_CODE;
		basew = 2;
		countw = 6;
		lbt_we = 1;
		#2;
		lbt_we = 0;
		#1;
		lbid = 0;
		#1;
		lbid = 3;
		#1;
		// set pointer reg
		pw = 4;
		preg_lbidw = 3;
		ofsw = 2;
		preg_we = 1;
		#2;
		preg_we = 0;
		#1;
		// check memory unit
		p0 = 4;
		#4

		if()

		$display ("Simulation end");
		$finish;
	end
	always begin
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
