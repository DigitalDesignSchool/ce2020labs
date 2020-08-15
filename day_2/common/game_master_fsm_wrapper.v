`include "game_config.vh"

module game_master_fsm_wrapper
(
    input  clk,
    input  reset,

    input  key,

    output sprite_target_write_xy,
    output sprite_torpedo_write_xy,

    output sprite_target_write_dxy,
    output sprite_torpedo_write_dxy,

    output sprite_target_enable_update,
    output sprite_torpedo_enable_update,

    input  sprite_target_within_screen,
    input  sprite_torpedo_within_screen,

    input  collision,

    output end_of_game_timer_start,
    output game_won,

    input  end_of_game_timer_running
);

    //------------------------------------------------------------------------

    reg reg_key;
    reg reg_sprite_target_within_screen;
    reg reg_sprite_torpedo_within_screen;
    reg reg_collision;
    reg reg_end_of_game_timer_running;

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            reg_key                           <= 1'b0;
            reg_sprite_target_within_screen   <= 1'b0;
            reg_sprite_torpedo_within_screen  <= 1'b0;
            reg_collision                     <= 1'b0;
            reg_end_of_game_timer_running     <= 1'b0;
        end
        else
        begin
            reg_key                           <= key;
            reg_sprite_target_within_screen   <= sprite_target_within_screen;
            reg_sprite_torpedo_within_screen  <= sprite_torpedo_within_screen;
            reg_collision                     <= collision;
            reg_end_of_game_timer_running     <= end_of_game_timer_running;
        end

    //------------------------------------------------------------------------

    `GAME_MASTER_FSM_MODULE master_fsm
    (
        .clk                           ( clk                               ),
        .reset                         ( reset                             ),

        .key                           ( reg_key                           ),

        .sprite_target_write_xy        ( sprite_target_write_xy            ),
        .sprite_torpedo_write_xy       ( sprite_torpedo_write_xy           ),

        .sprite_target_write_dxy       ( sprite_target_write_dxy           ),
        .sprite_torpedo_write_dxy      ( sprite_torpedo_write_dxy          ),

        .sprite_target_enable_update   ( sprite_target_enable_update       ),
        .sprite_torpedo_enable_update  ( sprite_torpedo_enable_update      ),

        .sprite_target_within_screen   ( reg_sprite_target_within_screen   ),
        .sprite_torpedo_within_screen  ( reg_sprite_torpedo_within_screen  ),

        .collision                     ( reg_collision                     ),

        .end_of_game_timer_start       ( end_of_game_timer_start           ),
        .game_won                      ( game_won                          ),

        .end_of_game_timer_running     ( reg_end_of_game_timer_running     )
    );

endmodule
