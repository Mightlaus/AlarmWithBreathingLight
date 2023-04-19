module breath_led (
    input clk,
    input rst_n,
    output pwm
);
    reg [5:0] cnt_1; // base
    reg [9:0] cnt_2; // us
    reg [9:0] cnt_3; // ms
    reg  cnt_4; // s
    reg flag;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_1 <= 6'b0;
        else begin
            if(cnt_1 == 49)        
                cnt_1 <= 6'b0;
            else
                cnt_1 <= cnt_1 + 1;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
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

    always @(posedge clk or negedge rst_n) begin
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

    always @(posedge clk or negedge rst_n) begin
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

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            flag <= 1;
        else begin
            if(cnt_4 == 1)
                flag <= ~flag;
        end
    end

    assign pwm = (flag)? ((cnt_2 < cnt_3)? 1'b1 : 1'b0):((cnt_2 < cnt_3)? 1'b0 : 1'b1);

endmodule