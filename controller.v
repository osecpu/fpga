`timescale 1ns / 1ps
`include "def.v"
module Controller(clk, reset, 
	memdata, memaddr, 
	instr0, instr1, current_state, 
	cr, pc);
	//
	input clk, reset;
	input [31:0] memdata;
	output [15:0] memaddr;
	output reg [31:0] instr0 = 0;
	output reg [31:0] instr1 = 0;
	output reg [3:0] current_state = 0;
	output reg [7:0] cr = 0;
	output reg [15:0] pc = 0;
	//
	assign memaddr = genMemAddr(current_state);
	wire	[15:0] pc_next;
	wire	[3:0]	next_state;
	assign pc_next = (
		current_state == `STATE_FETCH0 || 
		current_state == `STATE_FETCH1 ? pc + 1'b1 : pc);
	//
	wire [7:0] instr0_op;
	wire [7:0] next_instr0_op;
	assign instr0_op       	= instr0[31:24];
	assign next_instr0_op   = memdata[31:24];
	//
	function [15:0] genMemAddr (input [3:0] currentState);
		case (currentState)
			`STATE_FETCH0:	genMemAddr = pc;
			`STATE_FETCH1:	genMemAddr = pc;
			default:		genMemAddr = 0;
		endcase
	endfunction
	
	always @(posedge clk) begin
		if(reset == 1) begin
			pc = 0;
			current_state = `STATE_FETCH0;
		end
		if(reset == 0 && cr[`BIT_CR_HLT] == 0) begin
			if(current_state == `STATE_FETCH0) begin
				instr0 = memdata;
			end
			if(current_state == `STATE_FETCH1) begin
				instr1 = memdata;
			end
			current_state <= next_state;
			pc = pc_next;
		end
	end

	assign next_state = genNextState(current_state, next_instr0_op);
	function [3:0] genNextState (
		input [3:0] currentState, 
		input [7:0] next_instr0_op);
		case (currentState)
			`STATE_FETCH0: begin
				case(next_instr0_op)
					`OP_LIMM32: genNextState = `STATE_FETCH1;
					`OP_LBSET: genNextState = `STATE_FETCH1;
					default: genNextState = `STATE_EXEC;
				endcase
			end
			`STATE_FETCH1: begin
				genNextState = `STATE_EXEC;
			end
			`STATE_EXEC: begin
				genNextState = `STATE_FETCH0;
			end
			default: genNextState = `STATE_FETCH0;
		endcase
	endfunction
	
	always @(posedge clk) begin
		if(instr0_op == `OP_HLT) begin
			case (current_state) 
				`STATE_EXEC: begin
					cr[`BIT_CR_HLT] = 1'b1;
				end
			endcase
		end
	end
endmodule
