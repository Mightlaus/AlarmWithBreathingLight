module AWBled(
    input clk,
    input rst_n,
    input key_in,
    output beep,
    output led
);

reg enable;
wire isPress;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        enable <= 1'b0;
    else begin
        if(isPress)
            enable <= ~enable;
        else
            enable <= enable;
    end
end

alarm i1 (
	.beep(beep),
	.clk(clk),
	.rst_n(rst_n),
    .enable(enable)
);


breath_led i2 (
	.clk(clk),
	.pwm(led),
	.rst_n(rst_n),
    .enable(enable)
);

key_filter i3 (
	.clk(clk),
	.key_in(key_in),
	.rst_n(rst_n),
    .isPress(isPress)
);
endmodule