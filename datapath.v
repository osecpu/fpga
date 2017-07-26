`timescale 1ns / 1ps
`include "def.v"
module DataPath(
	instr0, instr1, current_state,
	alu_d0, alu_d1, alu_dout, alu_op, alu_iscmp,
	ireg_r0, ireg_r1, ireg_rw, ireg_we,
	ireg_d0, ireg_d1, ireg_dw);
	//
	input [31:0] instr0;
	input [31:0] instr1;
	input [3:0] current_state;
	input [31:0] alu_dout;
	input [31:0] ireg_d0, ireg_d1;
	//
	output reg [31:0] alu_d0, alu_d1;
	output reg [3:0] alu_op = 0;
	output reg alu_iscmp = 0;
	output reg [5:0] ireg_r0, ireg_r1, ireg_rw;
	output reg ireg_we;
	output reg [31:0] ireg_dw;
	//
	wire [5:0] instr0_operand0	= instr0[23:18];
	wire [5:0] instr0_operand1	= instr0[17:12];
	wire [5:0] instr0_operand2	= instr0[11: 6];
	wire [5:0] instr0_operand3	= instr0[5: 0];
	wire [7:0] instr0_op		= instr0[31:24];
	wire [31:0] instr0_imm16_ext= {{16{instr0[15]}},instr0[15: 0]};
	//
	always begin
		case (current_state)
			`STATE_EXEC: begin
				case (instr0_op)
					`OP_LBSET: begin
						alu_d0 = 0;
						alu_d1 = 0;
						alu_iscmp = 0;
						ireg_r0 = 0;
						ireg_r1 = 0;
						ireg_rw = instr0_operand0;
						ireg_dw = instr0_imm16_ext;
						ireg_we = 1;
					end
					`OP_LIMM16: begin
						alu_d0 = 0;
						alu_d1 = 0;
						alu_iscmp = 0;
						ireg_r0 = 0;
						ireg_r1 = 0;
						ireg_rw = instr0_operand0;
						ireg_dw = instr0_imm16_ext;
						ireg_we = 1;
					end
					`OP_CP: begin
						alu_d0 = 0;
						alu_d1 = 0;
						alu_iscmp = 0;
						ireg_r0 = instr0_operand1;
						ireg_r1 = 0;
						ireg_rw = instr0_operand0;
						ireg_dw = ireg_d0;
						ireg_we = 1;
					end
					`OP_OR, `OP_XOR, `OP_AND, 
						`OP_ADD, `OP_SUB, 
						`OP_SHL, `OP_SAR 
						: begin
						alu_d0 = ireg_d0;
						alu_d1 = ireg_d1;
						alu_iscmp = 0;
						ireg_r0 = instr0_operand1;
						ireg_r1 = instr0_operand2;
						ireg_rw = instr0_operand0;
						ireg_dw = alu_dout;
						ireg_we = 1;
						//
						alu_op = instr0_op[3:0];
					end
					`OP_CMPE, `OP_CMPNE, 
						`OP_CMPL, `OP_CMPGE, 
						`OP_CMPLE, `OP_CMPG,
						`OP_TSTZ, `OP_TSTNZ
						: begin
						alu_d0 = ireg_d0;
						alu_d1 = ireg_d1;
						alu_iscmp = 1;
						ireg_r0 = instr0_operand1;
						ireg_r1 = instr0_operand2;
						ireg_rw = instr0_operand0;
						ireg_dw = alu_dout;
						ireg_we = 1;
						//
						alu_op = {1'b0, instr0_op[2:0]};
					end
					`OP_LIMM32: begin
						alu_d0 = 0;
						alu_d1 = 0;
						alu_iscmp = 0;
						ireg_r0 = 0;
						ireg_r1 = 0;
						ireg_rw = instr0_operand0;
						ireg_dw = instr1;
						ireg_we = 1;
					end
					`OP_CPDR: begin // CPDR
						alu_d0 = 0;
						alu_d1 = 0;
						alu_iscmp = 0;
						ireg_r0 = instr0_operand1;
						ireg_r1 = 0;
						ireg_rw = 0;
						ireg_dw = 0;
						ireg_we = 0;
					end
					default: begin
						alu_d0 = 0;
						alu_d1 = 0;
						alu_iscmp = 0;
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
				alu_iscmp = 0;
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
