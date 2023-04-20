module AWBled(
    input clk,
    input rst_n,
    output beep,
    output led
);

    
alarm i1 (
	.beep(beep),
	.clk(clk),
	.rst_n(rst_n)
);


breath_led i2 (
	.clk(clk),
	.pwm(led),
	.rst_n(rst_n)
);
endmodule