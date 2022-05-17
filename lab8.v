/**
 *
 * @author : 409410037, 409410100
 * @latest changed : 2022/5/8 12:34
 */

`define length 6

module lab8(input clk,
            input reset,
            input give_valid,
            input [7:0]dataX,
            input [7:0]dataY,
            output reg [7:0]ansX,
            output reg [7:0]ansY,
            output reg out_valid);

integer i;
reg [7:0]inX[0:`length-1];
reg [7:0]inY[0:`length-1];
reg signed [7:0]tempX[0:`length-1];
reg signed [7:0]tempY[0:`length-1];

reg [7:0]ix = 8'b0;

initial begin
    $dumpfile("Lab.vcd");
    $dumpvars(0, lab8tb);
    for (i = 0; i < `length; i = i + 1)
        $dumpvars(1, inX[i], inY[i], tempX[i], tempY[i], count[i]);
end

// 輸入六個點
always@(posedge clk or negedge reset) begin
    if (!reset) begin
        for (i = 0; i < `length; i = i + 1) begin
            inX[i] <= 0;
            inY[i] <= 0;
        end
    end else if (give_valid) begin
        inX[ix] <= dataX;
        inY[ix] <= dataY;
        ix <= ix + 1;
    end
end

// 建立向量
always@(posedge clk or negedge reset) begin
    if (!reset) begin
        // 等待輸入?
    end else if (ix == 0) begin
        ix <= ix + 1;
    end
    else if (give_valid) begin
        tempX[ix] <= inX[ix] - inX[0];  //好像不行這樣?因為上面的always有用到inX[ix]跟inY[ix]
        tempX[ix] <= inY[ix] - inY[0];
        ix <= ix + 1;
    end
end

always@(posedge clk or negedge reset) begin
    if (!reset) begin
        out_valid <= 0;
    end
end

endmodule

/*==================================*/