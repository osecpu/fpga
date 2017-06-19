`define CLK_BIT 0
//`define CLK_BIT 24	// for debug on hardware

`timescale 1ns / 1ps
// timescale [単位時間] / [丸め精度] 

module OSECPU(clk_org, seg, segsel);
	input clk_org;
	//
	output [7:0] seg;
	output [3:0] segsel;
	//
	reg [5:0] ireg_r0, ireg_r1, ireg_rw;
	wire [31:0] ireg_d0, ireg_d1, ireg_dw;
	reg ireg_we;
	reg [15:0] pc = 0;
	reg [3:0] current_state = 0;
	reg reset;
	wire clk;
	//
	LED7Seg led7seg(clk_org, seg, segsel, pc);
	IntegerRegister ireg(clk_org, ireg_r0, ireg_r1, ireg_rw, ireg_d0, ireg_d1, ireg_dw, ireg_we);

	wire [15:0] mem_addr;
	wire [31:0] mem_data;
	wire [31:0] mem_wdata;
	reg mem_we;
	Memory mem(clk_org, mem_addr, mem_data, mem_wdata, mem_we);
	assign mem_addr = genMemAddr(current_state);

	reg[31:0] instr0;
		wire [5:0] instr0_operand0;
		wire [5:0] instr0_operand1;
		wire [5:0] instr0_operand2;
		wire [5:0] instr0_operand3;
		wire [7:0] instr0_op;
		wire [15:0] instr0_imm16;
		wire [23:0] instr0_imm24;
		//
		assign instr0_operand0 = instr0[23:18];
		assign instr0_operand1 = instr0[17:12];
		assign instr0_operand2 = instr0[11: 6];
		assign instr0_operand3 = instr0[ 5: 0];
		assign instr0_op       = instr0[31:24];
		assign instr0_imm16    = instr0[15: 0]; 
		assign instr0_imm24    = instr0[23: 0]; 
	reg[31:0] instr1;

	initial begin
		reset = 1;
		#20;
		reset = 0;
	end

	reg [`CLK_BIT:0] clk_counter = 0;
	assign clk = clk_counter[`CLK_BIT];

	always @(posedge clk_org) begin
		clk_counter = clk_counter + 1;
	end

	function [3:0] genNextState (input [3:0] currentState);
		case (currentState)
			4'd0: begin
				// fetch
				pc = pc + 1;
				genNextState = 1;
			end
			4'd1: begin
				// decode
				instr0 = mem_data;
				
				genNextState = 0;
			end
		endcase
	endfunction

	function [15:0] genMemAddr (input [3:0] currentState);
		case (currentState)
			4'd0: begin
				genMemAddr = pc;
			end
		endcase
	endfunction

	always @(posedge clk) begin
		if(reset == 1) begin
			pc = 0;
			current_state = 0;
		end
		if(reset == 0) begin
			current_state = genNextState(current_state);
		end
	end
endmodule

module testbench_top(seg, segsel);
	output [7:0] seg;
	output [3:0] segsel;
	//
	reg clk, reset;
	reg [15:0] pc = 0;
	//
	OSECPU top(clk, seg, segsel);

	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, testbench_top);
	end

	always begin
		// gen 50MHz clock
		clk <= 1; #20;
		clk <= 0; #20;
	end

	reg [`CLK_BIT:0] clk_counter = 0;
	always @(posedge clk_counter[`CLK_BIT]) begin
		pc = pc + 1;
	end

	always @(posedge clk) begin
		if(pc == 100) begin
			$display ("Simulation end");
			$finish;
		end
		clk_counter = clk_counter + 1;
	end

endmodule
