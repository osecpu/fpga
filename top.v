`define CLK_BIT 0
//`define CLK_BIT 24	// for debug on hardware

`timescale 1ns / 1ps
// timescale [単位時間] / [丸め精度] 

module top(clk_org, seg, segsel);
	input clk_org;
	output [7:0] seg;
	output [3:0] segsel;
	//
	wire [31:0] osecpu_dr;
	wire [15:0] osecpu_pc;
	reg reset;
	reg [`CLK_BIT:0] clk_counter = 0;
	assign clk = clk_counter[`CLK_BIT];

	LED7Seg led7seg(clk_org, seg, segsel, {osecpu_dr[7:0], osecpu_pc[7:0]});
	OSECPU osecpu(clk_cpu, reset, osecpu_dr, osecpu_pc);

	initial begin
		reset = 1;
		#20;
		reset = 0;
	end
	always @(posedge clk_org) begin
		clk_counter = clk_counter + 1'b1;
	end
endmodule

module OSECPU(clk, reset, _dr, _pc);
	input clk;
	input reset;
	output [31:0] _dr;
	output [15:0] _pc;
	//
	wire [5:0] ireg_rw, ireg_r0, ireg_r1;
	wire [31:0] ireg_d0, ireg_d1, ireg_dw;
	wire ireg_we;
	reg	[15:0] pc = 0;
	assign _pc = pc;
	wire	[15:0] pc_next;
	reg	[3:0] current_state = 0;
	wire	[3:0]	next_state;
	assign pc_next = (next_state == 0 ? pc + 1'b1 : pc) ;
	//
	reg [31:0] DR = 0;
	assign _dr = DR;
	//
	reg [7:0] CR = 0;
	//
	wire [15:0] mem_addr;
	wire [31:0] mem_data;
	wire [31:0] mem_wdata;
	reg mem_we;
	assign mem_addr = genMemAddr(current_state);
	//
	wire [31:0] alu_d0, alu_d1, alu_dout;
	wire [3:0] alu_op;
	//
	ALUController alu(alu_d0, alu_d1, alu_dout, alu_op);
	IntegerRegister ireg(clk, ireg_r0, ireg_r1, ireg_rw, ireg_d0, ireg_d1, ireg_dw, ireg_we);
	Memory mem(clk, mem_addr, mem_data, mem_wdata, mem_we);
	
	reg[31:0] instr0 = 0;
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
	//reg[31:0] instr1;
	
	//
	
	always @(posedge clk) begin
		if(instr0_op == 8'hD3) begin
			// CPDR
			case (current_state) 
				4'd1: begin
					DR = ireg_d0;
				end
			endcase
		end
		if(instr0_op == 8'hF0) begin
			// END
			case (current_state) 
				4'd1: begin
					CR = 8'h01;
				end
			endcase
		end
	end
	
	assign ireg_we = genIRegWE(current_state, instr0_op);
	function genIRegWE(input [3:0] currentState, input [7:0] opcode);
		case (currentState)
			4'd1: begin
				case (opcode)
					8'h02:	genIRegWE = 1;	// LIMM16
					8'hd2:	genIRegWE = 1; // CP
					8'h14:	genIRegWE = 1; // ADD
					8'h15:	genIRegWE = 1; // SUB
					default:	genIRegWE = 0;
				endcase
			end
			default: begin
				genIRegWE = 0;
			end
		endcase
	endfunction
	
	assign ireg_rw = genIRegRW(instr0_op, current_state, instr0_operand0);
	function [5:0] genIRegRW (input [7:0] opcode, input [3:0] currentState, input [5:0]ope0);
		case (currentState)
			4'd1: begin
				case (opcode)
					8'h02:	genIRegRW = instr0_operand0;	// LIMM16
					8'hd2:	genIRegRW = instr0_operand0;	// CP
					8'h14:	genIRegRW = instr0_operand0; // ADD
					8'h15:	genIRegRW = instr0_operand0; // SUB
					default:	genIRegRW = 0;
				endcase
			end
			default: begin
				genIRegRW = 0;
			end
		endcase
	endfunction
		
	assign ireg_dw = genIRegDW(instr0_op, current_state, instr0_imm16_ext, ireg_d0, alu_dout);
	function [31:0] genIRegDW (
		input [7:0] opcode,
		input [3:0] currentState,
		input [31:0] imm16_ext,
		input [31:0] r0data,
		input [31:0] alu_dout
	);
		case (currentState)
			4'd1: begin
				case (opcode)
					8'h02:	genIRegDW = imm16_ext;	// LIMM16
					8'hd2:	genIRegDW = r0data;	// CP
					8'h14:	genIRegDW = alu_dout;	// ADD
					8'h15:	genIRegDW = alu_dout;	// SUB
					default:	genIRegDW = 0;
				endcase
			end
			default: begin
				genIRegDW = 0;
			end
		endcase
	endfunction
	
	assign ireg_r0 = genIReg_R0(instr0_op, current_state, instr0_operand1);
	function [5:0] genIReg_R0 (
		input [7:0] opcode,
		input [3:0] currentState,
		input [5:0] ope1);
		case (currentState)
			4'd1: begin
				case (opcode)
					8'hd2:	genIReg_R0 = ope1;	// CP
					8'h14:	genIReg_R0 = ope1;	// ADD
					8'h15:	genIReg_R0 = ope1;	// SUB
					8'hd3:	genIReg_R0 = ope1;	// CPDR
					default:	genIReg_R0 = 0;
				endcase
			end
			default: begin
				genIReg_R0 = 0;
			end
		endcase
	endfunction
	
	assign ireg_r1 = genIReg_R1(instr0_op, current_state, instr0_operand2);
	function [5:0] genIReg_R1 (
		input [7:0] opcode,
		input [3:0] currentState,
		input [5:0] ope2);
		case (currentState)
			4'd1: begin
				case (opcode)
					8'h14:	genIReg_R1 = ope2;	// ADD
					8'h15:	genIReg_R1 = ope2;	// SUB
					default:	genIReg_R1 = 0;
				endcase
			end
			default: begin
				genIReg_R1 = 0;
			end
		endcase
	endfunction
	
	assign alu_d0 = genALU_d0(instr0_op, current_state, ireg_d0);
	function [31:0] genALU_d0 (
		input [7:0] opcode,
		input [3:0] currentState, 
		input [31:0] r0d);
		case (currentState)
			4'd1: begin
				case (opcode)
					8'h14:	genALU_d0 = r0d;	// ADD
					8'h15:	genALU_d0 = r0d;	// SUB
					default:	genALU_d0 = 0;
				endcase
			end
			default: begin
				genALU_d0 = 0;
			end
		endcase
	endfunction
	
	assign alu_d1 = genALU_d1(instr0_op, current_state, ireg_d1);
	function [31:0] genALU_d1 (
		input [7:0] opcode,
		input [3:0] currentState, 
		input [31:0] r1d);
		case (currentState)
			4'd1: begin
				case (opcode)
					8'h14:	genALU_d1 = r1d;	// ADD
					8'h15:	genALU_d1 = r1d;	// SUB
					default:	genALU_d1 = 0;
				endcase
			end
			default: begin
				genALU_d1 = 0;
			end
		endcase
	endfunction
	
	assign alu_op = genALU_op(instr0_op, current_state);
	function [3:0] genALU_op (
		input [7:0] opcode,
		input [3:0] currentState);
		case (currentState)
			4'd1: begin
				case (opcode)
					8'h14:	genALU_op = 4'h4;	// ADD
					8'h15:	genALU_op = 4'h5;	// SUB
					default:	genALU_op = 0;
				endcase
			end
			default: begin
				genALU_op = 0;
			end
		endcase
	endfunction

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
				instr0 = mem_data;
			end
			current_state <= next_state;
			pc = pc_next;
		end
	end
	
	
endmodule

module testbench_top(seg, segsel);
	output [7:0] seg;
	output [3:0] segsel;
	//
	reg clk, reset;
	wire [31:0] osecpu_dr;
	wire [15:0] osecpu_pc;
	//
	OSECPU osecpu(clk, reset, osecpu_dr, osecpu_pc);

	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, testbench_top);
		//
		reset <= 1;
		#20;
		reset <= 0;
	end

	always begin
		// gen 50MHz clock
		clk <= 1; #20;
		clk <= 0; #20;
	end

	always @(posedge clk) begin
		if(osecpu_pc == 6) begin
			if(osecpu_dr == -4)
				$display ("Simulation PASS");
			else begin 
				$display ("Simulation **** FAILED ****");
			end
			$finish;
		end
	end
endmodule


