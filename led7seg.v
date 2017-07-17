`timescale 1ns / 1ps

module LED7Seg(clk, seg, segsel, data);
		// seg bits and led segment:
		//  77
		// 2  6
		//  11
		// 3  5
		//  44  0
		output [7:0] seg;
		output [3:0] segsel;
		input clk;
		input [15:0] data;
		
		reg [18:0] counter;

		wire [3:0] v0, v1, v2, v3;
		assign v0 = data[3:0];
		assign v1 = data[7:4];
		assign v2 = data[11:8];
		assign v3 = data[15:12];
		
		wire [1:0] dsel = counter[18:17];
		assign segsel = ~(1 << dsel);
		assign seg = decodev(dsel, v0, v1, v2, v3);
		
		always @ (posedge clk) begin
			counter = counter + 1;
		end
		
		function [7:0] decodev (
			input [1:0] vsel,
			input [4:0] v0,
			input [4:0] v1,
			input [4:0] v2,
			input [4:0] v3);
			case (vsel)
				2'b00: decodev = decode(v0);
				2'b01: decodev = decode(v1);
				2'b10: decodev = decode(v2);
				2'b11: decodev = decode(v3);
			endcase
		endfunction
		
		function [7:0] decode (input [3:0] n);
			case (n)
				4'h0: decode = 8'b00000011;
				4'h1: decode = 8'b10011111;
				4'h2: decode = 8'b00100101;
				4'h3: decode = 8'b00001101;
				4'h4: decode = 8'b10011001;
				4'h5: decode = 8'b01001001;
				4'h6: decode = 8'b01000001;
				4'h7: decode = 8'b00011111;
				4'h8: decode = 8'b00000001;
				4'h9: decode = 8'b00001001;
				4'hA: decode = 8'b00010001;
				4'hb: decode = 8'b11000001;
				4'hC: decode = 8'b01100011;
				4'hd: decode = 8'b10000101;
				4'hE: decode = 8'b01100001;
				4'hF: decode = 8'b01110001;
			endcase
		endfunction
		
endmodule
