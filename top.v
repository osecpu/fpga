module top(
	clk,
	seg, segsel
);

input clk;
output [7:0] seg;
output [3:0] segsel;

reg [15:0] pc = 0;

LED7Seg led7seg(clk, seg, segsel, pc);


reg [24:0] clk_counter = 0;
always @(posedge clk) begin
	clk_counter = clk_counter + 1;
end

always @(posedge clk_counter[24]) begin
	pc = pc + 1;
end

endmodule