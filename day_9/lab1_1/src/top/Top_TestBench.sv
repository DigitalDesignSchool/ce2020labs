`timescale 1 ns / 1 ns

module Top_FB_TestBench();

reg clk, reset_n;
reg [3:0] key_sw;

top DUT (
.clk(clk),
.reset_n(reset_n),
.key_sw(key_sw)
);

always #5 clk=~clk;

initial begin
clk=1;
reset_n=0;
key_sw=0;
#20;
reset_n=1;

end

endmodule