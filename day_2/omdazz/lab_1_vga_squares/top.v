`include "config.vh"

module top
# (
    parameter X_WIDTH          = 10,
              Y_WIDTH          = 10,
              clk_mhz          = 50
)
(
    input        clk,
    input        reset_n,
    
    input  [3:0] key_sw,
    output [3:0] led,
    
    output [7:0] abcdefgh,
    output [3:0] digit,

    output       buzzer,

    output       hsync,
    output       vsync,
    output [2:0] rgb
);

    assign led       = key_sw;
    assign abcdefgh  = 8'hff;
    assign digit     = 4'hf;
    assign buzzer    = 1'b0;

    //------------------------------------------------------------------------

    wire                 display_on;
    wire [X_WIDTH - 1:0] pixel_x;
    wire [Y_WIDTH - 1:0] pixel_y;
	wire [3:0]           i_sw;
	
	assign i_sw =        ~key_sw;
 
    vga
    # (
        .HPOS_WIDTH ( X_WIDTH    ),
        .VPOS_WIDTH ( Y_WIDTH    ),
        
        .CLK_MHZ    ( clk_mhz    )
    )
    i_vga
    (
        .clk        ( clk        ), 
        .reset      ( ~reset_n   ),
        .hsync      ( hsync      ),
        .vsync      ( vsync      ),
        .display_on ( display_on ),
        .hpos       ( pixel_x    ),
        .vpos       ( pixel_y    )
    );

    //------------------------------------------------------------------------

    color_square 
    # (
       .HPOS_WIDTH  ( X_WIDTH    ),
       .VPOS_WIDTH  ( Y_WIDTH    ),
        
       .CLK_MHZ     ( clk_mhz    )
    )

    color_square
    (
        .clk        ( clk        ),
        .reset      ( ~reset_n   ),
        .display_on ( display_on ),
        .key_sw     ( i_sw       ),
        .hpos       ( pixel_x    ),
        .vpos       ( pixel_y    ),
        .rgb        ( rgb        )
    );

endmodule
