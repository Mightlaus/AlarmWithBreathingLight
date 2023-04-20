module alarm (
    input clk,
    input rst_n,
    output reg beep
);
    reg [27:0] tone;
    reg [6:0] ramp;
    wire [14:0] clkdriver;
    reg [14:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            tone <= 28'b0;
        else begin
            if(tone == 28'h FFFFFFF)
                tone <= 28'b0;
            else
                tone <= tone + 28'd1; 
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            ramp <= 7'b0;
        else begin
            if(tone[26] == 1)
                ramp <= tone[25:19];
            else   
                ramp <= ~tone[25:19];
        end
    end

    assign clkdriver = {2'b01,ramp,6'b000000};   

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 15'b0;
        else begin
            if(cnt == clkdriver)
                cnt <= 15'b0;
            else
                cnt <= cnt + 15'd1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            beep <= 1'b0;
        else begin
            if(cnt <= (clkdriver >>> 1))
                beep <= 1'b1;
            else
                beep <= 1'b0;
        end
    end
endmodule