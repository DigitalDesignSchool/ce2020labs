`include "game_config.vh"

module game_master_fsm_3_three_always_more_states
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

    //------------------------------------------------------------------------

    localparam [2:0] STATE_START    = 3'd0,
                     STATE_AIM      = 3'd1,
                     STATE_SHOOT    = 3'd2,
                     STATE_WON      = 3'd3,
                     STATE_WON_END  = 3'd4,
                     STATE_LOST     = 3'd5,
                     STATE_LOST_END = 3'd6;

    //------------------------------------------------------------------------

    reg [2:0] state;
    reg [2:0] n_state;

    //------------------------------------------------------------------------

    wire out_of_screen
        =   ~ sprite_target_within_screen
          | ~ sprite_torpedo_within_screen;

    //------------------------------------------------------------------------

    always @*
    begin
        n_state = 3'bx;  // For debug and "don't care" directive for synthesis

        case (state)

        STATE_START    : n_state =                             STATE_AIM;

        STATE_AIM      : n_state = out_of_screen             ? STATE_LOST
                                 : collision                 ? STATE_WON
                                 : key                       ? STATE_SHOOT
                                 :                             STATE_AIM;

        STATE_SHOOT    : n_state = out_of_screen             ? STATE_LOST
                                 : collision                 ? STATE_WON
                                 :                             STATE_SHOOT;

        STATE_WON      : n_state =                             STATE_WON_END;

        STATE_WON_END  : n_state = end_of_game_timer_running ? STATE_WON_END
                                 :                             STATE_START;

        STATE_LOST     : n_state =                             STATE_LOST_END;

        STATE_LOST_END : n_state = end_of_game_timer_running ? STATE_LOST_END
                                 :                             STATE_START;
        endcase
    end

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            state <= STATE_START;
        else
            state <= n_state;

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            sprite_target_write_xy            <= 1'b0;
            sprite_torpedo_write_xy           <= 1'b0;

            sprite_target_write_dxy           <= 1'b0;
            sprite_torpedo_write_dxy          <= 1'b0;

            sprite_target_enable_update       <= 1'b0;
            sprite_torpedo_enable_update      <= 1'b0;

            end_of_game_timer_start           <= 1'b0;
            game_won                          <= 1'b0;
        end
        else
        begin
            sprite_target_write_xy            <= 1'b0;
            sprite_torpedo_write_xy           <= 1'b0;

            sprite_target_write_dxy           <= 1'b0;
            sprite_torpedo_write_dxy          <= 1'b0;

            sprite_target_enable_update       <= 1'b0;
            sprite_torpedo_enable_update      <= 1'b0;

            end_of_game_timer_start           <= 1'b0;
            game_won                          <= 1'b0;

            //--------------------------------------------------------------------

            case (n_state)

            STATE_START:
            begin
                sprite_target_write_xy        <= 1'b1;
                sprite_torpedo_write_xy       <= 1'b1;

                sprite_target_write_dxy       <= 1'b1;
            end

            STATE_AIM:
            begin
                sprite_target_enable_update   <= 1'b1;
            end

            STATE_SHOOT:
            begin
                sprite_torpedo_write_dxy      <= 1'b1;

                sprite_target_enable_update   <= 1'b1;
                sprite_torpedo_enable_update  <= 1'b1;
            end

            STATE_WON:
            begin
                end_of_game_timer_start       <= 1'b1;
                game_won                      <= 1'b1;
            end

            STATE_WON_END:
            begin
                game_won                      <= 1'b1;
            end

            STATE_LOST:
            begin
                end_of_game_timer_start       <= 1'b1;
            end

            STATE_LOST_END:
            begin
            end

            endcase
        end

endmodule
