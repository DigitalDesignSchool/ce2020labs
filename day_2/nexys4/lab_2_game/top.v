`include "config.vh"
//Nexus A7 wrapper
module top
# (
    parameter clk_mhz = 100,
              strobe_to_update_xy_counter_width = 20
)
(
    input CLK100MHZ,
    input CPU_RESETN,
    
    input BTNL,
    input BTNR,
    
    output  VGA_HS,
    output  VGA_VS,
    output	[3:0] VGA_R,	
    output	[3:0] VGA_G,	
    output	[3:0] VGA_B
);


	 
	wire [3:0] key_sw = {BTNL, 1'b1, BTNR, 1'b1};
    wire launch_key = key_sw != 4'b1111;  // Any key is pressed
    
    // Either of two leftmost keys is pressed
    wire left_key   = key_sw [3] ;

    // Either of two rightmost keys is pressed
    wire right_key  = key_sw [1];
	wire r,g,b;
	assign VGA_R = {r,r,r,r};
	assign VGA_G = {g,g,g,g};
	assign VGA_B = {b,b,b,b};
	
    game_top
    # (
        .clk_mhz (clk_mhz),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    i_game_top
    (
        .clk              (   CLK100MHZ             ),
        .reset            ( ~ CPU_RESETN            ),

        .launch_key       (   launch_key            ),
        .left_right_keys  ( { left_key, right_key } ),

        .hsync            (   VGA_HS                ),
        .vsync            (   VGA_VS                ),
        .rgb              ( { r, g, b } )
    );

endmodule