module div_clk(clk, rst, clk_1hz);
	input rst;
	input clk;
	output reg clk_1hz;
	integer counter;

	always @(posedge clk or negedge rst) begin
		if (!rst)
			clk_1hz <= 0;
		else if (counter >= 25000000)
			clk_1hz <= ~clk_1hz;
	end

	always @(posedge clk or negedge rst) begin
		if (!rst)
			counter <= 0;
		else if (counter >= 25000000)
			counter <= 0;
		else
			counter <= counter + 1;
	end
	
endmodule
