`include "game_config.vh"

module game_master_fsm_9_bad_priority_logic
(
    input      clk,
    input      reset,

    input      key,

    output reg sprite_target_write_xy,
    output reg sprite_torpedo_write_xy,

    output reg sprite_target_write_dxy,
    output reg sprite_torpedo_write_dxy,

    output reg sprite_target_enable_update,
    output reg sprite_torpedo_enable_update,

    input      sprite_target_within_screen,
    input      sprite_torpedo_within_screen,

    input      collision,

    output reg end_of_game_timer_start,
    output reg game_won,

    input      end_of_game_timer_running
);

    // Using one-hot

    localparam STATE_START  = 0,
               STATE_AIM    = 1,
               STATE_SHOOT  = 2,
               STATE_END    = 3;

    reg [3:0] state;
    reg [3:0] d_state;

    reg d_sprite_target_write_xy;
    reg d_sprite_torpedo_write_xy;

    reg d_sprite_target_write_dxy;
    reg d_sprite_torpedo_write_dxy;

    reg d_sprite_target_enable_update;
    reg d_sprite_torpedo_enable_update;

    reg d_end_of_game_timer_start;
    reg d_game_won;

    //------------------------------------------------------------------------

    wire end_of_game
        =   ~ sprite_target_within_screen
          | ~ sprite_torpedo_within_screen
          |   collision;

    //------------------------------------------------------------------------

    always @*
    begin
        d_state = 4'b0;

        d_sprite_target_write_xy        = 1'b0;
        d_sprite_torpedo_write_xy       = 1'b0;

        d_sprite_target_write_dxy       = 1'b0;
        d_sprite_torpedo_write_dxy      = 1'b0;

        d_sprite_target_enable_update   = 1'b0;
        d_sprite_torpedo_enable_update  = 1'b0;

        d_end_of_game_timer_start       = 1'b0;
        d_game_won                      = game_won;

        //--------------------------------------------------------------------

        // Bad style that infers priority

        if (state [STATE_START])
        begin
            d_sprite_target_write_xy        = 1'b1;
            d_sprite_torpedo_write_xy       = 1'b1;

            d_sprite_target_write_dxy       = 1'b1;

            d_game_won                      = 1'b0;

            d_state [STATE_AIM] = 1;
        end

        else if (state [STATE_AIM])
        begin
            d_sprite_target_enable_update   = 1'b1;

            if (end_of_game)
            begin
                d_end_of_game_timer_start   = 1'b1;

                d_state [STATE_END] = 1;
            end
            else if (key)
            begin
                d_state [STATE_SHOOT] = 1;
            end
            else
            begin
                d_state [STATE_AIM] = 1;
            end
        end

        else if (state [STATE_SHOOT])
        begin
            d_sprite_torpedo_write_dxy      = 1'b1;

            d_sprite_target_enable_update   = 1'b1;
            d_sprite_torpedo_enable_update  = 1'b1;

            if (collision)
                d_game_won = 1'b1;

            if (end_of_game)
            begin
                d_end_of_game_timer_start   = 1'b1;

                d_state [STATE_END] = 1;
            end
            else
            begin
                d_state [STATE_SHOOT] = 1;
            end
        end

        else if (state [STATE_END])
        begin
            // TODO: Investigate why it needs collision detection here
            // and not in previous state

            if (collision)
                d_game_won = 1'b1;

            if (! end_of_game_timer_running)
                d_state [STATE_START] = 1;
            else
                d_state [STATE_END] = 1;
        end
    end

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            state                         <= (1 << STATE_START);

            sprite_target_write_xy        <= 1'b0;
            sprite_torpedo_write_xy       <= 1'b0;

            sprite_target_write_dxy       <= 1'b0;
            sprite_torpedo_write_dxy      <= 1'b0;

            sprite_target_enable_update   <= 1'b0;
            sprite_torpedo_enable_update  <= 1'b0;

            end_of_game_timer_start       <= 1'b0;
            game_won                      <= 1'b0;
        end
        else
        begin
            state                         <= d_state;

            sprite_target_write_xy        <= d_sprite_target_write_xy;
            sprite_torpedo_write_xy       <= d_sprite_torpedo_write_xy;

            sprite_target_write_dxy       <= d_sprite_target_write_dxy;
            sprite_torpedo_write_dxy      <= d_sprite_torpedo_write_dxy;

            sprite_target_enable_update   <= d_sprite_target_enable_update;
            sprite_torpedo_enable_update  <= d_sprite_torpedo_enable_update;

            end_of_game_timer_start       <= d_end_of_game_timer_start;
            game_won                      <= d_game_won;
        end

endmodule
