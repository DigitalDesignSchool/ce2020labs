`include "game_config.vh"

module game_sprite_top
#(
    parameter SPRITE_WIDTH  = 8,
              SPRITE_HEIGHT = 8,

              DX_WIDTH      = 2,  // X speed width in bits
              DY_WIDTH      = 2,  // Y speed width in bits

              ROW_0         = 32'h000cc000,
              ROW_1         = 32'h000cc000,
              ROW_2         = 32'h000cc000,
              ROW_3         = 32'hcccccccc,
              ROW_4         = 32'hcccccccc,
              ROW_5         = 32'h000cc000,
              ROW_6         = 32'h000cc000,
              ROW_7         = 32'h000cc000,

              strobe_to_update_xy_counter_width = 20
)

//----------------------------------------------------------------------------

(
    input                     clk,
    input                     reset,

    input  [`X_WIDTH   - 1:0] pixel_x,
    input  [`Y_WIDTH   - 1:0] pixel_y,

    input                     sprite_write_xy,
    input                     sprite_write_dxy,

    input  [`X_WIDTH   - 1:0] sprite_write_x,
    input  [`Y_WIDTH   - 1:0] sprite_write_y,

    input  [ DX_WIDTH  - 1:0] sprite_write_dx,
    input  [ DY_WIDTH  - 1:0] sprite_write_dy,

    input                     sprite_enable_update,

    output [`X_WIDTH   - 1:0] sprite_x,
    output [`Y_WIDTH   - 1:0] sprite_y,

    output                    sprite_within_screen,

    output [`X_WIDTH   - 1:0] sprite_out_left,
    output [`X_WIDTH   - 1:0] sprite_out_right,
    output [`Y_WIDTH   - 1:0] sprite_out_top,
    output [`Y_WIDTH   - 1:0] sprite_out_bottom,

    output                    rgb_en,
    output [`RGB_WIDTH - 1:0] rgb
);

    game_sprite_control
    #(
        .DX_WIDTH              ( DX_WIDTH              ),
        .DY_WIDTH              ( DY_WIDTH              ),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    sprite_control
    (
        .clk                   ( clk                   ),
        .reset                 ( reset                 ),

        .sprite_write_xy       ( sprite_write_xy       ),
        .sprite_write_dxy      ( sprite_write_dxy      ),

        .sprite_write_x        ( sprite_write_x        ),
        .sprite_write_y        ( sprite_write_y        ),

        .sprite_write_dx       ( sprite_write_dx       ),
        .sprite_write_dy       ( sprite_write_dy       ),

        .sprite_enable_update  ( sprite_enable_update  ),

        .sprite_x              ( sprite_x              ),
        .sprite_y              ( sprite_y              )
    );

    `GAME_SPRITE_DISPLAY_MODULE
    #(
        .SPRITE_WIDTH          ( SPRITE_WIDTH          ),
        .SPRITE_HEIGHT         ( SPRITE_HEIGHT         ),

        .ROW_0                 ( ROW_0                 ),
        .ROW_1                 ( ROW_1                 ),
        .ROW_2                 ( ROW_2                 ),
        .ROW_3                 ( ROW_3                 ),
        .ROW_4                 ( ROW_4                 ),
        .ROW_5                 ( ROW_5                 ),
        .ROW_6                 ( ROW_6                 ),
        .ROW_7                 ( ROW_7                 )
    )
    sprite_display
    (
        .clk                   ( clk                   ),
        .reset                 ( reset                 ),

        .pixel_x               ( pixel_x               ),
        .pixel_y               ( pixel_y               ),

        .sprite_x              ( sprite_x              ),
        .sprite_y              ( sprite_y              ),

        .sprite_within_screen  ( sprite_within_screen  ),

        .sprite_out_left       ( sprite_out_left       ),
        .sprite_out_right      ( sprite_out_right      ),
        .sprite_out_top        ( sprite_out_top        ),
        .sprite_out_bottom     ( sprite_out_bottom     ),

        .rgb_en                ( rgb_en                ),
        .rgb                   ( rgb                   )
    );

endmodule
