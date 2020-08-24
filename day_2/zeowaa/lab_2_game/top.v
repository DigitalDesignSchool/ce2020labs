`include "config.vh"

module top
# (
    parameter clk_mhz = 50,
              strobe_to_update_xy_counter_width = 20
)
(
    input         clk,
    input  [ 3:0] key,
    input  [ 7:0] sw,
    output [11:0] led,

    output [ 7:0] abcdefgh,
    output [ 7:0] digit,

    output        buzzer,

    output        vsync,
    output        hsync,
    output [ 2:0] rgb,

    inout  [18:0] gpio
);

    wire reset = ~ key [3];

    assign led       = { key, sw };
    assign abcdefgh  = sw;
    assign digit     = 8'b1;
    assign buzzer    = 1'b1;

    wire launch_key = key_sw != 4'b1111;  // Any key is pressed
    
    // Either of two leftmost keys is pressed
    wire left_key   = key_sw [3:2] != 2'b11;

    // Either of two rightmost keys is pressed
    wire right_key  = key_sw [1:0] != 2'b11;

    wire launch_key = ~ key [1] | ~ key [0];
    wire left_key   = ~ key [1];
    wire right_key  = ~ key [0];

    game_top
    # (
        .clk_mhz (clk_mhz),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    i_game_top
    (
        .clk              (   clk                   ),
        .reset            ( ~ reset_n               ),

        .launch_key       (   launch_key            ),
        .left_right_keys  ( { left_key, right_key } ),

        .hsync            (   hsync                 ),
        .vsync            (   vsync                 ),
        .rgb              (   rgb                   )
    );

endmodule
