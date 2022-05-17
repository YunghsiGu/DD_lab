/**
 *
 * @author : 409410037, 409410100
 * @latest change : 2022/5/8 12:34
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
reg [7:0]inX[0:`length-1];          // store input
reg [7:0]inY[0:`length-1];
reg [7:0]negcount[0:`length-1];     //大概是逆時針方向的接收器?
reg signed [7:0]tempX[0:`length-1]; // store output
reg signed [7:0]tempY[0:`length-1];

reg [3:0]count[0:`length - 1];

reg [3:0]state;
reg [7:0]ix;
reg [7:0]jx;
reg [7:0]kx;

initial begin
    $dumpfile("Lab.vcd");
    $dumpvars(0, lab8tb);
    for (i = 0; i < `length; i = i + 1)
        $dumpvars(1, inX[i], inY[i], tempX[i], tempY[i], count[i]);
end

always@(posedge clk or posedge reset) begin
    /*系統 reset 時，圍籬系統應將 out_valid 設為 low*/
    if (reset) begin    // 初始化
        state <= 1;
        for (i = 0; i < `length; i = i + 1) begin
            inX[i] <= 0;
            inY[i] <= 0;
            tempX[i] <= 0;
            tempY[i] <= 0;
            count[i] <= i;
            negcount[i] <= 0;
        end
        ix <= 0;    //紀錄輸第幾筆資料
        jx <= 0;
        kx <= 0;
    end else begin
        case (state)
            4'd0:begin      // initial state
                state <= 1;
                for (i = 0; i < `length; i = i + 1) begin
                    inX[i] <= 0;
                    inY[i] <= 0;
                    tempX[i] <= 0;
                    tempY[i] <= 0;
                    count[i] <= i;
                    negcount[i] <= 0;
                end
                ix <= 0;
                jx <= 0;
                kx <= 0;
            end
            4'd1:begin      // receive input state
                if (ix == `length)      //已經輸6筆座標
                    state <= 2;
                else if (give_valid) begin
                    inX[ix] <= dataX;
                    inY[ix] <= dataY;
                    ix <= ix + 1;
                end
            end
            4'd2:begin      // calculate vector from inputs
                state <= 3;
                tempX[5] <= inX[5] - inX[0];
                tempY[5] <= inY[5] - inY[0];
                tempX[4] <= inX[4] - inX[0];
                tempY[4] <= inY[4] - inY[0];
                tempX[3] <= inX[3] - inX[0];
                tempY[3] <= inY[3] - inY[0];
                tempX[2] <= inX[2] - inX[0];
                tempY[2] <= inY[2] - inY[0];
                tempX[1] <= inX[1] - inX[0];
                tempY[1] <= inY[1] - inY[0];
                tempX[0] <= inX[0] - inX[0];
                tempY[0] <= inY[0] - inY[0];
            end
            4'd3:begin      // compare each vector
                if (jx == `length-1) begin      
                    if(kx == `length-1) state <= 4;
                    else                kx <= kx+1;
                    jx <= 0;
                end else
                    jx <= jx+1;

                if ((tempX[kx] * tempY[jx] - tempX[jx] * tempY[kx]) < 0)//表示jx位於kx的順時針方向---jx/kx
                    negcount[kx] <= negcount[kx] + 1;                   //
            end
            4'd4:begin      // sort the position of vectors(bubble sort)
                

            end
            /*每次輸出結果後，將 out_valid 再復歸為 low*/
            4'd5:begin      // output answer and back to initial state
            //只有先寫back to initial state
                state <= 1;
                for (i = 0; i < `length; i = i + 1)
                begin
                    inX[i] <= 0;
                    inY[i] <= 0;
                    tempX[i] <= 0;
                    tempY[i] <= 0;
                    count[i] <= i;
                    negcount[i] <= 0;
                end
                ix <= 0;
                jx <= 0;
                kx <= 0;


            end
            default://不知該放甚麼??
        endcase
    end
end

endmodule

/*==================================*/