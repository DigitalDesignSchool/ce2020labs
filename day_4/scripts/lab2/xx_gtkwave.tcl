# gtkwave::loadFile "dump.vcd"

set all_signals [list]

lappend all_signals testbench.clk
lappend all_signals testbench.reset_n
lappend all_signals testbench.i_top.i_game_top.vcu_reg_control
lappend all_signals testbench.i_top.i_game_top.vcu_reg_control_we
lappend all_signals testbench.i_top.i_game_top.vcu_reg_wdata
lappend all_signals testbench.i_top.i_game_top.vcu_reg_wdata_we
lappend all_signals testbench.i_top.i_game_top.vcu_reg_rdata
lappend all_signals testbench.i_top.i_game_top.vsync
lappend all_signals testbench.i_top.i_game_top.display_on
lappend all_signals testbench.i_top.i_game_top.rgb
lappend all_signals testbench.i_top.i_game_top.imAddr
lappend all_signals testbench.i_top.i_game_top.imData
lappend all_signals testbench.i_top.i_game_top.sprite_torpedo_write_xy
lappend all_signals testbench.i_top.i_game_top.sprite_torpedo_write_x
lappend all_signals testbench.i_top.i_game_top.sprite_torpedo_write_y


set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
