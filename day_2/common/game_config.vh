`ifndef GAME_CONFIG_VH
`define GAME_CONFIG_VH

`include "config.vh"

`define SCREEN_WIDTH   640
`define SCREEN_HEIGHT  480

`define X_WIDTH        10  // X coordinate width in bits
`define Y_WIDTH        10  // Y coordinate width in bits

`define RGB_WIDTH      3

`ifndef GAME_MASTER_FSM_MODULE

// `define GAME_MASTER_FSM_MODULE   game_master_fsm_1_two_always
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_2_three_always
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_3_three_always_more_states
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_4_good_style_of_one_hot_two_always
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_5_good_style_of_one_hot_three_always
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_6_good_style_of_one_hot_three_always_more_states
   `define GAME_MASTER_FSM_MODULE   game_master_fsm_7_signals_from_state
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_7_signals_from_state_var_1
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_7_signals_from_state_var_2
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_7_signals_from_state_var_3
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_7_signals_from_state_var_4
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_8_bad_style_of_one_hot
// `define GAME_MASTER_FSM_MODULE   game_master_fsm_9_bad_priority_logic

`endif

`define N_MIXER_PIPE_STAGES  1

// `define GAME_SPRITE_DISPLAY_MODULE  game_sprite_display_alt_1
   `define GAME_SPRITE_DISPLAY_MODULE  game_sprite_display

`endif
