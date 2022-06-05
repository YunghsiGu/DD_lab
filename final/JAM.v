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

integer i, j;

initial begin
    $dumpfile("JAM.vcd");
    $dumpvars(0, testfixture);
    for (i = 0; i < 8; i = i + 1)
        $dumpvars(1, num[i]);
    for (j = 0; j < 64; j = j + 1)
        $dumpvars(1, worker[j]);
end

reg [5:0]state;
reg [2:0]replace;       // 替換點
reg [2:0]num[0:7];      // 字典序演算法; initial: 0, 1, 2, 3, 4, 5, 6, 7
reg [6:0]worker[0:63];  // Cost

always @(negedge CLK or negedge RST) begin
    if (RST) begin
        state <= 0;
        W <= 0;
        J <= 0;
        replace <= 0;
        num[0] <= 7;
        num[1] <= 6;
        num[2] <= 5;
        num[3] <= 4;
        num[4] <= 3;
        num[5] <= 2;
        num[6] <= 1;
        num[7] <= 0;
    end else begin
        case (state)
            5'd0:begin  // input
                if (W <= 7) begin
                    worker[W * 8 + J] <= Cost;
                    if (J < 7) begin
                        J <= J + 1;
                    end else begin
                        if (W == 7) begin
                            state <= 1;
                        end else begin
                            W <= W + 1;
                            J <= 0;
                        end
                    end
                end
            end 
            5'd1:begin  // algorithm
                if (num[0] > num[1]) begin
                    state <= 4;
                    num[0] <= num[1];
                    num[1] <= num[0];
                end else if (num[1] > num[2]) begin
                    state <= 2;
                    replace <= 2;
                end else if (num[2] > num[3]) begin
                    state <= 2;
                    replace <= 3;
                end else if (num[3] > num[4]) begin
                    state <= 2;
                    replace <= 4;
                end else if (num[4] > num[5]) begin
                    state <= 2;
                    replace <= 5;
                end else if (num[5] > num[6]) begin
                    state <= 2;
                    replace <= 6;
                end else if (num[6] > num[7]) begin
                    state <= 2;
                    replace <= 7;
                end else begin
                    state <= 4;
                end
            end
        endcase
    end
end

endmodule


