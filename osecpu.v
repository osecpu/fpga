`timescale 1ns / 1ps
module OSECPU(clk, reset, dr, pc);
	input clk;
	input reset;
	output [31:0] dr;
	output [15:0] pc;
	//
	wire [31:0] alu_d0, alu_d1, alu_dout;
	wire [3:0] alu_op;
	//
	wire [5:0] ireg_rw, ireg_r0, ireg_r1;
	wire [31:0] ireg_d0, ireg_d1, ireg_dw;
	wire ireg_we;
	//
	wire [5:0] preg_p0, preg_p1, preg_pw;
	wire [11:0] preg_lbid0, preg_lbid1, preg_lbidw;
	wire [15:0] preg_ofs0, preg_ofs1, preg_ofsw;
	wire preg_we;
	//
	wire [11:0] lbt_lbid, lbt_lbidw;
	wire [7:0] lbt_typ, lbt_typw;
	wire [15:0] lbt_base, lbt_basew;
	wire [15:0] lbt_count, lbt_countw;
	wire lbt_we;
	//
	wire [15:0] mem_addr;
	wire [31:0] mem_data;
	wire [31:0] mem_wdata;
	reg mem_we;
	//
	wire [31:0] instr0;
	wire [3:0] current_state;
	wire [7:0] cr;
	wire [15:0] pc;
	//
	reg [31:0] dr;
	//
	Controller ctrl(clk, reset, 
		mem_data, mem_addr, 
		instr0, current_state, 
		cr, pc);
	ALUController alu(alu_d0, alu_d1, alu_dout, alu_op);
	IntegerRegister ireg(clk, 
		ireg_r0, ireg_r1, ireg_rw, 
		ireg_d0, ireg_d1, ireg_dw, 
		ireg_we);
	PointerRegister preg(clk, 
		preg_p0, preg_p1, preg_pw, 
		preg_lbid0, preg_lbid1, preg_lbidw, 
		preg_ofs0, preg_ofs1, preg_ofsw, 
		preg_we);
	LabelTable lbt(clk, 
		lbt_lbid, lbt_lbidw, 
		lbt_typ, lbt_typw, 
		lbt_base, lbt_basew, 
		lbt_count, lbt_countw, 
		lbt_we);
	Memory mem(clk, mem_addr, mem_data, mem_wdata, mem_we);
	DataPath datapath(
		instr0, current_state,
		alu_d0, alu_d1, alu_dout, alu_op,
		ireg_r0, ireg_r1, ireg_rw, ireg_we,
		ireg_d0, ireg_d1, ireg_dw);
	
	wire [7:0] instr0_op;
	assign instr0_op       	= instr0[31:24];
	//
	always @(posedge clk) begin
		if(instr0_op == 8'hD3) begin
			// CPDR
			case (current_state) 
				4'd1: begin
					dr = ireg_d0;
				end
			endcase
		end
	end
endmodule
