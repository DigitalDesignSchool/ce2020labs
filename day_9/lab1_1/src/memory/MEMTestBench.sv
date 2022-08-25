`timescale 1 ns / 1 ns

module TestBench();
parameter RAMLENGTH  = 800,
		  DATA_WIDTH=6,
		  ADDR_WIDTH=10,
		  V_BOTTOM = 1,
          V_SYNC   = 3,
          V_TOP    = 30,
		  H_FRONT  =  80,
          H_SYNC   =  136,
          H_BACK   =  216,
		  RESOLUTION_H = 640,
		  RESOLUTION_V = 480,
		  X_WIRE_WIDTH = $clog2 (RESOLUTION_H+H_FRONT+H_SYNC+H_BACK),
		  Y_WIRE_WIDTH = $clog2 (RESOLUTION_V+V_BOTTOM+V_SYNC+V_TOP);

reg display_on, clk, memreset,reset_n,fifoempty;
reg [ADDR_WIDTH-1:0] resetcnt;
reg [X_WIRE_WIDTH-1:0] hpos;
reg [Y_WIRE_WIDTH-1:0] vpos;
reg [2:0] RGBin,RGB;

int hpos_check[10];
int vpos_check[10];
int RGB_check[10];

RGBMemory_top
	 #(
		.RAMLENGTH(RAMLENGTH), //RAMLENGTH*DATAWIDTH = 4800 = 80x60 RAM RESOLUTION
		.DATA_WIDTH(DATA_WIDTH),
		.X_WIRE_WIDTH(X_WIRE_WIDTH),
		.Y_WIRE_WIDTH(Y_WIRE_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.RESOLUTION_H(RESOLUTION_H),
		.RESOLUTION_V(RESOLUTION_V)
	 )
	 FrameBuffer
	 (
		.display_on(display_on),
		.clk(clk),
		.memreset(memreset),
		.reset_n(~reset_n),
		.resetcnt(resetcnt),
		.RGBin(RGBin),
		.hpos(hpos),
		.vpos(vpos),
		.RGB(RGB),
		.fifoempty(fifoempty)
	 );

always #5 clk=~clk;

initial begin
fifoempty=0;
clk=0;
display_on=1;
RGBin=0;
resetcnt=0;
memreset=0;
hpos=0;
vpos=0;
RGB=0;
reset_n=0;
#20;
reset_n=1;
for(integer i=0; i<800; i++) begin
resetcnt<=i;
#10;
end
#15;
memreset=1;
#100
display_on=0;
vpos=0;
for(integer i=0; i<5; i++) begin
hpos=i;
if((i%2)==0) RGBin=3'b111;
else RGBin=3'b000;
#50;
end
#120;
display_on=1;
RGBin=0;
vpos=0;
for(integer i=0;i<31;i++) begin
hpos=i; #10;
end
#120
display_on=0;
vpos=1;
for(integer i=0; i<5; i++) begin
hpos=i;
if((i%2)==0) RGBin=3'b111;
else RGBin=3'b000;
#50;
end
#120
display_on=1;
RGBin=0;
vpos=0;
for(integer i=0;i<31;i++) begin
hpos=i; #10;
end
#120
display_on=0;
vpos=2;
for(integer i=0; i<5; i++) begin
hpos=i;
if((i%2)==0) RGBin=3'b111;
else RGBin=3'b000;
#50;
end
#120
display_on=1;
RGBin=0;
vpos=0;
for(integer i=0;i<31;i++) begin
hpos=i; #10;
end
#120
hpos=0;
vpos=0;



/*#100
display_on=0;
for(integer i=0; i<10; i++)begin
	hpos=$urandom_range(0,79);
	vpos=$urandom_range(0,59);
	RGBin=$urandom_range(0,7);
	hpos_check[i]=hpos;
	vpos_check[i]=vpos;
	RGB_check[i]=RGBin;
	#50;
end
#10
display_on=1;
for(integer i=0; i<10; i++)begin
hpos=hpos_check[i]*8;
vpos=vpos_check[i]*8;
#10;
if(RGB!=RGB_check[i]) $display("Wrong data on the coordinates hpos=%d, vpos=%d. Supposed to be %d ",hpos,vpos, RGB_check[i]);
end
#10*/
$stop;

end

endmodule