`timescale 1 ns / 1 ns

module MEM_BRUSH_TestBench();
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
		  DEBOUNCE_TIMER = 4,
		  BRUSH_SLOWNESS = 16,
		  X_WIRE_WIDTH = $clog2 (RESOLUTION_H+H_FRONT+H_SYNC+H_BACK),
		  Y_WIRE_WIDTH = $clog2 (RESOLUTION_V+V_BOTTOM+V_SYNC+V_TOP);

reg clk, reset_n, hsync, vsync;
reg [3:0] key_sw;
reg [2:0] rgb;

int hpos_check[10];
int vpos_check[10];
int RGB_check[10];

	 wire [3:0] BTN,BTN_POSEDGE,BTN_NEGEDGE;
	 wire enable,pllclk,fifoempty,fifofull,display_on,fifopush,fifopop;;
	 // webuf - write enable for framebuffer and decoder;
	 //rinwire - r component of rgb pixel, which supposed to be written to memory
	
	 wire [2:0] RGBfifo,FB_RGB,brush_RGB;//ROM_RGB;
	
	 wire [X_WIRE_WIDTH - 1:0] hpos,hpos_to_fb,hposfifo,brush_hpos;//ROM_hpos;

	 wire [Y_WIRE_WIDTH - 1:0] vpos,vpos_to_fb,vposfifo,brush_vpos;//ROM_vpos;

	 wire [DATA_WIDTH-1:0] datainbuf_R,datainbuf_G,datainbuf_B,dataoutbuf_R, dataoutbuf_G, dataoutbuf_B;

	 wire [ADDR_WIDTH:0]resetcnt;
	
	vga
    # (
        .HPOS_WIDTH ( X_WIRE_WIDTH    ),
        .VPOS_WIDTH ( Y_WIRE_WIDTH    ),
        
		.H_DISPLAY( RESOLUTION_H ),
        .H_FRONT  (	H_FRONT		 ),
        .H_SYNC   (	H_SYNC		 ),
        .H_BACK   (	H_BACK		 ),
        .V_DISPLAY(	RESOLUTION_V ),
        .V_BOTTOM (	V_BOTTOM	 ),
        .V_SYNC   (	V_SYNC		 ),
        .V_TOP    (	V_TOP		 )
    )
    i_vga
    (
        .clk        ( clk     ), 
        .reset      ( ~reset_n   ),
        .hsync      ( hsync      ),
        .vsync      ( vsync      ),
        .display_on ( display_on ),
        .hpos       ( hpos    	 ),
        .vpos       ( vpos    	 ),
		.enable	  	( enable	 )
    );
	
	 button_debouncer 
	 #(
	 .DEBOUNCE_TIMER( DEBOUNCE_TIMER)
	 )
	 Debouncer
	 (
	  .clk			( clk			), 
	  .reset		( ~reset_n 		),
	  .RAW_BTN		( ~key_sw		),
	  .BTN			( BTN		 	),
	  .BTN_POSEDGE	( BTN_POSEDGE	),
	  .BTN_NEGEDGE	( BTN_NEGEDGE	)
	 );
	 
	 brush
	 #(
	 .SLOWNESS		 ( BRUSH_SLOWNESS),
	 .RESOLUTION_H   ( RESOLUTION_H  ),
	 .RESOLUTION_V   ( RESOLUTION_V  ),
	 .HPOS_WIDTH	 ( X_WIRE_WIDTH  ),
	 .VPOS_WIDTH 	 ( Y_WIRE_WIDTH  )
	 )
	 Painting_Brush
	 (
	  .clk		  	 ( clk		  ),
	  .reset	  	 ( ~reset_n   ),
	  .BTN		  	 ( BTN		  ), // [2:0]movedirection=[2:0]key_sw
	  .BTN_POSEDGE	 ( BTN_POSEDGE),
	  .display_on	 ( display_on ),
	  .hpos		  	 ( hpos		  ),
	  .vpos		  	 ( vpos		  ),
	  .FB_RGB	  	 ( FB_RGB	  ),
	  .memenable	 ( enable 	  ),
	  .rgb		  	 ( rgb		  ),
	  .writergb		 ( brush_RGB  ),
	  .fifopush  	 ( fifopush	  ),
	  .fifofull		 ( fifofull   ),
	  .writecounter_x( brush_hpos ),
	  .writecounter_y( brush_vpos )
	 );	 
	 
	 FIFO_top
	 #(.HPOS_WIDTH	 (X_WIRE_WIDTH),
		.VPOS_WIDTH	 (Y_WIRE_WIDTH)
		)
	 FIFO
	 (
			.clk		(clk	   ),
			.rst		(~reset_n  ),
			.push		(fifopush  ),
			.toppop		(fifopop   ),
			.hpos_write	(brush_hpos),
			.vpos_write	(brush_vpos),
			.RGB_write	(brush_RGB ),
			.hpos_read	(hposfifo  ),
			.vpos_read	(vposfifo  ),
			.RGB_read   (RGBfifo   ),
			.full		(fifofull  ),
			.empty		(fifoempty )
	);
	 
	 
	 RGBMemory_top
	 #(
		.RAMLENGTH	 (RAMLENGTH	  ), //RAMLENGTH*DATAWIDTH = 4800 = 80x60 RAM RESOLUTION
		.DATA_WIDTH	 (DATA_WIDTH  ),
		.X_WIRE_WIDTH(X_WIRE_WIDTH),
		.Y_WIRE_WIDTH(Y_WIRE_WIDTH),
		.ADDR_WIDTH	 (ADDR_WIDTH  ),
		.RESOLUTION_H(RESOLUTION_H),
		.RESOLUTION_V(RESOLUTION_V)
	 )
	 FrameBuffer
	 (
		.display_on( display_on	  ),
		.clk	   ( clk		  ),
		.memreset  ( enable		  ),
		.reset_n   ( ~reset_n	  ),
		.resetcnt  ( resetcnt	  ),
		.RGBin	   ( RGBfifo	  ),
		.hpos	   ( hpos_to_fb	  ),
		.vpos	   ( vpos_to_fb	  ),
		.RGB	   ( FB_RGB		  ),
		.fifoempty ( fifoempty	  )
	 );
	 
	 memsyncreset
	 #(
	 .ADDR_WIDTH   ( ADDR_WIDTH	  ),
	 .RAMLENGTH    ( RAMLENGTH    )
	 )
	 memsyncreset
	 (
	 .clk		   ( clk		  ), 
	 .memreset	   ( ~reset_n	  ),
	 .resetcnt	   ( resetcnt	  ),
	 .memenable	   ( enable		  )
	 );
	 
	assign hpos_to_fb = (display_on) ? hpos : hposfifo;
	assign vpos_to_fb = (display_on) ? vpos : vposfifo;
	assign fifopop = ~display_on&&~fifoempty;

always #5 clk=~clk;

initial begin
clk=0;
reset_n = 1;
key_sw = '1;
#10;
reset_n = 0;
#10;
reset_n = 1;
#13000;
key_sw = 4'b0100;
#10000;
//key_sw = '1;
end

endmodule