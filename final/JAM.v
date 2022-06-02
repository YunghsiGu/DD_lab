module JAM (
input CLK,
input RST,
output reg [2:0] W, // 指定取得第 W 位工人成本資料, 0 ≤ W ≤ 7
output reg [2:0] J, // 指定取得第 J 項成本資料, 0 ≤ J ≤ 7
input [6:0] Cost,   // 成本數值
output reg [3:0] MatchCount,    // 輸出符合最小成本的可能組合的數量
output reg [9:0] MinCost,       // 輸出最小總工作成本的數值
output reg Valid
);

initial begin
    $dumpfile("JAM.vcd");
    $dumpvars(0, testfixture);
    for (i = 0; i < 8; i = i + 1)
        $dumpvars(1, num[i]);
end

reg [5:0]state;
reg [2:0]num[0:7];

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 0;
    end else begin

    end
end

endmodule


