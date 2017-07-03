`timescale 1ns / 1ps
module Controller(clk, reset, 
	memdata, memaddr, 
	instr0, current_state, 
	cr, pc);
	//
	input clk, reset;
	input [31:0] memdata;
	output [15:0] memaddr;
	output reg [31:0] instr0;
	output reg [3:0] current_state = 0;
	output reg [31:0] dr;
	output reg [7:0] cr;
	output reg [15:0] pc = 0;
	//
	assign memaddr = genMemAddr(current_state);
	wire	[15:0] pc_next;
	wire	[3:0]	next_state;
	assign pc_next = (next_state == 0 ? pc + 1'b1 : pc);
	//
	wire [7:0] instr0_op;
	assign instr0_op       	= instr0[31:24];
	//
	function [15:0] genMemAddr (input [3:0] currentState);
		case (currentState)
			4'd0:		genMemAddr = pc;
			default:	genMemAddr = 0;
		endcase
	endfunction
	
	always @(posedge clk) begin
		if(reset == 1) begin
			pc = 0;
			current_state = 0;
		end
		if(reset == 0) begin
			if(next_state == 1) begin
				instr0 = memdata;
			end
			current_state <= next_state;
			pc = pc_next;
		end
	end

	assign next_state = genNextState(current_state);
	function [3:0] genNextState (input [3:0] currentState);
		case (currentState)
			4'd0: begin
				// fetch
				
				genNextState = 1;
			end
			4'd1: begin
				// decode
				genNextState = 0;
			end
			default: genNextState = 0;
		endcase
	endfunction
	
	always @(posedge clk) begin
		if(instr0_op == 8'hF0) begin
			// END
			case (current_state) 
				4'd1: begin
					cr = 8'h01;
				end
			endcase
		end
	end
endmodule
