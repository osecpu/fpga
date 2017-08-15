`timescale 1ns / 1ps
`include "def.v"
module Controller(clk, reset, 
	memdata, memaddr, ireg_d0_lsb, 
	instr0, instr1, current_state, 
	cr, pc,
	pc_update_req, pc_update_addr);
	//
	input clk, reset;
	input [31:0] memdata;
	input ireg_d0_lsb;
	input pc_update_req;
	input [15:0] pc_update_addr;
	output reg [15:0] memaddr;
	output reg [31:0] instr0 = 0;
	output reg [31:0] instr1 = 0;
	output reg [3:0] current_state = 0;
	output reg [7:0] cr = 0;
	output reg [15:0] pc = 0;
	//
	reg		[15:0] pc_next;
	wire    [ 7:0] cr_next;
	reg		[ 3:0] next_state;
	always begin
		case (current_state)
			`STATE_FETCH0_0, `STATE_FETCH1_0: pc_next = pc + 1;
			`STATE_EXEC: begin
				if(pc_update_req) pc_next = pc_update_addr;
				else pc_next = pc;
			end
			default: pc_next = pc;
		endcase
		#1;
	end
	//
	wire [7:0] instr0_op;
	wire [7:0] next_instr0_op;
	assign instr0_op       	= instr0[31:24];
	assign next_instr0_op   = memdata[31:24];
	//
	reg cr_next_hlt;
	reg cr_next_skip;
	assign cr_next = {6'b0, cr_next_skip, cr_next_hlt};
	always begin
		// HLT bit
		if(current_state == `STATE_EXEC && instr0_op == `OP_HLT) begin
			cr_next_hlt = 1;
		end
		else cr_next_hlt = cr[`BIT_CR_HLT];
		// SKIP bit
		case (current_state)
			`STATE_FETCH0_1: begin
				case(next_instr0_op)
					`OP_LIMM32, `OP_LBSET: begin
						cr_next_skip = cr[`BIT_CR_SKIP];
					end
					default: cr_next_skip = 0;
				endcase
			end
			`STATE_FETCH1_1: begin
				cr_next_skip = 0;
			end
			`STATE_EXEC: begin
				if(instr0_op == `OP_CND && ireg_d0_lsb == 0) begin
					cr_next_skip = 1;
				end
				else cr_next_skip = 0;
			end
			default: cr_next_skip = cr[`BIT_CR_SKIP];
		endcase
		#1;
	end
	//
	always begin
		case (current_state)
			`STATE_FETCH0_0, `STATE_FETCH0_1:	memaddr = pc;
			`STATE_FETCH1_0, `STATE_FETCH1_1:	memaddr = pc;
			default:			memaddr = 0;
		endcase
		#1;
	end

	function genCRNextHLT(input [3:0]cstate, input[7:0] op);
		genCRNextHLT = (cstate == `STATE_EXEC && op == `OP_HLT);
	endfunction
	
	always @(negedge clk) begin
		if(reset == 0 && cr[`BIT_CR_HLT] == 0) begin
			if(current_state == `STATE_FETCH0_1) begin
				instr0 <= memdata;
			end
			if(current_state == `STATE_FETCH1_1) begin
				instr1 <= memdata;
			end
		end
	end

	always @(posedge clk) begin
		if(reset == 1) begin
			pc = 0;
			current_state = `STATE_FETCH0_0;
			cr = 0;
		end
		if(reset == 0 && cr[`BIT_CR_HLT] == 0) begin
			current_state <= next_state;
			pc <= pc_next;
			cr <= cr_next;
		end
	end
	// state transition
	always begin
		#1;
		case (current_state)
			`STATE_FETCH0_0:
					next_state = `STATE_FETCH0_1;
			`STATE_FETCH0_1: begin
				case(next_instr0_op)
					`OP_LIMM32, `OP_LBSET: begin
						next_state = `STATE_FETCH1_0;
					end
					default: begin
						if(cr[`BIT_CR_SKIP])
							next_state = `STATE_FETCH0_0;
						else					
							next_state = `STATE_EXEC;
					end
				endcase
			end
			`STATE_FETCH1_0:
					next_state = `STATE_FETCH1_1;
			`STATE_FETCH1_1: begin
				if(cr[`BIT_CR_SKIP])
					next_state = `STATE_FETCH0_0;
				else
					next_state = `STATE_EXEC;
			end
			`STATE_EXEC: begin
				next_state = `STATE_FETCH0_0;
			end
			default: next_state = `STATE_HLT;
		endcase
	end
endmodule
