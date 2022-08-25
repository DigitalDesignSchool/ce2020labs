`timescale 1 ns / 1 ns

module FIFOTestBench();
parameter RESOLUTION_H = 1280,
		  RESOLUTION_V = 960,
		  V_BOTTOM = 1,
          V_SYNC   = 3,
          V_TOP    = 30,
		  H_FRONT  =  80,
          H_SYNC   =  136,
          H_BACK   =  216,
          X_WIRE_WIDTH = $clog2 (RESOLUTION_H+H_FRONT+H_SYNC+H_BACK),
		  Y_WIRE_WIDTH = $clog2 (RESOLUTION_V+V_BOTTOM+V_SYNC+V_TOP),
		  FIFODEPTH=10;

reg clk,reset_n,push,pop,empty,full;
reg [X_WIRE_WIDTH-1:0] hpos,hpos_read;
reg [Y_WIRE_WIDTH-1:0] vpos,vpos_read;
reg [2:0] RGBin,RGB;

//int hpos_check[10];
//int vpos_check[10];
//int RGB_check[10];

FIFO_top
#(
	.RESOLUTION_H(RESOLUTION_H),
	.RESOLUTION_V(RESOLUTION_V),
	.V_BOTTOM(V_BOTTOM),
    .V_SYNC(V_SYNC),
    .V_TOP(V_TOP),
	.H_FRONT(H_FRONT),
    .H_SYNC(H_SYNC),
    .H_BACK(H_BACK),
	.FIFODEPTH(FIFODEPTH)
)
DUT (
  .clk(clk),
  .rst(~reset_n),
  .push(push),
  .toppop(pop),
  .hpos_write(hpos),
  .vpos_write(vpos),
  .RGB_write(RGBin),
  .hpos_read(hpos_read),
  .vpos_read(vpos_read),
  .RGB_read(RGB),
  .empty(empty),
  .full(full)
);

always #5 clk=~clk;

initial begin
clk=0;
push=0;
pop=0;
hpos=0;
vpos=0;
hpos_read=0;
vpos_read=0;
RGBin=0;
reset_n=0;
#20;
reset_n=1;
#10
push=1;
for(integer i=0; i<10; i++) begin
hpos=$urandom_range(0,1279);
vpos=$urandom_range(0,959);
RGBin=$urandom_range(0,7);
#10;
end
push=0;
#10;
pop=1;
#550;
pop=0;
push=1;
for(integer i=0; i<7; i++) begin
hpos=$urandom_range(0,1279);
vpos=$urandom_range(0,959);
RGBin=$urandom_range(0,7);
#10;
end
push=0;
#10;
pop=1;
#120;
$stop;

end

endmodule