`include "game_config.vh"

module game_sprite_display_wrapper
#(
    parameter SPRITE_WIDTH  = 8,
              SPRITE_HEIGHT = 8,

              ROW_0         = 32'h000cc000,
              ROW_1         = 32'h000cc000,
              ROW_2         = 32'h000cc000,
              ROW_3         = 32'hcccccccc,
              ROW_4         = 32'hcccccccc,
              ROW_5         = 32'h000cc000,
              ROW_6         = 32'h000cc000,
              ROW_7         = 32'h000cc000
)

//----------------------------------------------------------------------------

(
    input                     clk,
    input                     reset,

    input  [`X_WIDTH   - 1:0] pixel_x,
    input  [`Y_WIDTH   - 1:0] pixel_y,

    input  [`X_WIDTH   - 1:0] sprite_x,
    input  [`Y_WIDTH   - 1:0] sprite_y,

    output                    sprite_within_screen,

    output [`X_WIDTH   - 1:0] sprite_out_left,
    output [`X_WIDTH   - 1:0] sprite_out_right,
    output [`Y_WIDTH   - 1:0] sprite_out_top,
    output [`Y_WIDTH   - 1:0] sprite_out_bottom,

    output                    rgb_en,
    output [`RGB_WIDTH - 1:0] rgb
);

    //------------------------------------------------------------------------

    reg [`X_WIDTH - 1:0] reg_pixel_x;
    reg [`Y_WIDTH - 1:0] reg_pixel_y;

    reg [`X_WIDTH - 1:0] reg_sprite_x;
    reg [`Y_WIDTH - 1:0] reg_sprite_y;

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            reg_pixel_x  <= 1'b0;
            reg_pixel_y  <= 1'b0;

            reg_sprite_x <= 1'b0;
            reg_sprite_y <= 1'b0;
        end
        else
        begin
            reg_pixel_x  <= pixel_x;
            reg_pixel_y  <= pixel_y;

            reg_sprite_x <= sprite_x;
            reg_sprite_y <= sprite_y;
        end

    //------------------------------------------------------------------------

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

        .pixel_x               ( reg_pixel_x           ),
        .pixel_y               ( reg_pixel_y           ),

        .sprite_x              ( reg_sprite_x          ),
        .sprite_y              ( reg_sprite_y          ),

        .sprite_within_screen  ( sprite_within_screen  ),

        .sprite_out_left       ( sprite_out_left       ),
        .sprite_out_right      ( sprite_out_right      ),
        .sprite_out_top        ( sprite_out_top        ),
        .sprite_out_bottom     ( sprite_out_bottom     ),

        .rgb_en                ( rgb_en                ),
        .rgb                   ( rgb                   )
    );

endmodule
