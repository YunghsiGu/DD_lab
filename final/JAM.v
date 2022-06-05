/**
 *
 * @author : 409410037 古詠熙 409410100 徐佳琪
 * @latest changed : 2022/6/5 21:30
 */

module JAM (
input CLK,
input RST,
output reg [2:0] W, // 指定取得第 W 位工人成本資料, 0 ≤ W ≤ 7
output reg [2:0] J, // 指定取得第 J 項成本資料, 0 ≤ J ≤ 7
input [6:0] Cost,   // 成本數值
output reg [3:0] MatchCount,    // 輸出符合最小成本的可能組合的數量
output reg [9:0] MinCost,       // 輸出最小總工作成本的數值
output reg Valid);

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
reg [2:0]num[0:7];      // 字典序演算法; initial: [7]=0, [6]=1, [5]=2, [4]=3, [3]=4, [2]=5, [1]=6, [0]=7
reg [6:0]worker[0:63];  // Cost
reg [10:0]result;       // 工作成本
reg [10:0]min_cost;
reg [3:0]match_count;
reg [16:0]calculate_time;   // 計算工作成本的次數

always @(negedge CLK or posedge RST) begin
    if (RST) begin
        state <= 0;
        W <= 0;
        J <= 0;
        replace <= 0;
        min_cost <= 0;
        match_count <= 1;
        calculate_time <= 0;
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
            5'd2:begin  // 找到比替換數大的最小數字
                if (num[0] > num[replace]) begin
                    num[0] <= num[replace];         // swap
                    num[replace] <= num[0];
                    state <= 3;
                end else if (num[1] > num[replace] | replace == 2) begin
                    num[1] <= num[replace];
                    num[replace] <= num[1];
                    state <= 3;
                end else if (num[2] > num[replace] | replace == 3) begin
                    num[2] <= num[replace];
                    num[replace] <= num[2];
                    state <= 3;
                end else if (num[3] > num[replace] | replace == 4) begin
                    num[3] <= num[replace];
                    num[replace] <= num[3];
                    state <= 3;
                end else if (num[4] > num[replace] | replace == 5) begin
                    num[4] <= num[replace];
                    num[replace] <= num[4];
                    state <= 3;
                end else if (num[5] > num[replace] | replace == 6) begin
                    num[5] <= num[replace];
                    num[replace] <= num[5];
                    state <= 3;
                end else if (num[6] > num[replace] | replace == 7) begin
                    num[6] <= num[replace];
                    num[replace] <= num[6];
                    state <= 3;
                end else begin                      // can't find
                    state <= 4; 
                end 
            end
            5'd3:begin  // flip
                state <= 4;
                num[0] <= num[replace - 1];
                num[replace - 1] <= num[0];
                if ((replace - 2) - 1 > 1) begin
                    num[1] <= num[replace - 2];
                    num[replace - 2] <= num[1];
                    if (replace == 7) begin
                        num[2] <= num[4];
                        num[4] <= num[2];                  
                    end
                end
            end
            5'd4:begin  // calculate
                state <= 5;
                calculate_time <= calculate_time + 1;
                result <= (worker[num[7]] + worker[8 + num[6]] + worker[16 + num[5]] + 
                worker[24 + num[4]] + worker[32 + num[3]] + worker[40 + num[2]] +
                worker[48 + num[1]] + worker[56 + num[0]]);
            end
            5'd5:begin
                if (result < min_cost || calculate_time == 1) begin
                    min_cost <= result;
                    match_count <= 1;
                end else if (result == min_cost) begin
                    match_count <= match_count + 1;
                end
                if (calculate_time == 40320) begin
                    MinCost <= min_cost;
                    MatchCount <= match_count;
                    Valid <= 1;
                end else begin
                    state <= 1;
                end
            end
        endcase
    end
end

endmodule