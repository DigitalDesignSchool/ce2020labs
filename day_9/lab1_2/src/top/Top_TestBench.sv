`timescale 1 ns / 1 ns

module Top_FB_TestBench();

reg clk, reset_n;

top DUT (
.clk(clk),
.reset_n(reset_n)
);

always #5 clk=~clk;

initial begin
clk=1;
reset_n=0;
#20;
reset_n=1;

end

endmodule