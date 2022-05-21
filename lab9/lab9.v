/**
 *
 * @author : 409410037 古詠熙, 409410100 徐佳琪
 * @latest changed : 2022/5/21 18:35
 */

module lab9(input clk,
            input reset,
            input give_valid,
            input [13:0]Intake,         // 場地可容納的人數（3 ~ 9972）
            output reg [13:0]UpPrime,   // 大於場地可容納人數的最小質數（2 ~ 9973）
            output reg [13:0]LowPrime,  // 小於場地可容納人數的最大質數（2 ~ 9973）
            output out_valid
            );

initial begin
	$dumpfile("Lab.vcd");
	$dumpvars(0, lab9tb);
end

reg [1:0]build;     // 建表了沒
reg [4:0]state;     // 用在 case
reg [7:0]i, j;
reg [7:0]count;     // list 裡面有幾個質數
reg [13:0]num;      // 接收 Intake
reg [13:0]up, low;  // 大於的跟小於的
reg [7:0]list[0:25];    // 100 內的質數

// 大於的做完了 (0:還沒, 1:做完)
reg updone; 

// 小於的做完了 (0:還沒, 1:做完)
reg lowdone; 

assign out_valid = lowdone & updone;    // up 跟 low 都做完了

// 1. initial 
// 2. N+1 or N-1
// 3. check 0 ~ N root
// 4. back to 2. or done

always@(posedge clk or posedge reset) begin
	if (reset) begin
		UpPrime <= 0;
		LowPrime <= 0;
		lowdone <= 0;
		updone <= 0;
		state <= 0;
		count <= 0;
		i <= 2;
		j <= 0;
		build <= 0;
		list[0] <= 10;
	end else begin
		case (state)
			4'd0:begin  // 1. initial 
				UpPrime <= 0;
				LowPrime <= 0;
				updone <= 0;
				lowdone <= 0;
				if (give_valid) begin
					num <= Intake;
					up <= Intake + 1;
					low <= Intake - 1;
					if (build) begin
						state <= 2;
						i <= 0;
						j <= 0;
					end else begin
						state <= 1;
					end
				end
			end
			4'd1:begin  // build the list
				if (list[j] * list[j] > i) begin
					list[count] <= i;
					count <= count + 1;
					i <= i + 1;
					j <= 0;                  
					if (count == 24) begin   // 找到所有質數
						state <= 2;
						i <= 0;
						build <= 1;
					end
				end else if (i % list[j] == 0) begin
					i <= i + 1;
					j <= 0;
				end else
					j <= j + 1;
			end
			4'd2:begin  // 3. check 0 ~ N root
				// 大於的
				if (!updone) begin 
					if (list[i] * list[i] > up) begin
						updone <= 1;  						  
						if (lowdone) begin  // 4. back to 2. or done
							state <= 0;
							i <= 0;
							j <= 0;
							LowPrime <= low;
							UpPrime <= up;
						end                 
					end else if (up % list[i] == 0) begin
						up <= up + 1;   // 2. N+1
						i <= 0;
					end else begin
						i <= i + 1;
					end
				end
				// 小於的
				if (!lowdone) begin
					if (list[j] * list[j] > low) begin
						lowdone <= 1;   						  
						if (updone) begin  // 4. back to 2. or done
							state <= 0;
							i <= 0;
							j <= 0;
							LowPrime <= low;
							UpPrime <= up;
						end
					end else if (low % list[j] == 0) begin
						low <= low - 1; // 2. N-1
						j <= 0;
					end else begin
						j <= j + 1;
					end
				end
			end
		endcase
	end
end

endmodule

/*==================================*/
