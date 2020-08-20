module top
# (
    parameter clk_mhz = 50,
              strobe_to_update_xy_counter_width = 20
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

    game_top
    # (
        .clk_mhz (clk_mhz),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    i_game_top
    (
        .clk              (   clk                       ),
        .reset            ( ~ reset_n                   ),

        .launch_key       (   key_sw [3] | key_sw [0]   ),
        .left_right_keys  ( { key_sw [3] , key_sw [0] } ),

        .hsync            ( hsync                       ),
        .vsync            ( vsync                       ),
        .rgb              ( rgb                         )
    );

endmodule
