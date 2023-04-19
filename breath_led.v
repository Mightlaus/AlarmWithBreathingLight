module breath_led (
    input clk, // 时钟脉冲周期为20ns
    input rst_n,
    output pwm
);
    reg [5:0] cnt_1; // base
    reg [9:0] cnt_2; // us
    reg [9:0] cnt_3; // ms
    reg  cnt_4; // s
    reg flag;

    always @(posedge clk or negedge rst_n) begin // 每50下脉冲为1us，每过1us  cnt_1清零
        if(!rst_n)                              // 该always块仅负责cnt_1的循环从0~49
            cnt_1 <= 6'b0;
        else begin
            if(cnt_1 == 49)        
                cnt_1 <= 6'b0;
            else
                cnt_1 <= cnt_1 + 1;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin // cnt_1为49时，cnt_2加一，为us计数器
        if(!rst_n)
            cnt_2 <= 10'b0;
        else begin
            if(cnt_2 == 999)        
                cnt_2 <= 10'b0;
            else begin
                if (cnt_1 == 49) begin
                    cnt_2 <= cnt_2 + 1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin // cnt_2为999时，cnt_3加一，为ms计数器
        if(!rst_n)
            cnt_3 <= 10'b0;
        else begin
            if(cnt_3 == 999)        
                cnt_3 <= 10'b0;
            else begin
                if (cnt_2 == 999) begin
                    cnt_3 <= cnt_3 + 1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin // cnt_3为999时，cnt_4加一，为s计数器
        if(!rst_n)
            cnt_4 <= 1'b0;
        else begin
            if(cnt_4 == 1)        
                cnt_4 <= 1'b0;
            else begin
                if (cnt_3 == 999) begin
                    cnt_4 <= cnt_4 + 1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin // 每秒进行一次翻转，以实现占空比从小到大再从大到小
        if(!rst_n)
            flag <= 1;
        else begin
            if(cnt_4 == 1)
                flag <= ~flag;
        end
    end

    assign pwm = (flag)? ((cnt_2 < cnt_3)? 1'b1 : 1'b0):((cnt_2 < cnt_3)? 1'b0 : 1'b1);

endmodule