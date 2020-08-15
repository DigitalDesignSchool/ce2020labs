`include "game_config.vh"

module game_master_fsm_6_good_style_of_one_hot_three_always_more_states
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

    //------------------------------------------------------------------------

    localparam STATE_START    = 0,
               STATE_AIM      = 1,
               STATE_SHOOT    = 2,
               STATE_WON      = 3,
               STATE_WON_END  = 4,
               STATE_LOST     = 5,
               STATE_LOST_END = 6;

    //------------------------------------------------------------------------

    reg [6:0] state;
    reg [6:0] n_state;

    //------------------------------------------------------------------------

    wire out_of_screen
        =   ~ sprite_target_within_screen
          | ~ sprite_torpedo_within_screen;

    //------------------------------------------------------------------------

    always @*
    begin
        n_state = 7'b0;

        case (1'b1)  // synopsys parallel_case

        state [STATE_START]:                 n_state [ STATE_AIM      ] = 1'b1;

        state [STATE_AIM]:

            if      ( out_of_screen        ) n_state [ STATE_LOST     ] = 1'b1;
            else if ( collision            ) n_state [ STATE_WON      ] = 1'b1;
            else if ( key                  ) n_state [ STATE_SHOOT    ] = 1'b1;
            else                             n_state [ STATE_AIM      ] = 1'b1;

        state [STATE_SHOOT]:

            if      ( out_of_screen        ) n_state [ STATE_LOST     ] = 1'b1;
            else if ( collision            ) n_state [ STATE_WON      ] = 1'b1;
            else                             n_state [ STATE_SHOOT    ] = 1'b1;

        state [STATE_WON]:
                                             n_state [ STATE_WON_END  ] = 1'b1;

        state [STATE_WON_END]:

            if ( end_of_game_timer_running ) n_state [ STATE_WON_END  ] = 1'b1;
            else                             n_state [ STATE_START    ] = 1'b1;

        state [STATE_LOST]:

                                             n_state [ STATE_LOST_END ] = 1'b1;

        state [STATE_LOST_END]:

            if ( end_of_game_timer_running ) n_state [ STATE_LOST_END ] = 1'b1;
            else                             n_state [ STATE_START    ] = 1'b1;

        endcase
    end

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            state <= (7'b1 << STATE_START);
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

            case (1'b1)  // synopsys parallel_case

            n_state [STATE_START]:
            begin
                sprite_target_write_xy        <= 1'b1;
                sprite_torpedo_write_xy       <= 1'b1;

                sprite_target_write_dxy       <= 1'b1;
            end

            n_state [STATE_AIM]:
            begin
                sprite_target_enable_update   <= 1'b1;
            end

            n_state [STATE_SHOOT]:
            begin
                sprite_torpedo_write_dxy      <= 1'b1;

                sprite_target_enable_update   <= 1'b1;
                sprite_torpedo_enable_update  <= 1'b1;
            end

            n_state [STATE_WON]:
            begin
                end_of_game_timer_start       <= 1'b1;
                game_won                      <= 1'b1;
            end

            n_state [STATE_WON_END]:
            begin
                game_won                      <= 1'b1;
            end

            n_state [STATE_LOST]:
            begin
                end_of_game_timer_start       <= 1'b1;
            end

            n_state [STATE_LOST_END]:
            begin
            end

            endcase
        end

endmodule
