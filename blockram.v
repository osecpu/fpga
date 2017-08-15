`timescale 1ns / 1ps

module BlockRAM(clk, addr, wdata, we, data);
	parameter DataWidth = 8;
	parameter AddrWidth = 8;
	parameter InitFileName = "ram.txt";
	//
	input clk;
	input [AddrWidth-1:0] addr;
	input [DataWidth-1:0] wdata;
	input we;
	output [DataWidth-1:0] data;
	//
	reg [AddrWidth-1:0] addr_buf = 0;
	reg [DataWidth-1:0] ram [2**AddrWidth-1:0];
	//
	assign data = ram[addr_buf];
	//
	always@(posedge clk) begin
		addr_buf = addr;
		if(we) begin
			ram[addr_buf] = wdata;
		end
	end
	//
	initial begin
		$readmemh(InitFileName, ram);
	end
endmodule

