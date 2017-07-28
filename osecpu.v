`timescale 1ns / 1ps
`include "def.v"
module OSECPU(clk, reset, dr, cr, pc);
	input clk;
	input reset;
	output reg [31:0] dr = 0;
	output [15:0] pc;
	output [7:0] cr;
	//
	wire [31:0] alu_d0, alu_d1, alu_dout;
	wire [3:0] alu_op;
	wire alu_iscmp;
	//
	wire [5:0] ireg_rw, ireg_r0, ireg_r1;
	wire [31:0] ireg_d0, ireg_d1, ireg_dw;
	wire ireg_we;
	//
	wire [5:0] preg_p0, preg_p1, preg_pw;
	wire [11:0] preg_lbid0, preg_lbid1, preg_lbidw;
	wire [15:0] preg_ofs0, preg_ofs1, preg_ofsw;
	wire preg_we, preg_pc_update_req;
	//
	wire [ 5:0] mmu_reqType;
	wire [15:0] mmu_ofs;
	wire [11:0] mmu_lbid;
	wire [15:0] mmu_addr;
	wire        mmu_invalid;
	//
	wire [11:0] lbt_lbidw;
	wire [ 5:0] lbt_typw;
	wire [15:0] lbt_basew;
	wire [15:0] lbt_countw;
	wire lbt_we;
	//
	wire [15:0] mem_addr;
	wire [31:0] mem_data;
	wire [31:0] mem_wdata;
	reg mem_we;
	//
	wire [31:0] instr0;
	wire [31:0] instr1;
	wire [3:0] current_state;
	wire [15:0] pc;
	//
	Controller ctrl(clk, reset, 
		mem_data, mem_addr, ireg_d0[0], 
		instr0, instr1, current_state, 
		cr, pc,
		preg_pc_update_req, mmu_addr);
	ALUController alu(alu_d0, alu_d1, alu_dout, alu_op, alu_iscmp);
	IntegerRegister ireg(clk, 
		ireg_r0, ireg_r1, ireg_rw, 
		ireg_d0, ireg_d1, ireg_dw, 
		ireg_we);
	PointerRegister preg(clk, 
		preg_p0, preg_p1, preg_pw, 
		preg_lbid0, preg_lbid1, preg_lbidw, 
		preg_ofs0, preg_ofs1, preg_ofsw, 
		preg_we, preg_pc_update_req);
	MMU mmu(clk,
		mmu_reqType, mmu_ofs, mmu_lbid, mmu_addr, mmu_invalid,
		lbt_lbidw, lbt_typw, lbt_basew, lbt_countw, lbt_we);
	Memory mem(clk, mem_addr, mem_data, mem_wdata, mem_we);
	DataPath datapath(
		instr0, instr1, current_state,
		alu_d0, alu_d1, alu_dout, alu_op, alu_iscmp,
		ireg_r0, ireg_r1, ireg_rw, ireg_we,
		ireg_d0, ireg_d1, ireg_dw,
		lbt_lbidw, lbt_typw, lbt_basew, lbt_countw, lbt_we,
		preg_p0, preg_p1, preg_pw,
		preg_lbid0, preg_lbid1, preg_lbidw, 
		preg_ofs0, preg_ofs1, preg_ofsw, 
		preg_we,
		mmu_reqType, mmu_ofs, mmu_lbid, mmu_addr, mmu_invalid);
	
	wire [7:0] instr0_op;
	assign instr0_op       	= instr0[31:24];
	//
	always @(posedge clk) begin
		if(instr0_op == 8'hD3) begin
			// CPDR
			case (current_state) 
				`STATE_EXEC: begin
					dr = ireg_d0;
				end
			endcase
		end
	end
endmodule
