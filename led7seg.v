module led7seg(btn, seg, d);
		input [3:0] btn;
		output [7:0] seg;
		output [3:0] d;
		
		assign d = btn;
		reg [7:0] segd;

		assign seg = segd;
		
		
		
		
		always begin
			//seg = segd;
		end
		
endmodule