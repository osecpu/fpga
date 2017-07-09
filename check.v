module check();
	reg signed [15:0] a,b,c;
	initial begin
		b = 16'hffdd;
		c = 16'h02;
		a = b >>> c;
		$display("%x", a);
		$finish;
	end
endmodule
