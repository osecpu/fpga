`timescale 1ns / 1ps
`include "def.v"
module DataPath(
	instr0, instr1, current_state,
	alu_d0, alu_d1, alu_dout, alu_op, alu_iscmp,
	ireg_r0, ireg_r1, ireg_rw, ireg_we,
	ireg_d0, ireg_d1, ireg_dw,
	lbt_lbidw, lbt_typw, lbt_basew, lbt_countw, lbt_we,
	preg_p0, preg_p1, preg_pw,
	preg_lbid0, preg_lbid1, preg_lbidw,
	preg_ofs0, preg_ofs1, preg_ofsw,
	preg_we);
	//
	input [31:0] instr0;
	input [31:0] instr1;
	input [ 3:0] current_state;
	input [31:0] alu_dout;
	input [31:0] ireg_d0, ireg_d1;
	input [11:0] preg_lbid0, preg_lbid1;
	input [15:0] preg_ofs0, preg_ofs1;
	//
	output reg [31:0] alu_d0, alu_d1;
	output reg [ 3:0] alu_op = 0;
	output reg        alu_iscmp = 0;
	output reg [ 5:0] ireg_r0, ireg_r1, ireg_rw;
	output reg        ireg_we;
	output reg [31:0] ireg_dw;
	output reg [11:0] lbt_lbidw;
	output reg [ 5:0] lbt_typw;
	output reg [15:0] lbt_basew;
	output reg [15:0] lbt_countw;
	output reg        lbt_we;
	output reg [ 5:0] preg_p0, preg_p1, preg_pw;
	output reg [11:0] preg_lbidw;
	output reg [15:0] preg_ofsw;
	output reg        preg_we;
	//
	wire [5:0]  instr0_operand0	 = instr0[23:18];
	wire [5:0]  instr0_operand1	 = instr0[17:12];
	wire [5:0]  instr0_operand2	 = instr0[11: 6];
	wire [5:0]  instr0_operand3	 = instr0[ 5: 0];
	wire [7:0]  instr0_op		 = instr0[31:24];
	wire [31:0] instr0_imm16_ext = {{16{instr0[15]}},instr0[15: 0]};
	wire [15:0] instr0_imm16     = instr0[15: 0];
	//
	wire [15:0] instr1_base      = instr1[31:16];
	wire [15:0] instr1_count     = instr1[15: 0];

	//
	always begin
		// ALU
		case (current_state)
			`STATE_EXEC: begin
				case (instr0_op)
					`OP_OR, `OP_XOR, `OP_AND, 
						`OP_ADD, `OP_SUB, 
						`OP_SHL, `OP_SAR 
						: begin
						alu_d0 = ireg_d0;
						alu_d1 = ireg_d1;
						alu_iscmp = 0;
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
						alu_op = {1'b0, instr0_op[2:0]};
					end
					`OP_PADD : begin
						alu_d0 = ireg_d0;
						alu_d1 = preg_ofs0;
						alu_iscmp = 0;
						alu_op = `ALU_OP_ADD;
					end
					`OP_PDIF : begin
						alu_d0 = preg_ofs0;
						alu_d1 = preg_ofs1;
						alu_iscmp = 0;
						alu_op = `ALU_OP_SUB;
					end
					`OP_PCMPE, `OP_PCMPNE,
						`OP_PCMPL, `OP_PCMPGE,
						`OP_PCMPLE, `OP_PCMPG : begin
						alu_d0 = preg_ofs0;
						alu_d1 = preg_ofs1;
						alu_iscmp = 1;
						alu_op = {1'b0, instr0_op[2:0]};
					end
					default: begin
						alu_d0 = 0;
						alu_d1 = 0;
						alu_iscmp = 0;
						alu_op = 0;
					end
				endcase
			end
			default: begin
				alu_d0 = 0;
				alu_d1 = 0;
				alu_iscmp = 0;
				alu_op = 0;
			end
		endcase
		// LabelTable write
		case (current_state)
			`STATE_EXEC: begin
				case (instr0_op)
					`OP_LBSET: begin
						lbt_lbidw = instr0_imm16;
						lbt_typw = instr0_operand0;
						lbt_basew = instr1_base;
						lbt_countw = instr1_count;
						lbt_we = 1;
					end
					default: begin
						lbt_lbidw = 0;
						lbt_typw = 0;
						lbt_basew = 0;
						lbt_countw = 0;
						lbt_we = 0;
					end
				endcase
			end
			default: begin
				lbt_lbidw = 0;
				lbt_typw = 0;
				lbt_basew = 0;
				lbt_countw = 0;
				lbt_we = 0;
			end
		endcase
		// PReg R
		case (current_state)
			`STATE_EXEC: begin
				case (instr0_op)
					`OP_PADD: begin
						preg_p0 = instr0_operand2;
						preg_p1 = 0;
					end
					`OP_PDIF,
						`OP_PCMPE, `OP_PCMPNE,
						`OP_PCMPL, `OP_PCMPGE,
						`OP_PCMPLE, `OP_PCMPG
						: begin
						preg_p0 = instr0_operand1;
						preg_p1 = instr0_operand2;
					end
					default: begin
						preg_p0 = 0;
						preg_p1 = 0;
					end
				endcase
			end
			default: begin
				preg_p0 = 0;
				preg_p1 = 0;
			end
		endcase
		// PReg W
		case (current_state)
			`STATE_EXEC: begin
				case (instr0_op)
					`OP_PLIMM: begin
						preg_pw = instr0_operand0;
						preg_lbidw = instr0_imm16;
						preg_ofsw = 0;
						preg_we = 1;
					end
					`OP_PADD: begin
						preg_pw = instr0_operand1;
						preg_lbidw = preg_lbid0;
						preg_ofsw = alu_dout;
						preg_we = 1;
					end
					default: begin
						preg_pw = 0;
						preg_lbidw = 0;
						preg_ofsw = 0;
						preg_we = 0;
					end
				endcase
			end
			default: begin
				preg_pw = 0;
				preg_lbidw = 0;
				preg_ofsw = 0;
				preg_we = 0;
			end
		endcase
		// IReg R
		case (current_state)
			`STATE_EXEC: begin
				case (instr0_op)
					`OP_PADD: begin
						ireg_r0 = instr0_operand0;
						ireg_r1 = 0;
					end
					`OP_CP, `OP_CPDR: begin
						ireg_r0 = instr0_operand1;
						ireg_r1 = 0;
					end
					`OP_OR, `OP_XOR, `OP_AND, 
						`OP_ADD, `OP_SUB, 
						`OP_SHL, `OP_SAR,
						`OP_CMPE, `OP_CMPNE, 
						`OP_CMPL, `OP_CMPGE, 
						`OP_CMPLE, `OP_CMPG,
						`OP_TSTZ, `OP_TSTNZ
						: begin
						ireg_r0 = instr0_operand1;
						ireg_r1 = instr0_operand2;
					end
					default: begin
						ireg_r0 = 0;
						ireg_r1 = 0;
					end
				endcase
			end
			default: begin
				ireg_r0 = 0;
				ireg_r1 = 0;
			end
		endcase
		// IReg W
		case (current_state)
			`STATE_EXEC: begin
				case (instr0_op)
					`OP_LIMM16: begin
						ireg_rw = instr0_operand0;
						ireg_dw = instr0_imm16_ext;
						ireg_we = 1;
					end
					`OP_CP: begin
						ireg_rw = instr0_operand0;
						ireg_dw = ireg_d0;
						ireg_we = 1;
					end
					`OP_OR, `OP_XOR, `OP_AND, 
						`OP_ADD, `OP_SUB, 
						`OP_SHL, `OP_SAR,
						//
						`OP_CMPE, `OP_CMPNE, 
						`OP_CMPL, `OP_CMPGE, 
						`OP_CMPLE, `OP_CMPG,
						`OP_TSTZ, `OP_TSTNZ,
						`OP_PDIF,
						`OP_PCMPE, `OP_PCMPNE,
						`OP_PCMPL, `OP_PCMPGE,
						`OP_PCMPLE, `OP_PCMPG
						: begin
						ireg_rw = instr0_operand0;
						ireg_dw = alu_dout;
						ireg_we = 1;
					end
					`OP_LIMM32: begin
						ireg_rw = instr0_operand0;
						ireg_dw = instr1;
						ireg_we = 1;
					end
					default: begin
						ireg_rw = 0;
						ireg_dw = 0;
						ireg_we = 0;
					end
				endcase
			end
			default: begin
				ireg_rw = 0;
				ireg_dw = 0;
				ireg_we = 0;
			end
		endcase
		#1;	// このwaitは必須（シミュレーションの無限ループを避けるため）
	end
endmodule
