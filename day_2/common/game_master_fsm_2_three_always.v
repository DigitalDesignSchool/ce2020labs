`include "game_config.vh"

module game_master_fsm_2_three_always
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

    localparam [1:0] STATE_START  = 0,
                     STATE_AIM    = 1,
                     STATE_SHOOT  = 2,
                     STATE_END    = 3;

    reg [1:0] state;
    reg [1:0] d_state;

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
        d_state = 2'bx;

        //--------------------------------------------------------------------

        case (state)

        STATE_START:                                   d_state = STATE_AIM;

        STATE_AIM:    if      ( end_of_game          ) d_state = STATE_END;
                      else if ( key                  ) d_state = STATE_SHOOT;
                      else                             d_state = STATE_AIM;

        STATE_SHOOT:  if (  end_of_game              ) d_state = STATE_END;
                      else                             d_state = STATE_SHOOT;

        STATE_END:    if ( end_of_game_timer_running ) d_state = STATE_END;
                      else                             d_state = STATE_START;
        endcase
    end

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            state <= STATE_START;
        else
            state <= d_state;

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
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
            sprite_target_write_xy        <= 1'b0;
            sprite_torpedo_write_xy       <= 1'b0;

            sprite_target_write_dxy       <= 1'b0;
            sprite_torpedo_write_dxy      <= 1'b0;

            sprite_target_enable_update   <= 1'b0;
            sprite_torpedo_enable_update  <= 1'b0;

            end_of_game_timer_start       <= 1'b0;

            //--------------------------------------------------------------------

            case (d_state)

            STATE_START:
            begin
                sprite_target_write_xy        <= 1'b1;
                sprite_torpedo_write_xy       <= 1'b1;

                sprite_target_write_dxy       <= 1'b1;

                game_won                      <= 1'b0;
            end

            STATE_AIM:
            begin
                sprite_target_enable_update   <= 1'b1;

                if (end_of_game)
                    end_of_game_timer_start   <= 1'b1;
            end

            STATE_SHOOT:
            begin
                sprite_torpedo_write_dxy      <= 1'b1;

                sprite_target_enable_update   <= 1'b1;
                sprite_torpedo_enable_update  <= 1'b1;

                if (collision)
                    game_won <= 1'b1;

                if (end_of_game)
                    end_of_game_timer_start   <= 1'b1;
            end

            STATE_END:
            begin
                // TODO: Investigate why it needs collision detection here
                // and not in previous state

                if (collision)
                    game_won <= 1'b1;
            end

            endcase
        end

endmodule
