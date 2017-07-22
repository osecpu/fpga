`timescale 1ns / 1ps
`include "def.v"
module DataPath(
	instr0, current_state,
	alu_d0, alu_d1, alu_dout, alu_op,
	ireg_r0, ireg_r1, ireg_rw, ireg_we,
	ireg_d0, ireg_d1, ireg_dw);
	//
	input [31:0] instr0;
	input [3:0] current_state;
	input [31:0] alu_dout;
	input [31:0] ireg_d0, ireg_d1;
	//
	output reg [31:0] alu_d0, alu_d1;
	output reg [3:0] alu_op = 0;
	output reg [5:0] ireg_r0, ireg_r1, ireg_rw;
	output reg ireg_we;
	output reg [31:0] ireg_dw;
	//
	wire [5:0] instr0_operand0;
	wire [5:0] instr0_operand1;
	wire [5:0] instr0_operand2;
	//wire [5:0] instr0_operand3;
	wire [7:0] instr0_op;
	wire [31:0] instr0_imm16_ext;
	//wire [31:0] instr0_imm24_ext;
	//
	assign instr0_operand0 	= instr0[23:18];
	assign instr0_operand1 	= instr0[17:12];
	assign instr0_operand2 	= instr0[11: 6];
	//assign instr0_operand3 	= instr0[ 5: 0];
	assign instr0_op       	= instr0[31:24];
	assign instr0_imm16_ext	= {{16{instr0[15]}},instr0[15: 0]}; 
	//assign instr0_imm24_ext	= {{ 8{instr0[23]}},instr0[23: 0]}; 
	
	always begin
		case (current_state)
			`STATE_EXEC: begin
				case (instr0_op)
					`OP_LIMM16: begin // LIMM16
						alu_d0 = 0;
						alu_d1 = 0;
						ireg_r0 = 0;
						ireg_r1 = 0;
						ireg_rw = instr0_operand0;
						ireg_dw = instr0_imm16_ext;
						ireg_we = 1;
					end
					8'hd2: begin // CP
						alu_d0 = 0;
						alu_d1 = 0;
						ireg_r0 = instr0_operand1;
						ireg_r1 = 0;
						ireg_rw = instr0_operand0;
						ireg_dw = ireg_d0;
						ireg_we = 1;
					end
					8'h10, 8'h11, 8'h12, 8'h14, 8'h15, 8'h18, 8'h19: begin
						// OR, XOR, AND ADD, SUB
						alu_d0 = ireg_d0;
						alu_d1 = ireg_d1;
						ireg_r0 = instr0_operand1;
						ireg_r1 = instr0_operand2;
						ireg_rw = instr0_operand0;
						ireg_dw = alu_dout;
						ireg_we = 1;
						//
						alu_op = instr0_op[3:0];
					end
					8'hd3: begin // CPDR
						alu_d0 = 0;
						alu_d1 = 0;
						ireg_r0 = instr0_operand1;
						ireg_r1 = 0;
						ireg_rw = 0;
						ireg_dw = 0;
						ireg_we = 0;
					end
					default: begin
						alu_d0 = 0;
						alu_d1 = 0;
						ireg_r0 = 0;
						ireg_r1 = 0;
						ireg_rw = 0;
						ireg_dw = 0;
						ireg_we = 0;
					end
				endcase
			end
			default: begin
				alu_d0 = 0;
				alu_d1 = 0;
				ireg_r0 = 0;
				ireg_r1 = 0;
				ireg_rw = 0;
				ireg_dw = 0;
				ireg_we = 0;
			end
		endcase
		#1;	// このwaitは必須（シミュレーションの無限ループを避けるため）
	end
endmodule
