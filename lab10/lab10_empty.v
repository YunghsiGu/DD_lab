/**
 *
 * @author : 409412345, 409412346
 * @latest changed : 2022/5/8 12:34
 */

module lab10(input clk,
			input reset,
			input [3:0]code_pos,
			input [2:0]code_len,
			input [7:0]chardata,
			output reg finish,
			output reg [7:0]char_nxt);

initial begin
    $dumpfile("Lab.vcd");
    $dumpvars(0, lab10tb);
end

reg [2:0]state;

always@(posedge clk or posedge reset) // spin window
begin
	if(reset)
	begin	
		
	end
	else
	begin
		
	end
end

always@(posedge clk or posedge reset) // output & state control
begin
	if(reset)
	begin
	  
	end
	else
	begin
	
	end
end

endmodule