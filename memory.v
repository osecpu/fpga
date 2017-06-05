module memory(clk, addr, data);
	input clk;
	input [15:0] addr;
	output [3:0] data;

	reg [3:0] rom[15:0];	// 左が要素、右がアドレス

	assign data = rom[addr];

	always @ (posedge clk)
		begin

		end

	initial
		begin
			$readmemh("rom.hex", rom);
		end

endmodule
