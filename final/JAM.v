module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );

initial begin
    $dumpfile("JAM.vcd");
    $dumpvars(0, testfixture);
    for(i = 0; i < 8; i = i+1)
        $dumpvars(1, num[i]);
end

reg [5:0]state;
reg [2:0]num[0:7];
always @(posedge CLK or posedge RST) 
begin
    if(RST)
    begin
        state <= 0;
    end
    else 
    begin

    end
end

endmodule


