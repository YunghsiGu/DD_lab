/*==================================*/
`include "lab8.v"
`timescale 1ps / 1ps
`define PAT         "data.dat"
`define End_CYCLE   1000000
`define CYCLE       50.0
`define out         2
`define in          1
`define pattern_set 3
`define set_length  6
`define empty       0
`define positive    1
`define MAX         `pattern_set * `set_length

module lab8tb;

integer fd;
integer charcount;

reg [99:0] line;

reg [2:0] inout_flag;

integer loop_in;
integer loop_gold;


reg clk = 0;
reg reset = 0;

reg [6:0]datx[0:`MAX];
reg [6:0]daty[0:`MAX];

reg [6:0]goldx[0:`MAX];
reg [6:0]goldy[0:`MAX];

reg fail;
reg getdata;
reg [3:0]state;
reg [3:0]loop;
reg [8:0]correct;
reg [3:0]testset;

integer i;

reg [7:0]dataX;
reg [7:0]dataY;
reg give_valid;
wire [7:0]ansX;
wire [7:0]ansY;
wire out_valid;

lab8 xa(.clk(clk), 
        .reset(reset), 
        .give_valid(give_valid),
        .dataX(dataX), 
        .dataY(dataY), 
        .ansX(ansX), 
        .ansY(ansY), 
        .out_valid(out_valid));

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
    //$dumpfile("Lab.fsdb");
    //$dumpvars(0, lab8tb);
    for(i = 0; i < `MAX; i = i+1)
        $dumpvars(1, datx[i], daty[i], goldx[i], goldy[i]);
end

initial begin
    $display("----------------------");
    $display("-- Simulation Start --");
    $display("----------------------");
    @(posedge clk);  #2 reset = 1'b1; 
    #(`CYCLE*2);  
    @(posedge clk);  #2 reset = 1'b0;
end

integer cycle=`empty;
always @(posedge clk) begin
    cycle = cycle + 1;
    if (cycle > `End_CYCLE) begin
        $display("--------------------------------------------------");
        $display("-- Failed waiting valid signal, Simulation STOP --");
        $display("--------------------------------------------------");
        $finish;
    end
end

initial begin
    fd = $fopen(`PAT,"r");
    if (fd == `empty) begin
        $display ("pattern handle null");
        $finish;
    end
    else if (!$feof(fd)) begin
        loop_in = 0;
        loop_gold = 0;
        getdata = `positive;
        charcount = $fgets (line, fd);
        while(charcount > `empty && getdata) begin
            if(line == "end\n")             getdata = `empty;
            else if(line == "input\n")      inout_flag = `in;
            else if(line == "output\n")     inout_flag = `out;
            else if(inout_flag == `in)
            begin
                charcount = $sscanf(line, "%d %d", datx[loop_in], daty[loop_in]);
                // $display("in %d %d %d", datx[loop_in], daty[loop_in], loop_in);
                loop_in = loop_in + 1;
            end
            else if(inout_flag == `out)
            begin
                charcount = $sscanf(line, "%d %d", goldx[loop_gold], goldy[loop_gold]);
                // $display("out %d %d %d", goldx[loop_gold], goldy[loop_gold], loop_gold);
                loop_gold = loop_gold + 1;
            end
            charcount = $fgets (line, fd);
        end
        $fclose(fd);
    end
end

always @(negedge clk ) begin
    if (reset) begin
        fail = 0;
        state = 0;
        reset = 0;
        loop = 0;
        loop_in = 0;
        loop_gold = 0;
        correct = 0;
        testset = 1;
    end 
    else 
    begin
        // $display("state : %d %d %d", state, testset, loop);
        case(state)
            4'd0 : begin
                fail = 0;
                state = 1;
                loop = 0;
            end
            4'd1 : begin
                if(loop >= `set_length)
                begin
                    state = 2;
                    give_valid = 0;
                    loop = 0;
                end
                else
                begin
                    give_valid = `positive;
                    dataX = datx[loop_in];
                    dataY = daty[loop_in];
                    loop = loop + 1;
                    loop_in = loop_in + 1;
                end
            end
            4'd2 : begin
                if(out_valid == `positive)
                begin
                    $display("cycle %d", cycle);
                    if(ansX != goldx[loop_gold] || ansY != goldy[loop_gold])
                    begin
                        $display("Set %d, expect (%d, %d), but get (%d, %d).", testset, goldx[loop_gold], goldy[loop_gold], ansX, ansY);
                        fail = 1;
                    end
                    else if(ansX == goldx[loop_gold] || ansY == goldy[loop_gold])
                    begin
                        $display("Set %d, expect (%d, %d), get (%d, %d) correctly.", testset, goldx[loop_gold], goldy[loop_gold], ansX, ansY);
                        correct = correct + 1;
                    end
                    if(loop == `set_length - 1)
                    begin
                        loop = 0;
                        testset = testset + 1;
                        if (testset <= `pattern_set)
                            state = 0;
                        else
                            state = 3;
                    end
                    loop = loop + 1;
                    loop_gold = loop_gold + 1;
                end
            end
            4'd3 : begin
                $display ("-------------------------------------------------");
                if(fail == 0 && correct == `set_length * `pattern_set)
                    $display("--    Simulation finish,  ALL PASS             --");
                else
                    $display("--    Simulation Failed.                       --");
                $display ("-------------------------------------------------");
                $finish;
            end
        endcase
    end
end

endmodule // End of module

/*==================================*/