module top(
	clk,
	seg, segsel
);

input clk;
output [7:0] seg;
output [3:0] segsel;

reg [15:0] data = 16'h1246;

LED7Seg led7seg(clk, seg, segsel, data);

/*
initial begin
	data = 16'h1246;
end
*/
endmodule